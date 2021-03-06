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
//  WattGroup.m
//  Watt
//
//  Generated by Flexions  
//  Copyright (c) 2013 Benoit Pereira da Silva All rights reserved.
 
#import "WattGroup.h" 
#import "WattCollectionOfUser.h"

@implementation WattGroup 

@synthesize name=_name;
@synthesize objectName=_objectName;
@synthesize users=_users;

- (void)setValue:(id)value forKey:(NSString *)key {
	if ([key isEqualToString:@"name"]){
		[super setValue:value forKey:@"name"];
	} else if ([key isEqualToString:@"objectName"]) {
		[super setValue:value forKey:@"objectName"];
	} else if ([key isEqualToString:@"users"]) {
		[super setValue:[WattCollectionOfUser instanceFromDictionary:value inRegistry:_registry includeChildren:NO] forKey:@"users"];
	} else {
		[super setValue:value forKey:key];
	}
}

- (WattCollectionOfUser*)users{
	if([_users isAnAlias]){
		id o=[_registry objectWithUinstID:_users.uinstID];
		if(o){
			_users=o;
		}
	}
	return _users;
}


- (WattCollectionOfUser*)users_auto{
	_users=[self users];
	if(!_users){
		_users=[[WattCollectionOfUser alloc] initInRegistry:_registry];
	}
	return _users;
}

- (void)setUsers:(WattCollectionOfUser*)users{
	_users=users;
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
	if(_name){
		[dictionary setValue:self.name forKey:@"name"];
	}
	if(_objectName){
		[dictionary setValue:self.objectName forKey:@"objectName"];
	}
	if(_users){
		if(includeChildren){
			[dictionary setValue:[self.users dictionaryRepresentationWithChildren:includeChildren] forKey:@"users"];
		}else{
			[dictionary setValue:[self.users aliasDictionaryRepresentation] forKey:@"users"];
		}
	}
    return dictionary;
}


- (NSString*)description{
    if([self isAnAlias])
        return [super aliasDescription];
    NSMutableString *s=[NSMutableString stringWithString:[super description]];
	[s appendFormat:@"Instance of %@ (%@.%@) :\n",@"WattGroup ",_registry.uidString,@(_uinstID)];
	[s appendFormat:@"name : %@\n",self.name];
	[s appendFormat:@"objectName : %@\n",self.objectName];
	[s appendFormat:@"users : %@\n",NSStringFromClass([self.users class])];
	return s;
}

@end
