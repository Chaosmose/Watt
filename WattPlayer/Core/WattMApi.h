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
//  WTMApi.h
//
//  Created by Benoit Pereira da Silva on 17/05/13.
//  Copyright (c) 2013 Pereira da Silva. All rights reserved.
//

#import <Foundation/Foundation.h>


#ifndef WT_LOG
#define WT_LOG 1 // You can set up WT_LOG to 1 or 0
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

#import "WTMObject.h"

@protocol WTMlocalizationDelegateProtocol;

@interface WattMApi : NSObject

@property (nonatomic,assign)id<WTMlocalizationDelegateProtocol>localizationDelegate;

// WattMApi singleton accessor
+(WattMApi*)sharedInstance;

#pragma mark localization

//This method is called from WTMObject within the localize implementation.
//Calls the localizationDelegate if it is set or invokes the default implementation
-(void)localize:(WTMObject*)reference withKey:(NSString*)key andValue:(id)value;

@end

#pragma mark localization delegate prototocol
// You can implement this protocol if you want to customize the internationalization process.
@protocol WTMlocalizationDelegateProtocol <NSObject>
@required
-(void)localize:(id)reference withKey:(NSString*)key andValue:(id)value;
@end
