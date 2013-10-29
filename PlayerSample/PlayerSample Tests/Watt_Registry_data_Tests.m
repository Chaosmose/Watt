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
    [self.api use:WattJx];
}

- (void)tearDown{
    [super tearDown];
    self.dataRegistry=nil;
    self.api=nil;
}


- (void)testExtractionAndPackaging{
    
    NSString *p=[[NSBundle mainBundle] pathForResource:@"dataset1" ofType:@"json"];
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
            NSMutableString *__weak folderPath=[NSMutableString stringWithString:[weakApi applicationDocumentsDirectory]];
            [folderPath appendFormat:@"export/%@/",[filteredBaseName length]>1?filteredBaseName:[NSNumber numberWithInt:obj.uinstID]];
            [weakApi createRecursivelyRequiredFolderForPath:folderPath];
            
            NSString*path=[NSString stringWithFormat:@"%@%@",folderPath,@"activity.jx"];
            WTLog(@"%@",[path stringByReplacingOccurrencesOfString:@" " withString:@"\\ "]);
            
            [weakApi writeRegistry:r toFile:path];
            XCTAssertTrue([[NSFileManager defaultManager] fileExistsAtPath:path isDirectory:NO],@"File at path %@ should exist",path);
            
            // We do create void file to simulate the export
            [r enumerateObjectsUsingBlock:^(WattObject *obj, NSUInteger idx, BOOL *stop) {
                if ([[obj class]isSubclassOfClass:[WTMLinkedAsset class]]) {
                    WTMLinkedAsset *l=(WTMLinkedAsset*)obj;
                    NSString*destination=[folderPath stringByAppendingString:l.relativePath];
                    [weakApi createRecursivelyRequiredFolderForPath:destination];
                    [weakApi.fileManager createFileAtPath:destination contents:nil attributes:nil];
                }
            }];
            
            [[WattBundlePackager sharedInstance]packFolderFromPath:folderPath
                                                         withBlock:^(BOOL success, NSString *packPath) {
                                                             XCTAssertTrue([[NSFileManager defaultManager] fileExistsAtPath:packPath isDirectory:NO],@"File at path %@ should exist",packPath);
                                                         } useBackgroundMode:NO
                                                         overWrite:YES];
        } reverse:NO];
    }
}





@end
