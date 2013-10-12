//
//  PlayerSample_Tests.m
//  PlayerSample Tests
//
//  Created by Benoit Pereira da Silva on 12/10/13.
//  Copyright (c) 2013 Pereira da Silva. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "WTM.h"

@interface PlayerSample_Tests : XCTestCase

@end

@implementation PlayerSample_Tests

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


- (void)testOne{
    XCTAssertFalse(2==1, @"2 should not be equal to 1");
}

/*

- (void)testShelfName
{
   WTMShelf *s=[[WTMApi sharedInstance] createShelfWithName:@"a"];
    XCTAssertEqual(s.name, @"a", @"Shelf name should be 'a' and is %@ ",s.name);
}*/

@end
