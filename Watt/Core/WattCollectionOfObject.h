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
//  WattCollectionOfObject.h
//  PlayerSample
//
//  Created by Benoit Pereira da Silva on 17/05/13.
//  Copyright (c) 2013 Pereira da Silva. All rights reserved.
//

#import "WattObjectProtocols.h"
#import "WattObject.h"

@interface WattCollectionOfObject : WattObject {
    @protected
    NSMutableArray* _collection;
}


#pragma mark - filtering
    
    /**
     *  Returns collection of object filtered by the predicate
     *
     *  @param predicate the predicate to filter the collection
     *  @param registry the registry that holds the collection Commonly you pass nil as registry to make the collection un persistent.
     *
     *  @return The filtered collection
     */
- (WattCollectionOfObject*)filteredCollectionUsingPredicate:(NSPredicate *)predicate withRegistry:(WattRegistry *)registry;
    
    
    
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
                                               withRegistry:(WattRegistry *)registry;
    
    
    
    /**
     * Returns collection of object filtered by the block
     *
     *  @param block the block that determine if a member of the source collection should be included into the filtered collection
     *  @param registry the registry that holds the collection Commonly you pass nil as registry to make the collection un persistent.
     *
     *  @return The filtered collection
     */
- (WattCollectionOfObject*)filteredCollectionUsingBlock:(BOOL (^)(WattObject *obj))block withRegistry:(WattRegistry *)registry;
    
    
#pragma mark - sorting
    
    /**
     *  Sorts the collection using a comparator
     *
     *  @param cmptr the comparator  NSComparisonResult (^NSComparator)(id obj1, id obj2)
     */
- (void)sortUsingComparator:(NSComparator)cmptr;
    
    
#pragma mark -
    
- (WattObject *)objectAtIndex:(NSUInteger)index;
- (WattObject *)firstObject;
- (WattObject *)lastObject;
- (WattObject *)firstObjectCommonWithArray:(NSArray*)array;
- (WattObject*)objectWithUinstID:(NSInteger)uinstID;
    
#pragma mark - Enumeration
    
- (void)enumerateObjectsUsingBlock:(void (^)(WattObject *obj, NSUInteger idx, BOOL *stop))block reverse:(BOOL)useReverseEnumeration;
    
#pragma mark -
    
- (void)addObject:(WattObject*)anObject;
- (void)insertObject:(WattObject*)anObject atIndex:(NSUInteger)index;
- (void)removeLastObject;
- (void)removeObjectAtIndex:(NSUInteger)index;
- (void)replaceObjectAtIndex:(NSUInteger)index withObject:(WattObject*)anObject;
- (void)moveObjectFromIndex:(NSUInteger)from toIndex:(NSUInteger)to;
    
    
- (NSUInteger)indexOfObjectWithID:(NSUInteger)uinstID;
- (BOOL)containsAnObjectWithID:(NSUInteger)uinstID;
    
- (NSUInteger)count;
- (NSUInteger)indexOfObject:(WattObject *)object;
- (void)removeObject:(WattObject*)object;
    
    
#pragma mark - index
    
    /**
     *  This selector enumerates the member of the collection and allocate the index value
     *  and allocate to the designated property
     *
     *  @param propertyName the name of the property
     */
- (void)computeCollectionIndexesAndStoreInPropertyWithName:(NSString*)propertyName;



#pragma mark - runtime

/**
 *  Used when __WT_COLLECTION_ADDITION_RUNTINE_TYPE_CHECKING is defined
 *
 *  @return the collectedObjectClass
 */
- (Class)collectedObjectClass;


@end
