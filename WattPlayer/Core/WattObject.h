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
//  WTMObject.h
//  PlayerSample
//
//  Created by Benoit Pereira da Silva on 09/05/13.
//  Copyright (c) 2013 Pereira da Silva. All rights reserved.
//


#pragma mark - log macros

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

#pragma mark - WattCoding

#ifndef WT_CODING_KEYS
#define WT_CODING_KEYS
#define __uinstID__         @"i"
#define __className__       @"cln"
#define __properties__      @"p"
#define __collection__      @"cll"
#endif

#pragma mark - Runtime

#ifndef WT_RUNTIME_CONFIGURATION
#define WT_RUNTIME_CONFIGURATION
#define WT_ALLOW_MULTIPLE_REGISTRATION 1
#endif

@class WattObject;
@class WattApi;

#import "WattRegistry.h"

#pragma mark WattAliasing
@protocol WattAliasing <NSObject>
@required
- (BOOL)isAnAlias;
- (id)initInRegistry:(WattRegistry*)registry;
@end



@interface WattObject : NSObject<WattAliasing>{
    @private
    NSString *_currentLocale;           // The locale that has been used for localization
    NSMutableArray *_propertiesKeys;    // Used by the WTMObject root object to store the properties name
    WattApi *_wapi;
    NSInteger _uinstID;
    @protected
    WattRegistry*_registry;
}

#pragma mark - registry

@property (readonly)NSInteger uinstID;
@property (readonly)WattRegistry*registry;

- (id)init; // Uses WattApi.defaultRegistry

// WattAliasing
//- (id)initInRegistry:(WattRegistry*)registry;

// Do not call directly!
// This selector is used during initialization.
// If used twice will raise an exception "Attempt to re-identify an instance"
- (void)identifyWithUinstId:(NSInteger)identifier;

#pragma mark - pseudo protocol implementation 

+ (WattObject*)instanceFromDictionary:(NSDictionary *)aDictionary
                           inRegistry:(WattRegistry*)registry
                      includeChildren:(BOOL)includeChildren;

- (void)setAttributesFromDictionary:(NSDictionary *)aDictionary;

- (NSDictionary *)dictionaryRepresentationWithChildren:(BOOL)includeChildren;


#pragma mark - localization

- (WattObject*)localized; // Usually overriden for strong typing during Flexions
- (void)localize;
- (BOOL)hasBeenLocalized;

// Reflexion utility that is not as fast as NSFastEnumeration on the first call 
// But this approach is much more flexible in our context KVC, inheritance & universal persistency.
- (NSArray*)allPropertiesName;
@end




#pragma mark WattCoding
@protocol WattCoding <NSObject>
+ (WattObject*)instanceFromDictionary:(NSDictionary *)aDictionary
                           inRegistry:(WattRegistry*)registry
                      includeChildren:(BOOL)includeChildren; // Usually overriden to return strongly typed instances during Flexions

- (NSDictionary *)dictionaryRepresentationWithChildren:(BOOL)includeChildren;
@end


