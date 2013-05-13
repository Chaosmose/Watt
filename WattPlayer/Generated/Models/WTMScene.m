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
//  WTMScene.m
//  Watt
//
//  Generated by Flexions  
//  Copyright (c) 2013 Benoit Pereira da Silva All rights reserved.
 
#import "WTMScene.h" 
#import "WTMCollectionOfElement.h"

@implementation WTMScene 


-(id)init{
    self=[super init];
    if(self){
		self.elements=[[WTMCollectionOfElement alloc] init];
   
    }
    return self;
}


+ (WTMScene*)instanceFromDictionary:(NSDictionary *)aDictionary{
	WTMScene*instance = nil;
	if([aDictionary objectForKey:@"className"] && [aDictionary objectForKey:@"properties"]){
		Class theClass=NSClassFromString([aDictionary objectForKey:@"className"]);
		id unCasted= [[theClass alloc] init];
		[unCasted setAttributesFromDictionary:[aDictionary objectForKey:@"properties"]];
		instance=(WTMScene*)unCasted;
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
	if ([key isEqualToString:@"activityIndex"]){
		[super setValue:value forKey:@"activityIndex"];
	} else if ([key isEqualToString:@"comment"]) {
		[super setValue:value forKey:@"comment"];
	} else if ([key isEqualToString:@"controllerClass"]) {
		[super setValue:value forKey:@"controllerClass"];
	} else if ([key isEqualToString:@"number"]) {
		[super setValue:value forKey:@"number"];
	} else if ([key isEqualToString:@"ownerUserUID"]) {
		[super setValue:value forKey:@"ownerUserUID"];
	} else if ([key isEqualToString:@"rect"]) {
		[super setValue:value forKey:@"rect"];
	} else if ([key isEqualToString:@"rights"]) {
		[super setValue:value forKey:@"rights"];
	} else if ([key isEqualToString:@"title"]) {
		[super setValue:value forKey:@"title"];
	} else if ([key isEqualToString:@"uid"]) {
		[super setValue:value forKey:@"uid"];
	} else if ([key isEqualToString:@"elements"]) {
		[super setValue:[WTMCollectionOfElement instanceFromDictionary:value] forKey:@"elements"];
	} else {
		[super setValue:value forUndefinedKey:key];
	}
}

- (NSDictionary*)dictionaryRepresentation{
	NSMutableDictionary *wrapper = [NSMutableDictionary dictionary];
    NSMutableDictionary *dictionary=[NSMutableDictionary dictionary];
	[dictionary setValue:[NSNumber numberWithInteger:self.activityIndex] forKey:@"activityIndex"];
	[dictionary setValue:self.comment forKey:@"comment"];
	[dictionary setValue:self.controllerClass forKey:@"controllerClass"];
	[dictionary setValue:[NSNumber numberWithInteger:self.number] forKey:@"number"];
	[dictionary setValue:self.ownerUserUID forKey:@"ownerUserUID"];
	[dictionary setValue:[NSValue valueWithCGRect:self.rect] forKey:@"rect"];
	[dictionary setValue:self.rights forKey:@"rights"];
	[dictionary setValue:self.title forKey:@"title"];
	[dictionary setValue:self.uid forKey:@"uid"];
	[dictionary setValue:[self.elements dictionaryRepresentation] forKey:@"elements"];
	[wrapper setObject:NSStringFromClass([self class]) forKey:@"className"];
    [wrapper setObject:dictionary forKey:@"properties"];
    return wrapper;
}

-(NSString*)description{
	NSMutableString *s=[NSMutableString string];
	[s appendFormat:@"activityIndex : %@\n",[NSNumber numberWithInteger:self.activityIndex]];
	[s appendFormat:@"comment : %@\n",self.comment];
	[s appendFormat:@"controllerClass : %@\n",self.controllerClass];
	[s appendFormat:@"number : %@\n",[NSNumber numberWithInteger:self.number]];
	[s appendFormat:@"ownerUserUID : %@\n",self.ownerUserUID];
	[s appendFormat:@"rect : %@\n",[NSValue valueWithCGRect:self.rect]];
	[s appendFormat:@"rights : %@\n",self.rights];
	[s appendFormat:@"title : %@\n",self.title];
	[s appendFormat:@"uid : %@\n",self.uid];
	[s appendFormat:@"elements : %@\n",self.elements];
	return s;
}

@end
