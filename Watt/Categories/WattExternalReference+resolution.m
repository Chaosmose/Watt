//
//  WattExternalReference+resolution.m
//  PlayerSample
//
//  Created by Benoit Pereira da Silva on 09/11/2013.
//  Copyright (c) 2013 Pereira da Silva. All rights reserved.
//

#import "WattExternalReference+Resolution.h"

@implementation WattExternalReference (Resolution)

-(id)concreteInstance{
    return [self.registry.pool objectByWattReference:self];
}

@end
