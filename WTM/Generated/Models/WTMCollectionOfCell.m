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
//  WTMColumn.h
//  WTM
//
//  Generated by Flexions  
//  Copyright (c) 2013 Benoit Pereira da Silva All rights reserved.
 

#import "WTMCollectionOfCell.h" 

@implementation WTMCollectionOfCell{
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
	[s appendFormat:@"Instance of %@ (%@) :\n",NSStringFromClass([self class]),@(self.uinstID)];
    [s appendFormat:@"Collection of %@\n",@"WTMCell"];
    [s appendFormat:@"With of %@ members\n",@([_collection count])];
	return s;
}

- (void)enumerateObjectsUsingBlock:(void (^)(WTMCell *obj, NSUInteger idx, BOOL *stop))block reverse:(BOOL)useReverseEnumeration{
	 NSUInteger idx = 0;
    BOOL stop = NO;
    NSEnumerator * enumerator=useReverseEnumeration?[_collection reverseObjectEnumerator]: [_collection objectEnumerator];
    for( WTMCell* obj in enumerator ){
        block(obj, idx++, &stop);
        if( stop )
            break;
    }
}

- ( WTMCollectionOfCell*)filteredCollectionUsingBlock:(BOOL (^)(WTMCell  *obj))block withRegistry:(WattRegistry *)registry{
	 WTMCollectionOfCell *__block collection=[[WTMCollectionOfCell alloc] initInRegistry:registry];
	    [self enumerateObjectsUsingBlock:^(WTMCell *obj, NSUInteger idx, BOOL *stop) {
	        if(block(obj)){
	            [collection addObject:obj];
	        }
	    } reverse:NO];
	    return collection;
	}

- (WTMCollectionOfCell*)filteredCollectionUsingPredicate:(NSPredicate *)predicate withRegistry:(WattRegistry *)registry{
	return (WTMCollectionOfCell*)[super filteredCollectionUsingPredicate:predicate withRegistry:registry];
}

- (NSUInteger)count{
    return [_collection count];
}
- (WTMCell *)objectAtIndex:(NSUInteger)index{
	return (WTMCell*)[super  objectAtIndex:index];
}

- (WTMCell *)lastObject{
    return  (WTMCell*)[super lastObject];
}

- (WTMCell *)firstObject{
    return  (WTMCell*)[super firstObject];
}

- (WTMCell *)firstObjectCommonWithArray:(NSArray*)array{
    return (WTMCell*)[super firstObjectCommonWithArray:array];
}

- (void)addObject:(WTMCell*)anObject{
 	[super addObject:anObject];
}

- (void)insertObject:(WTMCell*)anObject atIndex:(NSUInteger)index{
	[super insertObject:anObject atIndex:index];
}

- (void)removeLastObject{
	[super removeLastObject];
}

- (void)removeObjectAtIndex:(NSUInteger)index{
    [super removeObjectAtIndex:index];
}

- (void)replaceObjectAtIndex:(NSUInteger)index withObject:(WTMCell*)anObject{
    [super replaceObjectAtIndex:index withObject:anObject];
}

- (Class)collectedObjectClass{
	return [WTMCell class];
}

@end
