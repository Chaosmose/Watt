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
//
//  WTMObjectsRegister.m
//  PlayerSample
//
//  Created by Benoit Pereira da Silva on 22/05/13.
//  Copyright (c) 2013 Pereira da Silva. All rights reserved.
//

#import "WattRegistry.h"

@implementation WattRegistry{
    NSInteger           _uinstIDCounter;
    NSMutableDictionary  *_registry;
}


-(id)init{
    self=[super init];
    if(self){
        _uinstIDCounter=0;
        _registry=[NSMutableDictionary dictionary];
    }
    return self;
}

-(NSUInteger)count{
    return _uinstIDCounter;
}


+ (WattRegistry*)instanceFromArray:(NSArray*)array{
    WattRegistry *r=[[WattRegistry alloc] init];
    for (NSDictionary *d in array) {
        WattObject *liveObject=[WattObject instanceFromDictionary:d inRegistry:r];
        [r registerObject:liveObject];
    }
    return r;
}


- (NSArray*)arrayRepresentation{
    NSMutableArray*registryArray=[NSMutableArray array];
    for (NSString *k in _registry) {
        id o=[_registry objectForKey:k];
        if(![o isKindOfClass:[NSNull class]]){
            if([o respondsToSelector:@selector(dictionaryRepresentation)]){
                [registryArray addObject:[o dictionaryRepresentation]];
            }
        }
    }
    return registryArray;
}



#pragma runtime object graph identification


-(NSInteger)_createAnUinstID{
    _uinstIDCounter++;
    return _uinstIDCounter;
}


-(WattObject*)objectWithUinstID:(NSInteger)uinstID{
    if([_registry count]>uinstID){
        return [_registry objectForKey:[self _keyFrom:uinstID]];
    }else{
        return nil;
    }
}

-(NSString*)_keyFrom:(NSInteger)uinstID{
    return [NSString stringWithFormat:@"%i",uinstID];
}


-(void)registerObject:(WattObject*)reference{
    if(reference.uinstID==0){
        [reference identifyWithUinstId:[self _createAnUinstID]];
        [_registry setValue:reference forKey:[self _keyFrom:reference.uinstID]];
    }else if(_uinstIDCounter>reference.uinstID){
        if(![[self objectWithUinstID:reference.uinstID] isEqual:reference]){
            [NSException raise:@"Registry" format:@"Identity missmatch"];
        }
    }else{
#if  !WT_ALLOW_MULTIPLE_REGISTRATION
       [NSException raise:@"Registry" format:@"Identity overflow"];
#endif
    }
}

-(void)unRegisterObject:(WattObject*)reference{
    [_registry removeObjectForKey:[self _keyFrom:reference.uinstID]];
}


-(NSString*)description{
	NSMutableString *s=[NSMutableString string];
    [s appendFormat:@"Registry with %i members\n\n",[self count]];
    int i=0;
    for (NSString*key in _registry) {
        [s appendFormat:@"#%i|%@\n",i,[_registry objectForKey:key]];
        i++;
    }
	return s;
}


@end
