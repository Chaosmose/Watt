//
//  WTMCollectionOfModel.m
//  PlayerSample
//
//  Created by Benoit Pereira da Silva on 17/05/13.
//  Copyright (c) 2013 Pereira da Silva. All rights reserved.
//

#import "WattCollectionOfObject.h"

@implementation WattCollectionOfObject

-(id)init{
    self=[self initInRegistry:wattAPI.defaultRegistry];
    if (self) {
        _collection=[NSMutableArray array];
    }
    return self;
}

-(id)initInRegistry:(WattRegistry *)registry{
    self=[super initInRegistry:registry];
    if (self) {
        _collection=[NSMutableArray array];
    }
    return self;
}


- (void)localize{
    for (WattObject*object in _collection) {
        if([object respondsToSelector:@selector(localize)]){
            [object localize];
        }
    }
}

- (void)setAttributesFromDictionary:(NSDictionary *)aDictionary{
	if (![aDictionary isKindOfClass:[NSDictionary class]]) {
		return;
	}
	
    NSArray *a=[aDictionary objectForKey:__collection__];
    for (NSDictionary*objectDictionary in a) {
        Class c=NSClassFromString([objectDictionary objectForKey:__className__]);
        id o=[c instanceFromDictionary:objectDictionary inRegistry:_registry includeChildren:YES];
        [_collection addObject:o];
    }
}

+ (WattCollectionOfObject*)instanceFromDictionary:(NSDictionary *)aDictionary
                                       inRegistry:(WattRegistry*)registry
                                  includeChildren:(BOOL)includeChildren{
	WattCollectionOfObject*instance = nil;
	NSInteger wtuinstID=[[aDictionary objectForKey:__uinstID__] integerValue];
    if(wtuinstID<[registry count]){
        return (WattCollectionOfObject*)[registry objectWithUinstID:wtuinstID];
    }
	if([aDictionary objectForKey:__className__] && [aDictionary objectForKey:__properties__]){
		Class theClass=NSClassFromString([aDictionary objectForKey:__className__]);
        if(theClass!=[WattObjectAlias class]){
            // We instantiate the class.
            id unCasted= [[theClass alloc] initInRegistry:registry];
            [unCasted setAttributesFromDictionary:aDictionary];
            instance=(WattCollectionOfObject*)unCasted;
        }else{
            // We keep the alias for runtime resolution.
            // The resolution will occur once in the kvc selector valueForKey:
            return [WattObjectAlias instanceFromDictionary:aDictionary];
        }
	}
	return instance;
}

- (NSDictionary*)dictionaryRepresentationWithChildren:(BOOL)includeChildren{
	NSMutableDictionary *wrapper = [NSMutableDictionary dictionary];
	NSMutableDictionary *dictionary = [NSMutableDictionary dictionary];
    NSMutableArray *array=[NSMutableArray array];
    for (WattObject *o in _collection) {
        if(includeChildren){
            NSDictionary*oDictionary=[o dictionaryRepresentationWithChildren:includeChildren];
            [array addObject:oDictionary];
        }else{
            // We store an alias.
            NSDictionary*oDictionary=[WattObjectAlias aliasDictionaryRepresentationFrom:o];
            [array addObject:oDictionary];
        }
    }
    [dictionary setValue:array forKey:__collection__];
	[wrapper setObject:NSStringFromClass([self class]) forKey:__className__];
    [wrapper setObject:dictionary forKey:__properties__];
    [wrapper setObject:[NSNumber numberWithInteger:self.uinstID] forKey:__uinstID__];
    return wrapper;
}


- (WattObject *)objectAtIndex:(NSUInteger)index{
    WattObject*o=[_collection objectAtIndex:index];
    if([o isAnAlias]){
        WattObjectAlias *alias=(WattObjectAlias*)o;
        o=[_registry objectWithUinstID:alias.uinstID];
        [_collection replaceObjectAtIndex:index withObject:o];
    }
    return o;
}

- (WattObject *)lastObject{
    WattObject*o=[_collection lastObject];
    if([o isAnAlias]){
        WattObjectAlias *alias=(WattObjectAlias*)o;
        o=[_registry objectWithUinstID:alias.uinstID];
        [_collection replaceObjectAtIndex:[_collection count]-1 withObject:o];
    }
    return o;
}

- (WattObject *)firstObjectCommonWithArray:(NSArray*)array{
    WattObject*o=[_collection firstObjectCommonWithArray:array];
    if([o isAnAlias]){
        WattObjectAlias *alias=(WattObjectAlias*)o;
        NSInteger index=[_collection indexOfObject:o];
        o=[_registry objectWithUinstID:alias.uinstID];
        [_collection replaceObjectAtIndex:index withObject:o];
    }
    return o;
}

- (void)addObject:(WTMActivity*)anObject{
 	[_collection addObject:anObject];
}

- (void)insertObject:(WTMActivity*)anObject atIndex:(NSUInteger)index{
	[_collection insertObject:anObject atIndex:index];
}

- (void)removeLastObject{
	[_collection removeLastObject];
}

- (void)removeObjectAtIndex:(NSUInteger)index{
    [_collection removeObjectAtIndex:index];
}

- (void)replaceObjectAtIndex:(NSUInteger)index withObject:(WTMActivity*)anObject{
    [_collection replaceObjectAtIndex:index withObject:anObject];
}

@end
