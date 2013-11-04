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

@class WattRegistry,WattObject,WattReference,WattRegistryFileMap,WattRegistryFilesUtils;

/*

 Definitions : 
 --------------
 
 -A pool            : groups an ensemble of registries and associated files
 -A registry        : manages a graph of watt objects and collections (it is an object graph DB)
 -A WattReference   : identifies an object by its registry identity and unique instance identifier (UinstID)
 
 File tree : 
 -----------

    ->PoolFolder/                               <- the root pool folder (its path is defined by initializationpath)
        <mapfileName>.<ext>                     <- the serialized registry file map (in a registry without pool)
        -> <registryUidString>/                 <- the watt bundle folder for a given registry and dependencies
                <base>/                         <- base localization folder
                    registry.<ext>              <- the serialized registry (object DB)
                    <bundled folders and file>  <- the bundled files and folders
                <_locale_>/
 
                <delta-DB> <- future extension for delta synchronisation
        
        <trash/>    <- trash area for registry-bundle
 
    ->Import/       <- conventionnaly we copy the files to import (dowloads in progress..., etc)
    ->Export/       <- conventionnaly we copy the exported files
   
    Note : <ext> depends on serialization + soup mode
 
 
  Discussion :  
 -------------
 
  An app generally use one WattRegistryPool (but can use more if necessary)
  For better performance you should use multiple registries
 
 Samples : 
 -------------
 
 The easyest method to create a new registry in the pool :
 WattRegistry*registry=[self registryWithUidString:nil];

 
 
 */

@interface WattRegistryPool : NSObject

/**
 * The utils to be used by the registries
 */
@property (nonatomic,readonly)  WattRegistryFilesUtils *utils;

#pragma mark - Initializer

/**
 *  If the path does not exists it is created.
 *
 *  @param path the path of the file to store the RegistriesFileMap
 *
 *  @return a pool of registry
 */
-(instancetype)initFromRegistryFileMapRelativePath:(NSString*)path
                                      andSecretKey:(NSString*)secret;



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


// POST CREATION

/**
 *  Adds the registry to the pool
 *
 *  @param registry the instance
 *
 *  @return YES if there was no instance.
 */
- (BOOL)addRegistry:(WattRegistry*)registry;


/**
 *  Moves the registry and its dependencies to the trash
 *
 *  @param registry the instance
 *
 *  @return YES if there was an instance.
 */
- (BOOL)removeRegistry:(WattRegistry*)registry;



/**
 *  Saves all the registries
 */
- (void)saveRegistries;

/**
 *  Saves all the registries with hasChanged flag set to YES
 */
- (void)saveRegistriesIfNecessary;


#pragma mark - Object grabber.

/**
 *  Returns the object by its wattReference
 *
 *  @param wattReference the object external reference of a watt object into another registry
 *
 *  @return the object or nil
 */
- (WattObject*)objectByWattReference:(WattReference*)wattReference;


/**
 *  Returns the object by its registryUidString and objectUinstID
 *
 *  @param wattReference the object external reference of a watt object into another registry
 *
 *  @return the object or nil
 */
- (WattObject*)objectByRegistryID:(NSString*)registryUidString andObjectUinstID:(NSInteger)objectUinstID;


#pragma mark - files 

/**
 *  The pool relative path
 *
 *  @return the path
 */
- (NSString*)poolFolderRelativePath;


#pragma mark - Trash
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



#pragma mark - Memory optimization


//- (BOOL)unloadRegistryWithRegistryID:(NSString*)registryUidString;

//- (BOOl)unloadRegistries;

@end