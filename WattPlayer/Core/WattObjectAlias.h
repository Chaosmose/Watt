//
//  WTMObjectAlias.h
//  PlayerSample
//
//  Created by Benoit Pereira da Silva on 22/05/13.
//  Copyright (c) 2013 Pereira da Silva. All rights reserved.
//


// We uses aliases to store reference to object graph
// during a registry serialization.

#import <Foundation/Foundation.h>

@interface WattObjectAlias : NSObject{
}

-(id)initWithUinstID:(NSInteger)uinstID;
-(NSInteger)uinstID;
-(NSDictionary*)dictionaryRepresentation;


@end
