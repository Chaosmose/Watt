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
//  WattBundlePackager.h
//
//  Created by Benoit Pereira da Silva on 17/05/13.
//  Copyright (c) 2013 Pereira da Silva. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WattPackager : NSObject

// WTMPackager singleton accessor
+ (WattPackager*)sharedInstance;

/**
 *  By default ".watt" you can use your own packExtension
 */
@property (nonatomic,copy) NSString *defaultPackExtension;

/**
 * The file  manager
 */
@property (atomic,strong)  NSFileManager *fileManager;


#pragma mark - Packaging

/**
 *  Pack the folder
 *
 *  @param path           the source path
 *  @param block          the completion block with the success flag an the final path
 *  @param backgroundMode should the operation be performed in background
 *  @param overWrite      if there is an existing destination and set to yes it is overwritten
 */
-(void)packFolderFromPath:(NSString*)path
                    withBlock:(void (^)(BOOL success, NSString*packPath, NSError*error))block
            useBackgroundMode:(BOOL)backgroundMode
                overWrite:(BOOL)overWrite;


/**
 *  Unpack
 *
 *  @param sourcePath        the source path
 *  @param destinationFolder the destination
 *  @param block             the completion block with the success flag an the final path
 *  @param backgroundMode    should the operation be performed in background
 *  @param overWrite      if there is an existing destination and set to yes it is overwritten
 */
-(void)unPackFromPath:(NSString*)sourcePath
                   to:(NSString*)destinationFolder
            withBlock:(void (^)(BOOL success,NSString*path,NSError*error))block
    useBackgroundMode:(BOOL)backgroundMode
   overWrite:(BOOL)overWrite;









@end
