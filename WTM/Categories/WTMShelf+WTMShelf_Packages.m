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
 *  @param serializationMode    the Watt_F_TYPE
 *  @return                     The package in a separate registry.
 */
- (WTMPackage*)packageWithObjectName:(NSString*)name using:(Watt_F_TYPE)serializationMode{
    if(!self.packagesList){
        return nil;
    }
    NSString *__weak search=name;
    WTMPackage *__block packageReference=nil;
    [[self _packages_auto] enumerateObjectsUsingBlock:^(WTMPackage *obj, NSUInteger idx, BOOL *stop) {
        if([obj.objectName isEqualToString:search]){
            packageReference=obj;
            *stop=YES;
        }

    } reverse:NO];
    
    if(!packageReference){
        // We should try to deserialize.
        WattUtils *utils=[[WattUtils alloc] init];
        [utils use:serializationMode];
        NSString*path=[utils absolutePathForRegistryBundleFolderWithName:name];
        WattRegistry*r=[utils readRegistryFromFile:path];
        if(r){
            packageReference=[r objectWithUinstID:kWattRegistryRootUinstID];
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
    [[self _packages_auto] addObject:package];
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

- (WTMCollectionOfPackage*)_packages_auto{
	if(![self _packages]){
        WattRegistry *r=[[WattRegistry alloc] init];
        WTMCollectionOfPackage*p=[[WTMCollectionOfPackage alloc] initInRegistry:r];
        [self _setPackages:p];
    }
    return [self _packages];
}


- (NSString*)_uuidString {
    WattUtils *utils=[[WattUtils alloc] init];
    return [utils uuidString];
}

#pragma  mark - Associative references


- (WTMCollectionOfPackage*)_packages {
    return (WTMCollectionOfPackage*)objc_getAssociatedObject(self, PackagesKey);
}

- (void)_setPackages:(WTMCollectionOfPackage*)newPackages{
    objc_setAssociatedObject(self, PackagesKey, newPackages, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (void) dealloc{
    [self _setPackages:nil];
}

@end
