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
#import "WattDefinitions.h"
#import "WattRegistryPool.h"

#define kWattRegistryRootUinstID 1

@class WattObject;
@class WattCollectionOfObject;
@class WattRegistryFilesUtils;
@class WattRegistryPool;

@interface WattRegistry : NSObject

/**
 *  The holding pool
 *  Excepted the WattRegistryPool's registry all the registries refers to a pool!
 */
@property (nonatomic,weak)WattRegistryPool*pool;

/**
 * The registry uidString is used for external purpose
 * eg : defining a file path to store serialized registry and associated bundle
 * Notice that the mane is not serialized within the registry but by its RegistryPool
 */
@property (nonatomic,copy)NSString* uidString;

/**
 *  The registry serializationMode
 */
@property (nonatomic,assign) WattSerializationMode serializationMode;


#pragma mark - Save

/**
 *  Autosave :
 *
 *  I# You can use @selector(executeAndAutoSaveBlock:) if you perform a suite of actions and want to save them immediatly
 *
 *  II# You can manually use the autosave to reduce the I/O
 *
 *  1- set registry.autosave=NO;
 *  2- update the models , deletes, modify, create , ...
 *  3- set registry.hasChanged when you perform a discrete changes that need to saved (the api, the collection automatically set)
 *  4- set registry.autosave=YES (this will save only if on of the object has changed)
 */
@property (nonatomic,assign)BOOL autosave;

/**
 * A flag used by the autosave process.
 */
@property (nonatomic) BOOL hasChanged;

#pragma mark - constructors

/**
 * The factory constructor
 *
 *  @param serializationMode The format (json,plist, ...) +  soup or not
 *  @param name               The name of the registry
 *  @param pool              The pool container
 *
 *  @return The new created instance
 */
+(instancetype)registryWithSerializationMode:(WattSerializationMode)serializationMode
                      uniqueStringIdentifier:(NSString*)identifier
                                      inPool:(WattRegistryPool*)pool;


/**
 * The constructor (you should not use the simple init)
 *
 *  @param serializationMode The format (json,plist, ...) +  soup or not
 *  @param name              The name of the registry
 *  @param pool              The pool container
 *  @return The new created instance
 */
-(instancetype)initRegistryWithSerializationMode:(WattSerializationMode)serializationMode
                          uniqueStringIdentifier:(NSString*)identifier
                                          inPool:(WattRegistryPool*)pool;

#pragma mark - save

/**
 *  Execute a bunch of modification in the block and save if necessary
 *
 *  @param block of modification of object in the registry.
 */
- (void)executeBlockAndSaveIfNecessary:(void (^)())block;

/**
 *  Saves if hasChanged==YES;
 */
- (void)saveIfNecessary;

/**
 *  Saves
 */
- (void)save;



#pragma mark - Serialization/Deserialization facilities

/**
 *  The serialization path
 *
 *  @return the path
 */
- (NSString*)serializationPath;


/**
 * A facility constructor for a registry fron an array instance
 *
 *  @param array             the array flat representation
 *  @param serializationMode the mode
 *  @param identifier        the registry unique string identifier
 *  @param pool              the pool
 *  @param resolveAliases    resolveAliases directly (can be defered to runtine for lazy resolution)
 *
 *  @return the registry
 */
+ (WattRegistry*)instanceFromArray:(NSArray*)array
             withSerializationMode:(WattSerializationMode)serializationMode
            uniqueStringIdentifier:(NSString*)identifier
                            inPool:(WattRegistryPool*)pool
                    resolveAliases:(BOOL)resolveAliases;

- (NSArray*)arrayRepresentation;

- (WattObject*)instanceFromDictionary:(NSDictionary*)dictionary;


#pragma mark - runtime object graph register

- (id)objectWithUinstID:(NSInteger)uinstID;
- (void)registerObject:(WattObject*)reference;       // Generates a unique id + add the reference to the registry
- (void)unRegisterObject:(WattObject*)reference;

// The id must be already set and not conflicting with existing uinstID
- (void)addObject:(WattObject *)reference;


- (id)objectsWithClass:(Class)theClass andPrefix:(NSString*)prefix returningRegistry:(WattRegistry*)registry;

#pragma  mark - Enumeration

/**
 *  Enumerates the objects to perform block based action on the objects
 *
 *  @param block the block can be stopped by setting stop=YES;
 */
- (void)enumerateObjectsUsingBlock:(void (^)(WattObject *obj, NSUInteger idx, BOOL *stop))block;

/**
 *  Enumerates the objects to perform block based action on the objects
 *
 *  @param block                 the block can be stopped by setting stop=YES;
 *  @param useReverseEnumeration if YES the enumeration order is reversed ( usefull for deletion )
 */
- (void)enumerateObjectsUsingBlock:(void (^)(WattObject *obj, NSUInteger idx, BOOL *stop))block reverse:(BOOL)useReverseEnumeration;


#pragma mark - counters

/**
 *  Returns the number of live referenced objects.
 *
 *  @return the count
 */
- (NSUInteger)count;

/**
 *  Gives the next uisntID (used for merging for example)
 *
 *  @return return an uinstID > the last uinstID
 */
- (NSUInteger)nextUinstID;


#pragma mark - Merging

/**
 *  Merge the registryToAdd into the current registry
 *  During the merging the registry to be added will be destroyed.
 *
 *  @param registryToAdd the registry to add
 *
 *  @return a success flag
 */
- (BOOL)mergeWithRegistry:(WattRegistry*)registryToAdd;


#pragma mark - Destroy


/**
 *  Destroys the registry ( used in merging process for example)
 */
- (void)destroyRegistry;




@end