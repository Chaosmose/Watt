//
//  WTMObjectAlias.m
//  PlayerSample
//
//  Created by Benoit Pereira da Silva on 22/05/13.
//  Copyright (c) 2013 Pereira da Silva. All rights reserved.
//

#import "WattObjectAlias.h"

@implementation WattObjectAlias{
    NSInteger _uinstID;
}

-(id)init{
    [NSException raise:@"Core" format:@"WTMObjectAlias must be initialized using initWithUinstID:"];
    return nil;
}


-(id)initWithUinstID:(NSInteger)uinstID{
    self=[super init];
    if(self){
        _uinstID=uinstID;
    }
    return self;
}

-(NSInteger)uinstID{
    return _uinstID;
}


-(NSDictionary*)dictionaryRepresentation{
	NSMutableDictionary *wrapper = [NSMutableDictionary dictionary];
    NSMutableDictionary *dictionary=[NSMutableDictionary dictionary];
	[wrapper setObject:NSStringFromClass([self class]) forKey:__className__];
    [wrapper setObject:dictionary forKey:__properties__];
    [wrapper setObject:[NSNumber numberWithInteger:self.uinstID] forKey:__uinstID__];
    return wrapper;
}


@end
