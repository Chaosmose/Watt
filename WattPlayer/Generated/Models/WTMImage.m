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
//  WTMImage.m
//  Watt
//
//  Generated by Flexions  
//  Copyright (c) 2013 Benoit Pereira da Silva All rights reserved.
 
#import "WTMImage.h" 

@implementation WTMImage 

@synthesize size=_size;

- (void)setValue:(id)value forKey:(NSString *)key {
	if ([key isEqualToString:@"size"]){
		[super setValue:value forKey:@"size"];
	} else {
		[super setValue:value forKey:key];
	}
}




- (NSDictionary *)dictionaryRepresentationWithChildren:(BOOL)includeChildren{
    if([self isAnAlias])
        return [super aliasDictionaryRepresentation];
	NSMutableDictionary *wrapper = [NSMutableDictionary dictionary];
    NSMutableDictionary *dictionary=[NSMutableDictionary dictionary];
	[dictionary setValue:[NSValue valueWithCGSize:self.size] forKey:@"size"];
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
	[s appendFormat:@"size : %@\n",[NSValue valueWithCGSize:self.size]];
	return s;
}

@end
