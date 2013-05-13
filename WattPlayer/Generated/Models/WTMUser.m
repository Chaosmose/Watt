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
//  WTMUser.m
//  Watt
//
//  Generated by Flexions  
//  Copyright (c) 2013 Benoit Pereira da Silva All rights reserved.
 
#import "WTMUser.h" 
#import "WTMCollectionOfGroup.h"

@implementation WTMUser 


-(id)init{
    self=[super init];
    if(self){
		self.groups=[[WTMCollectionOfGroup alloc] init];
   
    }
    return self;
}


+ (WTMUser*)instanceFromDictionary:(NSDictionary *)aDictionary{
	WTMUser*instance = nil;
	if([aDictionary objectForKey:@"className"] && [aDictionary objectForKey:@"properties"]){
		Class theClass=NSClassFromString([aDictionary objectForKey:@"className"]);
		id unCasted= [[theClass alloc] init];
		[unCasted setAttributesFromDictionary:[aDictionary objectForKey:@"properties"]];
		instance=(WTMUser*)unCasted;
	}
	return instance;
}

- (void)setAttributesFromDictionary:(NSDictionary *)aDictionary{
	if (![aDictionary isKindOfClass:[NSDictionary class]]) {
		return;
	}
	[self setValuesForKeysWithDictionary:aDictionary];
}

- (void)setValue:(id)value forKey:(NSString *)key {
	if ([key isEqualToString:@"identity"]){
		[super setValue:value forKey:@"identity"];
	} else if ([key isEqualToString:@"uid"]) {
		[super setValue:value forKey:@"uid"];
	} else if ([key isEqualToString:@"groups"]) {
		[super setValue:[WTMCollectionOfGroup instanceFromDictionary:value] forKey:@"groups"];
	} else {
		[super setValue:value forUndefinedKey:key];
	}
}

- (NSDictionary*)dictionaryRepresentation{
	NSMutableDictionary *wrapper = [NSMutableDictionary dictionary];
    NSMutableDictionary *dictionary=[NSMutableDictionary dictionary];
	[dictionary setValue:self.identity forKey:@"identity"];
	[dictionary setValue:self.uid forKey:@"uid"];
	[dictionary setValue:[self.groups dictionaryRepresentation] forKey:@"groups"];
	[wrapper setObject:NSStringFromClass([self class]) forKey:@"className"];
    [wrapper setObject:dictionary forKey:@"properties"];
    return wrapper;
}

-(NSString*)description{
	NSMutableString *s=[NSMutableString string];
	[s appendFormat:@"identity : %@\n",self.identity];
	[s appendFormat:@"uid : %@\n",self.uid];
	[s appendFormat:@"groups : %@\n",self.groups];
	return s;
}

@end
