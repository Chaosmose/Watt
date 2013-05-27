//
//  WTMObjectAlias.h
//  PlayerSample
//
//  Created by Benoit Pereira da Silva on 22/05/13.
//  Copyright (c) 2013 Pereira da Silva. All rights reserved.
//


// We uses aliases to store reference to object graph
// during a registry serialization.

#import"WattObject.h"

@class WattObject;
@class WattRegistry;

@interface WattObjectAlias : NSObject<WattAliasing>{
}

+ (NSDictionary*)aliasDictionaryRepresentationFrom:(WattObject*)object;
+ (WattObjectAlias*)aliasFrom:(WattObject*)object;
+ (id)instanceFromDictionary:(NSDictionary *)aDictionary;
- (NSInteger)uinstID;

- (id)initInRegistry:(WattRegistry*)registry;
- (NSDictionary *)dictionaryRepresentationWithChildren:(BOOL)includeChildren;



@end
