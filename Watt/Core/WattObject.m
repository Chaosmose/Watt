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
#import "WattApi.h"
#import <objc/runtime.h>

@implementation WattObject{
}


- (instancetype)init{
    self=[self initInRegistry:nil];
    if (self) {
        
    }
    return self;
}

- (instancetype)initAsAliasWithidentifier:(NSInteger)identifier{
    self=[self initInRegistry:nil];
    if (self) {
        _uinstID=identifier;
        _isAnAlias=YES;
    }
    return self;
}


- (instancetype)initInRegistry:(WattRegistry*)registry{
    self=[super init];
    if(self){
        _wapi=wattAPI;
        _uinstID=0;// no registration
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


-(void)autoUnRegister{
    [_registry unRegisterObject:self];
}



- (BOOL)isAnAlias{
    return _isAnAlias;
}


+ (instancetype)instanceFromDictionary:(NSDictionary *)aDictionary
                            inRegistry:(WattRegistry*)registry
                       includeChildren:(BOOL)includeChildren{
    
	WattObject*instance = nil;
	NSInteger wtuinstID=[[aDictionary objectForKey:__uinstID__] integerValue];
    if(wtuinstID<[registry count]){
        instance=[registry objectWithUinstID:wtuinstID];
        return instance;
    }
    
	if(!instance  ){
        if(![aDictionary objectForKey:__className__]){
            instance=[[WattObject alloc] initAsAliasWithidentifier:wtuinstID];
        }else{
            // We instantiate the class.
            Class theClass=NSClassFromString([aDictionary objectForKey:__className__]);
            instance= [[theClass alloc] initInRegistry:registry];
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
                [_wapi localize:self withKey:key andValue:o];
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
