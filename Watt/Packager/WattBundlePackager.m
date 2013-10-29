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
#import "SSZipArchive.h"
#if TARGET_OS_IPHONE
#import "SVProgressHUD.h"
#endif

@interface WattBundlePackager()<SSZipArchiveDelegate>{
}
@property (nonatomic,strong)    NSOperationQueue *queue;
@property (atomic,strong)       NSFileManager *fileManager;
@end

@implementation WattBundlePackager


+ (WattBundlePackager*)sharedInstance {
    static WattBundlePackager *sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[self alloc] init];
        sharedInstance.queue=[[NSOperationQueue alloc] init];
        [sharedInstance.queue setMaxConcurrentOperationCount:1];
        sharedInstance.fileManager=[[NSFileManager alloc]init];
    });
    return sharedInstance;
}


- (NSString*)defaultPackExtension{
    if(!_defaultPackExtension){
        self.defaultPackExtension=@".watt";
    }
    return _defaultPackExtension;
}

#pragma mark -


/**
 *  Pack the folder
 *
 *  @param path           the source path
 *  @param block          the completion block with the success flag an the final path
 *  @param backgroundMode should the operation be performed in background
 */
-(void)packFolderFromPath:(NSString*)path
                withBlock:(void (^)(BOOL success, NSString*packPath))block
        useBackgroundMode:(BOOL)backgroundMode{

    NSString *sourceFolderPath=path;
    sourceFolderPath=[sourceFolderPath substringToIndex:[sourceFolderPath length]-1];
    NSString *__weak destinationFilePath=[sourceFolderPath stringByAppendingFormat:@".%@",self.defaultPackExtension];
    NSInteger i=0;
    while ([self.fileManager fileExistsAtPath:destinationFilePath]) {
        destinationFilePath=[sourceFolderPath stringByAppendingFormat:@".%i.%@",i,self.defaultPackExtension];
        i++;
    }
    [self zip:sourceFolderPath
           to:destinationFilePath
    withBlock:^(BOOL success) {
        block(success,destinationFilePath);
    } useBackgroundMode:backgroundMode];
    
}


/**
 *  Unpack
 *
 *  @param sourcePath        the source path
 *  @param destinationFolder the destination
 *  @param block             the completion block with the success flag an the final path
 *  @param backgroundMode    should the operation be performed in background
 */
-(void)unPackFromPath:(NSString*)sourcePath
                   to:(NSString*)destinationFolder
            withBlock:(void (^)(BOOL success,NSString*path))block
    useBackgroundMode:(BOOL)backgroundMode{
    
    if(![self.fileManager fileExistsAtPath:sourcePath]){
        block(NO,nil);
    }else{
        [self _createRecursivelyRequiredFolderForPath:destinationFolder];
        NSString *__weak destination=destinationFolder;
        [self unZip:sourcePath
                 to:destinationFolder
          withBlock:^(BOOL success) {
              block(success,destination);
          }useBackgroundMode:backgroundMode];
    }
}



-(BOOL)_createRecursivelyRequiredFolderForPath:(NSString*)path{
    if(![[path substringFromIndex:path.length-1] isEqualToString:@"/"])
        path=[path stringByDeletingLastPathComponent];
    
    if(![self.fileManager fileExistsAtPath:path]){
        NSError *error=nil;
        [self.fileManager createDirectoryAtPath:path
                    withIntermediateDirectories:YES
                                     attributes:nil
                                          error:&error];
        if(error){
            return NO;
        }
    }
    return YES;
}


#pragma mark - Downloading

/**
 *  Download then unpack the downloaded pack
 *
 *  @param sourceURL         the url
 *  @param destinationFolder the destination
 *  @param block             the completion block with the success flag an the final path
 */
-(void)unPackFromUrl:(NSURL*)sourceURL
                  to:(NSString*)destinationFolder
           withBlock:(void (^)(BOOL success,NSString*path))block{
    
}


#pragma mark - Uploading

// SHOULD BE IMPLEMENTED PER PROJECT
// POST to a given URL






#pragma mark - ZIP / UNZIP

-(void)unZip:(NSString*)zipSourcePath
          to:(NSString*)destinationFolder
   withBlock:(void (^)(BOOL success))block
useBackgroundMode:(BOOL)backgroundMode{
    if([self.fileManager fileExistsAtPath:zipSourcePath]){
        if([self _createRecursivelyRequiredFolderForPath:destinationFolder]){
#if TARGET_OS_IPHONE
            if(backgroundMode){
                [SVProgressHUD showWithMaskType:SVProgressHUDMaskTypeGradient];
            }
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

- (void)zipArchiveWillUnzipFileAtIndex:(NSInteger)fileIndex
                            totalFiles:(NSInteger)totalFiles
                           archivePath:(NSString *)archivePath
                              fileInfo:(unz_file_info)fileInfo{
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
    if([self.fileManager fileExistsAtPath:sourcePath]){
        if([self.fileManager fileExistsAtPath:destinationZipFilePath]){
            [self.fileManager removeItemAtPath:destinationZipFilePath error:&error];
        }
#if TARGET_OS_IPHONE
        if(backgroundMode){
            
            [SVProgressHUD showWithStatus:@"Compression"
                                 maskType:SVProgressHUDMaskTypeBlack];
        }
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
        if(backgroundMode){
            [self.queue addOperationWithBlock:^{
                [SVProgressHUD dismiss];
            }];
        }
#endif
    }else{
        block(NO);
    }
    
}



-(void)_addFolder:(NSString*)path pathPrefix:(NSString*)prefix toMapping:(NSMutableDictionary**)dictionary{
    NSFileManager *fm=self.fileManager;
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



@end
