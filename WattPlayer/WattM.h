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
//  WattTM.h
//
//  Created by Benoit Pereira da Silva on 17/05/13.
//  Copyright (c) 2013 Pereira da Silva. All rights reserved.


#import <Foundation/Foundation.h>



#import "WattApi.h"
#import "WattObject.h"
#import "WattMPackager.h"
#import "WattCollectionOfObject.h"
#import "WattRegistry.h"

//Import of flexion generated classes
#import "WTMModelsImports.h"

#ifndef WT_MACROS
#define WT_CODING_KEYS
#define wattAPI [WattApi sharedInstance]
#define wattPackager [WattMPackager sharedInstance]

#if TARGET_OS_IPHONE
#define currentOrientation() [[UIApplication sharedApplication] statusBarOrientation]
#define isLandscapeOrientation() UIDeviceOrientationIsLandscape(currentOrientation())
#define isIpad()(UI_USER_INTERFACE_IDIOM()==UIUserInterfaceIdiomPad)
#define isWidePhone() ([UIScreen mainScreen].scale == 2.f && [UIScreen mainScreen].bounds.size.height == 568.0f)
#define scale() [UIScreen mainScreen].scale
#import "UIImage+wattAdaptive.h"
#endif



#endif
