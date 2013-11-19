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
//  Watt.h
//
//  Created by Benoit Pereira da Silva on 17/05/13.
//  Copyright (c) 2013 Pereira da Silva. All rights reserved.

#import "WattDefinitions.h"

#ifndef __WT_LOG
#define __WT_LOG 1 // You can set up WT_LOG to 1 or 0
typedef enum logNatures{
    WT_LOG_DEBUG=0,
    WT_LOG_RUNTIME=1,
}LogNature;
#if WT_LOG
#define WTLogNF(nature,format, ... ){\
NSLog( @"WT(%i):%s line:%d:{\n%@\n}\n",\
nature,\
__PRETTY_FUNCTION__,\
__LINE__ ,\
[NSString stringWithFormat:(format), ##__VA_ARGS__]\
);\
}
#define WTLog(format, ...){ WTLogNF(WT_LOG_DEBUG,format, ##__VA_ARGS__); }
#define WTLogN(message,nature){ WTLogNF(nature,@"%@",message); }
#else
#define WTLogNF(nature,format, ... ){}
#define WTLog(format, ...){  }
#define WTLogN(message,nature){ }
#endif
#endif

#ifndef __WT_RUNTIME_CONFIGURATION
#define __WT_RUNTIME_CONFIGURATION


#define selectorSetterFromPropertyName(propertyName) NSSelectorFromString([NSString stringWithFormat:@"set%@:",[propertyName capitalizedString]])
#define selectorGetterFromPropertyName(propertyName) NSSelectorFromString(propertyName)

#if TARGET_OS_IPHONE
#define currentOrientation() [[UIApplication sharedApplication] statusBarOrientation]
#define isLandscapeOrientation() UIDeviceOrientationIsLandscape(currentOrientation())
#define isIpad()(UI_USER_INTERFACE_IDIOM()==UIUserInterfaceIdiomPad)
#define isWidePhone() ([UIScreen mainScreen].scale == 2.f && [UIScreen mainScreen].bounds.size.height == 568.0f)
#define scale() [UIScreen mainScreen].scale
#endif
#endif

#pragma mark - Imports

#import "WattObjectProtocols.h"
#import "WattObject.h"
#import "WattRegistry.h"
#import "WattCollectionOfObject.h"

#import "WattACL.h"
#import "WattDelta.h"
#import "WattDeltaEngine.h"
#import "WattPackager.h"


#import "NSObject+WattBase.h"
#import "WattObject+ExternalReference.h"

#pragma mark - generated imports

#import "WattImports.h"
