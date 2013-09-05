// This file is part of "WTM"
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
//  WTM.h
//
//  Created by Benoit Pereira da Silva on 10/08/2013
//  Copyright (c) 2013 Pereira da Silva. All rights reserved.


// WTM is built on Watt
#import "Watt.h"
#import "WTMApi.h"


#ifndef WTM_MACROS
#define WTM_MACROS
#define wtmAPI [WTMApi sharedInstance]
#define wtmRegistry [wtmAPI currentRegistry]
#endif

#ifndef WTM_CONST
#define WTM_CONST
#endif


#if TARGET_OS_IPHONE
#import "UIImage+wattAdaptive.h"
#endif

