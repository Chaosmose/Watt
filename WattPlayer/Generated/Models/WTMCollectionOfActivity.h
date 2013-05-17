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
//  WTMCollectionOfActivity.h
//  Watt
//
//  Generated by Flexions  
//  Copyright (c) 2013 Benoit Pereira da Silva All rights reserved.
 
#import "WTMActivity.h" 
#import "WTMCollectionOfModel.h" 

@interface WTMCollectionOfActivity:WTMCollectionOfModel {
}

+ (WTMCollectionOfActivity *)instanceFromDictionary:(NSDictionary *)aDictionary;
- (void)setAttributesFromDictionary:(NSDictionary *)aDictionary;
- (NSDictionary *)dictionaryRepresentation;
- (WTMCollectionOfActivity *)localized;

- (NSUInteger)count;
- (WTMActivity *)objectAtIndex:(NSUInteger)index;
- (WTMActivity *)lastObject;
- (WTMActivity *)firstObjectCommonWithArray:(NSArray*)array;
- (void)addObject:(WTMActivity*)anObject;
- (void)insertObject:(WTMActivity*)anObject atIndex:(NSUInteger)index;
- (void)removeLastObject;
- (void)removeObjectAtIndex:(NSUInteger)index;
- (void)replaceObjectAtIndex:(NSUInteger)index withObject:(WTMActivity*)anObject;

@end
