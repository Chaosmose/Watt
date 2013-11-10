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
    r.registryUidString=[self.registry.uidString copy];
    r.objectUinstID=self->_uinstID;
    return r;
}


/**
 *  Determine if the current instance correspond to a given externalReference
 *
 *  @param externalReference the external reference
 *
 *  @return YES it the registry and ID maps
 */
-(BOOL)isEqualToExternalReference:(WattExternalReference*)externalReference{
    return ([externalReference.registryUidString isEqual:self.registry.uidString] &&
            externalReference.uinstID==self->_uinstID);
}

@end
