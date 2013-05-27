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
//  WTMUser.m
//  Watt
//
//  Generated by Flexions  
//  Copyright (c) 2013 Benoit Pereira da Silva All rights reserved.
 
#import "WTMUser.h" 
#import "WTMCollectionOfGroup.h"

@implementation WTMUser 

@synthesize identity=_identity;
@synthesize uid=_uid;
@synthesize groups=_groups;

- (WTMUser *)localized{
    [self localize];
    return self;
}

+ (WTMUser*)instanceFromDictionary:(NSDictionary *)aDictionary inRegistry:(WattRegistry*)registry includeChildren:(BOOL)includeChildren{
	return (WTMUser*)[WattObject instanceFromDictionary:aDictionary inRegistry:registry includeChildren:YES];;
}


- (void)setValue:(id)value forKey:(NSString *)key {
	if ([key isEqualToString:@"identity"]){
		[super setValue:value forKey:@"identity"];
	} else if ([key isEqualToString:@"uid"]) {
		[super setValue:value forKey:@"uid"];
	} else if ([key isEqualToString:@"groups"]) {
		[super setValue:[WTMCollectionOfGroup instanceFromDictionary:value inRegistry:_registry includeChildren:YES] forKey:@"groups"];
	} else {
		[super setValue:value forKey:key];
	}
}


-(WTMCollectionOfGroup*)groups{
	if([_groups isAnAlias]){
		WattObjectAlias *alias=(WattObjectAlias*)_groups;
		_groups=(WTMCollectionOfGroup*)[_registry objectWithUinstID:alias.uinstID];
	}
	if(!_groups){
		_groups=[[WTMCollectionOfGroup alloc] initInRegistry:_registry];
	}
	return _groups;
}


- (WTMCollectionOfGroup*)groups_auto{
	_groups=[self groups];
	if(!_groups){
		_groups=[[WTMCollectionOfGroup alloc] initInRegistry:_registry];
	}
	return _groups;
}

-(void)setGroups:(WTMCollectionOfGroup*)groups{
	_groups=groups;
}



-(NSDictionary *)dictionaryRepresentationWithChildren:(BOOL)includeChildren{
	NSMutableDictionary *wrapper = [NSMutableDictionary dictionary];
    NSMutableDictionary *dictionary=[NSMutableDictionary dictionary];
	[dictionary setValue:self.identity forKey:@"identity"];
	[dictionary setValue:self.uid forKey:@"uid"];
	if(includeChildren){
		[dictionary setValue:[self.groups dictionaryRepresentationWithChildren:includeChildren] forKey:@"groups"];
	}else{
		[dictionary setValue:[WattObjectAlias aliasDictionaryRepresentationFrom:self.groups] forKey:@"groups"];
	}
	[wrapper setObject:NSStringFromClass([self class]) forKey:__className__];
    [wrapper setObject:dictionary forKey:__properties__];
    [wrapper setObject:[NSNumber numberWithInteger:self.uinstID] forKey:__uinstID__];
    return wrapper;
}

-(NSString*)description{
	NSMutableString *s=[NSMutableString string];
	[s appendFormat:@"Instance of %@ :\n",NSStringFromClass([self class])];
	[s appendFormat:@"identity : %@\n",self.identity];
	[s appendFormat:@"uid : %@\n",self.uid];
	[s appendFormat:@"groups : %@\n",NSStringFromClass([self.groups class])];
	return s;
}

/*
// @todo implement the default values? 
- (void)setNilValueForKey:(NSString *)theKey{
    if ([theKey isEqualToString:@"age"]) {
        [self setValue:[NSNumber numberWithFloat:0.0] forKey:@"age"];
    } else
        [super setNilValueForKey:theKey];
}

//@todo implement the validation process
-(BOOL)validateName:(id *)ioValue error:(NSError * __autoreleasing *)outError{
 
    // The name must not be nil, and must be at least two characters long.
    if ((*ioValue == nil) || ([(NSString *)*ioValue length] < 2)) {
        if (outError != NULL) {
            NSString *errorString = NSLocalizedString(
                    @"A Person's name must be at least two characters long",
                    @"validation: Person, too short name error");
            NSDictionary *userInfoDict = @{ NSLocalizedDescriptionKey : errorString };
            *outError = [[NSError alloc] initWithDomain:@"PERSON_ERROR_DOMAIN"
                                                    code:1//PERSON_INVALID_NAME_CODE
                                                userInfo:userInfoDict];
        }
        return NO;
    }
    return YES;
}
*/


@end
