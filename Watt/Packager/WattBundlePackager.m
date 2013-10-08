// This file is part of "Watt"
//
// "Watt" is free software: you can redistribute it and/or modify
// it under the terms of the GNU LESSER GENERAL PUBLIC LICENSE as published by
// the Free Software Foundation, either version 3 of the License, or
// (at your option) any later version.
//
// "Watt" is distributed in the hope that it will be useful,
// but WITHOUT ANY WARRANTY; without even the implied warranty of
// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
// GNU LESSER GENERAL PUBLIC LICENSE for more details.
//
// You should have received a copy of the GNU LESSER GENERAL PUBLIC LICENSE
// along with "Watt"  If not, see <http://www.gnu.org/licenses/>
//
//  WattBundlePackager.m
//  PlayerSample
//
//  Created by Benoit Pereira da Silva on 17/05/13.
//  Copyright (c) 2013 Pereira da Silva. All rights reserved.


#import "WattBundlePackager.h"
#import "WattApi.h"

@interface WattBundlePackager()<SSZipArchiveDelegate>{
    
}
@property (nonatomic,strong) NSMutableArray *objectPool; // This object pool is used to retain ZipArchives during background NSOperation.
@property (nonatomic,strong) NSOperationQueue *queue;

#pragma mark - ZIP / UNZIP

-(void)unZip:(NSString*)zipSourcePath
          to:(NSString*)destinationFolder
   withBlock:(void (^)(BOOL success))block
useBackgroundMode:(BOOL)backgroundMode;;

-(void)zip:(NSString*)sourcePath
        to:(NSString*)destinationZipFilePath
 withBlock:(void (^)(BOOL success))block
useBackgroundMode:(BOOL)backgroundMode;

@end
@implementation WattBundlePackager

@synthesize api = _api;

+ (WattBundlePackager*)sharedInstance {
    static WattBundlePackager *sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[self alloc] init];
        sharedInstance.queue=[[NSOperationQueue alloc] init];
        [sharedInstance.queue setMaxConcurrentOperationCount:1];
        sharedInstance.objectPool=[NSMutableArray array];
    });
    return sharedInstance;
}


-(WattApi*)api{
    if(!_api){
        [NSException raise:@"WattBundlePackager" format:@"api must be set when using WattBundlePackager"];
    }
    return _api;
}

-(void)setApi:(WattApi *)api{
    _api=api;
}

#pragma mark - packaging



-(void)packWattBundleWithName:(NSString*)name
                    withBlock:(void (^)(BOOL success))block
            useBackgroundMode:(BOOL)backgroundMode{
    NSString *sourceFolderPath=[self.api absolutePathForRegistryBundleWithName:name];
    sourceFolderPath=[sourceFolderPath substringToIndex:[sourceFolderPath length]-1];
    NSString *destinationFilePath=[sourceFolderPath stringByAppendingString:@".zip"];;
    NSInteger i=0;
    while ([self.api.fileManager fileExistsAtPath:destinationFilePath]) {
        destinationFilePath=[sourceFolderPath stringByAppendingFormat:@".%i.zip",i];
        i++;
    }
    [self zip:sourceFolderPath
           to:destinationFilePath
    withBlock:^(BOOL success) {
        block(success);
    } useBackgroundMode:backgroundMode];
}



-(void)unPackWattBundleWithName:(NSString*)name
                      withBlock:(void (^)(BOOL success))block
              useBackgroundMode:(BOOL)backgroundMode{
    
    NSString *p=[[[self.api absolutePathForRegistryBundleWithName:name] lastPathComponent] stringByReplacingOccurrencesOfString:@"/" withString:@""];
    NSString *zipSourcePath=[[NSBundle mainBundle] pathForResource:p ofType:@".zip"];
    NSString *folderName=[[zipSourcePath lastPathComponent] stringByReplacingOccurrencesOfString:@".zip" withString:@""];
    NSString *destinationFolder=[[self.api applicationDocumentsDirectory] stringByAppendingString:folderName];
    if(![self.api.fileManager fileExistsAtPath:zipSourcePath]){
        zipSourcePath=[[self.api applicationDocumentsDirectory] stringByAppendingString:[zipSourcePath lastPathComponent]];
    }
    if(![self.api.fileManager fileExistsAtPath:zipSourcePath]){
        WTLog(@"%@ do not exist",zipSourcePath);
    }else{
        [self.api createRecursivelyRequiredFolderForPath:destinationFolder];
        [self unZip:zipSourcePath
                 to:destinationFolder
          withBlock:^(BOOL success) {
              block(success);
          }useBackgroundMode:backgroundMode];
    }
}



#pragma mark - ZIP / UNZIP

-(void)unZip:(NSString*)zipSourcePath
          to:(NSString*)destinationFolder
   withBlock:(void (^)(BOOL success))block
useBackgroundMode:(BOOL)backgroundMode{
    if([self.api.fileManager fileExistsAtPath:zipSourcePath]){
        if([self.api createRecursivelyRequiredFolderForPath:destinationFolder]){
#if TARGET_OS_IPHONE
            [SVProgressHUD showWithMaskType:SVProgressHUDMaskTypeGradient];
#endif
            if(backgroundMode){
                [self.queue addOperationWithBlock:^{
                    if([SSZipArchive unzipFileAtPath:zipSourcePath
                                       toDestination:destinationFolder
                                            delegate:self]){
                        block(YES);
                    }else{
                        block(NO);
                    }
#if TARGET_OS_IPHONE
                    [self.queue addOperationWithBlock:^{
                        [SVProgressHUD dismiss];
                    }];
#endif
                }];
            }else{
                if([SSZipArchive unzipFileAtPath:zipSourcePath
                                   toDestination:destinationFolder
                                        delegate:self]){
                    block(YES);
                }else{
                    block(NO);
                }
            }
        }else{
            // Error
        }
    }
}


#pragma mark SSZipArchiveDelegate

- (void)zipArchiveWillUnzipFileAtIndex:(NSInteger)fileIndex totalFiles:(NSInteger)totalFiles archivePath:(NSString *)archivePath fileInfo:(unz_file_info)fileInfo{
    /*
     CGFloat progress=(CGFloat)fileIndex/(CGFloat)totalFiles;
     dispatch_sync(dispatch_get_main_queue(), ^{
     
     [SVProgressHUD showProgress:progress
     status:@"UNZIP"
     maskType:SVProgressHUDMaskTypeBlack];
     
     });
     */
}


-(void)zip:(NSString*)sourcePath
        to:(NSString*)destinationZipFilePath
 withBlock:(void (^)(BOOL success))block
useBackgroundMode:(BOOL)backgroundMode{
    NSError*error=nil;
    if([self.api.fileManager fileExistsAtPath:sourcePath]){
        if([self.api.fileManager fileExistsAtPath:destinationZipFilePath]){
            [self.api.fileManager removeItemAtPath:destinationZipFilePath error:&error];
        }
#if TARGET_OS_IPHONE
        [SVProgressHUD showWithStatus:@"Compression"
                             maskType:SVProgressHUDMaskTypeBlack];
#endif
         if(backgroundMode){
        [self.queue addOperationWithBlock:^{
            if([SSZipArchive createZipFileAtPath:destinationZipFilePath
                         withContentsOfDirectory:sourcePath]){
                block(YES);
            }else{
                block(NO);
            }
        }];
         }else{
             if([SSZipArchive createZipFileAtPath:destinationZipFilePath
                          withContentsOfDirectory:sourcePath]){
                 block(YES);
             }else{
                 block(NO);
             }
         }
#if TARGET_OS_IPHONE
        [self.queue addOperationWithBlock:^{
            [SVProgressHUD dismiss];
        }];
#endif
    }else{
        block(NO);
    }
    
}



-(void)_addFolder:(NSString*)path pathPrefix:(NSString*)prefix toMapping:(NSMutableDictionary**)dictionary{
    NSFileManager *fm=self.api.fileManager;
	NSArray		*dirArray = [fm contentsOfDirectoryAtPath:path
                                                 error:nil];
    int nb=[dirArray count];
    for (int i=0; i<nb;i++) {
        NSString *s=[dirArray objectAtIndex:i];
		NSDictionary *dict = [fm attributesOfItemAtPath:[path stringByAppendingPathComponent:s] error:nil];
        NSString *prefixUpdated=[prefix length]>0 ? [prefix stringByAppendingPathComponent:s] : s;
		if ([[dict fileType] isEqualToString:NSFileTypeDirectory]
            || [[dict fileType] isEqualToString:NSFileTypeSymbolicLink]) {
            [self _addFolder:[path stringByAppendingPathComponent:s] pathPrefix:prefixUpdated toMapping:*&dictionary];
		} else {
            [*dictionary setValue:[path stringByAppendingPathComponent:s] forKey:prefixUpdated];
        }
	}
}


#pragma mark ZipArchiveDelegate


-(void)ErrorMessage:(NSString *)msg{
    WTLog(@"ZipArchiveDelegate ERROR : %@",msg);
}

-(BOOL)OverWriteOperation:(NSString *)file{
    return YES;
}


@end
