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
- (instancetype)initWithUinstID:(NSInteger)uinstID andClassName:(NSString*)className;
- (instancetype)initFromReference:(WattObject*)object andClassName:(NSString*)className;
@end


@implementation WattObjectAlias{
    NSInteger _uinstID;
    NSString* _aliasedClassName;
}

- (instancetype)init{
    [NSException raise:@"Core" format:@"WTMObjectAlias must be initialized using initWithUinstID:"];
    return nil;
}

- (instancetype)initWithUinstID:(NSInteger)uinstID andClassName:(NSString*)className{
    self=[super init];
    if(self){
        _uinstID=uinstID;
        _aliasedClassName=className;
    }
    return self;
}

- (instancetype)initFromReference:(WattObject*)object andClassName:(NSString *)className{
    return [[WattObjectAlias alloc] initWithUinstID:object.uinstID
                                       andClassName:className];
}

- (instancetype)initInRegistry:(WattRegistry*)registry{
    return nil;
}


- (BOOL)isAnAlias{
    return YES;
}

-(void)resolveAliases{
    // Nothing to do
}


+ (NSDictionary*)aliasDictionaryRepresentationFrom:(WattObject*)object{
    return [[[WattObjectAlias alloc]initFromReference:object
                                         andClassName:NSStringFromClass([object class])]
            dictionaryRepresentationWithChildren:NO];
}


+ (WattObjectAlias*)aliasFrom:(WattObject*)object{
    return [[WattObjectAlias alloc] initFromReference:object andClassName:NSStringFromClass([object class])];
}


+ (WattObjectAlias*)aliasFromDictionary:(NSDictionary *)aDictionary{
    NSNumber *uinstIDNb=[aDictionary objectForKey:__uinstID__];
    NSString *className=[aDictionary objectForKey:__className__];
    if(uinstIDNb && className){
        WattObjectAlias *alias=[[WattObjectAlias alloc] initWithUinstID:[uinstIDNb integerValue] andClassName:className];
#warning  should we populate the collection with alias in case it is a collection ?
        return alias;
    }else{
        [NSException raise:@"WattObjectAlias" format:@"Attempt to instanciate from an inconsistent dictionary %@",aDictionary];
    }
    return nil;
}


- (NSInteger)uinstID{
    return _uinstID;
}

- (NSDictionary *)dictionaryRepresentationWithChildren:(BOOL)includeChildren{
	NSMutableDictionary *wrapper = [NSMutableDictionary dictionary];
    [wrapper setObject:[NSNumber numberWithBool:YES] forKey:__isAliased__];
	[wrapper setObject:_aliasedClassName forKey:__className__];
    [wrapper setObject:[NSNumber numberWithInteger:self.uinstID] forKey:__uinstID__];
    return wrapper;
}

- (NSString*)description{
    return [NSString stringWithFormat:@"Alias of %@(#%i)",_aliasedClassName,self.uinstID];
}

@end
