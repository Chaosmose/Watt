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
//  WTMPackage.h
//  Watt
//
//  Generated by Flexions  
//  Copyright (c) 2013 Benoit Pereira da Silva All rights reserved.
 

#import "WTMCollectionOfUser.h" 

@implementation WTMCollectionOfUser{
}

-(id)initInRegistry:(WattRegistry*)registry{
    self=[super initInRegistry:registry];
    if(self){
        _collection=[NSMutableArray array];
    }
    return self;
}

+ (WTMCollectionOfUser*)instanceFromDictionary:(NSDictionary *)aDictionary inRegistry:(WattRegistry*)registry includeChildren:(BOOL)includeChildren{
	return (WTMCollectionOfUser*)[WattCollectionOfObject instanceFromDictionary:aDictionary inRegistry:registry includeChildren:includeChildren];
}

- (NSDictionary*)dictionaryRepresentationWithChildren:(BOOL)includeChildren{
    return [super dictionaryRepresentationWithChildren:includeChildren];
}

- (WTMCollectionOfUser*)localized{
	[self localize];
	return self;
}


-(NSString*)description{
	NSMutableString *s=[NSMutableString string];
    [s appendFormat:@"Collection of %@\n",@"WTMUser"];
    [s appendFormat:@"With of %i members\n",[_collection count]];
	return s;
}


- (NSUInteger)count{
    return [_collection count];
}
- (WTMUser *)objectAtIndex:(NSUInteger)index{
	return (WTMUser*)[super  objectAtIndex:index];
}

- (WTMUser *)lastObject{
    return  (WTMUser*)[super lastObject];
}

- (WTMUser *)firstObjectCommonWithArray:(NSArray*)array{
    return (WTMUser*)[super firstObjectCommonWithArray:array];
}

- (void)addObject:(WTMUser*)anObject{
 	[super addObject:anObject];
}

- (void)insertObject:(WTMUser*)anObject atIndex:(NSUInteger)index{
	[super insertObject:anObject atIndex:index];
}

- (void)removeLastObject{
	[super removeLastObject];
}

- (void)removeObjectAtIndex:(NSUInteger)index{
    [super removeObjectAtIndex:index];
}

- (void)replaceObjectAtIndex:(NSUInteger)index withObject:(WTMUser*)anObject{
    [super replaceObjectAtIndex:index withObject:anObject];
}


@end
