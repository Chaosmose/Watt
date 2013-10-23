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
//  WTMActivity.m
//  WTM
//
//  Generated by Flexions  
//  Copyright (c) 2013 Benoit Pereira da Silva All rights reserved.
 
#import "WTMActivity.h" 
#import "WTMPackage.h"
#import "WTMImage.h"
#import "WTMCollectionOfScene.h"

@implementation WTMActivity 

@synthesize level=_level;
@synthesize rating=_rating;
@synthesize score=_score;
@synthesize shortName=_shortName;
@synthesize title=_title;
@synthesize package=_package;
@synthesize picture=_picture;
@synthesize scenes=_scenes;


#pragma  mark WattCopying

- (instancetype)wattCopyInRegistry:(WattRegistry*)registry{
    WTMActivity *instance=[self copy];
    [registry addObject:instance];
    return instance;
}


// NSCopying
- (id)copyWithZone:(NSZone *)zone{
    WTMActivity *instance=[[[super class] allocWithZone:zone] init];
    	instance->_registry=nil; // We want to furnish a registry free copy
		// we do not provide an _uinstID
   			instance->_level=_level;
		instance->_rating=_rating;
		instance->_score=_score;
		instance->_shortName=[_shortName copyWithZone:zone];
		instance->_title=[_title copyWithZone:zone];
		instance->_package=[_package copyWithZone:zone];
		instance->_picture=[_picture copyWithZone:zone];
		instance->_scenes=[_scenes copyWithZone:zone];
    return instance;
}

#pragma mark -


- (void)setValue:(id)value forKey:(NSString *)key {
	if ([key isEqualToString:@"level"]){
		[super setValue:value forKey:@"level"];
	} else if ([key isEqualToString:@"rating"]) {
		[super setValue:value forKey:@"rating"];
	} else if ([key isEqualToString:@"score"]) {
		[super setValue:value forKey:@"score"];
	} else if ([key isEqualToString:@"shortName"]) {
		[super setValue:value forKey:@"shortName"];
	} else if ([key isEqualToString:@"title"]) {
		[super setValue:value forKey:@"title"];
	} else if ([key isEqualToString:@"package"]) {
		[super setValue:[WTMPackage instanceFromDictionary:value inRegistry:_registry includeChildren:NO] forKey:@"package"];
	} else if ([key isEqualToString:@"picture"]) {
		[super setValue:[WTMImage instanceFromDictionary:value inRegistry:_registry includeChildren:NO] forKey:@"picture"];
	} else if ([key isEqualToString:@"scenes"]) {
		[super setValue:[WTMCollectionOfScene instanceFromDictionary:value inRegistry:_registry includeChildren:NO] forKey:@"scenes"];
	} else {
		[super setValue:value forKey:key];
	}
}

- (WTMPackage*)package{
	if([_package isAnAlias]){
		id o=[_registry objectWithUinstID:_package.uinstID];
		if(o){
			_package=o;
		}
	}
	return _package;
}


- (WTMPackage*)package_auto{
	_package=[self package];
	if(!_package){
		_package=[[WTMPackage alloc] initInRegistry:_registry];
	}
	return _package;
}

- (void)setPackage:(WTMPackage*)package{
	_package=package;
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

- (WTMCollectionOfScene*)scenes{
	if([_scenes isAnAlias]){
		id o=[_registry objectWithUinstID:_scenes.uinstID];
		if(o){
			_scenes=o;
		}
	}
	return _scenes;
}


- (WTMCollectionOfScene*)scenes_auto{
	_scenes=[self scenes];
	if(!_scenes){
		_scenes=[[WTMCollectionOfScene alloc] initInRegistry:_registry];
	}
	return _scenes;
}

- (void)setScenes:(WTMCollectionOfScene*)scenes{
	_scenes=scenes;
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
	[dictionary setValue:[NSNumber numberWithInteger:self.level] forKey:@"level"];
	[dictionary setValue:[NSNumber numberWithInteger:self.rating] forKey:@"rating"];
	[dictionary setValue:[NSNumber numberWithInteger:self.score] forKey:@"score"];
	[dictionary setValue:self.shortName forKey:@"shortName"];
	[dictionary setValue:self.title forKey:@"title"];
	if(self.package){
		if(includeChildren){
			[dictionary setValue:[self.package dictionaryRepresentationWithChildren:includeChildren] forKey:@"package"];
		}else{
			[dictionary setValue:[self.package aliasDictionaryRepresentation] forKey:@"package"];
		}
	}
	if(self.picture){
		if(includeChildren){
			[dictionary setValue:[self.picture dictionaryRepresentationWithChildren:includeChildren] forKey:@"picture"];
		}else{
			[dictionary setValue:[self.picture aliasDictionaryRepresentation] forKey:@"picture"];
		}
	}
	if(self.scenes){
		if(includeChildren){
			[dictionary setValue:[self.scenes dictionaryRepresentationWithChildren:includeChildren] forKey:@"scenes"];
		}else{
			[dictionary setValue:[self.scenes aliasDictionaryRepresentation] forKey:@"scenes"];
		}
	}
    return dictionary;
}


- (NSString*)description{
    if([self isAnAlias])
        return [super aliasDescription];
    NSMutableString *s=[NSMutableString stringWithString:[super description]];
	[s appendFormat:@"Instance of %@ (%i) :\n",@"WTMActivity ",self.uinstID];
	[s appendFormat:@"level : %@\n",[NSNumber numberWithInteger:self.level]];
	[s appendFormat:@"rating : %@\n",[NSNumber numberWithInteger:self.rating]];
	[s appendFormat:@"score : %@\n",[NSNumber numberWithInteger:self.score]];
	[s appendFormat:@"shortName : %@\n",self.shortName];
	[s appendFormat:@"title : %@\n",self.title];
	[s appendFormat:@"package : %@\n",NSStringFromClass([self.package class])];
	[s appendFormat:@"picture : %@\n",NSStringFromClass([self.picture class])];
	[s appendFormat:@"scenes : %@\n",NSStringFromClass([self.scenes class])];
	return s;
}

@end
