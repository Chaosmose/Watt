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
//  WTMObject.m
//  PlayerSample
//
//  Created by Benoit Pereira da Silva on 09/05/13.
//  Copyright (c) 2013 Pereira da Silva. All rights reserved.
//

#import "WattObject.h"
#import "WattCollectionOfObject.h"
#import <objc/runtime.h>

@interface WattObject(){
    BOOL _aliasesHasBeenResolved; //A flag to Prevent circular desaliasing.
}
@end

@implementation WattObject{
}


- (instancetype)init{
    self=[self initInRegistry:nil];
    if (self) {
        
    }
    return self;
}

- (instancetype)initAsAliasWithIdentifier:(NSInteger)identifier{
    self=[self initInRegistry:nil];
    if (self) {
        _uinstID=identifier;
        _isAnAlias=YES;
    }
    return self;
}


- (instancetype)initInRegistry:(WattRegistry*)registry{
    return [self initInRegistry:registry withPresetIdentifier:0];
}


- (instancetype)initInRegistry:(WattRegistry*)registry withPresetIdentifier:(NSInteger)identifier{
    self=[super init];
    if(self){
        _uinstID=identifier;// no registration
        if(registry){
            _registry=registry;
            [_registry registerObject:self];
            _isAnAlias=NO;
        }else{
            // The registry is nil
            // Used for temp collection for example.
            // Or for aliases.
        }
    }
    return self;
}


#pragma  mark -  WattCopying

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
- (instancetype)wattCopyInRegistry:(WattRegistry*)destinationRegistry{
    WattObject*instance=[[[self class] alloc] init];
    instance->_registry=destinationRegistry;
    instance->_uinstID=[self uinstID];
    [destinationRegistry addObject:instance];
    destinationRegistry.hasChanged=YES;
    return instance;
}

/**
 *  Implemented in WattObject (no need normaly to implement)
 *  If the copy allready exists in the destination registry
 *  This method returns the existing reference
 *
 *  @param destinationRegistry the registry
 *
 *  @return return the copy
 */
- (instancetype)instancebyCopyTo:(WattRegistry*)destinationRegistry{
    WattObject *instance=[destinationRegistry objectWithUinstID:[self uinstID]];
    if(!instance){
        instance=[self wattCopyInRegistry:destinationRegistry];
    }
    if(![destinationRegistry objectWithUinstID:[instance uinstID]]){
        [destinationRegistry addObject:instance];
    }
    return instance;
}



#pragma mark - WattExtraction

/**
 *  Equivalent to WattCopying but without integration of non extractible properties
 *  You should implement this method the same way WattCopying but :
 *  instance->_aExtractible=< the copy logic >
 *  instance->_aNonExtractible=nil;
 *  return instance;
 *  }
 *
 *  @param destinationRegistry the registry
 *
 *  @return the copy of the instance in the destinationRegistry
 */
- (instancetype)wattExtractAndCopyToRegistry:(WattRegistry*)destinationRegistry{
    return [self instancebyCopyTo:destinationRegistry];
}




#pragma mark -


-(void)autoUnRegister{
    [_registry unRegisterObject:self];
}


- (BOOL)isAnAlias{
    return _isAnAlias;
}


+ (instancetype)instanceFromDictionary:(NSDictionary *)aDictionary
                            inRegistry:(WattRegistry*)registry
                       includeChildren:(BOOL)includeChildren{
    NSInteger wtuinstID=[[aDictionary objectForKey:__uinstID__] integerValue];
    WattObject*instance =[registry objectWithUinstID:wtuinstID];
    if(instance){
        return instance;
    }else{
        if(![aDictionary objectForKey:__className__]){
            instance=[[WattObject alloc] initAsAliasWithIdentifier:wtuinstID];
        }else{
            // We instantiate the class.
            Class theClass=NSClassFromString([aDictionary objectForKey:__className__]);
            instance= [[theClass alloc] initInRegistry:registry withPresetIdentifier:wtuinstID];
            [instance setAttributesFromDictionary:aDictionary];
        }
	}
	return instance;
}

- (void)setAttributesFromDictionary:(NSDictionary *)aDictionary{
	if (![aDictionary isKindOfClass:[NSDictionary class]]) {
		return;
	}
    if([aDictionary objectForKey:__className__]){
        NSNumber *uinstID=[aDictionary objectForKey:__uinstID__];
        if(uinstID){
            id properties=[aDictionary objectForKey:__properties__];
            NSString *selfClassName=NSStringFromClass([self class]);
            if (![selfClassName isEqualToString:[aDictionary objectForKey:__className__]]) {
                [NSException raise:@"WTMAttributesException" format:@"selfClassName %@ is not a %@ ",selfClassName,[aDictionary objectForKey:__className__]];
            }
            if([properties isKindOfClass:[NSDictionary class]]){
                for (NSString *key in properties) {
                    id value=[properties objectForKey:key];
                    if(value)
                        [self setValue:value forKey:key];
                }
            }else{
                [NSException raise:@"WTMAttributesException" format:@"properties is not a NSDictionary"];
            }
        }else{
            [NSException raise:@"WTMAttributesException" format:@"No uinstID in NSDictionary"];
        }
    }else{
        [self setValuesForKeysWithDictionary:aDictionary];
    }
}


- (NSDictionary *)dictionaryRepresentationWithChildren:(BOOL)includeChildren{
	NSMutableDictionary *wrapper = [NSMutableDictionary dictionary];
	[wrapper setObject:NSStringFromClass([self class]) forKey:__className__];
    [wrapper setObject:[self dictionaryOfPropertiesWithChildren:includeChildren] forKey:__properties__];
    [wrapper setObject:[NSNumber numberWithInteger:self.uinstID] forKey:__uinstID__];
    return wrapper;
}


- (NSMutableDictionary*)dictionaryOfPropertiesWithChildren:(BOOL)includeChildren{
    return [NSMutableDictionary dictionary];
}


- (instancetype)localized{
    [self localize];
    return self;
}

- (NSInteger)uinstID{
    return _uinstID;
}

- (void)identifyWithUinstId:(NSInteger)identifier{
    if(_uinstID==0){
        _uinstID=identifier;
    }else if(identifier==_uinstID){
        [NSException raise:@"Registry" format:@"Attempt to re-identify an instance"];
    }else{
        [NSException raise:@"Registry" format:@"Attempt to change the identity of an instance"];
    }
}

- (void)localize{
    if(![self hasBeenLocalized]){
        _currentLocale=[[NSLocale currentLocale] localeIdentifier];
        NSArray *keys=[self propertiesKeys];
        for (NSString*key in keys) {
            id o=[self valueForKey:key];
            if([o respondsToSelector:@selector(localize)]&&[o respondsToSelector:@selector(hasBeenLocalized)]){
                if(![o hasBeenLocalized])
                    [o localize];
            }else{
#warning todo
                //[_wapi localize:self withKey:key andValue:o];
            }
        }
    }
    
}


- (BOOL)hasBeenLocalized{
    return ([[[NSLocale currentLocale] localeIdentifier] isEqualToString:_currentLocale]);
}


// _keys dictionary caches the responses for future uses.
// the seconds invocation for a given class is costless.
- (NSArray*)propertiesKeys{
    if(_propertiesKeys){
        // If the keys have allready been computed
        return _propertiesKeys;
    }else{
        _propertiesKeys=[NSMutableArray array];
    }
    Class currentClass=[self class];
    NSUInteger  count;
    // (!) IMPORTANT
    // Each class has its own set of property in the inheritance chain.
    // So we do perform while "currentClass" has a superClass
    while (currentClass) {
        objc_property_t *propList = class_copyPropertyList(currentClass, &count);
        for ( NSUInteger i = 0; i < count; i++ ){
            objc_property_t property = propList[i];
            const char *propName = property_getName(property);
            NSString*keyString=[NSString stringWithCString:propName encoding:NSASCIIStringEncoding];
            [_propertiesKeys addObject:keyString];
        }
        free(propList);
        currentClass=[currentClass superclass];
    }
    return [NSArray arrayWithArray:_propertiesKeys];
}


// Attempt to resolve the aliases
- (void)resolveAliases{
    if(!_aliasesHasBeenResolved){
        _aliasesHasBeenResolved=YES;
        NSArray *p=[self propertiesKeys];
        for (NSString*key in p) {
            id value=[self valueForKey:key];
            if(value){
                if([value respondsToSelector:@selector(isAnAlias)] && [value isAnAlias]){
                    id instance=[_registry objectWithUinstID:[value uinstID]];
                    if(instance){
                        [self setValue:instance forKey:key];
                    }
                }else if([value respondsToSelector:@selector(resolveAliases)]){
                    // Recursive alias resolution
                    [value resolveAliases];
                }
            }
        }
    }
}


#pragma mark - alias mode

- (NSDictionary *)aliasDictionaryRepresentation{
	NSMutableDictionary *wrapper = [NSMutableDictionary dictionary];
    [wrapper setObject:[NSNumber numberWithInteger:self.uinstID] forKey:__uinstID__];
    return wrapper;
}

- (NSString*)aliasDescription{
    return [NSString stringWithFormat:@"Alias of %@(#%i)",NSStringFromClass([self class]),self.uinstID];
}


@end