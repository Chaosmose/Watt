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
#import "WTMActivity.h"
#import "WTMBehavior.h"
#import "WTMCollectionOfElement.h"
#import "WTMImage.h"

@implementation WTMScene 

@synthesize category=_category;
@synthesize comment=_comment;
@synthesize controllerClass=_controllerClass;
@synthesize extras=_extras;
@synthesize number=_number;
@synthesize rect=_rect;
@synthesize rights=_rights;
@synthesize title=_title;
@synthesize activity=_activity;
@synthesize behavior=_behavior;
@synthesize elements=_elements;
@synthesize picture=_picture;

- (void)setValue:(id)value forKey:(NSString *)key {
	if ([key isEqualToString:@"category"]){
		[super setValue:value forKey:@"category"];
	} else if ([key isEqualToString:@"comment"]) {
		[super setValue:value forKey:@"comment"];
	} else if ([key isEqualToString:@"controllerClass"]) {
		[super setValue:value forKey:@"controllerClass"];
	} else if ([key isEqualToString:@"extras"]) {
		[super setValue:value forKey:@"extras"];
	} else if ([key isEqualToString:@"number"]) {
		[super setValue:value forKey:@"number"];
	} else if ([key isEqualToString:@"rect"]) {
		[super setValue:value forKey:@"rect"];
	} else if ([key isEqualToString:@"rights"]) {
		[super setValue:value forKey:@"rights"];
	} else if ([key isEqualToString:@"title"]) {
		[super setValue:value forKey:@"title"];
	} else if ([key isEqualToString:@"activity"]) {
		[super setValue:[WTMActivity instanceFromDictionary:value inRegistry:_registry includeChildren:NO] forKey:@"activity"];
	} else if ([key isEqualToString:@"behavior"]) {
		[super setValue:[WTMBehavior instanceFromDictionary:value inRegistry:_registry includeChildren:NO] forKey:@"behavior"];
	} else if ([key isEqualToString:@"elements"]) {
		[super setValue:[WTMCollectionOfElement instanceFromDictionary:value inRegistry:_registry includeChildren:NO] forKey:@"elements"];
	} else if ([key isEqualToString:@"picture"]) {
		[super setValue:[WTMImage instanceFromDictionary:value inRegistry:_registry includeChildren:NO] forKey:@"picture"];
	} else {
		[super setValue:value forKey:key];
	}
}


- (WTMActivity*)activity{
	if([_activity isAnAlias]){
		id o=[_registry objectWithUinstID:_activity.uinstID];
		if(o){
			_activity=o;
		}
	}
	return _activity;
}


- (WTMActivity*)activity_auto{
	_activity=[self activity];
	if(!_activity){
		_activity=[[WTMActivity alloc] initInRegistry:_registry];
	}
	return _activity;
}

- (void)setActivity:(WTMActivity*)activity{
	_activity=activity;
}

- (WTMBehavior*)behavior{
	if([_behavior isAnAlias]){
		id o=[_registry objectWithUinstID:_behavior.uinstID];
		if(o){
			_behavior=o;
		}
	}
	return _behavior;
}


- (WTMBehavior*)behavior_auto{
	_behavior=[self behavior];
	if(!_behavior){
		_behavior=[[WTMBehavior alloc] initInRegistry:_registry];
	}
	return _behavior;
}

- (void)setBehavior:(WTMBehavior*)behavior{
	_behavior=behavior;
}

- (WTMCollectionOfElement*)elements{
	if([_elements isAnAlias]){
		id o=[_registry objectWithUinstID:_elements.uinstID];
		if(o){
			_elements=o;
		}
	}
	return _elements;
}


- (WTMCollectionOfElement*)elements_auto{
	_elements=[self elements];
	if(!_elements){
		_elements=[[WTMCollectionOfElement alloc] initInRegistry:_registry];
	}
	return _elements;
}

- (void)setElements:(WTMCollectionOfElement*)elements{
	_elements=elements;
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



- (NSDictionary *)dictionaryRepresentationWithChildren:(BOOL)includeChildren{
    if([self isAnAlias])
        return [super aliasDictionaryRepresentation];
	NSMutableDictionary *wrapper = [NSMutableDictionary dictionary];
    NSMutableDictionary *dictionary=[NSMutableDictionary dictionary];
	[dictionary setValue:self.category forKey:@"category"];
	[dictionary setValue:self.comment forKey:@"comment"];
	[dictionary setValue:self.controllerClass forKey:@"controllerClass"];
	[dictionary setValue:self.extras forKey:@"extras"];
	[dictionary setValue:[NSNumber numberWithInteger:self.number] forKey:@"number"];
	[dictionary setValue:self.rect forKey:@"rect"];
	[dictionary setValue:self.rights forKey:@"rights"];
	[dictionary setValue:self.title forKey:@"title"];
	if(self.activity){
		if(includeChildren){
			[dictionary setValue:[self.activity dictionaryRepresentationWithChildren:includeChildren] forKey:@"activity"];
		}else{
			[dictionary setValue:[self.activity aliasDictionaryRepresentation] forKey:@"activity"];
		}
	}
	if(self.behavior){
		if(includeChildren){
			[dictionary setValue:[self.behavior dictionaryRepresentationWithChildren:includeChildren] forKey:@"behavior"];
		}else{
			[dictionary setValue:[self.behavior aliasDictionaryRepresentation] forKey:@"behavior"];
		}
	}
	if(self.elements){
		if(includeChildren){
			[dictionary setValue:[self.elements dictionaryRepresentationWithChildren:includeChildren] forKey:@"elements"];
		}else{
			[dictionary setValue:[self.elements aliasDictionaryRepresentation] forKey:@"elements"];
		}
	}
	if(self.picture){
		if(includeChildren){
			[dictionary setValue:[self.picture dictionaryRepresentationWithChildren:includeChildren] forKey:@"picture"];
		}else{
			[dictionary setValue:[self.picture aliasDictionaryRepresentation] forKey:@"picture"];
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
	[s appendFormat:@"category : %@\n",self.category];
	[s appendFormat:@"comment : %@\n",self.comment];
	[s appendFormat:@"controllerClass : %@\n",self.controllerClass];
	[s appendFormat:@"extras : %@\n",self.extras];
	[s appendFormat:@"number : %@\n",[NSNumber numberWithInteger:self.number]];
	[s appendFormat:@"rect : %@\n",self.rect];
	[s appendFormat:@"rights : %@\n",self.rights];
	[s appendFormat:@"title : %@\n",self.title];
	[s appendFormat:@"activity : %@\n",NSStringFromClass([self.activity class])];
	[s appendFormat:@"behavior : %@\n",NSStringFromClass([self.behavior class])];
	[s appendFormat:@"elements : %@\n",NSStringFromClass([self.elements class])];
	[s appendFormat:@"picture : %@\n",NSStringFromClass([self.picture class])];
	return s;
}

@end
