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
//  WTMShelf.m
//  Watt
//
//  Generated by Flexions  
//  Copyright (c) 2013 Benoit Pereira da Silva All rights reserved.
 
#import "WTMShelf.h" 
#import "WTMCollectionOfPackage.h"
#import "WTMImage.h"
#import "WTMCollectionOfUser.h"

@implementation WTMShelf 

@synthesize comment=_comment;
@synthesize extras=_extras;
@synthesize packages=_packages;
@synthesize picture=_picture;
@synthesize users=_users;

- (void)setValue:(id)value forKey:(NSString *)key {
	if ([key isEqualToString:@"comment"]){
		[super setValue:value forKey:@"comment"];
	} else if ([key isEqualToString:@"extras"]) {
		[super setValue:value forKey:@"extras"];
	} else if ([key isEqualToString:@"packages"]) {
		[super setValue:[WTMCollectionOfPackage instanceFromDictionary:value inRegistry:_registry includeChildren:NO] forKey:@"packages"];
	} else if ([key isEqualToString:@"picture"]) {
		[super setValue:[WTMImage instanceFromDictionary:value inRegistry:_registry includeChildren:NO] forKey:@"picture"];
	} else if ([key isEqualToString:@"users"]) {
		[super setValue:[WTMCollectionOfUser instanceFromDictionary:value inRegistry:_registry includeChildren:NO] forKey:@"users"];
	} else {
		[super setValue:value forKey:key];
	}
}


- (WTMCollectionOfPackage*)packages{
	if([_packages isAnAlias]){
		id o=[_registry objectWithUinstID:_packages.uinstID];
		if(o){
			_packages=o;
		}
	}
	return _packages;
}


- (WTMCollectionOfPackage*)packages_auto{
	_packages=[self packages];
	if(!_packages){
		_packages=[[WTMCollectionOfPackage alloc] initInRegistry:_registry];
	}
	return _packages;
}

- (void)setPackages:(WTMCollectionOfPackage*)packages{
	_packages=packages;
}

- (WTMImage*)picture{
	if([_picture isAnAlias]){
		id o=[_registry objectWithUinstID:_picture.uinstID];
		if(o){
			_picture=o;
		}
	}
	return _picture;
}


- (WTMImage*)picture_auto{
	_picture=[self picture];
	if(!_picture){
		_picture=[[WTMImage alloc] initInRegistry:_registry];
	}
	return _picture;
}

- (void)setPicture:(WTMImage*)picture{
	_picture=picture;
}

- (WTMCollectionOfUser*)users{
	if([_users isAnAlias]){
		id o=[_registry objectWithUinstID:_users.uinstID];
		if(o){
			_users=o;
		}
	}
	return _users;
}


- (WTMCollectionOfUser*)users_auto{
	_users=[self users];
	if(!_users){
		_users=[[WTMCollectionOfUser alloc] initInRegistry:_registry];
	}
	return _users;
}

- (void)setUsers:(WTMCollectionOfUser*)users{
	_users=users;
}



- (NSDictionary *)dictionaryRepresentationWithChildren:(BOOL)includeChildren{
    if([self isAnAlias])
        return [super aliasDictionaryRepresentation];
	NSMutableDictionary *wrapper = [NSMutableDictionary dictionary];
    NSMutableDictionary *dictionary=[NSMutableDictionary dictionary];
	[dictionary setValue:self.comment forKey:@"comment"];
	[dictionary setValue:self.extras forKey:@"extras"];
	if(self.packages){
		if(includeChildren){
			[dictionary setValue:[self.packages dictionaryRepresentationWithChildren:includeChildren] forKey:@"packages"];
		}else{
			[dictionary setValue:[self.packages aliasDictionaryRepresentation] forKey:@"packages"];
		}
	}
	if(self.picture){
		if(includeChildren){
			[dictionary setValue:[self.picture dictionaryRepresentationWithChildren:includeChildren] forKey:@"picture"];
		}else{
			[dictionary setValue:[self.picture aliasDictionaryRepresentation] forKey:@"picture"];
		}
	}
	if(self.users){
		if(includeChildren){
			[dictionary setValue:[self.users dictionaryRepresentationWithChildren:includeChildren] forKey:@"users"];
		}else{
			[dictionary setValue:[self.users aliasDictionaryRepresentation] forKey:@"users"];
		}
	}
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
	[s appendFormat:@"comment : %@\n",self.comment];
	[s appendFormat:@"extras : %@\n",self.extras];
	[s appendFormat:@"packages : %@\n",NSStringFromClass([self.packages class])];
	[s appendFormat:@"picture : %@\n",NSStringFromClass([self.picture class])];
	[s appendFormat:@"users : %@\n",NSStringFromClass([self.users class])];
	return s;
}

@end
