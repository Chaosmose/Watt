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
#define WT_MACROS
#define wattAPI [WattApi sharedInstance]
#define wattPackager [WattMPackager sharedInstance]
#endif

#ifndef WT_CODING_KEYS
#define WT_CODING_KEYS
#define __uinstID__         @"i"
#define __className__       @"c"
#define __properties__      @"p"
#define __collection__      @"cl"
#define __isAliased__       @"a"
#endif

#ifndef WT_CONST
#define WT_CONST
#define kWattAPIExecptionName       @"WattAPIException"
#define kCategoryNameShared         @"shared"
#define kDefaultName                @"default"
#define kRegistryFileName           @"registry"
#define kWattSalt                   @"98717405-4A30-4DDC-9AA8-14E840D4D1F8"

#endif