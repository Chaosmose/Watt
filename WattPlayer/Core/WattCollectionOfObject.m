//
//  WTMCollectionOfModel.m
//  PlayerSample
//
//  Created by Benoit Pereira da Silva on 17/05/13.
//  Copyright (c) 2013 Pereira da Silva. All rights reserved.
//

#import "WattCollectionOfObject.h"

@implementation WattCollectionOfObject

-(void)localize{
    for (WattObject*object in _collection) {
        if([object respondsToSelector:@selector(localize)]){
            [object localize];
        }
    }
}

- (void)setAttributesFromDictionary:(NSDictionary *)aDictionary{
	if (![aDictionary isKindOfClass:[NSDictionary class]]) {
		return;
	}
	_collection=[NSMutableArray array];
    NSArray *a=[aDictionary objectForKey:__collection__];
    for (NSDictionary*objectDictionary in a) {
        Class c=NSClassFromString([objectDictionary objectForKey:__className__]);
        id o=[c instanceFromDictionary:objectDictionary inRegistry:_registry];
        [_collection addObject:o];
    }
}



@end
