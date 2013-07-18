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
//  WTMLibrary.h
//  Watt
//
//  Generated by Flexions  
//  Copyright (c) 2013 Benoit Pereira da Silva All rights reserved.
 

#import "WTMCollectionOfBand.h" 

@implementation WTMCollectionOfBand{
}

- (instancetype)initInRegistry:(WattRegistry*)registry{
    self=[super initInRegistry:registry];
    if(self){
        _collection=[NSMutableArray array];
    }
    return self;
}


- (NSString*)description{
    if([self isAnAlias])
        return [super aliasDescription];
	NSMutableString *s=[NSMutableString string];
	[s appendFormat:@"Instance of %@ (%i) :\n",NSStringFromClass([self class]),self.uinstID];
    [s appendFormat:@"Collection of %@\n",@"WTMBand"];
    [s appendFormat:@"With of %i members\n",[_collection count]];
	return s;
}

- (void)enumerateObjectsUsingBlock:(void (^)(WTMBand *obj, NSUInteger idx, BOOL *stop))block{
	 NSUInteger idx = 0;
    BOOL stop = NO;
    for( WTMBand* obj in _collection ){
        block(obj, idx++, &stop);
        if( stop )
            break;
    }
}

- (WTMCollectionOfBand*)filteredCollectionUsingPredicate:(NSPredicate *)predicate withRegistry:(WattRegistry *)registry{
	return (WTMCollectionOfBand*)[super filteredCollectionUsingPredicate:predicate withRegistry:registry];
}

- (NSUInteger)count{
    return [_collection count];
}
- (WTMBand *)objectAtIndex:(NSUInteger)index{
	return (WTMBand*)[super  objectAtIndex:index];
}

- (WTMBand *)lastObject{
    return  (WTMBand*)[super lastObject];
}

- (WTMBand *)firstObjectCommonWithArray:(NSArray*)array{
    return (WTMBand*)[super firstObjectCommonWithArray:array];
}

- (void)addObject:(WTMBand*)anObject{
 	[super addObject:anObject];
}

- (void)insertObject:(WTMBand*)anObject atIndex:(NSUInteger)index{
	[super insertObject:anObject atIndex:index];
}

- (void)removeLastObject{
	[super removeLastObject];
}

- (void)removeObjectAtIndex:(NSUInteger)index{
    [super removeObjectAtIndex:index];
}

- (void)replaceObjectAtIndex:(NSUInteger)index withObject:(WTMBand*)anObject{
    [super replaceObjectAtIndex:index withObject:anObject];
}


@end
