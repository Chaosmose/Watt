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
//  WTMObjectAlias.m
//  PlayerSample
//
//  Created by Benoit Pereira da Silva on 22/05/13.
//  Copyright (c) 2013 Pereira da Silva. All rights reserved.
//

#import "WattObjectAlias.h"
#import "WattCollectionOfObject.h"

@interface WattObjectAlias(){
}
- (instancetype)initWithUinstID:(NSInteger)uinstID andClassName:(NSString*)className;
- (instancetype)initFromReference:(WattObject*)object andClassName:(NSString*)className;
@end


@implementation WattObjectAlias{
    NSInteger _uinstID;
    NSString* _aliasedClassName;
}

- (instancetype)init{
    [NSException raise:@"Core" format:@"WTMObjectAlias must be initialized using initWithUinstID:"];
    return nil;
}

- (instancetype)initWithUinstID:(NSInteger)uinstID andClassName:(NSString*)className{
    self=[super init];
    if(self){
        _uinstID=uinstID;
        _aliasedClassName=className;
    }
    return self;
}

- (instancetype)initFromReference:(WattObject*)object andClassName:(NSString *)className{
    return [[WattObjectAlias alloc] initWithUinstID:object.uinstID
                                       andClassName:className];
}

- (instancetype)initInRegistry:(WattRegistry*)registry{
    return nil;
}


- (BOOL)isAnAlias{
    return YES;
}

-(void)resolveAliases{
    // Nothing to do
}


+ (NSDictionary*)aliasDictionaryRepresentationFrom:(WattObject*)object{
    return [[[WattObjectAlias alloc]initFromReference:object
                                         andClassName:NSStringFromClass([object class])]
            dictionaryRepresentationWithChildren:NO];
}


+ (WattObjectAlias*)aliasFrom:(WattObject*)object{
    return [[WattObjectAlias alloc] initFromReference:object andClassName:NSStringFromClass([object class])];
}


+ (id)aliasOrCollectionOfAliasFromDictionary:(NSDictionary *)aDictionary inRegistry:(WattRegistry*)registry{
    NSNumber *uinstIDNb=[aDictionary objectForKey:__uinstID__];
    NSString *className=[aDictionary objectForKey:__className__];
    BOOL isAnAlias=([aDictionary objectForKey:__isAliased__] && [[aDictionary objectForKey:__isAliased__] boolValue]==YES);
    if(uinstIDNb && className){
        Class theClass=NSClassFromString(className);
        // It is a collection 
        if( [theClass isSubclassOfClass:[WattCollectionOfObject class]] && [aDictionary objectForKey:__collection__]){
            // We create the collection
            WattCollectionOfObject*collectionOfAlias=(WattCollectionOfObject*)[[theClass alloc] init];
            [collectionOfAlias identifyWithUinstId:[uinstIDNb integerValue]];
            [registry addObject:collectionOfAlias];
            
            NSArray*array=[aDictionary objectForKey:__collection__];
            for (NSDictionary*aliasDictionary in array) {
                WattObjectAlias*alias=[WattObjectAlias aliasOrCollectionOfAliasFromDictionary:aliasDictionary inRegistry:registry];
                [collectionOfAlias addAlias:alias];
            }
            
            return collectionOfAlias;
        }else if(isAnAlias){
            // It is an alias
            WattObjectAlias *alias=[[WattObjectAlias alloc] initWithUinstID:[uinstIDNb integerValue] andClassName:className];
            return alias;
        }else{
            return nil;
        }

    }else{
        [NSException raise:@"WattObjectAlias" format:@"Attempt to instanciate from an inconsistent dictionary %@",aDictionary];
    }
    return nil;
}


- (NSInteger)uinstID{
    return _uinstID;
}

- (NSDictionary *)dictionaryRepresentationWithChildren:(BOOL)includeChildren{
	NSMutableDictionary *wrapper = [NSMutableDictionary dictionary];
    [wrapper setObject:[NSNumber numberWithBool:YES] forKey:__isAliased__];
	[wrapper setObject:_aliasedClassName forKey:__className__];
    [wrapper setObject:[NSNumber numberWithInteger:self.uinstID] forKey:__uinstID__];
    return wrapper;
}

- (NSString*)description{
    return [NSString stringWithFormat:@"Alias of %@(#%i)",_aliasedClassName,self.uinstID];
}

@end
