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

@synthesize identity=_identity;
@synthesize groups=_groups;

- (void)setValue:(id)value forKey:(NSString *)key {
	if ([key isEqualToString:@"identity"]){
		[super setValue:value forKey:@"identity"];
	} else if ([key isEqualToString:@"groups"]) {
		[super setValue:[WTMCollectionOfGroup instanceFromDictionary:value inRegistry:_registry includeChildren:NO] forKey:@"groups"];
	} else {
		[super setValue:value forKey:key];
	}
}

- (WTMCollectionOfGroup*)groups{
	if([_groups isAnAlias]){
		id o=[_registry objectWithUinstID:_groups.uinstID];
		if(o){
			_groups=o;
		}
	}
	return _groups;
}


- (WTMCollectionOfGroup*)groups_auto{
	_groups=[self groups];
	if(!_groups){
		_groups=[[WTMCollectionOfGroup alloc] initInRegistry:_registry];
	}
	return _groups;
}

- (void)setGroups:(WTMCollectionOfGroup*)groups{
	_groups=groups;
}


- (NSDictionary *)dictionaryRepresentationWithChildren:(BOOL)includeChildren{
	NSMutableDictionary *wrapper = [NSMutableDictionary dictionary];
	[wrapper setObject:NSStringFromClass([self class]) forKey:__className__];
    [wrapper setObject:[self dictionaryOfPropertiesWithChildren:includeChildren] forKey:__properties__];
    [wrapper setObject:[NSNumber numberWithInteger:self.uinstID] forKey:__uinstID__];
    return wrapper;
}

- (NSMutableDictionary*)dictionaryOfPropertiesWithChildren:(BOOL)includeChildren{
    NSMutableDictionary *dictionary=[super dictionaryOfPropertiesWithChildren:includeChildren];
	[dictionary setValue:self.identity forKey:@"identity"];
	if(self.groups){
		if(includeChildren){
			[dictionary setValue:[self.groups dictionaryRepresentationWithChildren:includeChildren] forKey:@"groups"];
		}else{
			[dictionary setValue:[self.groups aliasDictionaryRepresentation] forKey:@"groups"];
		}
	}
    return dictionary;
}


- (NSString*)description{
    if([self isAnAlias])
        return [super aliasDescription];
	NSMutableString *s=[NSMutableString string];
	[s appendFormat:@"Instance of %@ (%i) :\n",NSStringFromClass([self class]),self.uinstID];
	[s appendFormat:@"identity : %@\n",self.identity];
	[s appendFormat:@"groups : %@\n",NSStringFromClass([self.groups class])];
	return s;
}

@end
