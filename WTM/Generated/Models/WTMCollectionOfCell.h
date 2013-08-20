// This file is part of "WTM"
// 
// "WTM" is free software: you can redistribute it and/or modify
// it under the terms of the GNU LESSER GENERAL PUBLIC LICENSE as published by
// the Free Software Foundation, either version 3 of the License, or
// (at your option) any later version.
// 
// "WTM" is distributed in the hope that it will be useful,
// but WITHOUT ANY WARRANTY; without even the implied warranty of
// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
// GNU LESSER GENERAL PUBLIC LICENSE for more details.
// 
// You should have received a copy of the GNU LESSER GENERAL PUBLIC LICENSE
// along with "WTM"  If not, see <http://www.gnu.org/licenses/>
// 
//  WTMCollectionOfCell.h
//  WTM
//
//  Generated by Flexions  
//  Copyright (c) 2013 Benoit Pereira da Silva All rights reserved.
 
#import "WTMCell.h" 
#import "WattCollectionOfModel.h" 

@interface WTMCollectionOfCell:WattCollectionOfModel <WattCoding>{
}
- (void)enumerateObjectsUsingBlock:(void (^)(WTMCell *obj, NSUInteger idx, BOOL *stop))block;
- (WTMCollectionOfCell*)filteredCollectionUsingPredicate:(NSPredicate *)predicate withRegistry:(WattRegistry *)registry;
- (NSUInteger)count;
- (WTMCell *)objectAtIndex:(NSUInteger)index;
- (WTMCell *)firstObject;
- (WTMCell *)lastObject;
- (WTMCell *)firstObjectCommonWithArray:(NSArray*)array;
- (void)addObject:(WTMCell*)anObject;
- (void)insertObject:(WTMCell*)anObject atIndex:(NSUInteger)index;
- (void)removeLastObject;
- (void)removeObjectAtIndex:(NSUInteger)index;
- (void)replaceObjectAtIndex:(NSUInteger)index withObject:(WTMCell*)anObject;

@end
