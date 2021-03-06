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
//  WTMPackage.m
//  WTM
//
//  Generated by Flexions  
//  Copyright (c) 2013 Benoit Pereira da Silva All rights reserved.
 
#import "WTMPackage.h" 
#import "WTMCollectionOfActivity.h"
#import "WTMCollectionOfLibrary.h"

@implementation WTMPackage 

@synthesize license=_license;
@synthesize name=_name;
@synthesize pictureRelativePath=_pictureRelativePath;
@synthesize activities=_activities;
@synthesize libraries=_libraries;

- (void)setValue:(id)value forKey:(NSString *)key {
	if ([key isEqualToString:@"license"]){
		[super setValue:value forKey:@"license"];
	} else if ([key isEqualToString:@"name"]) {
		[super setValue:value forKey:@"name"];
	} else if ([key isEqualToString:@"pictureRelativePath"]) {
		[super setValue:value forKey:@"pictureRelativePath"];
	} else if ([key isEqualToString:@"activities"]) {
		[super setValue:[WTMCollectionOfActivity instanceFromDictionary:value inRegistry:_registry includeChildren:NO] forKey:@"activities"];
	} else if ([key isEqualToString:@"libraries"]) {
		[super setValue:[WTMCollectionOfLibrary instanceFromDictionary:value inRegistry:_registry includeChildren:NO] forKey:@"libraries"];
	} else {
		[super setValue:value forKey:key];
	}
}

- (WTMCollectionOfActivity*)activities{
	if([_activities isAnAlias]){
		id o=[_registry objectWithUinstID:_activities.uinstID];
		if(o){
			_activities=o;
		}
	}
	return _activities;
}


- (WTMCollectionOfActivity*)activities_auto{
	_activities=[self activities];
	if(!_activities){
		_activities=[[WTMCollectionOfActivity alloc] initInRegistry:_registry];
	}
	return _activities;
}

- (void)setActivities:(WTMCollectionOfActivity*)activities{
	_activities=activities;
}

- (WTMCollectionOfLibrary*)libraries{
	if([_libraries isAnAlias]){
		id o=[_registry objectWithUinstID:_libraries.uinstID];
		if(o){
			_libraries=o;
		}
	}
	return _libraries;
}


- (WTMCollectionOfLibrary*)libraries_auto{
	_libraries=[self libraries];
	if(!_libraries){
		_libraries=[[WTMCollectionOfLibrary alloc] initInRegistry:_registry];
	}
	return _libraries;
}

- (void)setLibraries:(WTMCollectionOfLibrary*)libraries{
	_libraries=libraries;
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
	if(_license){
		[dictionary setValue:self.license forKey:@"license"];
	}
	if(_name){
		[dictionary setValue:self.name forKey:@"name"];
	}
	if(_pictureRelativePath){
		[dictionary setValue:self.pictureRelativePath forKey:@"pictureRelativePath"];
	}
	if(_activities){
		if(includeChildren){
			[dictionary setValue:[self.activities dictionaryRepresentationWithChildren:includeChildren] forKey:@"activities"];
		}else{
			[dictionary setValue:[self.activities aliasDictionaryRepresentation] forKey:@"activities"];
		}
	}
	if(_libraries){
		if(includeChildren){
			[dictionary setValue:[self.libraries dictionaryRepresentationWithChildren:includeChildren] forKey:@"libraries"];
		}else{
			[dictionary setValue:[self.libraries aliasDictionaryRepresentation] forKey:@"libraries"];
		}
	}
    return dictionary;
}


- (NSString*)description{
    if([self isAnAlias])
        return [super aliasDescription];
    NSMutableString *s=[NSMutableString stringWithString:[super description]];
	[s appendFormat:@"Instance of %@ (%@.%@) :\n",@"WTMPackage ",_registry.uidString,@(_uinstID)];
	[s appendFormat:@"license : %@\n",self.license];
	[s appendFormat:@"name : %@\n",self.name];
	[s appendFormat:@"pictureRelativePath : %@\n",self.pictureRelativePath];
	[s appendFormat:@"activities : %@\n",NSStringFromClass([self.activities class])];
	[s appendFormat:@"libraries : %@\n",NSStringFromClass([self.libraries class])];
	return s;
}

@end
