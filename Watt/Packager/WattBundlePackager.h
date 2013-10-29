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

@interface WattBundlePackager : NSObject

// WTMPackager singleton accessor
+ (WattBundlePackager*)sharedInstance;


/**
 *  By default ".watt" you can use your own packExtension
 */
@property (nonatomic,copy) NSString *defaultPackExtension;

#pragma mark - Packaging


/**
 *  Pack the folder
 *
 *  @param path           the source path
 *  @param block          the completion block with the success flag an the final path
 *  @param backgroundMode should the operation be performed in background
 */
-(void)packFolderFromPath:(NSString*)path
                    withBlock:(void (^)(BOOL success, NSString*packPath))block
            useBackgroundMode:(BOOL)backgroundMode;


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
    useBackgroundMode:(BOOL)backgroundMode;



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
           withBlock:(void (^)(BOOL success,NSString*path))block;


#pragma mark - Uploading

// SHOULD BE IMPLEMENTED PER PROJECT
// POST to a given URL


@end
