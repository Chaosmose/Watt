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
//
//  WattRegistry.h
//  PlayerSample
//
//  Created by Benoit Pereira da Silva on 22/05/13.
//  Copyright (c) 2013 Pereira da Silva. All rights reserved.
//

#import <Foundation/Foundation.h>


#define kWattRegistryRootUinstID 1

@class WattObject;
@class WattCollectionOfObject;

@interface WattRegistry : NSObject

// The registry name is used for external purpose
// eg : defining a file path to store serialized registry and associated bundle
// Notice that the mane is never serialized.
@property (nonatomic,copy)NSString* name;


// WattDelta

@property (nonatomic,strong)NSDate *creationDate;
@property (nonatomic,strong)NSDate *lastSerializationDate;
@property (nonatomic,strong)NSString *uniqueIdentifier;
@property (nonatomic,strong)NSMutableArray *deltas;


#pragma mark - auto saving 

/**
 *  The reference to the hosting api
 */
@property (nonatomic) id apiReference;

/**
 *  Autosave
 */
@property (nonatomic,assign)BOOL autosave;

/**
 *  You can reference the serializationPath
 */
@property (nonatomic,copy) NSString *serializationPath;

/**
 * Automatically turns the hasChanged property of any holding wattObject if set to NO
 * Aggregates all the wattObject hasChanged property on getter.
 */
@property (nonatomic) BOOL hasChanged;

#pragma mark - Serialization/Deserialization facilities

// If you want serialize / deserialize a registry
// Including fully decoupled object.
+ (WattRegistry*)instanceFromArray:(NSArray*)array resolveAliases:(BOOL)resolveAliases;
- (NSArray*)arrayRepresentation;

// If you want just sub graphs
// resetHistory is done once per "session" to invalidate the serialization history
// the serialization history prevents from circular referencing;
- (NSDictionary*)dictionaryWithAliasesFrom:(WattObject*)object
                             resetHistory:(BOOL)resetHistory;

- (WattObject*)instanceFromDictionary:(NSDictionary*)dictionary;

#pragma mark - runtime object graph register

- (id)objectWithUinstID:(NSInteger)uinstID;
- (void)registerObject:(WattObject*)reference;       // Generates a unique id + add the reference to the registry
- (void)unRegisterObject:(WattObject*)reference;

// The id must be already set and not conflicting with existing uinstID
- (void)addObject:(WattObject *)reference;


- (id)objectsWithClass:(Class)theClass andPrefix:(NSString*)prefix returningRegistry:(WattRegistry*)registry;

- (void)enumerateObjectsUsingBlock:(void (^)(WattObject *obj, NSUInteger idx, BOOL *stop))block;

@end