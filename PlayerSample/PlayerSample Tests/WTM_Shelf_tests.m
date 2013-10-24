//
//  WTM_Shelf_tests.m
//  PlayerSample
//
//  Created by Benoit Pereira da Silva on 20/10/13.
//  Copyright (c) 2013 Pereira da Silva. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "WTM.h"

@interface WTM_Shelf_tests : XCTestCase

@end

@implementation WTM_Shelf_tests

- (void)setUp
{
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown
{
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}


- (void)testCompareShelfs_SerializationDeserialization{
    
    // 1- We create a Graph of object within a WattRegistry (r1)
    WattRegistry*r1=[self _createAPopulatedRegistry];
    //2- We serialize the registry R1 to a linear structure a1
    NSArray *a1=[r1 arrayRepresentation];
    
    //3- We generate a new Registry (r2) from a1 by deserializing
    WattRegistry*r2=[WattRegistry instanceFromArray:a1
                                resolveAliases:YES];
    
    r2.apiReference=wtmAPI;
    r2.name=@"r2";
    
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
    // We verify we have enough members.
    XCTAssertTrue([a1 count]>=4,@"The serialized registry should contains a least 4 items, current count is : %i",[a1 count]);
}


- (void)testShelfs_CopyFromARegistryToAnother{
    
    // 1- We create a Graph of object within a WattRegistry (r1)
    WattRegistry*r1=[self _createAPopulatedRegistry];
    WTMShelf *shelf=(WTMShelf*)[r1 objectWithUinstID:1];
    
    // 2- We copy the shel to another registry
    WattRegistry*r2=[[WattRegistry alloc]init];
    [shelf wattCopyInRegistry:r2];
    
    // TESTS
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

    
    // Let s count
    XCTAssertTrue([r1 count]==[r2 count], @"The registries do not have the same count %i %i",[r1 count], [r2 count]);

}



- (WattRegistry*)_createAPopulatedRegistry{
    
    WattRegistry*registry=[[WattRegistry alloc] init];
    registry.name=@"r1";
    registry.apiReference=[WTMApi sharedInstance];
    registry.autosave=NO;
    wtmAPI.currentRegistry=registry; // Very important
    
    WTMShelf *s=[self _createAShelfInRegistry:registry];
    s.comment=@"Comment #1 for test purposes";
    WTMPackage*p=[s.packages lastObject];
    p.name=@"Package A";
    
    WTMLibrary*lib=[p.libraries_auto firstObject];
    lib.name=@"First Library";
    
    WTMHyperlink*h=[wtmAPI createHyperlinkMemberInLibrary:lib];
    h.urlString=@"http://www.pereira-da-silva.com";
    
    return registry;
}


- (WTMShelf*)_createAShelfInRegistry:(WattRegistry*)registry{
    
    // We create a Shelf
    WTMShelf *shelf=[[WTMShelf alloc]initInRegistry:registry];
    // With one package
    WTMPackage *p=[wtmAPI createPackageInShelf:shelf];
    // With one lang dictionary
    [p langDictionary_auto];
    // Containing one library
    [wtmAPI createLibraryInPackage:p];
    
    return shelf;
}

@end
