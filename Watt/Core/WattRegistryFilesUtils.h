//
//  WattFileUtilities.h
//  Watt
//
//  Created by Benoit Pereira da Silva on 02/11/2013.
//  Copyright (c) 2013 Pereira da Silva. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WattDefinitions.h"

@class WattRegistry;

@interface WattRegistryFilesUtils : NSObject

/**
 *  An atomic instance of a NSFileManager
 */
@property (atomic,strong) NSFileManager *fileManager;

// The files with those extensions can be mixed in the soup (mixing is a sort of encryption)
// You can add any binary format by adding its extension to mixableExtensions
@property (nonatomic,strong)    NSMutableArray *mixableExtensions;

// You can add paths that you want to be mixed (for DRM purposes)
@property (nonatomic,strong)    NSMutableArray *forcedSoupPaths;

@property (nonatomic,copy) NSString*relativeFolderPath;

/**
 *  Initialize the utils with a secret soup key
 *
 *  @param secretKey the secret key
 *  @param relativeFolderPath the relative pool folder path
 *  @return the utils instance
 */
- (instancetype)initWithSecretKey:(NSString*)secretKey
            andRelativeFolderPath:(NSString*)relativeFolderPath;

/**
 *  Returns the wattSerializationMode by parsing the path suffix
 *
 *  @param path the path
 *
 *  @return the serialization mode
 */
- (WattSerializationMode)serializationModeFromPath:(NSString*)path;



#pragma mark - relative path and path discovery


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


#pragma  mark - file paths

/**
 *  The current applicationDocumentDirectory
 *
 *  @return The path of the directory
 */
- (NSString*)applicationDocumentsDirectory;

/**
 *  Returns the absolute path of the registry serialization file
 *
 *  @param name the registry name
 *
 *  @return the absolute path of the registry serialization file
 */
- (NSString*)absolutePathForRegistryFileWithName:(NSString*)name;

//

/**
 *  Returns the absolute path of the registry bundle folder
 *
 *  @param name the registry name
 *
 *  @return the absolute path of the registry bundle folder
 */
- (NSString*)absolutePathForRegistryBundleFolderWithName:(NSString*)name;



#pragma mark - files I/O


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

#pragma mark - File serialization / deserialization

/**
 * Serializes the registry to a file only if registry.hasChanged==YES
 *
 *  @param registry the registry to be serialized
 *  @param path     the path
 *
 *  @return the success of the operation
 */
-(BOOL)writeRegistryIfNecessary:(WattRegistry*)registry toFile:(NSString*)path;

/**
 *  Serializes the registry to a file
 *
 *  @param registry the registry to be serialized
 *  @param path     the path
 *
 *  @return the success of the operation
 */
-(BOOL)writeRegistry:(WattRegistry*)registry toFile:(NSString*)path;

/**
 *  Deserializes a registry from a file.
 *
 *  @param path the path
 *
 *  @return the registry
 */
-(WattRegistry*)readRegistryFromFile:(NSString*)path;


@end
