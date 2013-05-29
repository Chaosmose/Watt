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
//  WTMCollectionOfPackage.h
//  Watt
//
//  Generated by Flexions  
//  Copyright (c) 2013 Benoit Pereira da Silva All rights reserved.
 
#import "WTMPackage.h" 
#import "WattCollectionOfObject.h" 

@interface WTMCollectionOfPackage:WattCollectionOfObject <WattCoding>{
}


- (NSUInteger)count;
- (WTMPackage *)objectAtIndex:(NSUInteger)index;
- (WTMPackage *)lastObject;
- (WTMPackage *)firstObjectCommonWithArray:(NSArray*)array;
- (void)addObject:(WTMPackage*)anObject;
- (void)insertObject:(WTMPackage*)anObject atIndex:(NSUInteger)index;
- (void)removeLastObject;
- (void)removeObjectAtIndex:(NSUInteger)index;
- (void)replaceObjectAtIndex:(NSUInteger)index withObject:(WTMPackage*)anObject;

@end
