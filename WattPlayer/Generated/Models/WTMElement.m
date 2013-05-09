// This file is part of "Watt-Multimedia-Engine"
// 
// "Watt-Multimedia-Engine" is free software: you can redistribute it and/or modify
// it under the terms of the GNU LESSER GENERAL PUBLIC LICENSE as published by
// the Free Software Foundation, either version 3 of the License, or
// (at your option) any later version.
// 
// "Watt-Multimedia-Engine" is distributed in the hope that it will be useful,
// but WITHOUT ANY WARRANTY; without even the implied warranty of
// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
// GNU LESSER GENERAL PUBLIC LICENSE for more details.
// 
// You should have received a copy of the GNU LESSER GENERAL PUBLIC LICENSE
// along with "Watt-Multimedia-Engine"  If not, see <http://www.gnu.org/licenses/>
// 
//  WTMElement.m
//  Watt-Multimedia-Engine
//
//  Generated by Flexions  
//  Copyright (c) 2013 Benoit Pereira da Silva All rights reserved.
 
#import "WTMElement.h" 
#import "WTMCollectionOfDatum.h"

@implementation WTMElement 

+ (WTMElement*)instanceFromDictionary:(NSDictionary *)aDictionary{
	WTMElement*instance = nil;
	if([aDictionary objectForKey:@"className"] && [aDictionary objectForKey:@"properties"]){
		Class theClass=NSClassFromString([aDictionary objectForKey:@"className"]);
		id unCasted= [[theClass alloc] init];
		[unCasted setAttributesFromDictionary:[aDictionary objectForKey:@"properties"]];
		instance=(WTMElement*)unCasted;
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
	if ([key isEqualToString:@"assetLibUID"]){
		[super setValue:value forKey:@"assetLibUID"];
	} else if ([key isEqualToString:@"assetMemberIndex"]) {
		[super setValue:value forKey:@"assetMemberIndex"];
	} else if ([key isEqualToString:@"behaviorLibUID"]) {
		[super setValue:value forKey:@"behaviorLibUID"];
	} else if ([key isEqualToString:@"behaviorMemberIndex"]) {
		[super setValue:value forKey:@"behaviorMemberIndex"];
	} else if ([key isEqualToString:@"controllerClass"]) {
		[super setValue:value forKey:@"controllerClass"];
	} else if ([key isEqualToString:@"ownerUserUID"]) {
		[super setValue:value forKey:@"ownerUserUID"];
	} else if ([key isEqualToString:@"rect"]) {
		[super setValue:value forKey:@"rect"];
	} else if ([key isEqualToString:@"rights"]) {
		[super setValue:value forKey:@"rights"];
	} else if ([key isEqualToString:@"sceneIndex"]) {
		[super setValue:value forKey:@"sceneIndex"];
	} else if ([key isEqualToString:@"metadata"]) {
		[super setValue:[WTMCollectionOfDatum instanceFromDictionary:value] forKey:@"metadata"];
	} else {
		[super setValue:value forUndefinedKey:key];
	}
}

- (NSDictionary*)dictionaryRepresentation{
	NSMutableDictionary *wrapper = [NSMutableDictionary dictionary];
    NSMutableDictionary *dictionary=[NSMutableDictionary dictionary];
	[dictionary setValue:self.assetLibUID forKey:@"assetLibUID"];
	[dictionary setValue:[NSNumber numberWithInteger:self.assetMemberIndex] forKey:@"assetMemberIndex"];
	[dictionary setValue:self.behaviorLibUID forKey:@"behaviorLibUID"];
	[dictionary setValue:[NSNumber numberWithInteger:self.behaviorMemberIndex] forKey:@"behaviorMemberIndex"];
	[dictionary setValue:self.controllerClass forKey:@"controllerClass"];
	[dictionary setValue:self.ownerUserUID forKey:@"ownerUserUID"];
	[dictionary setValue:[NSValue valueWithCGRect:self.rect] forKey:@"rect"];
	[dictionary setValue:self.rights forKey:@"rights"];
	[dictionary setValue:[NSNumber numberWithInteger:self.sceneIndex] forKey:@"sceneIndex"];
	[dictionary setValue:[self.metadata dictionaryRepresentation] forKey:@"metadata"];
	[wrapper setObject:NSStringFromClass([self class]) forKey:@"className"];
    [wrapper setObject:dictionary forKey:@"properties"];
    return wrapper;
}

-(NSString*)description{
	NSMutableString *s=[NSMutableString string];
	[s appendFormat:@"assetLibUID : %@\n",self.assetLibUID];
	[s appendFormat:@"assetMemberIndex : %@\n",[NSNumber numberWithInteger:self.assetMemberIndex]];
	[s appendFormat:@"behaviorLibUID : %@\n",self.behaviorLibUID];
	[s appendFormat:@"behaviorMemberIndex : %@\n",[NSNumber numberWithInteger:self.behaviorMemberIndex]];
	[s appendFormat:@"controllerClass : %@\n",self.controllerClass];
	[s appendFormat:@"ownerUserUID : %@\n",self.ownerUserUID];
	[s appendFormat:@"rect : %@\n",[NSValue valueWithCGRect:self.rect]];
	[s appendFormat:@"rights : %@\n",self.rights];
	[s appendFormat:@"sceneIndex : %@\n",[NSNumber numberWithInteger:self.sceneIndex]];
	[s appendFormat:@"metadata : %@\n",self.metadata];
	return s;
}

@end
