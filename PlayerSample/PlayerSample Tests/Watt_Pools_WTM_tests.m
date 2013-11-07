//
//  WTM_Shelf_tests.m
//  PlayerSample
//
//  Created by Benoit Pereira da Silva on 20/10/13.
//  Copyright (c) 2013 Pereira da Silva. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "WTM.h"


// We do use WTM shelf and packages
// to perform composed test the pools and registry features.
// So we _createAPopulatedPool and _deletePopulatedPool on setup and tear down

// Those tests are complex but neither systematic nore very rigourous
// I use them as "sums of controls"


@interface Watt_Pools_WTM_tests : XCTestCase{
    WattRegistryPool *_pool;
    WTMShelf *_shelf;
    WTMPackage *_package;
}

@end

@implementation Watt_Pools_WTM_tests

- (void)setUp{
    [super setUp];
    [self _createAPopulatedPoolWithMode:WattJ];
}

- (void)tearDown{
    [super tearDown];
    [self _deletePopulatedPool];
}


- (void)testRegistryArrayRepresentation{
    
    [_pool saveRegistries];
    
    // 1- We use WattRegistry (r1)
    WattRegistry*r1=_package.registry;
    
    //2- We serialize the registry R1 to a linear structure a1
    NSArray *a1=[r1 arrayRepresentation];
    
    //3- We generate a new Registry (r2) from a1 by deserializing
    WattRegistry *r2=[WattRegistry instanceFromArray:a1
                               withSerializationMode:WattJ
                              uniqueStringIdentifier:[_pool uuidStringCreate]
                                              inPool:_pool
                                      resolveAliases:YES];
    
    [self _compare:r1 with:r2];
}

#pragma mark - unload reload in any mode

- (void)testUnloadReloadARegistryInAPool_J{
    XCTAssertNoThrow([self __unloadReloadARegistryWithMode:WattJ], @"_unloadReloadARegistryWithMode:WattJ should not throw an exception");
}
- (void)testUnloadReloadARegistryInAPool_P{
      XCTAssertNoThrow([self __unloadReloadARegistryWithMode:WattP], @"_unloadReloadARegistryWithMode:WattP should not throw an exception");
}
- (void)testUnloadReloadARegistryInAPool_Jx{
      XCTAssertNoThrow([self __unloadReloadARegistryWithMode:WattJx], @"_unloadReloadARegistryWithMode:WattJx should not throw an exception");
}
- (void)testUnloadReloadARegistryInAPool_Px{
      XCTAssertNoThrow([self __unloadReloadARegistryWithMode:WattPx], @"_unloadReloadARegistryWithMode:WattPx should not throw an exception");
}


- (void)testUnloadReloadARegistriesByName{
    NSUInteger initialPoolCount=[_pool registryCount];
    NSArray*rl=[_pool registriesUidStringList];
    XCTAssertTrue([_pool registryCount]==[rl count], @"all the registries are loaded the registryCount should be equal to  registriesUidStringList count");
    
    for (NSString *s in rl) {
        WattRegistry*r=[_pool registryWithUidString:s];
        [r save];
    }
    [_pool unloadRegistries];
    XCTAssertTrue([_pool registryCount]==0, @"the pool in memory should be void after unloadRegistries");
    
    for (NSString *s in rl) {
        WattRegistry*reloaded=[_pool registryWithUidString:s];
        if ([reloaded count]>0) {
            [_pool registryWithUidString:s];
        }
    }
    
    XCTAssertTrue([_pool registryCount]==initialPoolCount, @"after reloading the pool count should be equal to the initialPoolCount");
    
}

 
#pragma mark - Merger

- (void)testMergeRegistries{
    
    WattRegistry*r1=_package.registry;
    WattRegistry*s1=_shelf.registry;
    
    NSUInteger r1Count=[r1 count];
    NSUInteger s1Count=[s1 count];
    
    
    [r1 mergeWithRegistry:_shelf.registry];
    
    [self _checkIntegrityOfPackageRegistry:r1];
    [self _checkIntegrityOfShelfRegistry:r1];
    XCTAssertTrue(r1Count+s1Count==[r1 count], @"The sum of counts should remain constant");
    XCTAssertTrue([_shelf.registry isEqual:r1], @"The shelf should have moved to the R1 registry");
    XCTAssertTrue([_package.registry isEqual:r1], @"The package should be in the R1 registry");
    

    
}

#pragma mark - WattCopy

- (void)testOneCopyInRegistry{
    XCTAssertNoThrow([self __oneCopyInRegistry], @"__oneCopyInRegistry should not throw an exception");
}

- (void)__oneCopyInRegistry{
    NSUInteger count=[_package.registry count];
    WattRegistry*r2=[_pool registryWithUidString:nil];
    WTMPackage*p2=[_package wattCopyInRegistry:r2];
    NSUInteger count2=[r2 count];
    
    [self _checkIntegrityOfPackageRegistry:r2];
    XCTAssertTrue(count==count2, @"The registries do not have the same count %i %i",count,count2);
    XCTAssertNotEqual(_package, p2, @"After the copy the instances should not be equal");
    XCTAssertNotNil(_package,  @"After the copy the _package should not be nil");
    XCTAssertNotNil(p2,  @"After the copy the p2 should not be nil");
}


- (void)testMultiCopyFromVariousRegistry{
    XCTAssertNoThrow([self __multiCopyFromVariousRegistry], @"__multiCopyFromVariousRegistry should not throw an exception");
}


- (void)__multiCopyFromVariousRegistry{
    // We create a new registry in the pool
    WattRegistry*r2=[_pool registryWithUidString:nil];
    NSUInteger count=[_package.registry count]+[_shelf.registry count];
    // We copy object from separate registries to a new unified Registry
    WTMPackage *p2=[_package wattCopyInRegistry:r2];
    WTMShelf *s2=[_shelf wattCopyInRegistry:r2];
    NSUInteger countR2=[r2 count];
    
    [self _checkIntegrityOfPackageRegistry:r2];
    XCTAssertTrue(count==countR2, @"The registries do not have the same count %i %i",count,countR2);
    XCTAssertNotEqual(_package, p2, @"After the copy the instances should not be equal");
    XCTAssertNotNil(_package,  @"After the copy the _package should not be nil");
    XCTAssertNotNil(p2,  @"After the copy the p2 should not be nil");
    XCTAssertNotEqual(_shelf, s2, @"After the copy the instances should not be equal");
    XCTAssertNotNil(_shelf,  @"After the copy the _package should not be nil");
    XCTAssertNotNil(s2,  @"After the copy the s2 should not be nil");
}


- (void)testCopyFromARegistryToAnotherWithinANewPool{
    
    // 1- We WattRegistry (r1)
    WattRegistry*r1=_package.registry;
    NSUInteger count=[r1 count];
    
    // 2- We create a new registry
    WattRegistryPool *pool2=[[WattRegistryPool alloc] initWithRelativePath:@"p2/"
                                                         serializationMode:WattJ
                                                              andSecretKey:nil];
    WattRegistry*r2=[pool2 registryWithUidString:nil];
    
    // 3- We copy the elements to another registry
    [_package wattCopyInRegistry:r2];
    NSUInteger countR2=[r2 count];
    WTMPackage *p2=[r2 objectWithUinstID:kWattRegistryRootUinstID];
    
    [self _checkIntegrityOfPackageRegistry:r2];
    XCTAssertTrue(count==countR2, @"The registries do not have the same count %i %i",count,countR2);
    XCTAssertNotEqual(_package, p2, @"After the copy the instances should not be equal");
    XCTAssertNotNil(_package,  @"After the copy the _package should not be nil");
    XCTAssertNotNil(p2,  @"After the copy the p2 should not be nil");

    [pool2 deletePoolFiles];
    
}


#pragma mark - sub Test Methods

- (void)_compare:(WattRegistry*)r1 with:(WattRegistry*)r2{
    XCTAssertNotEqual(r1, r2, @"r1 %@ should not be equal to r2 %@",r1,r2);
    // Let's compare r1 & r2 members.
    WattRegistry *__block r2Ref=r2;
    NSMutableString *__block s=[NSMutableString string];
    [r1 enumerateObjectsUsingBlock:^(WattObject *obj, NSUInteger idx, BOOL *stop) {
        NSUInteger identifier=obj.uinstID;
        id ro=[r2Ref objectWithUinstID:identifier];
        
        // We verify the class mapping
        XCTAssertTrue([obj isMemberOfClass:[ro class]], @"The obj : %@ should be a member %@",obj,NSStringFromClass([ro class]));
        
        // We verify that the instance are not references.
        XCTAssertFalse([obj isEqual:ro], @"The instances should not be equal");
        [s appendFormat:@"Analysed : %@\n",NSStringFromClass([obj class])];
    }];
    XCTAssertTrue([r1 count]==[r2 count], @"The registries do not have the same count %i %i",[r1 count], [r2 count]);
}



- (void)_checkIntegrityOfPackageRegistry:(WattRegistry*)registry{
    // Test the integrity of the populated pool
    [registry enumerateObjectsUsingBlock:^(WattObject *obj, NSUInteger idx, BOOL *stop) {
        if([obj isMemberOfClass:[WTMPackage class]]){
            XCTAssertTrue(obj.uinstID==kWattRegistryRootUinstID,@"Package should be the root object");
        }
        if([obj isMemberOfClass:[WTMHyperlink class]]){
            XCTAssertTrue([[((WTMHyperlink*)obj) urlString] isEqualToString:@"http://www.pereira-da-silva.com"],@"semantic failure on WTMHyperlink.urlString");
            XCTAssertTrue([[[((WTMHyperlink*)obj) library] name] isEqualToString:@"First Library"],@"semantic failure on WTMHyperlink.library.name");
        }
        if([obj isMemberOfClass:[WTMActivity class]]){
            XCTAssertTrue([[((WTMActivity*)obj) shortName] isEqualToString:@"activity1"],@"semantic failure on WTMActivity.shortName");
        }
    }];
    
}

- (void)_checkIntegrityOfShelfRegistry:(WattRegistry*)registry{
    // Test the integrity of the populated pool
    [registry enumerateObjectsUsingBlock:^(WattObject *obj, NSUInteger idx, BOOL *stop) {
        if([obj isMemberOfClass:[WTMShelf class]]){
            XCTAssertTrue([[((WTMShelf*)obj) comment] isEqualToString:@"Comment #1 for test purposes"],@"semantic failure on WTMShelf.comment");
        }
    }];
}


- (void)__unloadReloadARegistryWithMode:(WattSerializationMode)mode{
    [self _deletePopulatedPool];
    [self _createAPopulatedPoolWithMode:mode];
    
    WattRegistry*r1=_package.registry;
    NSUInteger r1Count=[r1 count];
    NSString *uidString=_package.registry.uidString;
    
    // We save the registry
    [_pool saveRegistry:_package.registry];
    
    // We Unload
    [_pool unloadRegistryWithRegistryID:uidString];
    
    //We reload from the serizalized registry identified by its uidString
    WattRegistry*r2=[_pool registryWithUidString:uidString];
    NSUInteger r2Count=[r2 count];
    
    //Test the semantic integrity.
    [self _checkIntegrityOfPackageRegistry:r2];
    
    //Then count
    XCTAssertTrue(r1Count==r2Count, @"The counts should remain constant %i<>%i",r1Count,r2Count);
}



#pragma  mark - Value generation

- (WattRegistryPool*)_createAPopulatedPoolWithMode:(WattSerializationMode)mode{
    
    // We remove the folder before to start (in case there was an exception)
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *basePath = ([paths count] > 0) ? [paths objectAtIndex:0] : nil;
    basePath=[basePath stringByAppendingString:@"/test/"];
    NSError*error=nil;
    [[NSFileManager defaultManager]removeItemAtPath:basePath error:&error];
    
    _pool=[[WattRegistryPool alloc] initWithRelativePath:@"test/"
                                       serializationMode:mode
                                            andSecretKey:nil];
    
    // We create a Shelf (with its own registry)
    _shelf=[wtmAPI createShelfInPool:_pool];
    _shelf.comment=@"Comment #1 for test purposes";
    
    // And one package (with its own registry)
    _package=[wtmAPI createPackageInPool:_pool];
    
    
    // We populate the package with a few content
    WTMActivity*a=[wtmAPI createActivityInPackage:_package];
    [a setShortName:@"activity1"];
    
    WTMLibrary*lib=[_package.libraries_auto firstObject];
    lib.name=@"First Library";
    
    WTMHyperlink*h=[wtmAPI createHyperlinkMemberInLibrary:lib];
    h.urlString=@"http://www.pereira-da-silva.com";
    
    return _pool;
}



- (void)_deletePopulatedPool{
    [_pool deletePoolFiles];
    _pool=nil;
    _shelf=nil;
    _package=nil;
}

@end
