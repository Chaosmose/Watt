//
//  WattObject+ExternalReference.m
//  PlayerSample
//
//  Created by Benoit Pereira da Silva on 09/11/2013.
//  Copyright (c) 2013 Pereira da Silva. All rights reserved.
//

#import "WattObject+ExternalReference.h"
#import "WattExternalReference.h"


@implementation WattObject (ExternalReference)
/**
 *  Returns the external reference from the instance
 *
 *  @return the reference.
 */
- (WattExternalReference*)externalReference{
    WattExternalReference*r=[[WattExternalReference alloc]initInRegistry:self.registry];
    r.registryUidString=self.registry.uidString;
    r.objectUinstID=self->_uinstID;
    return r;
}

@end
