//
//  WattObjectProtocols.h
//  PlayerSample
//
//  Created by Benoit Pereira da Silva on 03/11/2013.
//  Copyright (c) 2013 Pereira da Silva. All rights reserved.
//

@class WattRegistry;

#pragma mark - WattCoding

@protocol WattCoding <NSObject>
@required
- (NSDictionary *)dictionaryRepresentationWithChildren:(BOOL)includeChildren;
- (NSMutableDictionary*)dictionaryOfPropertiesWithChildren:(BOOL)includeChildren;
@end