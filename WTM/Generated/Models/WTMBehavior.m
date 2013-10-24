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
//  WTMBehavior.m
//  WTM
//
//  Generated by Flexions  
//  Copyright (c) 2013 Benoit Pereira da Silva All rights reserved.
 
#import "WTMBehavior.h" 

@implementation WTMBehavior 

@synthesize actionName=_actionName;
@synthesize attributes=_attributes;
@synthesize triggerName=_triggerName;


#pragma  mark WattCopying

- (instancetype)wattCopyInRegistry:(WattRegistry*)destinationRegistry{
	WTMBehavior *instance=[super wattCopyInRegistry:destinationRegistry];
	instance->_registry=destinationRegistry;
	instance->_actionName=[_actionName copy];
	instance->_attributes=[_attributes copy];
	instance->_triggerName=[_triggerName copy];
    return instance;
}


#pragma mark -


- (void)setValue:(id)value forKey:(NSString *)key {
	if ([key isEqualToString:@"actionName"]){
		[super setValue:value forKey:@"actionName"];
	} else if ([key isEqualToString:@"attributes"]) {
		[super setValue:value forKey:@"attributes"];
	} else if ([key isEqualToString:@"triggerName"]) {
		[super setValue:value forKey:@"triggerName"];
	} else {
		[super setValue:value forKey:key];
	}
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
	[dictionary setValue:self.actionName forKey:@"actionName"];
	[dictionary setValue:self.attributes forKey:@"attributes"];
	[dictionary setValue:self.triggerName forKey:@"triggerName"];
    return dictionary;
}


- (NSString*)description{
    if([self isAnAlias])
        return [super aliasDescription];
    NSMutableString *s=[NSMutableString stringWithString:[super description]];
	[s appendFormat:@"Instance of %@ (%i) :\n",@"WTMBehavior ",self.uinstID];
	[s appendFormat:@"actionName : %@\n",self.actionName];
	[s appendFormat:@"attributes : %@\n",self.attributes];
	[s appendFormat:@"triggerName : %@\n",self.triggerName];
	return s;
}

@end
