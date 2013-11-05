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
//  WattCollectionOfExternalReference.h
//  Watt
//
//  Generated by Flexions  
//  Copyright (c) 2013 Benoit Pereira da Silva All rights reserved.
 
#import "WattExternalReference.h" 
#import "WattCollectionOfObject.h" 

@interface WattCollectionOfExternalReference:WattCollectionOfObject <WattCoding,WattCopying,WattExtraction>{
}
- (void)enumerateObjectsUsingBlock:(void (^)(WattExternalReference *obj, NSUInteger idx, BOOL *stop))block reverse:(BOOL)useReverseEnumeration;
- ( WattCollectionOfExternalReference*)filteredCollectionUsingBlock:(BOOL (^)(WattExternalReference  *obj))block withRegistry:(WattRegistry *)registry;
- (WattCollectionOfExternalReference*)filteredCollectionUsingPredicate:(NSPredicate *)predicate withRegistry:(WattRegistry *)registry;
- (NSUInteger)count;
- (WattExternalReference *)objectAtIndex:(NSUInteger)index;
- (WattExternalReference *)firstObject;
- (WattExternalReference *)lastObject;
- (WattExternalReference *)firstObjectCommonWithArray:(NSArray*)array;
- (void)addObject:(WattExternalReference*)anObject;
- (void)insertObject:(WattExternalReference*)anObject atIndex:(NSUInteger)index;
- (void)removeLastObject;
- (void)removeObjectAtIndex:(NSUInteger)index;
- (void)replaceObjectAtIndex:(NSUInteger)index withObject:(WattExternalReference*)anObject;

@end
