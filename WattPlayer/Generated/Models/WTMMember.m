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
//  WTMMember.m
//  Watt
//
//  Generated by Flexions  
//  Copyright (c) 2013 Benoit Pereira da Silva All rights reserved.
 
#import "WTMMember.h" 

@implementation WTMMember 

@synthesize index=_index;
@synthesize name=_name;
@synthesize ownerUserUID=_ownerUserUID;
@synthesize rights=_rights;
@synthesize uid=_uid;

- (void)setValue:(id)value forKey:(NSString *)key {
	if ([key isEqualToString:@"index"]){
		[super setValue:value forKey:@"index"];
	} else if ([key isEqualToString:@"name"]) {
		[super setValue:value forKey:@"name"];
	} else if ([key isEqualToString:@"ownerUserUID"]) {
		[super setValue:value forKey:@"ownerUserUID"];
	} else if ([key isEqualToString:@"rights"]) {
		[super setValue:value forKey:@"rights"];
	} else if ([key isEqualToString:@"uid"]) {
		[super setValue:value forKey:@"uid"];
	} else {
		[super setValue:value forKey:key];
	}
}




- (NSDictionary *)dictionaryRepresentationWithChildren:(BOOL)includeChildren{
    if([self isAnAlias])
        return [super aliasDictionaryRepresentation];
	NSMutableDictionary *wrapper = [NSMutableDictionary dictionary];
    NSMutableDictionary *dictionary=[NSMutableDictionary dictionary];
	[dictionary setValue:[NSNumber numberWithInteger:self.index] forKey:@"index"];
	[dictionary setValue:self.name forKey:@"name"];
	[dictionary setValue:self.ownerUserUID forKey:@"ownerUserUID"];
	[dictionary setValue:self.rights forKey:@"rights"];
	[dictionary setValue:self.uid forKey:@"uid"];
	[wrapper setObject:NSStringFromClass([self class]) forKey:__className__];
    [wrapper setObject:dictionary forKey:__properties__];
    [wrapper setObject:[NSNumber numberWithInteger:self.uinstID] forKey:__uinstID__];
    return wrapper;
}


- (NSString*)description{
    if([self isAnAlias])
        return [super aliasDescription];
	NSMutableString *s=[NSMutableString string];
	[s appendFormat:@"Instance of %@ :\n",NSStringFromClass([self class])];
	[s appendFormat:@"index : %@\n",[NSNumber numberWithInteger:self.index]];
	[s appendFormat:@"name : %@\n",self.name];
	[s appendFormat:@"ownerUserUID : %@\n",self.ownerUserUID];
	[s appendFormat:@"rights : %@\n",self.rights];
	[s appendFormat:@"uid : %@\n",self.uid];
	return s;
}

@end
