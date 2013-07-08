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
//  WTMUser.h
//  Watt
//
//  Generated by Flexions  
//  Copyright (c) 2013 Benoit Pereira da Silva All rights reserved.
 

#import "WTMCollectionOfGroup.h" 

@implementation WTMCollectionOfGroup{
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
    [s appendFormat:@"Collection of %@\n",@"WTMGroup"];
    [s appendFormat:@"With of %i members\n",[_collection count]];
	return s;
}

- (void)enumerateObjectsUsingBlock:(void (^)(WTMGroup *obj, NSUInteger idx, BOOL *stop))block{
	 NSUInteger idx = 0;
    BOOL stop = NO;
    for( WTMGroup* obj in _collection ){
        block(obj, idx++, &stop);
        if( stop )
            break;
    }
}

- (WTMCollectionOfGroup*)filteredCollectionUsingPredicate:(NSPredicate *)predicate withRegistry:(WattRegistry *)registry{
	return (WTMCollectionOfGroup*)[super filteredCollectionUsingPredicate:predicate withRegistry:registry];
}

- (NSUInteger)count{
    return [_collection count];
}
- (WTMGroup *)objectAtIndex:(NSUInteger)index{
	return (WTMGroup*)[super  objectAtIndex:index];
}

- (WTMGroup *)lastObject{
    return  (WTMGroup*)[super lastObject];
}

- (WTMGroup *)firstObjectCommonWithArray:(NSArray*)array{
    return (WTMGroup*)[super firstObjectCommonWithArray:array];
}

- (void)addObject:(WTMGroup*)anObject{
 	[super addObject:anObject];
}

- (void)insertObject:(WTMGroup*)anObject atIndex:(NSUInteger)index{
	[super insertObject:anObject atIndex:index];
}

- (void)removeLastObject{
	[super removeLastObject];
}

- (void)removeObjectAtIndex:(NSUInteger)index{
    [super removeObjectAtIndex:index];
}

- (void)replaceObjectAtIndex:(NSUInteger)index withObject:(WTMGroup*)anObject{
    [super replaceObjectAtIndex:index withObject:anObject];
}


@end
