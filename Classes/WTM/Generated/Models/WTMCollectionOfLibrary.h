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
//  WTMCollectionOfLibrary.h
//  WTM
//
//  Generated by Flexions  
//  Copyright (c) 2013 Benoit Pereira da Silva All rights reserved.
 
#import "WTMLibrary.h" 
#import "WattCollectionOfModel.h" 

@interface WTMCollectionOfLibrary:WattCollectionOfModel <WattCoding>{
}
- (void)enumerateObjectsUsingBlock:(void (^)(WTMLibrary *obj, NSUInteger idx, BOOL *stop))block reverse:(BOOL)useReverseEnumeration;
- ( WTMCollectionOfLibrary*)filteredCollectionUsingBlock:(BOOL (^)(WTMLibrary  *obj))block withRegistry:(WattRegistry *)registry;
- (WTMCollectionOfLibrary*)filteredCollectionUsingPredicate:(NSPredicate *)predicate withRegistry:(WattRegistry *)registry;
- (NSUInteger)count;
- (WTMLibrary *)objectAtIndex:(NSUInteger)index;
- (WTMLibrary *)firstObject;
- (WTMLibrary *)lastObject;
- (WTMLibrary *)firstObjectCommonWithArray:(NSArray*)array;
- (void)addObject:(WTMLibrary*)anObject;
- (void)insertObject:(WTMLibrary*)anObject atIndex:(NSUInteger)index;
- (void)removeLastObject;
- (void)removeObjectAtIndex:(NSUInteger)index;
- (void)replaceObjectAtIndex:(NSUInteger)index withObject:(WTMLibrary*)anObject;

@end
