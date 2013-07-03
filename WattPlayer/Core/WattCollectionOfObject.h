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

#import "WattObject.h"

@class WattRegistry;
@class WattObjectAlias;

@interface WattCollectionOfObject : WattObject {
@protected
    NSMutableArray* _collection;
}

/*
 Returns a collection filtered.
 Commonly you pass nil as registry to make the collection un persistent.
 */
-(WattCollectionOfObject*)filteredCollectionUsingPredicate:(NSPredicate *)predicate withRegistry:(WattRegistry *)registry;

// Accessors

- (WattObject *)objectAtIndex:(NSUInteger)index;
- (WattObject *)lastObject;
- (WattObject *)firstObjectCommonWithArray:(NSArray*)array;
- (WattObject*)objectWithObjectName:(NSString*)objectName;
- (WattObject*)objectWithUinstID:(NSInteger)uinstID;



- (void)addObject:(WattObject*)anObject;
- (void)insertObject:(WattObject*)anObject atIndex:(NSUInteger)index;
- (void)removeLastObject;
- (void)removeObjectAtIndex:(NSUInteger)index;
- (void)replaceObjectAtIndex:(NSUInteger)index withObject:(WattObject*)anObject;

- (NSUInteger)indexOfObjectWithID:(NSUInteger)uinstID;
- (BOOL)containsAnObjectWithID:(NSUInteger)uinstID;

- (NSUInteger)count;
- (NSUInteger)indexOfObject:(WattObject *)object;
- (void)removeObject:(WattObject*)object;

@end
