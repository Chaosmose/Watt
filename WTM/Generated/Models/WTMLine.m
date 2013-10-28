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
//  WTMLine.m
//  WTM
//
//  Generated by Flexions  
//  Copyright (c) 2013 Benoit Pereira da Silva All rights reserved.
 
#import "WTMLine.h" 
#import "WTMCollectionOfCell.h"
#import "WTMTable.h"

@implementation WTMLine 

@synthesize width=_width;
@synthesize cells=_cells;
@synthesize table=_table;


#pragma  mark WattCopying

- (instancetype)wattCopyInRegistry:(WattRegistry*)destinationRegistry{
	WTMLine *instance=[super wattCopyInRegistry:destinationRegistry];
	instance->_registry=destinationRegistry;
	instance->_width=_width;
	instance->_cells=[_cells instancebyCopyTo:destinationRegistry];
	instance->_table=[_table instancebyCopyTo:destinationRegistry];
    return instance;
}

#pragma  mark WattExtraction

- (instancetype)wattExtractAndCopyToRegistry:(WattRegistry*)destinationRegistry{
	WTMLine *instance=[super wattExtractAndCopyToRegistry:destinationRegistry];
	instance->_registry=destinationRegistry;
	instance->_width=_width;
	instance->_cells=[_cells extractInstancebyCopyTo:destinationRegistry];
	instance->_table=[_table extractInstancebyCopyTo:destinationRegistry];
    return instance;
}




#pragma mark -


- (void)setValue:(id)value forKey:(NSString *)key {
	if ([key isEqualToString:@"width"]){
		[super setValue:value forKey:@"width"];
	} else if ([key isEqualToString:@"cells"]) {
		[super setValue:[WTMCollectionOfCell instanceFromDictionary:value inRegistry:_registry includeChildren:NO] forKey:@"cells"];
	} else if ([key isEqualToString:@"table"]) {
		[super setValue:[WTMTable instanceFromDictionary:value inRegistry:_registry includeChildren:NO] forKey:@"table"];
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
	[dictionary setValue:[NSNumber numberWithInteger:self.width] forKey:@"width"];
	if(self.cells){
		if(includeChildren){
			[dictionary setValue:[self.cells dictionaryRepresentationWithChildren:includeChildren] forKey:@"cells"];
		}else{
			[dictionary setValue:[self.cells aliasDictionaryRepresentation] forKey:@"cells"];
		}
	}
	if(self.table){
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
	[s appendFormat:@"Instance of %@ (%i) :\n",@"WTMLine ",self.uinstID];
	[s appendFormat:@"width : %@\n",[NSNumber numberWithInteger:self.width]];
	[s appendFormat:@"cells : %@\n",NSStringFromClass([self.cells class])];
	[s appendFormat:@"table : %@\n",NSStringFromClass([self.table class])];
	return s;
}

@end
