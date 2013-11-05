//
//  WattPool.m
//  Watt
//
//  Created by Benoit Pereira da Silva on 04/11/2013.
//  Copyright (c) 2013 Pereira da Silva. All rights reserved.
//

#import "WattRegistryPool.h"
#import "watt.h"

static NSString*trashFolderName=@"trash";


@interface WattRegistryPool(){
    
    // The root object of the fileMapRegistry
    WattRegistryFileMap* _fileMap;
    
    // The registry that contains the pool
    WattRegistry*_fileMapRegistry;
    
    // The registry that contains the pool
    NSString*_fileMapRegistryFilePath;
    
    // The registry cache ( references the registry in memory)
    NSMutableDictionary*_registries;
    
    // The pool folder relative path
    NSString* _poolFolderRelativePath;
    
    // The pool folder absolute path
    NSString*_poolFolderAbsolutePath;
}
@end

@implementation WattRegistryPool

@synthesize utils = _utils;

#pragma mark - Initializer

/**
 *  If the path does not exists it is created.
 *
 *  @param path the path of the file to store the RegistriesFileMap
 *
 *  @return a pool of registry
 */
-(instancetype)initFromRegistryFileMapRelativePath:(NSString*)path
                                      andSecretKey:(NSString*)secret{
    self=[super init];
    if(self){
        _utils=[[WattRegistryFilesUtils alloc] init];
        
        _fileMapRegistryFilePath=[[_utils applicationDocumentsDirectory] stringByAppendingString:path];
        _poolFolderRelativePath=[path stringByDeletingLastPathComponent];
        _poolFolderAbsolutePath=[[_utils applicationDocumentsDirectory]stringByAppendingString:_poolFolderRelativePath];
        _registries=[NSMutableDictionary dictionary];
        if([_utils.fileManager fileExistsAtPath:_poolFolderAbsolutePath isDirectory:NO]){
            _fileMapRegistry=[_utils readRegistryFromFile:_fileMapRegistryFilePath];
            _fileMap=[_fileMapRegistry objectWithUinstID:kWattRegistryRootUinstID];
        }
        //Createn the trash folder if necessary
        [_utils createRecursivelyRequiredFolderForPath:[self _trashFolderPath]];
    }
    return self;
}


- (void)_saveFileMap{
    [_utils writeRegistry:_fileMapRegistry toFile:_fileMapRegistryFilePath];
}


#pragma mark - Registries management

/**
 *  Adds the registry to the pool
 *
 *  @param registry the instance
 *
 *  @return YES if there was no instance.
 */
- (BOOL)addRegistry:(WattRegistry*)registry{
    if(![_registries objectForKey:registry.uidString]){
        registry.pool=self;
        [_registries setObject:registry forKey:registry.uidString];
        [self _saveFileMap];
        return YES;
    }
    return NO;
}

/**
 *  Removes the registry and its dependencies
 *
 *  @param registry the instance
 *
 *  @return YES if there was an instance.
 */
- (BOOL)removeRegistry:(WattRegistry*)registry{
    if([_registries objectForKey:registry.uidString]){
        [_registries removeObjectForKey:registry.uidString];
        [self trashItemFromPath:[_utils absolutePathForRegistryBundleFolderWithName:registry.uidString]];
        [self _saveFileMap];
        return YES;
    }
    return NO;
}


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
- (WattRegistry*)registryWithUidString:(NSString*)registryUidString{
    if(!registryUidString)
        registryUidString=[self.utils uuidString];
    WattRegistry*registry=[_registries objectForKey:registryUidString];
    if(registry)
        return registry;// We return if the registry is alaready added.
    
    NSString*p=[self.utils absolutePathForRegistryFileWithName:registryUidString];
    registry=[self.utils readRegistryFromFile:p];
    registry.uidString=registryUidString;// The identifier is not serialized
    
    if(!registry){
        // We create a registry with the default serialization mode
        registry=[WattRegistry registryWithSerializationMode:WattJx
                                      uniqueStringIdentifier:registryUidString
                                                      inPool:self];
    }
    //The registry has been loaded or created
    //We add it to the pool
    [self addRegistry:registry];
    return registry;
}


/**
 *  Saves all the registries
 */
- (void)saveRegistries{
    for (WattRegistry*registry in _registries) {
        [registry save];
    }
}


/**
 *  Saves all the registries with hasChanged flag set to YES
 */
- (void)saveRegistriesIfNecessary{
    for (WattRegistry*registry in _registries) {
        [registry saveIfNecessary];
    }
}


#pragma mark - Object grabber.

/**
 *  Returns the object by its WattExternalReference
 *
 *  @param WattExternalReference the object external reference of a watt object into another registry
 *
 *  @return the object or nil
 */
- (WattModel*)objectByWattReference:(WattExternalReference*)externalReference{
    WattRegistry*registry=[self registryWithUidString:externalReference.registryUidString];
    return [registry objectWithUinstID:externalReference.uinstID];
}


/**
 *  Returns the object by its registryUidString and objectUinstID
 *
 *  @param wattReference the object external reference of a watt object into another registry
 *
 *  @return the object or nil
 */
- (WattModel*)objectByRegistryID:(NSString*)registryUidString andObjectUinstID:(NSInteger)objectUinstID{
    WattRegistry*registry=[self registryWithUidString:registryUidString];
    return [registry objectWithUinstID:objectUinstID];
}

#pragma mark - files

- (NSString*)poolFolderRelativePath{
    return _poolFolderRelativePath;
    
}

#pragma mark - Trash

- (BOOL)trashItemFromPath:(NSString*)path{
    NSError*error=nil;
    [_utils.fileManager moveItemAtPath:path
                                toPath:[self _trashFolderPath] error:&error];
    if (error) {
        return NO;
    }
    return YES;
}


/**
 *  Definitively suppress the folder and file cntent
 */
- (void)emptyTheTrash{
    [_utils removeItemAtPath:[self _trashFolderPath]];
    // We recreate the trash
    [_utils createRecursivelyRequiredFolderForPath:[self _trashFolderPath]];
}

- (NSString*)_trashFolderPath{
    return[_poolFolderAbsolutePath stringByAppendingFormat:@"%@",trashFolderName];
}


#pragma mark - Memory optimization


//- (BOOL)unloadRegistryWithRegistryID:(NSString*)registryUidString;

//- (BOOl)unloadRegistries;



@end
