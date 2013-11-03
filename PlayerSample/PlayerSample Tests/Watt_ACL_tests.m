//
//  WattACL.m
//  PlayerSample
//
//  Created by Benoit Pereira da Silva on 20/10/13.
//  Copyright (c) 2013 Pereira da Silva. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "Watt.h"

@interface Watt_ACL_tests : XCTestCase
@property (strong,nonatomic)WattACL *api;
@end

@implementation Watt_ACL_tests

- (void)setUp{
    [super setUp];
    self.api=[[WattACL alloc] init];
}

- (void)tearDown{
    [super tearDown];
    self.api=nil;
}

- (void)testACL_StringAndNumbersShouldBeSymetric{
    NSArray *r=@[@(777),@(666),@(555),@(755),@(700),@(000),@(111)];
    NSMutableString *m=[NSMutableString string];
    for (NSNumber *n in r) {
        NSString *rs=[self.api rightsFromInteger:[n integerValue]];
        NSUInteger ri=[self.api rightsFromString:rs];
        [m  appendFormat:@"Tested : %@:%@\n",rs,n];
        XCTAssertTrue(ri==[n integerValue], @"%@ failed",n);
    }
    WTLog(@"%@",m);
}


- (void)testACL_StandardValue{
    XCTAssertTrue([self.api rightsFromString:@"RWXRWXRWX"]==777,@"RWXRWXRWX should equals 777");
    XCTAssertTrue([self.api rightsFromString:@"RWX------"]==700,@"RWX------ should equals 700");
    
}

@end
