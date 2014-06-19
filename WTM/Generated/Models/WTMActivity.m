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
#import "WTMCollectionOfScene.h"

@implementation WTMActivity 

@synthesize level=_level;
@synthesize pictureRelativePath=_pictureRelativePath;
@synthesize rating=_rating;
@synthesize score=_score;
@synthesize shortName=_shortName;
@synthesize title=_title;
@synthesize package=_package;
@synthesize scenes=_scenes;




#pragma mark -


- (void)setValue:(id)value forKey:(NSString *)key {
	if ([key isEqualToString:@"level"]){
		[super setValue:value forKey:@"level"];
	} else if ([key isEqualToString:@"pictureRelativePath"]) {
		[super setValue:value forKey:@"pictureRelativePath"];
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
	[dictionary setValue:@(self.level) forKey:@"level"];
	if(_pictureRelativePath){
		[dictionary setValue:self.pictureRelativePath forKey:@"pictureRelativePath"];
	}
	[dictionary setValue:@(self.rating) forKey:@"rating"];
	[dictionary setValue:@(self.score) forKey:@"score"];
	if(_shortName){
		[dictionary setValue:self.shortName forKey:@"shortName"];
	}
	if(_title){
		[dictionary setValue:self.title forKey:@"title"];
	}
	if(_package){
		if(includeChildren){
			[dictionary setValue:[self.package dictionaryRepresentationWithChildren:includeChildren] forKey:@"package"];
		}else{
			[dictionary setValue:[self.package aliasDictionaryRepresentation] forKey:@"package"];
		}
	}
	if(_scenes){
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
	[s appendFormat:@"Instance of %@ (%@.%@) :\n",@"WTMActivity ",_registry.uidString,@(_uinstID)];
	[s appendFormat:@"level : %@\n",@(self.level)];
	[s appendFormat:@"pictureRelativePath : %@\n",self.pictureRelativePath];
	[s appendFormat:@"rating : %@\n",@(self.rating)];
	[s appendFormat:@"score : %@\n",@(self.score)];
	[s appendFormat:@"shortName : %@\n",self.shortName];
	[s appendFormat:@"title : %@\n",self.title];
	[s appendFormat:@"package : %@\n",NSStringFromClass([self.package class])];
	[s appendFormat:@"scenes : %@\n",NSStringFromClass([self.scenes class])];
	return s;
}

@end
