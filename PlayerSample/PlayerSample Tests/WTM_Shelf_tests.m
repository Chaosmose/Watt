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


- (void)testShelfAndPackagesSerializationDeserialization{
    
    // 1- We create a Graph of object within a WattRegistry (r1)
    WattRegistry*r1=[self _createAPopulatedRegistry];
    //2- We serialize the registry R1 to a linear structure a1
    NSArray *a1=[r1 arrayRepresentation];
    
    //3- We generate a new Registry (r2) from a1 by deserializing
    WattRegistry*r2=[WattRegistry instanceFromArray:a1 withSerializationMode:WattJ
                                               name:@"r2"
                                   andContainerName:@"test"
                                     resolveAliases:YES];
    
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
}


- (void)testShelfsCopyFromARegistryToAnother{
    
    // 1- We create a Graph of object within a WattRegistry (r1)
    WattRegistry*r1=[self _createAPopulatedRegistry];
    WTMShelf *shelf=(WTMShelf*)[r1 objectWithUinstID:1];
    
    // 2- We copy the shel to another registry
    WattRegistry*r2=[[WattRegistry alloc]initWithSerializationMode:WattJ name:[WattUtils uuidString] andContainerName:shelf.name];
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
    
    WattRegistry*registry=[[WattRegistry alloc] initWithSerializationMode:WattJ name:@"r1" andContainerName:nil];
    registry.autosave=NO;
    
    WTMShelf *s=[self _createAShelfInRegistry:registry];
    s.comment=@"Comment #1 for test purposes";
   

    NSString *pObjectName=[s.packagesList firstObject];
    WTMPackage*p=[s packageWithObjectName:pObjectName using:WattJ];
    p.name=@"Package A";
    
    XCTAssertNotNil(p,@"The package should no be nil");
    
    
    WTMLibrary*lib=[p.libraries_auto firstObject];
    lib.name=@"First Library";
    
    WTMHyperlink*h=[wtmAPI createHyperlinkMemberInLibrary:lib];
    h.urlString=@"http://www.pereira-da-silva.com";
    
    [p.registry save];
    
    WTLog(@"p.registry serializationPath : %@",[p.registry serializationPath]);
    
    return registry;
}


- (WTMShelf*)_createAShelfInRegistry:(WattRegistry*)registry{
    
    // We create a Shelf
    WTMShelf *shelf=[[WTMShelf alloc]initInRegistry:registry];
    
    // And one package (with its own registry)
    WTMPackage *p=[wtmAPI createPackageInShelf:shelf];
    
    //
    WTMActivity*a=[wtmAPI createActivityInPackage:p];
    [a setShortName:@"activity1"];
    
    return shelf;
}

@end
