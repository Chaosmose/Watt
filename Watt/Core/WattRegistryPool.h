//
//  WattPool.h
//  Watt
//
//  Created by Benoit Pereira da Silva on 04/11/2013.
//  Copyright (c) 2013 Pereira da Silva. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WattDefinitions.h"

static NSString*mapFileDefaultName=@"map";

@class WattRegistry,WattModel,WattExternalReference,WattRegistryFileMap,WattRegistryFilesUtils;

/*
 
 Notes :
 --------------
 
 
 
 -A WattRegistryPool        : coordinates and insure the persistency of an ensemble of registries and associated files
 -A WattRegistry            : manages a graph of WattObjects and collections (it is an object graph DB)
 -A WattExternalReference   : identifies a WattObject by its registry identity and unique instance identifier (UinstID)
 
 NEED TO EXPLAIN :
 *WAttObject Aliasing (linear serialization)
 *WattExternalReference (referencing loading on demand)
 *Cross registry aggregation issues
 
 
 File tree :
 -----------
 
 ->PoolFolder/                   <- the root pool folder (its path is defined by initializationpath)
 -> <registryUidString>/         <- the watt bundle folder for a given registry and dependencies
 registry.<ext>                  <- the serialized registry (object DB)
 <bundled folders and file>      <- the bundled files and folders
 <delta-DB>                      <- future extension for delta synchronisation
 <trash/>                            <- trash area for registry-bundle
 
 ->Import/                              <- conventionnaly we copy the files to import (dowloads in progress..., etc)
 ->Export/                              <- conventionnaly we copy the exported files
 
 Note : <ext> depends on serialization + soup mode
 
 
 Discussion :
 -------------
 
 An app generally use one WattRegistryPool (but can use more if necessary)
 For better performance you should use multiple registries
 
 IMPORTANT IDEA :
 -----------------
 
 Data/Assets Mobility
 Serialized registries are very easy to move.
 You only need to move the files to the pool folder and load using the id and the secret if the content is protected.
 
 
 Samples :
 -------------
 
 The easyest method to create a new registry in the pool :
 WattRegistry*registry=[<pool> registryWithUidString:nil];
 
 
 */


@interface WattRegistryPool : NSObject


/**
 *  An atomic instance of a NSFileManager
 */
@property (atomic,readonly) NSFileManager *fileManager;

// The files with those extensions can be mixed in the soup (mixing is a sort of encryption)
// You can add any binary format by adding its extension to mixableExtensions
@property (nonatomic,strong)    NSMutableArray *mixableExtensions;

// You can add paths that you want to be mixed (for DRM purposes)
@property (nonatomic,strong)    NSMutableArray *forcedSoupPaths;

/**
 * the serialization mode
 */
@property (nonatomic,readonly)WattSerializationMode serializationMode;



#pragma mark - KVC Advanced configuration

/**
 *  During developpment to check cross registry aggregation.
 *  A registry aggregation is a semantic fault any cross registry referencing should be handled using an WattExternalReference
 *  If you raise "RegistryAggregation" exception you should use a WattExternalReference
 */
@property (nonatomic) BOOL controlKVCRegistriesAtRuntime;   // Default is NO production code should normaly use YES.

/**
 *  If you want to allow unstrict KVC
 *  In such a case the undefined key (due to versionning for example can be ignored)
 */
@property (nonatomic) BOOL faultTolerenceOnMissingKVCkeys;  // Default is YES;



#pragma mark - Initializer


/**
 *  If the pool does not exists it is created.
 *
 *  @param path   the pool relative path
 *  @param mode   the serialization mode
 *  @param secret the secret key used when mixing the soup
 *
 *  @return the pool of registries
 */
-(instancetype)initWithRelativePath:(NSString*)path
                  serializationMode:(WattSerializationMode)mode
                       andSecretKey:(NSString*)secret;


#pragma mark - converter


#warning todo
//- (void)convertToSerializationMode:(WattSerializationMode)mode;


#pragma mark - Registries management


/**
 *  Use this method to create, acces or load a registry
 *
 *  Returns a registry identified by its registryUidString
 *  If the registry does not exist it is created with default serialization mode
 *
 *  @param registryUidString the identifier if nil the uidString is created
 *
 *  @return the registry or nil
 */
- (WattRegistry*)registryWithUidString:(NSString*)registryUidString;



/**
 *  The registry is removed from the pool but not clean up in memory.
 *  This method is used to move a registry from a pool to another.
 *
 *  @param registry the registry to deReference
 *
 *  @return YES if the registry was referenced
 */
- (BOOL)detachRegistry:(WattRegistry*)registry;


/**
 *  Unloads the registry with a given id (and cleanup the memory)
 *  The file remain intact (but the state is not saved before unloading)
 *
 *  @param registryUidString the identifier
 *
 *  @return YES if there was a registry with this identifier
 */
- (BOOL)unloadRegistryWithRegistryID:(NSString*)registryUidString;


/**
 *  Unloads all the registries
 *
 *  @return YES if it is a success.
 */
- (BOOL)unloadRegistries;


/**
 *  Moves the registry and its dependencies to the trash
 *
 *  @param registry the instance
 *
 *  @return YES if there was an instance.
 */
- (BOOL)trashRegistry:(WattRegistry*)registry;


/**
 *  Saves the registry
 *
 *  @param registry the registry to be saved
 */
- (void)saveRegistry:(WattRegistry*)registry;


/**
 *  Saves all the registries
 */
- (void)saveRegistries;

/**
 *  Saves all the registries with hasChanged flag set to YES
 */
- (void)saveRegistriesIfNecessary;


/**
 *  Returns the list of the registry's identifiers
 *
 *  @return the list of string
 */
- (NSArray*)registriesUidStringList;



#pragma mark - Object grabber.

/**
 *  Returns the object by its WattExternalReference
 *
 *  @param WattExternalReference the object external reference of a watt object into another registry
 *
 *  @return the object or nil
 */
- (id)objectByWattReference:(WattExternalReference*)externalReference;


/**
 *  Returns the object by its registryUidString and objectUinstID
 *
 *  @param wattReference the object external reference of a watt object into another registry
 *
 *  @return the object or nil
 */
- (id)objectByRegistryID:(NSString*)registryUidString andObjectUinstID:(NSInteger)objectUinstID;


#pragma mark - file paths

/**
 *  The current applicationDocumentDirectory
 *
 *  @return The path of the directory
 */
- (NSString*)applicationDocumentsDirectory;

/**
 *  The absolute path of the pool folder
 *
 *  @return the path
 */
- (NSString*)poolFolderAbsolutePath;


/**
 *  Returns the absolute path of the registry serialization file
 *
 *  @param name the registry name
 *
 *  @return the absolute path of the registry serialization file
 */
- (NSString*)absolutePathForRegistryFileWithName:(NSString*)name;


/**
 *  Returns the absolute path of the registry bundle folder
 *
 *  @param name the registry name
 *
 *  @return the absolute path of the registry bundle folder
 */
- (NSString*)absolutePathForRegistryBundleFolderWithName:(NSString*)name;


/**
 *  Returns an existing absolute paths from a relative path
 *
 *  @param relativePath    the relative path
 *  @param wattBundleName  the watt bundle name
 *
 *  @return the absolute path of existing file path and nil if the file does not exists.
 */
- (NSString*)absolutePathFromRelativePath:(NSString *)relativePath
                         inBundleWithName:(NSString*)wattBundleName;


/**
 *  Returns an array of existing absolute paths from the relative path
 *
 *  @param relativePath   the relative path
 *  @param wattBundleName the watt bundle name
 *  @param returnAll      if YES returns all else only the first.
 *
 *  @return an Array of absolute existing file paths (excludes unexisting path)
 */
- (NSArray*)absolutePathsFromRelativePath:(NSString *)relativePath
                         inBundleWithName:(NSString*)wattBundleName
                                      all:(BOOL)returnAll;


#pragma mark - Trash file management


/**
 *  Moves the items to the trash
 *
 *  @param path the source path
 *
 *  @return YES if no error occured
 */
- (BOOL)trashItemFromPath:(NSString*)path;

/**
 *  Definitively suppress the folder and file cntent
 */
- (void)emptyTheTrash;


#pragma mark - file destruction

/**
 *  Use with caution
 *  Deletes all the data and files
 */
- (void)deletePoolFiles;


#pragma mark - file I/O


/**
 *  Write the data mixing if necessary
 *
 *  @param data The nsdata to write to the path
 *  @param path the destination path
 *
 *  @return the success of the file operation
 */
- (BOOL)writeData:(NSData*)data toPath:(NSString*)path;

/**
 *  Reads the data and mix if necessary (mixing is reversible)
 *
 *  @param path the path
 *
 *  @return the Data
 */
- (NSData*)readDataFromPath:(NSString*)path;

/**
 *  Write the data mixing if necessary
 *
 *  @param data The nsdata to write to the path
 *  @param path the destination path
 *
 *  @return the success of the file operation
 */
- (BOOL)writeData:(NSData*)data toPath:(NSString*)path withForcedSerializationMode:(WattSerializationMode)mode;

/**
 *  Reads the data and mix if necessary
 *
 *  @param path the path
 *  @param mode
 *
 *  @return the Data
 */
- (NSData*)readDataFromPath:(NSString*)path withForcedSerializationMode:(WattSerializationMode)mode;



/**
 *  Creates all the intermediary folders for a given a path
 *
 *  @param path the path
 *
 *  @return the success of the operation
 */
- (BOOL)createRecursivelyRequiredFolderForPath:(NSString*)path;


/**
 *  Removes the item (folder or file) with recursive deletion
 *
 *  @param path the path to delete
 *
 *  @return the success of the operation
 */
- (BOOL)removeItemAtPath:(NSString*)path;


/**
 *  Returns the number of registries in the pool
 *
 *  @return the count
 */
- (NSUInteger)registryCount;

@end