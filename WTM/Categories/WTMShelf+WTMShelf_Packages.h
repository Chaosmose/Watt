//
//  WTMShelf+WTMShelf_Packages.h
//  PlayerSample
//
//  Created by Benoit Pereira da Silva on 02/11/2013.
//  Copyright (c) 2013 Pereira da Silva. All rights reserved.
//

#import "Watt.h"
#import "WTMShelf.h"
#import "WTMPackage.h"
#import "WTMCollectionOfPackage.h"

@interface WTMShelf (WTMShelf_Packages)


// EACH PACKAGE HAS ITS OWN REGISTRY
// And can be serialized with is own serialization mode

/**
 *  Use this method to load one package.
 *  Its reference will be stored in a memory cache
 *
 *  @param name                 the name of the package to load.
 *  @param serializationMode    the WattSerializationMode
 *  @return                     The package in a separate registry.
 */
- (WTMPackage*)packageWithObjectName:(NSString*)name using:(WattSerializationMode)serializationMode;

/**
 *  Add a package to the shelf.
 *  The package should have be the kWattRegistryRootUinstID in its registry
 *
 *  @param package the package to add.
 */
- (void)addPackage:(WTMPackage*)package;

/**
 *  Removes the package and delete the files.
 *
 *  @param package     the package reference
 *  @param deleteFiles if YES the files should be deleted.
 */
- (void)removePackage:(WTMPackage*)package deleteFiles:(BOOL)deleteFiles;


@end