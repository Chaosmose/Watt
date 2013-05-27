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
#import "WattApi.h"
#import <objc/runtime.h>

@implementation WattObject{    
}


-(id)init{
    self=[self initInRegistry:wattAPI.defaultRegistry];
    if (self) {
        
    }
    return self;
}


-(id)initInRegistry:(WattRegistry*)registry{
    self=[super init];
    if(self){
        if(registry){
            _registry=registry;
            _wapi=[WattApi sharedInstance];
            _uinstID=0;// no registration
            [_registry registerObject:self];
        }else{
           [NSException raise:@"Core" format:@"Attempt to init a WattObject with a Nil  registry"]; 
        }
    }
    return self;
}

-(BOOL)isAnAlias{
    return NO;
}


+ (WattObject*)instanceFromDictionary:(NSDictionary *)aDictionary
                           inRegistry:(WattRegistry*)registry
                      includeChildren:(BOOL)includeChildren{
	WattObject*instance = nil;
	NSInteger wtuinstID=[[aDictionary objectForKey:__uinstID__] integerValue];
    if(wtuinstID<[registry count]){
        instance=[registry objectWithUinstID:wtuinstID];
    }
	if(!instance && [aDictionary objectForKey:__className__]){
		Class theClass=NSClassFromString([aDictionary objectForKey:__className__]);
        if(theClass!=[WattObjectAlias class]){
            // We instantiate the class.
            id unCasted= [[theClass alloc] initInRegistry:registry];
            [unCasted setAttributesFromDictionary:aDictionary];
            instance=(WattObject*)unCasted;
        }else{
            // We keep the alias for runtime resolution.
            // The resolution will occur once in the kvc selector valueForKey:
            return [WattObjectAlias instanceFromDictionary:aDictionary];
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


-(NSDictionary *)dictionaryRepresentationWithChildren:(BOOL)includeChildren{
	NSMutableDictionary *wrapper = [NSMutableDictionary dictionary];
    NSMutableDictionary *dictionary=[NSMutableDictionary dictionary];
	[wrapper setObject:NSStringFromClass([self class]) forKey:__className__];
    [wrapper setObject:dictionary forKey:__properties__];
    [wrapper setObject:[NSNumber numberWithInteger:self.uinstID] forKey:__uinstID__];
    return wrapper;
}



-(WattObject*)localized{
    [self localize];
    return self;
}

-(NSInteger)uinstID{
    return _uinstID;
}

-(void)identifyWithUinstId:(NSInteger)identifier{
    if(_uinstID==0){
        _uinstID=identifier;
    }else if(identifier==_uinstID){
        [NSException raise:@"Registry" format:@"Attempt to re-identify an instance"];
    }else{
        [NSException raise:@"Registry" format:@"Attempt to change the identity of an instance"];
    }
}

-(void)localize{
    if([self hasBeenLocalized]){
        NSArray *keys=[self allPropertiesName];
        for (NSString*key in keys) {
            id o=[self valueForKey:key];
            if([o respondsToSelector:@selector(localize)]){
                [o localize];
            }else{
                [_wapi localize:self withKey:key andValue:o];
            }
        }
    }
    _currentLocale=[[NSLocale currentLocale] localeIdentifier];
}


-(BOOL)hasBeenLocalized{
    return ([[[NSLocale currentLocale] localeIdentifier] isEqualToString:_currentLocale]);
}


// _keys dictionary caches the responses for future uses.
// the seconds invocation for a given class is costless.
-(NSArray*)allPropertiesName{
    if(_propertiesKeys){
        // If the keys have allready been computed
        return _propertiesKeys;
    }else{
        _propertiesKeys=[NSMutableArray array];
    }
    Class currentClass=[self class];
    NSUInteger count;
    // (!) IMPORTANT
    // Each class has its own set o property in the inheritance chain.
    // So we do perform while "currentClass" has a superClass
    while (currentClass) {
        objc_property_t *propList = class_copyPropertyList(currentClass, &count);
        for ( int i = 0; i < count; i++ ){
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

/*
// KVC aliasing
// We dynamicly resolve the reference.
-(id)valueForKey:(NSString *)key{
    id<WattAliasing> value =[super valueForKey:key];
    // isAnAlias is a native method with no reflexion.
    if([value isAnAlias]){
        WattObjectAlias *alias=(WattObjectAlias*)value;
        id reference=[_registry objectWithUinstID:alias.uinstID];
        if(reference){
            return reference;
        }
    }
    return value;
}
*/

@end
