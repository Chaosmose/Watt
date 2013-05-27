//
//  WTMCollectionOfModel.h
//  PlayerSample
//
//  Created by Benoit Pereira da Silva on 17/05/13.
//  Copyright (c) 2013 Pereira da Silva. All rights reserved.
//

#import "WattObject.h"

@interface WattCollectionOfObject : WattObject {
    @protected
    NSMutableArray* _collection;
}


+ (WattCollectionOfObject*)instanceFromDictionary:(NSDictionary *)aDictionary
                                       inRegistry:(WattRegistry*)registry
                                  includeChildren:(BOOL)includeChildren;


// Accessors

- (WattObject *)objectAtIndex:(NSUInteger)index;
- (WattObject *)lastObject;
- (WattObject *)firstObjectCommonWithArray:(NSArray*)array;

- (void)addObject:(WattObject*)anObject;
- (void)insertObject:(WattObject*)anObject atIndex:(NSUInteger)index;
- (void)removeLastObject;
- (void)removeObjectAtIndex:(NSUInteger)index;
- (void)replaceObjectAtIndex:(NSUInteger)index withObject:(WattObject*)anObject;


@end
