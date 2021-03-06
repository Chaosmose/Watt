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
//  WattCollectionOfObject.m
//  PlayerSample
//
//  Created by Benoit Pereira da Silva on 17/05/13.
//  Copyright (c) 2013 Pereira da Silva. All rights reserved.
//

#import "WattCollectionOfObject.h"
#import "Watt.h"
#import "WattACL.h"



@implementation WattCollectionOfObject

- (instancetype)init{
    self=[super init];
    if (self) {
        _collection=[NSMutableArray array];
    }
    return self;
}

- (instancetype)initInRegistry:(WattRegistry *)registry{
    self=[super initInRegistry:registry];
    if (self) {
        _collection=[NSMutableArray array];
    }
    return self;
}


- (instancetype)initInRegistry:(WattRegistry*)registry withPresetIdentifier:(NSInteger)identifier{
    self=[super initInRegistry:registry withPresetIdentifier:identifier];
    if(self){
        _collection=[NSMutableArray array];
    }
    return self;
}

- (instancetype)replicateToRegistry:(WattRegistry*)destination{
    Class CurrentClass=[self class];
    id instance=[[CurrentClass alloc] initInRegistry:destination];
    for (id object in _collection) {
        [((WattCollectionOfObject*)instance)->_collection addObject:[((WattObject*)object) replicateToRegistry:destination]];
    }
    return instance;
}




#pragma mark

// Filtering

- (WattCollectionOfObject*)filteredCollectionUsingPredicate:(NSPredicate *)predicate withRegistry:(WattRegistry *)registry{
    NSArray *array=[_collection filteredArrayUsingPredicate:predicate];
    Class currentClass=[self class];
    id instance=[[currentClass alloc]initInRegistry:registry];
    for (id o in array) {
        [instance addObject:o];
    }
    return instance;
    
}



/**
 * Returns collection of object filtered by the predicate
 * Simple filteredCollectionUsingPredicate is faster , use this method if there is no alternative
 *
 *  @param predicate  the predicate
 *  @param sortingKey the sorting key
 *  @param ascending  the sorting order
 *  @param limit      the limit
 *  @param registry   the registry that holds the collection Commonly you pass nil as registry to make the collection un persistent.
 *
 *  @return the filtered collection
 */
- (WattCollectionOfObject*)filteredCollectionUsingPredicate:(NSPredicate *)predicate
                                                 sortingKey:(NSString*)sortingKey
                                                  ascending:(BOOL)ascending
                                                      limit: (NSUInteger)limit
                                               withRegistry:(WattRegistry *)registry{
    
    NSSortDescriptor *descriptor = [NSSortDescriptor sortDescriptorWithKey:sortingKey
                                                                 ascending:ascending];
    NSArray *sorted=nil;
    if(predicate){
        NSArray *array=[_collection filteredArrayUsingPredicate:predicate];
        sorted=[array sortedArrayUsingDescriptors:@[descriptor]];
    }else{
        sorted=[_collection sortedArrayUsingDescriptors:@[descriptor]];
    }
    Class currentClass=[self class];
    id instance=[[currentClass alloc]initInRegistry:registry];
    int i=0;
    for (id o in sorted) {
        if([((WattObject*)o).registry.uidString isEqualToString:registry.uidString]|| !registry){
            [instance addObject:o];
        }else{
            id cpo=[o replicateToRegistry:registry];
            [instance addObject:cpo];
        }
        
        i++;
        if (i >= limit) break;
    }
    return instance;
}


- (WattCollectionOfObject*)filteredCollectionUsingBlock:(BOOL (^)(WattObject *obj))block withRegistry:(WattRegistry *)registry{
    WattCollectionOfObject *__block collection=[[WattCollectionOfObject alloc] initInRegistry:registry];
    [self enumerateObjectsUsingBlock:^(WattObject *obj, NSUInteger idx, BOOL *stop) {
        if(block(obj)){
            [collection addObject:obj];
        }
    } reverse:NO];
    return collection;
}

// Sorting

- (void)sortUsingComparator:(NSComparator)cmptr{
    [_collection sortUsingComparator:cmptr];
}





- (void)enumerateObjectsUsingBlock:(void (^)(WattObject *obj, NSUInteger idx, BOOL *stop))block reverse:(BOOL)useReverseEnumeration{
    BOOL __block reversed=useReverseEnumeration;
    NSUInteger idx = reversed?[self count]-1:0;
    BOOL stop = NO;
    NSEnumerator * enumerator=useReverseEnumeration?[_collection reverseObjectEnumerator]: [_collection objectEnumerator];
    for( WattObject* obj in enumerator ){
        block(obj, (reversed?idx--:idx++), &stop);
        if( stop )
            break;
    }
}


-(void)resolveAliases{
    // We need eventually to replace the alias within the collection by real instances
    NSInteger nb=[_collection count]-1;
    for (NSInteger idx=nb;idx>=0;idx--) {
        WattObject*o=[_collection objectAtIndex:idx];
        if([o isAnAlias]){
            WattObject*instance=(WattObject*)[_registry objectWithUinstID:o.uinstID];
            if(instance){
                [_collection replaceObjectAtIndex:idx withObject:instance];
            }
        }
    }
}



- (void)setAttributesFromDictionary:(NSDictionary *)aDictionary{
	if (![aDictionary isKindOfClass:[NSDictionary class]]) {
		return;
	}
    NSArray *a=[aDictionary objectForKey:__collection__];
    for (NSDictionary*objectDictionary in a) {
        Class c=[objectDictionary objectForKey:__className__]?NSClassFromString([objectDictionary objectForKey:__className__]):[WattObject class];
        id o=[c instanceFromDictionary:objectDictionary
                            inRegistry:_registry
                       includeChildren:YES];
        [_collection addObject:o];
    }
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
            NSDictionary*oDictionary=[o aliasDictionaryRepresentation];
            [array addObject:oDictionary];
        }
    }
    [wrapper setValue:array forKey:__collection__];
	[wrapper setObject:NSStringFromClass([self class]) forKey:__className__];
    [wrapper setObject:dictionary forKey:__properties__];
    [wrapper setObject:[NSNumber numberWithInteger:self.uinstID] forKey:__uinstID__];
    return wrapper;
}


- (WattObject *)objectAtIndex:(NSUInteger)index{
    WattObject*o=[_collection objectAtIndex:index];
    if([o isAnAlias]){
        o=[_registry objectWithUinstID:o.uinstID];
        [_collection replaceObjectAtIndex:index withObject:o];
    }
    return o;
}

- (WattObject *)firstObject{
    if([_collection count]>0){
        return [self objectAtIndex:0];
    }
    return nil;
}

- (WattObject *)lastObject{
    WattObject*o=[_collection lastObject];
    if([o isAnAlias]){
        o=[_registry objectWithUinstID:o.uinstID];
        [_collection replaceObjectAtIndex:[_collection count]-1 withObject:o];
    }
    return o;
}

- (WattObject *)firstObjectCommonWithArray:(NSArray*)array{
    WattObject*o=[_collection firstObjectCommonWithArray:array];
    if([o isAnAlias]){
        NSInteger index=[_collection indexOfObject:o];
        o=[_registry objectWithUinstID:o.uinstID];
        [_collection replaceObjectAtIndex:index withObject:o];
    }
    return o;
}


- (WattObject*)objectWithUinstID:(NSInteger)uinstID{
    for (WattObject*o in _collection) {
        if([o uinstID]==uinstID){
            return o;
        }
    }
    return nil;
}


- (void)addObject:(WattObject*)anObject{
#ifdef  __WT_COLLECTION_ADDITION_RUNTINE_TYPE_CHECKING
    if(![anObject isMemberOfClass:[self collectedObjectClass]]){
        [NSException raise:@"Watt collection type mismatch while calling addObject " format:@"Should be %@", [self collectedObjectClass],anObject?[anObject class]:@"Is nil"];
    }
#endif
    [_collection addObject:anObject];
    self.registry.hasChanged=YES;
}


- (void)insertObject:(WattObject*)anObject atIndex:(NSUInteger)index{
#ifdef  __WT_COLLECTION_ADDITION_RUNTINE_TYPE_CHECKING
    if(![anObject isMemberOfClass:[self collectedObjectClass]]){
        [NSException raise:@"Watt collection type mismatch while calling insertObject " format:@"Should be %@", [self collectedObjectClass],anObject?[anObject class]:@"Is nil"];
    }
#endif
	[_collection insertObject:anObject atIndex:index];
    self.registry.hasChanged=YES;
}

- (void)removeLastObject{
	[_collection removeLastObject];
    self.registry.hasChanged=YES;
}

- (void)removeObjectAtIndex:(NSUInteger)index{
    [_collection removeObjectAtIndex:index];
    self.registry.hasChanged=YES;
}


- (void)removeObject:(WattObject*)object{
    [_collection removeObject:object];
    self.registry.hasChanged=YES;
}

- (void)replaceObjectAtIndex:(NSUInteger)index withObject:(WattObject*)anObject{
#ifdef  __WT_COLLECTION_ADDITION_RUNTINE_TYPE_CHECKING
    if(![anObject isMemberOfClass:[self collectedObjectClass]]){
        [NSException raise:@"Watt collection type mismatch while calling replaceObjectAtIndex " format:@"Should be %@", [self collectedObjectClass],anObject?[anObject class]:@"Is nil"];
    }
#endif
    [_collection replaceObjectAtIndex:index withObject:anObject];
    self.registry.hasChanged=YES;
}

- (void)moveObjectFromIndex:(NSUInteger)from toIndex:(NSUInteger)to{
    if (to != from) {
        id obj = [_collection objectAtIndex:from];
        [_collection removeObjectAtIndex:from];
        if (to >= [self count]) {
            [_collection addObject:obj];
        } else {
            [_collection insertObject:obj atIndex:to];
        }
        self.registry.hasChanged=YES;
    }
}



- (BOOL)containsAnObjectWithID:(NSUInteger)uinstID{
    for (WattObject*o in _collection) {
        if(o.uinstID==uinstID)
            return YES;
    }
    return NO;
}

- (NSUInteger)indexOfObjectWithID:(NSUInteger)uinstID{
    NSUInteger i=0;
    for (WattObject*o in _collection) {
        if(o.uinstID==uinstID)
            return i;
        i++;
    }
    return NSNotFound;
}



-(NSUInteger)count{
    return [_collection count];
}

- (NSUInteger)indexOfObject:(WattObject *)object{
    return [_collection indexOfObject:object];
}


- (NSString*)description{
    if([self isAnAlias])
        return [super aliasDescription];
	NSMutableString *s=[NSMutableString string];
    Class theClass=(_collection && [_collection count]>0)?[[_collection objectAtIndex:0] class]:[NSNull class];
    [s appendFormat:@"Collection of %@\n",NSStringFromClass(theClass)];
    [s appendFormat:@"With of %@ members\n",_collection?@([_collection count]):@(0)];
	return s;
}

#pragma mark - index


/**
 *  This selector enumerates the member of the collection and allocate the index value
 *  and allocate to the designated property
 *
 *  @param propertyName the name of the property
 */
- (void)computeCollectionIndexesAndStoreInPropertyWithName:(NSString*)propertyName{
    SEL selectorForProperty=selectorSetterFromPropertyName(propertyName);
    BOOL tested=NO;
    BOOL ok=YES;
    NSInteger i=0;
    for (id member in _collection) {
        if(!tested)
            ok=[member respondsToSelector:selectorForProperty];
        if(!ok){
            [NSException raise:@"computeCollectionIndexesAndStoreInPropertyWithName"
                        format:@"Member does not respond to %@",NSStringFromSelector(selectorForProperty)];
        }else{
            [member setValue:@(i) forKey:propertyName];
        }
        i++;
    }
}


#pragma mark - runtime

/**
 *  Used when __WT_COLLECTION_ADDITION_RUNTINE_TYPE_CHECKING is defined
 *
 *  @return the collectedObjectClass
 */
- (Class)collectedObjectClass{
    return [WattObject class];
}
@end