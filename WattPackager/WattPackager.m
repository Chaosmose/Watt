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


#import "WattPackager.h"
#import "SSZipArchive.h"

static NSString *WattPackagerErrorDomainName=@"WattPackagerErrorDomainName";

@interface WattPackager()<SSZipArchiveDelegate>{
}
@property (nonatomic,strong)    NSOperationQueue *queue;

@end

@implementation WattPackager


+ (WattPackager*)sharedInstance {
    static WattPackager *sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[self alloc] init];
        sharedInstance.queue=[[NSOperationQueue alloc] init];
        [sharedInstance.queue setMaxConcurrentOperationCount:1];
        sharedInstance.fileManager=[NSFileManager defaultManager];
    });
    return sharedInstance;
}


- (NSString*)defaultPackExtension{
    if(!_defaultPackExtension){
        self.defaultPackExtension=@"watt";
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
 *  @param overWrite      if there is an existing destination and set to yes it is overwritten
 */
-(void)packFolderFromPath:(NSString*)path
                withBlock:(void (^)(BOOL success, NSString*packPath,NSError*error))block
        useBackgroundMode:(BOOL)backgroundMode
                overWrite:(BOOL)overWrite{
    NSError*error=nil;
    NSString *sourceFolderPath=path;
    sourceFolderPath=[sourceFolderPath substringToIndex:[sourceFolderPath length]-1];
    NSString *__weak destinationFilePath=[sourceFolderPath stringByAppendingFormat:@".%@",self.defaultPackExtension];
    NSInteger i=0;
    if(overWrite){
        if([self.fileManager fileExistsAtPath:destinationFilePath]){
            [self.fileManager removeItemAtPath:destinationFilePath error:&error];
        }
    }else{
        while ([self.fileManager fileExistsAtPath:destinationFilePath]) {
            destinationFilePath=[sourceFolderPath stringByAppendingFormat:@".%i.%@",i,self.defaultPackExtension];
            i++;
        }
    }
    if(!error){
        [self _zip:sourceFolderPath
                to:destinationFilePath
         withBlock:^(BOOL success,NSError *error) {
             block((success&&!error),destinationFilePath,error);
         } useBackgroundMode:backgroundMode];
    }else{
        block(NO,destinationFilePath,error);
    }
}


/**
 *  Unpack
 *
 *  @param sourcePath        the source path
 *  @param destinationFolder the destination
 *  @param block             the completion block with the success flag an the final path
 *  @param backgroundMode    should the operation be performed in background
 *  @param overWrite        if there is an existing destination and set to yes it is overwritten
 */
-(void)unPackFromPath:(NSString*)sourcePath
                   to:(NSString*)destinationFolder
            withBlock:(void (^)(BOOL success,NSString*path,NSError*error))block
    useBackgroundMode:(BOOL)backgroundMode
            overWrite:(BOOL)overWrite{
    
    
    NSString *__weak destination=destinationFolder;
    if([self.fileManager fileExistsAtPath:destinationFolder] && overWrite){
        NSError*error=nil;
        [self.fileManager removeItemAtPath:destinationFolder error:&error];
    }else{
        int i=1;
        while ([self.fileManager fileExistsAtPath:destination]) {
            i++;
            destination=[destinationFolder stringByAppendingFormat:@"_%i",i];
        }
    }
    [self _createRecursivelyRequiredFolderForPath:destination];
    
    WattPackager *__weak weakSelf=self;
    NSString *__weak weakSourcePath=sourcePath;
    [self _unZip:sourcePath
              to:destination
       withBlock:^(BOOL success,NSError*error) {
           if (success){
               [weakSelf.fileManager removeItemAtPath:weakSourcePath
                                                error:&error];
           }
           block((success&&!error),destination,error);
       }useBackgroundMode:backgroundMode];
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



#pragma mark - ZIP / UNZIP

-(void)_unZip:(NSString*)zipSourcePath
           to:(NSString*)destinationFolder
    withBlock:(void (^)(BOOL success,NSError*error))block
useBackgroundMode:(BOOL)backgroundMode{
    
    NSString *__weak weakSourcePath=zipSourcePath;//tempPath;
    WattPackager *__weak weakSelf=self;
    if([self _createRecursivelyRequiredFolderForPath:destinationFolder]){
        if(backgroundMode){
            [self.queue addOperationWithBlock:^{
                NSError *error=nil;
                if([SSZipArchive unzipFileAtPath:weakSourcePath
                                   toDestination:destinationFolder
                                       overwrite:NO
                                        password:nil
                                           error:&error
                                        delegate:weakSelf]){
                    block(YES,error);
                }else{
                    block(NO,error);
                }
            }];
        }else{
            NSError *error=nil;
            if([SSZipArchive unzipFileAtPath:weakSourcePath
                               toDestination:destinationFolder
                                   overwrite:NO
                                    password:nil
                                       error:&error
                                    delegate:weakSelf]){
                block(YES,error);
            }else{
                block(NO,error);
            }
        }
    }else{
        NSError *error=[NSError errorWithDomain:WattPackagerErrorDomainName
                                           code:1
                                       userInfo:@{@"message": @"_createRecursivelyRequiredFolderForPath failed"}];
        block(NO,error);
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


-(void)_zip:(NSString*)sourcePath
         to:(NSString*)destinationZipFilePath
  withBlock:(void (^)(BOOL success,NSError*error))block
useBackgroundMode:(BOOL)backgroundMode{
    NSError*error=nil;
    WattPackager *__weak weakSelf=self;
    if([self.fileManager fileExistsAtPath:sourcePath]){
        if([self.fileManager fileExistsAtPath:destinationZipFilePath]){
            [self.fileManager removeItemAtPath:destinationZipFilePath error:&error];
        }
        if(error){
            block(NO,error);
        }
        if(backgroundMode){
            [self.queue addOperationWithBlock:^{
                
                if([SSZipArchive createZipFileAtPath:destinationZipFilePath
                             withContentsOfDirectory:sourcePath]){
                    block(YES,nil);
                }else{
                    NSError *error=[NSError errorWithDomain:WattPackagerErrorDomainName
                                                       code:2
                                                   userInfo:@{@"message": @"createZipFileAtPath error"
                                                              ,@"source":[sourcePath copy]
                                                              ,@"destination:":[destinationZipFilePath copy]}];
                    block(NO,error);
                }
            }];
        }else{
            if([SSZipArchive createZipFileAtPath:destinationZipFilePath
                         withContentsOfDirectory:sourcePath]){
                block(YES,nil);
            }else{
                NSError *error=[NSError errorWithDomain:WattPackagerErrorDomainName
                                                   code:2
                                               userInfo:@{@"message": @"createZipFileAtPath error"
                                                          ,@"source":[sourcePath copy]
                                                          ,@"destination:":[destinationZipFilePath copy]}];
                block(NO,error);
            }
            
        }
    }else{
        NSError *error=[NSError errorWithDomain:WattPackagerErrorDomainName
                                           code:3
                                       userInfo:@{@"message": @"Unexisting source",@"source":[sourcePath copy]}];
        block(NO,error);
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
