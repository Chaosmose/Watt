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
#import "SSZipArchive.h"

#if TARGET_OS_IPHONE
#import "SVProgressHUD.h"
#endif

@class WattApi;


@interface WattBundlePackager : NSObject

// WTMPackager singleton accessor
+ (WattBundlePackager*)sharedInstance;

// You must set the this property before to use the WattBundlePackager
@property (nonatomic,weak) WattApi *api;



#pragma mark -


-(void)packFolderFromPath:(NSString*)path
                    withBlock:(void (^)(BOOL success))block
            useBackgroundMode:(BOOL)backgroundMode
        withExtension:(NSString*)extension;

-(void)unPackFromPath:(NSString*)path
            withBlock:(void (^)(BOOL success))block
    useBackgroundMode:(BOOL)backgroundMode;




// LEGACY APPROACH


#pragma mark - packaging

-(void)packWattBundleWithName:(NSString*)name
                    withBlock:(void (^)(BOOL success))block
            useBackgroundMode:(BOOL)backgroundMode;

-(void)unPackWattBundleWithName:(NSString*)name
                      withBlock:(void (^)(BOOL success))block
              useBackgroundMode:(BOOL)backgroundMode;

@end
