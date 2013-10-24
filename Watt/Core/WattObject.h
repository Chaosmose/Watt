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

//  Created by Benoit Pereira da Silva on 09/05/13.
//  Copyright (c) 2013 Pereira da Silva. All rights reserved.
//
#pragma mark Declarations

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


#ifndef WT_RUNTIME_CONFIGURATION
#define WT_RUNTIME_CONFIGURATION

#define selectorSetterFromPropertyName(propertyName) NSSelectorFromString([NSString stringWithFormat:@"set%@:",[propertyName capitalizedString]])
#define selectorGetterFromPropertyName(propertyName) NSSelectorFromString(propertyName)


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
#define kWattBundle                 @".watt"

#define kWattClassPrefix            @"WTM"

#define kWattMe                     @"user-me"
#define kWattMyGroup                @"my-group"
#define kWattMyGroupName            @"users"

#endif

#import "WattRegistry.h"

#if TARGET_OS_IPHONE
#define currentOrientation() [[UIApplication sharedApplication] statusBarOrientation]
#define isLandscapeOrientation() UIDeviceOrientationIsLandscape(currentOrientation())
#define isIpad()(UI_USER_INTERFACE_IDIOM()==UIUserInterfaceIdiomPad)
#define isWidePhone() ([UIScreen mainScreen].scale == 2.f && [UIScreen mainScreen].bounds.size.height == 568.0f)
#define scale() [UIScreen mainScreen].scale
#endif
#endif

@class WattObject;
@class WattApi;

#pragma mark - WattCopying

@protocol WattCopying
@required
/**
 *  Equivalent to NSCopying but with a reference to an explicit registry 
 *  You should implement this method (sample) :
 *
 * - (instancetype)wattCopyInRegistry:(WattRegistry*)destinationRegistry{
 *  <YourClass> *instance=[super wattCopyInRegistry:destinationRegistry];
 *  instance->_registry=destinationRegistry;
 *  instance->_aString=[_aString copy];
 *  instance->_aScalar=_aScalar;
 *  instance->_aWattCopyableObject=[_aWattCopyableObject wattCopyInRegistry:destinationRegistry];
 *  return instance;
 *  }
 *
 *  @param destinationRegistry the registry
 *
 *  @return the copy of the instance in the destinationRegistry
 */
- (instancetype)wattCopyInRegistry:(WattRegistry*)destinationRegistry;
@optional

/**
 *  Implemented in WattObject (no need normaly to implement)
 *  If the copy allready exists in the destination registry
 *  This method returns the existing reference
 *
 *  @param sourceObject        the object to be copied
 *  @param destinationRegistry the registry
 *
 *  @return return the copy
 */
- (WattObject*)instanceOf:(WattObject*)sourceObject
                 byCopyTo:(WattRegistry*)destinationRegistry;
@end



#pragma mark - WattCoding

@protocol WattCoding <NSObject>
@required
- (NSDictionary *)dictionaryRepresentationWithChildren:(BOOL)includeChildren;
- (NSMutableDictionary*)dictionaryOfPropertiesWithChildren:(BOOL)includeChildren;
@end

#pragma mark - WattObject

@interface WattObject : NSObject<WattCoding,WattCopying>{
@private
    NSMutableArray *_propertiesKeys;    // Used by the WTMObject root object to store the properties name
@protected
    NSInteger _uinstID;
    NSString *_currentLocale;           // The locale that has been used for localization
    WattRegistry*_registry;
    BOOL _isAnAlias;
}


@property (readonly)NSInteger uinstID;
@property (readonly)WattRegistry*registry;

// You should normally use only initInRegistry directly

- (instancetype)init;
- (instancetype)initInRegistry:(WattRegistry*)registry;
- (instancetype)initInRegistry:(WattRegistry*)registry withPresetIdentifier:(NSInteger)identifier; //Used for reinstanciation from a device to another
- (instancetype)initAsAliasWithIdentifier:(NSInteger)identifier; // instanciate an alias

// ANY WattObject should be unRegistered to be released from its registry
// autoUnRegister is a facility
-(void)autoUnRegister;

// Do not call directly!
// This selector is used during initialization.
// If used twice will raise an exception "Attempt to re-identify an instance"
- (void)identifyWithUinstId:(NSInteger)identifier;


#pragma mark - Aliasing

- (BOOL)isAnAlias;
- (void)resolveAliases;

- (NSDictionary *)aliasDictionaryRepresentation;
- (NSString*)aliasDescription;

#pragma mark -

+ (instancetype)instanceFromDictionary:(NSDictionary *)aDictionary
                            inRegistry:(WattRegistry*)registry
                       includeChildren:(BOOL)includeChildren;

- (void)setAttributesFromDictionary:(NSDictionary *)aDictionary;

// Returns all the properties keys of the object.
- (NSArray*)propertiesKeys;


#pragma mark - localization

- (instancetype)localized;
- (void)localize;
- (BOOL)hasBeenLocalized;

@end