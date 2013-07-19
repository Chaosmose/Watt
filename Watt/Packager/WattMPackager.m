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
//  WTMPackager.m
//  PlayerSample
//
//  Created by Benoit Pereira da Silva on 17/05/13.
//  Copyright (c) 2013 Pereira da Silva. All rights reserved.

#import "Watt.h"
#import "WattMPackager.h"

@interface WattMPackager()<SSZipArchiveDelegate>{
}
@property (nonatomic,strong) NSMutableArray *objectPool; // This object pool is used to retain ZipArchives during background NSOperation.
@property (nonatomic,strong) NSOperationQueue *queue;

@end
@implementation WattMPackager


+ (WattMPackager*)sharedInstance {
    static WattMPackager *sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[self alloc] init];
        sharedInstance.queue=[[NSOperationQueue alloc] init];
        [sharedInstance.queue setMaxConcurrentOperationCount:1];
        sharedInstance.objectPool=[NSMutableArray array];
    });
    return sharedInstance;
}

#pragma mark - ZIP / UNZIP

-(void)unZip:(NSString*)zipSourcePath
          to:(NSString*)destinationFolder
   withBlock:(void (^)(BOOL success))block{
    
    if([wattAPI.fileManager fileExistsAtPath:zipSourcePath]){
        if([wattAPI createRecursivelyRequiredFolderForPath:destinationFolder]){
            [SVProgressHUD showWithMaskType:SVProgressHUDMaskTypeGradient];
            
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
            // Error
        }
    }
}

#pragma mark SSZipArchiveDelegate

- (void)zipArchiveWillUnzipFileAtIndex:(NSInteger)fileIndex totalFiles:(NSInteger)totalFiles archivePath:(NSString *)archivePath fileInfo:(unz_file_info)fileInfo{
    CGFloat progress=(CGFloat)fileIndex/(CGFloat)totalFiles;
    dispatch_sync(dispatch_get_main_queue(), ^{
        /*
        [SVProgressHUD showProgress:progress
                             status:@"UNZIP"
                           maskType:SVProgressHUDMaskTypeBlack];
         */
    });
    
}


-(void)zip:(NSString*)sourcePath
        to:(NSString*)destinationZipFilePath
 withBlock:(void (^)(BOOL success))block{
    NSError*error=nil;
    if([wattAPI.fileManager fileExistsAtPath:sourcePath]){
        if([wattAPI.fileManager fileExistsAtPath:destinationZipFilePath]){
            [wattAPI.fileManager removeItemAtPath:destinationZipFilePath error:&error];
        }
#if TARGET_OS_IPHONE
        [SVProgressHUD showWithStatus:@"Compression"
                             maskType:SVProgressHUDMaskTypeBlack];
#endif
        [self.queue addOperationWithBlock:^{
            if([SSZipArchive createZipFileAtPath:destinationZipFilePath
                         withContentsOfDirectory:sourcePath]){
                block(YES);
            }else{
                block(NO);
            }
        }];
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
    NSFileManager *fm=wattAPI.fileManager;
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
