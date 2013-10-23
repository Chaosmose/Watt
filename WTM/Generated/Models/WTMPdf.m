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
//  WTMPdf.m
//  WTM
//
//  Generated by Flexions  
//  Copyright (c) 2013 Benoit Pereira da Silva All rights reserved.
 
#import "WTMPdf.h" 

@implementation WTMPdf 

@synthesize size=_size;


#pragma  mark WattCopying

- (instancetype)wattCopyInRegistry:(WattRegistry*)registry{
    WTMPdf *instance=[self copy];
    [registry addObject:instance];
    return instance;
}


// NSCopying
- (id)copyWithZone:(NSZone *)zone{
    WTMPdf *instance=[[[super class] allocWithZone:zone] init];
    	instance->_registry=nil; // We want to furnish a registry free copy
		// we do not provide an _uinstID
   			instance->_size=[_size copyWithZone:zone];
    return instance;
}

#pragma mark -


- (void)setValue:(id)value forKey:(NSString *)key {
	if ([key isEqualToString:@"size"]){
		[super setValue:value forKey:@"size"];
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
	[dictionary setValue:self.size forKey:@"size"];
    return dictionary;
}


- (NSString*)description{
    if([self isAnAlias])
        return [super aliasDescription];
    NSMutableString *s=[NSMutableString stringWithString:[super description]];
	[s appendFormat:@"Instance of %@ (%i) :\n",@"WTMPdf ",self.uinstID];
	[s appendFormat:@"size : %@\n",self.size];
	return s;
}

@end
