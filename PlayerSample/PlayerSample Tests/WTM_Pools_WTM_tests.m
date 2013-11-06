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

@interface WTM_Pools_WTM_tests : XCTestCase{
    WattRegistryPool *_pool;
    WTMShelf *_shelf;
    WTMPackage *_package;
}

@end

@implementation WTM_Pools_WTM_tests

- (void)setUp{
    [super setUp];
    [self _createAPopulatedPool];
}

- (void)tearDown{
    [super tearDown];
    [self _deletePopulatedPool];
}


- (void)testRegistrySerializationDeserialization{
    
    [_pool saveRegistries];
    
    
    // 1- We use WattRegistry (r1)
    WattRegistry*r1=_package.registry;
    
    //2- We serialize the registry R1 to a linear structure a1
    NSArray *a1=[r1 arrayRepresentation];
    
    //3- We generate a new Registry (r2) from a1 by deserializing
    WattRegistry *r2=[WattRegistry instanceFromArray:a1
                               withSerializationMode:WattJ
                              uniqueStringIdentifier:[_pool uuidString]
                                              inPool:_pool
                                      resolveAliases:YES];
    
    [self _compare:r1 with:r2];
    
}


 - (void)testCopyFromARegistryToAnother{
 
 // 1- We WattRegistry (r1)
 WattRegistry*r1=_package.registry;
 
 // 2- We create a new registry
 WattRegistry*r2=[_pool registryWithUidString:nil];
 
 // 3- We copy the elements to another registry
 [_package wattCopyInRegistry:r2];
 
 [self _compare:r1 with:r2];
}


 
 - (void)testCopyFromARegistryToAnotherWithinANewPool{
 
 // 1- We WattRegistry (r1)
 WattRegistry*r1=_package.registry;
 
 // 2- We create a new registry
 WattRegistryPool *pool2=[[WattRegistryPool alloc] initWithRelativePath:@"p2/"
 serializationMode:WattJ
 andSecretKey:nil];
 
 WattRegistry*r2=[_pool registryWithUidString:nil];
 
 // 3- We copy the elements to another registry
 [_package wattCopyInRegistry:r2];
 
 [self _compare:r1 with:r2];
 [pool2 deletePoolFiles];

}

- (void)testMergeAndCopyRegistry{
    
    // 1- We WattRegistry (r1)
    WattRegistry*r1=_package.registry;
    [r1 mergeWithRegistry:_shelf.registry];
    
    // 2- We create a new registry
    WattRegistry*r2=[_pool registryWithUidString:nil];
    
    // 3- We copy the elements to another registry
    [_package wattCopyInRegistry:r2];
    
    
L OPERATIONDE mergeWithRegistry ecrase ? 
    [self _compare:r1 with:r2];
}


- (void)testMultiCopyFromVariousRegistry{
    XCTAssertNoThrow([self __multiCopyFromVariousRegistry], @"__multiCopyFromVariousRegistry should not throw an exception");
}

- (void)__multiCopyFromVariousRegistry{
    WattRegistry*r2=[_pool registryWithUidString:nil];
    // We copy object from separate registries to a new unified Registry
    [_package wattCopyInRegistry:r2];
    [_shelf wattCopyInRegistry:r2];
}





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



- (WattRegistryPool*)_createAPopulatedPool{
   
    // We remove the folder before to start (in case there was an exception)
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *basePath = ([paths count] > 0) ? [paths objectAtIndex:0] : nil;
    basePath=[basePath stringByAppendingString:@"/test/"];
    NSError*error=nil;
    [[NSFileManager defaultManager]removeItemAtPath:basePath error:&error];
    
    
    
    _pool=[[WattRegistryPool alloc] initWithRelativePath:@"test/"
                                       serializationMode:WattJ
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
