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
//  WTMColumn.m
//  WTM
//
//  Generated by Flexions  
//  Copyright (c) 2013 Benoit Pereira da Silva All rights reserved.
 
#import "WTMColumn.h" 
#import "WTMCollectionOfCell.h"
#import "WTMCollectionOfLine.h"

@implementation WTMColumn 

@synthesize cells=_cells;
@synthesize lines=_lines;

- (void)setValue:(id)value forKey:(NSString *)key {
	if ([key isEqualToString:@"cells"]){
		[super setValue:[WTMCollectionOfCell instanceFromDictionary:value inRegistry:_registry includeChildren:NO] forKey:@"cells"];
	} else if ([key isEqualToString:@"lines"]) {
		[super setValue:[WTMCollectionOfLine instanceFromDictionary:value inRegistry:_registry includeChildren:NO] forKey:@"lines"];
	} else {
		[super setValue:value forKey:key];
	}
}

- (WTMCollectionOfCell*)cells{
	if([_cells isAnAlias]){
		id o=[_registry objectWithUinstID:_cells.uinstID];
		if(o){
			_cells=o;
		}
	}
	return _cells;
}


- (WTMCollectionOfCell*)cells_auto{
	_cells=[self cells];
	if(!_cells){
		_cells=[[WTMCollectionOfCell alloc] initInRegistry:_registry];
	}
	return _cells;
}

- (void)setCells:(WTMCollectionOfCell*)cells{
	_cells=cells;
}

- (WTMCollectionOfLine*)lines{
	if([_lines isAnAlias]){
		id o=[_registry objectWithUinstID:_lines.uinstID];
		if(o){
			_lines=o;
		}
	}
	return _lines;
}


- (WTMCollectionOfLine*)lines_auto{
	_lines=[self lines];
	if(!_lines){
		_lines=[[WTMCollectionOfLine alloc] initInRegistry:_registry];
	}
	return _lines;
}

- (void)setLines:(WTMCollectionOfLine*)lines{
	_lines=lines;
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
	if(self.cells){
		if(includeChildren){
			[dictionary setValue:[self.cells dictionaryRepresentationWithChildren:includeChildren] forKey:@"cells"];
		}else{
			[dictionary setValue:[self.cells aliasDictionaryRepresentation] forKey:@"cells"];
		}
	}
	if(self.lines){
		if(includeChildren){
			[dictionary setValue:[self.lines dictionaryRepresentationWithChildren:includeChildren] forKey:@"lines"];
		}else{
			[dictionary setValue:[self.lines aliasDictionaryRepresentation] forKey:@"lines"];
		}
	}
    return dictionary;
}


- (NSString*)description{
    if([self isAnAlias])
        return [super aliasDescription];
    NSMutableString *s=[NSMutableString stringWithString:[super description]];
	[s appendFormat:@"Instance of %@ (%i) :\n",@"WTMColumn ",self.uinstID];
	[s appendFormat:@"cells : %@\n",NSStringFromClass([self.cells class])];
	[s appendFormat:@"lines : %@\n",NSStringFromClass([self.lines class])];
	return s;
}

@end
