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
//  WTMLabel.m
//  WTM
//
//  Generated by Flexions  
//  Copyright (c) 2013 Benoit Pereira da Silva All rights reserved.
 
#import "WTMLabel.h" 

@implementation WTMLabel 

@synthesize font=_font;
@synthesize text=_text;


#pragma  mark WattCopying

- (instancetype)wattCopyInRegistry:(WattRegistry*)destinationRegistry{
	WTMLabel *instance=[super wattCopyInRegistry:destinationRegistry];
	instance->_registry=destinationRegistry;
	instance->_font=[_font copy];
	instance->_text=[_text copy];
    return instance;
}

#pragma  mark WattExtraction

- (instancetype)wattExtractAndCopyToRegistry:(WattRegistry*)destinationRegistry{
	WTMLabel *instance=[super wattExtractAndCopyToRegistry:destinationRegistry];
	instance->_registry=destinationRegistry;
	instance->_font=[_font copy];
	instance->_text=[_text copy];
    return instance;
}




#pragma mark -


- (void)setValue:(id)value forKey:(NSString *)key {
	if ([key isEqualToString:@"font"]){
		[super setValue:value forKey:@"font"];
	} else if ([key isEqualToString:@"text"]) {
		[super setValue:value forKey:@"text"];
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
	if(_font){
		[dictionary setValue:self.font forKey:@"font"];
	}
	if(_text){
		[dictionary setValue:self.text forKey:@"text"];
	}
    return dictionary;
}


- (NSString*)description{
    if([self isAnAlias])
        return [super aliasDescription];
    NSMutableString *s=[NSMutableString stringWithString:[super description]];
	[s appendFormat:@"Instance of %@ (%@.%i) :\n",@"WTMLabel ",_registry.uidString,_uinstID];
	[s appendFormat:@"font : %@\n",self.font];
	[s appendFormat:@"text : %@\n",self.text];
	return s;
}

@end
