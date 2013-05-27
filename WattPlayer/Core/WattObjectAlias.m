//
//  WTMObjectAlias.m
//  PlayerSample
//
//  Created by Benoit Pereira da Silva on 22/05/13.
//  Copyright (c) 2013 Pereira da Silva. All rights reserved.
//

#import "WattObjectAlias.h"

@interface WattObjectAlias(){
}
- (id)initWithUinstID:(NSInteger)uinstID;
- (id)initFromReference:(WattObject*)object;
@end


@implementation WattObjectAlias{
    NSInteger _uinstID;
}

- (id)init{
    [NSException raise:@"Core" format:@"WTMObjectAlias must be initialized using initWithUinstID:"];
    return nil;
}

- (id)initWithUinstID:(NSInteger)uinstID{
    self=[super init];
    if(self){
        _uinstID=uinstID;
    }
    return self;
}

- (id)initFromReference:(WattObject*)object{
    return [[WattObjectAlias alloc] initWithUinstID:object.uinstID];
}

- (id)initInRegistry:(WattRegistry*)registry{
    return nil;
}


- (BOOL)isAnAlias{
    return YES;
}


+ (NSDictionary*)aliasDictionaryRepresentationFrom:(WattObject*)object{
    return [[[WattObjectAlias alloc]initFromReference:object] dictionaryRepresentationWithChildren:NO];
}


+ (WattObjectAlias*)aliasFrom:(WattObject*)object{
    return [[WattObjectAlias alloc] initFromReference:object];
}


+ (id)instanceFromDictionary:(NSDictionary *)aDictionary{
    NSNumber *uinstIDNb=[aDictionary objectForKey:__uinstID__];
    if(uinstIDNb){
        return [[WattObjectAlias alloc] initWithUinstID:[uinstIDNb integerValue]];
    }else{
        [NSException raise:@"WattObjectAlias" format:@"Attempt to instanciate from a dictionary with no __uinstID__ key"];
    }
    return nil;
}


- (NSInteger)uinstID{
    return _uinstID;
}

- (NSDictionary *)dictionaryRepresentationWithChildren:(BOOL)includeChildren{
	NSMutableDictionary *wrapper = [NSMutableDictionary dictionary];
    NSMutableDictionary *dictionary=[NSMutableDictionary dictionary];
	[wrapper setObject:NSStringFromClass([self class]) forKey:__className__];
    [wrapper setObject:dictionary forKey:__properties__];
    [wrapper setObject:[NSNumber numberWithInteger:self.uinstID] forKey:__uinstID__];
    return wrapper;
}

-(NSString*)description{
    return [NSString stringWithFormat:@"Alias of %i",self.uinstID];
}

@end
