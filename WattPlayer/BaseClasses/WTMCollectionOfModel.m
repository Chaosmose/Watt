//
//  WTMCollectionOfModel.m
//  PlayerSample
//
//  Created by Benoit Pereira da Silva on 17/05/13.
//  Copyright (c) 2013 Pereira da Silva. All rights reserved.
//

#import "WTMCollectionOfModel.h"

@implementation WTMCollectionOfModel

-(void)localize{
    for (WTMModel*model in _collection) {
        if([model respondsToSelector:@selector(localize)]){
            [model localize];
        }
    }
}
@end
