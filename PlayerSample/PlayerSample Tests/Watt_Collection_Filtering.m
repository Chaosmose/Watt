//
//  Watt_Collection_Filtering.m
//  PlayerSample
//
//  Created by Benoit Pereira da Silva on 09/11/2013.
//  Copyright (c) 2013 Pereira da Silva. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "WTM.h"

@interface Watt_Collection_Filtering : XCTestCase

@end

@implementation Watt_Collection_Filtering

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

- (void)testExample
{
    WattRegistryPool *pool=[[WattRegistryPool alloc] initWithRelativePath:@"test/"
                                       serializationMode:WattJ
                                            andSecretKey:nil];
    
    // We create a Shelf (with its own registry)
    WTMShelf*shelf=[wtmAPI createShelfInPool:pool withRegistryUidString:@"s"];

    WTMMenuSection *section=[wtmAPI createSectionInShelf:shelf];
    
    // We create some menu
    [wtmAPI createMenuInSection:section thatRefersTo:shelf];
    [wtmAPI createMenuInSection:section thatRefersTo:shelf];
    [wtmAPI createMenuInSection:section thatRefersTo:shelf];
    [wtmAPI createMenuInSection:section thatRefersTo:shelf];
    [wtmAPI createMenuInSection:section thatRefersTo:shelf];
    
    
    NSPredicate *predicate=[NSPredicate predicateWithFormat:@"SELF.category==%@",@"favorite"];
    XCTAssertNoThrow([section.menus filteredCollectionUsingPredicate:predicate withRegistry:nil], @"Should not throw an exception");
    

    WTMCollectionOfMenu *collectionOfFavoritedMenus=[section.menus filteredCollectionUsingPredicate:predicate withRegistry:nil];
    [collectionOfFavoritedMenus sortUsingComparator:^NSComparisonResult(id obj1, id obj2) {
        if([(WTMMenu*)obj1 index]>=[(WTMMenu*)obj2 index]){
            return NSOrderedDescending;
        }else{
            return NSOrderedAscending ;
        }
    }];
    
    
    
}

@end
