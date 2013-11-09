//
//  WattObject+ExternalReference.h
//  PlayerSample
//
//  Created by Benoit Pereira da Silva on 09/11/2013.
//  Copyright (c) 2013 Pereira da Silva. All rights reserved.
//

#import "WattObject.h"

@interface WattObject (ExternalReference)

/**
 *  Returns the external reference from the instance
 *
 *  @return the reference.
 */
- (WattExternalReference*)externalReference;


/**
 *  Determine if the current instance correspond to a given externalReference
 *
 *  @param externalReference the external reference
 *
 *  @return YES it the registry and ID maps
 */
-(BOOL)isEqualToExternalReference:(WattExternalReference*)externalReference;

@end
