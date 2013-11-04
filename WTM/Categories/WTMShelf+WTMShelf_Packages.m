//
//  WTMShelf+WTMShelf_Packages.m
//  PlayerSample
//
//  Created by Benoit Pereira da Silva on 02/11/2013.
//  Copyright (c) 2013 Pereira da Silva. All rights reserved.
//

#import "WTMShelf+WTMShelf_Packages.h"
#import <objc/runtime.h>


/**
 *  The key to store the Associative reference of WTMCollectionOfPackage
 */
static char const * const PackagesKey = "PackagesKey";


@implementation WTMShelf (WTMShelf_Packages)


/**
 *  Use this method to load one package.
 *  Its reference will be stored in a memory cache
 *
 *  @param name                 the name of the package to load.
 *  @param serializationMode    the WattSerializationMode
 *  @return                     The package in a separate registry.s */
- (WTMPackage*)packageWithObjectName:(NSString*)name using:(WattSerializationMode)serializationMode{
    if(!self.packagesList){
        return nil;
    }
    WTMPackage * packageReference=[[self _packages_auto] objectForKey:name];
    if(!packageReference){
        // We should try to deserialize.
        WattUtils *utils=[[WattUtils alloc] init];
        [utils use:serializationMode];
        NSString*path=[utils absolutePathForRegistryBundleFolderWithName:name];
        WattRegistry*r=[utils readRegistryFromFile:path];
        if(r){
            packageReference=[r objectWithUinstID:kWattRegistryRootUinstID];
            [[self _packages_auto] setObject:packageReference forKey:packageReference.name];
        }
    }
    return packageReference;
}


/**
 *  Add a package to the shelf.
 *
 *  @param package the package to add.
 */
- (void)addPackage:(WTMPackage*)package{
    if(package.uinstID!=kWattRegistryRootUinstID){
         WattUtils *utils=[[WattUtils alloc] init];
        [utils raiseExceptionWithFormat:@"WTMPackage should be the kWattRegistryRootUinstID in its registry, use the WTM creation api."];
    }
    if(!self.packagesList){
        self.packagesList=[NSMutableArray array];
    }
    if(!package.objectName){
        package.objectName=[self _uuidString];
    }
    // We add the package name to the shelf packagesList
    [self.packagesList addObject:package.objectName];
    [self.registry setHasChanged:YES];
    
    // We reference the package.
    [[self _packages_auto] setObject:package forKey:package.name];
}


/**
 *  Removes the package and delete the files.
 *
 *  @param package     the package reference
 *  @param deleteFiles if YES the files should be deleted.
 */
- (void)removePackage:(WTMPackage*)package deleteFiles:(BOOL)deleteFiles{
    [self.packagesList removeObjectIdenticalTo:package.registry.name];
    if(deleteFiles){
        WattUtils *utils=[[WattUtils alloc] init];
        NSString*p=[utils absolutePathForRegistryBundleFolderWithName:package.registry.name];
        [utils removeItemAtPath:p];
    }
}

#pragma  mark - Private

- (NSMutableDictionary*)_packages_auto{
	if(![self _packages]){
        [self _setPackages:[NSMutableDictionary dictionary]];
    }
    return [self _packages];
}


- (NSString*)_uuidString {
    WattUtils *utils=[[WattUtils alloc] init];
    return [utils uuidString];
}

#pragma  mark - Associative references


- (NSMutableDictionary*)_packages {
    return (NSMutableDictionary*)objc_getAssociatedObject(self, PackagesKey);
}

- (void)_setPackages:(NSMutableDictionary*)newPackages{
    objc_setAssociatedObject(self, PackagesKey, newPackages, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (void) dealloc{
    [self _setPackages:nil];
}

@end
