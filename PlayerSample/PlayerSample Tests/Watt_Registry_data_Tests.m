//
//  PlayerSample_Tests.m
//  PlayerSample Tests
//
//  Created by Benoit Pereira da Silva on 12/10/13.
//  Copyright (c) 2013 Pereira da Silva. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "Watt.h"
#import "WTM.h"
#import "TRVSMonitor.h"

@interface Watt_Registry_data_Tests : XCTestCase
@property (atomic,strong)WattApi *api;
@property (atomic,strong)WattRegistry*dataRegistry;
@end

@implementation Watt_Registry_data_Tests


- (void)setUp{
    [super setUp];
    self.api=[[WattApi alloc] init];
}

- (void)tearDown{
    [super tearDown];
    self.dataRegistry=nil;
    self.api=nil;
}


- (void)testActivityExport{
    
    
    NSString *p=[[NSBundle mainBundle] pathForResource:@"dataset1" ofType:@"json"];
    WTLog(@"%@",[p stringByReplacingOccurrencesOfString:@" " withString:@"\\ "]);
    XCTAssertTrue(p, "The dataset path should not be nil");
    
    XCTAssertTrue([[NSFileManager defaultManager] fileExistsAtPath:p isDirectory:NO], @"dataset file should exist at path : %@",p);
    self.dataRegistry=[self.api readRegistryFromFile:p];
    XCTAssertTrue(self.dataRegistry, @"Data registry is nil");
    
    if(self.dataRegistry){
        
        WattApi *__weak weakApi=self.api;
        
        // We grab the root object
        WTMShelf*s=[self.dataRegistry objectWithUinstID:1];
        XCTAssertTrue(s,@"Shelf is nil");
        
        // We search the activity package
        WTMPackage *__block activitiesPackage=nil;
        [s.packages enumerateObjectsUsingBlock:^(WTMPackage *obj, NSUInteger idx, BOOL *stop) {
            if([obj.category isEqualToString:@"activity"]){
                activitiesPackage=obj;
            }
        }reverse:NO];
        XCTAssertTrue(activitiesPackage,@"We haven't found a package in 'activity' category");
        
        // We iterate on each activity
        [activitiesPackage.activities_auto enumerateObjectsUsingBlock:^(WTMActivity *obj, NSUInteger idx, BOOL *stop) {
            
            // We create a new registry
            WattRegistry*r=[[WattRegistry alloc] init];
            // Copy the activity in the new registry
            [obj wattExtractAndCopyToRegistry:r];
            
            NSString *baseName=[obj shortName];
            
            NSString *filteredBaseName=[baseName stringByReplacingOccurrencesOfString:@" " withString:@"_"];
            NSMutableString *folderPath=[NSMutableString stringWithString:[weakApi applicationDocumentsDirectory]];
            [folderPath appendFormat:@"export/%@/",[filteredBaseName length]>1?filteredBaseName:[NSNumber numberWithInt:obj.uinstID]];
            [weakApi createRecursivelyRequiredFolderForPath:folderPath];
            
            NSString*path=[NSString stringWithFormat:@"%@%@",folderPath,@"activity.j"];
            WTLog(@"%@",path);
            [weakApi writeRegistry:r toFile:path];
            
            XCTAssertTrue([[NSFileManager defaultManager] fileExistsAtPath:path isDirectory:NO],@"File at path %@ should exist",path);
            
        } reverse:NO];
    }
}





@end
