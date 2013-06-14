// This file is part of "Watt"
//
// "Watt" is free software: you can redistribute it and/or modify
// it under the terms of the GNU LESSER GENERAL PUBLIC LICENSE as published by
// the Free Software Foundation, either version 3 of the License, or
// (at your option) any later version.
//
// "Watt" is distributed in the hope that it will be useful,
// but WITHOUT ANY WARRANTY; without even the implied warranty of
// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
// GNU LESSER GENERAL PUBLIC LICENSE for more details.
//
// You should have received a copy of the GNU LESSER GENERAL PUBLIC LICENSE
// along with "Watt"  If not, see <http://www.gnu.org/licenses/>
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

@class WattRegistry;

@interface WattObjectAlias : NSObject<WattAliasing>{
}

// Returns an alias dictionary representation from a wattObject instance.
// Used by registry serialization process.
+ (NSDictionary*)aliasDictionaryRepresentationFrom:(WattObject*)object;

// Returns an alias to hold the place of an wattObject instance
+ (WattObjectAlias*)aliasFrom:(WattObject*)object;

// can return a WattObjectAlias instance
// or an WattCollectionOfObject with aliases 
+ (id)aliasOrCollectionOfAliasFromDictionary:(NSDictionary *)aDictionary inRegistry:(WattRegistry*)registry;

// The reference id
- (NSInteger)uinstID;


@end
