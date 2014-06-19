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
//  WTMScene.m
//  WTM
//
//  Generated by Flexions  
//  Copyright (c) 2013 Benoit Pereira da Silva All rights reserved.
 
#import "WTMScene.h" 
#import "WTMActivity.h"
#import "WTMCollectionOfBehavior.h"
#import "WTMCollectionOfElement.h"
#import "WTMTable.h"

@implementation WTMScene 

@synthesize footer=_footer;
@synthesize header=_header;
@synthesize index=_index;
@synthesize pictureRelativePath=_pictureRelativePath;
@synthesize title=_title;
@synthesize activity=_activity;
@synthesize behaviors=_behaviors;
@synthesize elements=_elements;
@synthesize table=_table;




#pragma mark -


- (void)setValue:(id)value forKey:(NSString *)key {
	if ([key isEqualToString:@"footer"]){
		[super setValue:value forKey:@"footer"];
	} else if ([key isEqualToString:@"header"]) {
		[super setValue:value forKey:@"header"];
	} else if ([key isEqualToString:@"index"]) {
		[super setValue:value forKey:@"index"];
	} else if ([key isEqualToString:@"pictureRelativePath"]) {
		[super setValue:value forKey:@"pictureRelativePath"];
	} else if ([key isEqualToString:@"title"]) {
		[super setValue:value forKey:@"title"];
	} else if ([key isEqualToString:@"activity"]) {
		[super setValue:[WTMActivity instanceFromDictionary:value inRegistry:_registry includeChildren:NO] forKey:@"activity"];
	} else if ([key isEqualToString:@"behaviors"]) {
		[super setValue:[WTMCollectionOfBehavior instanceFromDictionary:value inRegistry:_registry includeChildren:NO] forKey:@"behaviors"];
	} else if ([key isEqualToString:@"elements"]) {
		[super setValue:[WTMCollectionOfElement instanceFromDictionary:value inRegistry:_registry includeChildren:NO] forKey:@"elements"];
	} else if ([key isEqualToString:@"table"]) {
		[super setValue:[WTMTable instanceFromDictionary:value inRegistry:_registry includeChildren:NO] forKey:@"table"];
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

- (WTMCollectionOfBehavior*)behaviors{
	if([_behaviors isAnAlias]){
		id o=[_registry objectWithUinstID:_behaviors.uinstID];
		if(o){
			_behaviors=o;
		}
	}
	return _behaviors;
}


- (WTMCollectionOfBehavior*)behaviors_auto{
	_behaviors=[self behaviors];
	if(!_behaviors){
		_behaviors=[[WTMCollectionOfBehavior alloc] initInRegistry:_registry];
	}
	return _behaviors;
}

- (void)setBehaviors:(WTMCollectionOfBehavior*)behaviors{
	_behaviors=behaviors;
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

- (WTMTable*)table{
	if([_table isAnAlias]){
		id o=[_registry objectWithUinstID:_table.uinstID];
		if(o){
			_table=o;
		}
	}
	return _table;
}


- (WTMTable*)table_auto{
	_table=[self table];
	if(!_table){
		_table=[[WTMTable alloc] initInRegistry:_registry];
	}
	return _table;
}

- (void)setTable:(WTMTable*)table{
	_table=table;
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
	if(_footer){
		[dictionary setValue:self.footer forKey:@"footer"];
	}
	if(_header){
		[dictionary setValue:self.header forKey:@"header"];
	}
	[dictionary setValue:@(self.index) forKey:@"index"];
	if(_pictureRelativePath){
		[dictionary setValue:self.pictureRelativePath forKey:@"pictureRelativePath"];
	}
	if(_title){
		[dictionary setValue:self.title forKey:@"title"];
	}
	if(_activity){
		if(includeChildren){
			[dictionary setValue:[self.activity dictionaryRepresentationWithChildren:includeChildren] forKey:@"activity"];
		}else{
			[dictionary setValue:[self.activity aliasDictionaryRepresentation] forKey:@"activity"];
		}
	}
	if(_behaviors){
		if(includeChildren){
			[dictionary setValue:[self.behaviors dictionaryRepresentationWithChildren:includeChildren] forKey:@"behaviors"];
		}else{
			[dictionary setValue:[self.behaviors aliasDictionaryRepresentation] forKey:@"behaviors"];
		}
	}
	if(_elements){
		if(includeChildren){
			[dictionary setValue:[self.elements dictionaryRepresentationWithChildren:includeChildren] forKey:@"elements"];
		}else{
			[dictionary setValue:[self.elements aliasDictionaryRepresentation] forKey:@"elements"];
		}
	}
	if(_table){
		if(includeChildren){
			[dictionary setValue:[self.table dictionaryRepresentationWithChildren:includeChildren] forKey:@"table"];
		}else{
			[dictionary setValue:[self.table aliasDictionaryRepresentation] forKey:@"table"];
		}
	}
    return dictionary;
}


- (NSString*)description{
    if([self isAnAlias])
        return [super aliasDescription];
    NSMutableString *s=[NSMutableString stringWithString:[super description]];
	[s appendFormat:@"Instance of %@ (%@.%@) :\n",@"WTMScene ",_registry.uidString,@(_uinstID)];
	[s appendFormat:@"footer : %@\n",self.footer];
	[s appendFormat:@"header : %@\n",self.header];
	[s appendFormat:@"index : %@\n",@(self.index)];
	[s appendFormat:@"pictureRelativePath : %@\n",self.pictureRelativePath];
	[s appendFormat:@"title : %@\n",self.title];
	[s appendFormat:@"activity : %@\n",NSStringFromClass([self.activity class])];
	[s appendFormat:@"behaviors : %@\n",NSStringFromClass([self.behaviors class])];
	[s appendFormat:@"elements : %@\n",NSStringFromClass([self.elements class])];
	[s appendFormat:@"table : %@\n",NSStringFromClass([self.table class])];
	return s;
}

@end
