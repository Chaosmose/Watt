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
    
    XCTAssertTrue([a1 count]>=4,@"The serialized registry should contains a least 4 items, current count is : %i",[a1 count]);
    
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
        XCTAssertTrue([obj isMemberOfClass:[ro class]], @"The obj : %@ should be a member %@",obj,NSStringFromClass([ro class]));
        [s appendFormat:@"Analysed : %@\n",NSStringFromClass([obj class])];
    }];
    
    WTLog(@"\n%@",s);
    /*
    
    
    //4- We  grab the root object uinstID==1
    WTMShelf *s2=(WTMShelf*)[r2 objectWithUinstID:1];
    WTMPackage*p2=[s2.packages lastObject];
    WTMLibrary*l2=[p2.libraries lastObject];
    WTMMember*m2=[l2.members lastObject];
    WTLog(@"p2:%@ l2:%@ m2:%@ ",p2,l2,m2);
    WTLog(@"objectWithUinstID:7 %@",[r2 objectWithUinstID:7]);
    */
    /*
     // OTHER ATTEMPT :
     
     // Request a collection of members.
     WTMCollectionOfMember *members=[r2 objectsWithClass:[WTMMember class]
     andPrefix:@"WTM"
     returningRegistry:nil];// You can use r2 as returningRegistry to save the result
     // Use the collection
     // ...
     WTLog(@"%@",members);
     WTLog(@"%@",[members lastObject]);
     */
    
    // And unRegisterObject the collection if from the register if necessary
    //[r2 unRegisterObject:members];
    
}


- (WattRegistry*)_createAPopulatedRegistry{
    
    WattRegistry*registry=[[WattRegistry alloc] init];
    registry.name=@"r1";
    registry.apiReference=[WTMApi sharedInstance];
    registry.autosave=NO;
    
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
