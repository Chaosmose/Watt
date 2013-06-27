// This file is part of "Watt"
//
// "Watt" is free software: you can redistribute it and/or modify
// it under the terms of the GNU LESSER GENERAL PUBLIC LICENSE as published by
// the Free Software Foundation, either version 3 of the License, or
// (at your option) any later version.
//
// "Watt" is distributed in the hope that it will be useful,
// but WITHOUT ANY WARRANTY; without even the implied warranty of
// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
// GNU LESSER GENERAL PUBLIC LICENSE for more details.
//
// You should have received a copy of the GNU LESSER GENERAL PUBLIC LICENSE
// along with "Watt"  If not, see <http://www.gnu.org/licenses/>
//
//
//  WTMViewController.m
//  PlayerSample
//
//  Created by Benoit Pereira da Silva on 09/05/13.
//  Copyright (c) 2013 Pereira da Silva. All rights reserved.
//

#import "WTMViewController.h"
#import "WTMModelsImports.h"

@interface WTMViewController ()

@end

@implementation WTMViewController

// Principle :


// We create object registries.
// To deal with complex object graph more efficiently.
// it Allow to serialize a graph even with decorrelated relationships.

// @todo DOCUMENT the _auto getter.
//

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    
    // 1- We create a Graph of object within a WattRegistry (r1)
    
    WattRegistry*r1=[[WattRegistry alloc] init];
    WTMShelf *s=[self _createAShelfInRegistry:r1];
    s.comment=@"Comment #1 for test purposes";
    WTMPackage*p=[s.packages lastObject];
    p.name=@"Package A";
    
    WTMLibrary*lib=[p.libraries_auto lastObject];
    lib.name=@"First Library";
    
    WTMHyperlink*h=[[WTMHyperlink alloc] initInRegistry:r1];
    h.urlString=@"http://www.pereira-da-silva.com";
    [lib.members_auto addObject:h];
    h.library=lib;
    
    WTMShelf *s1=(WTMShelf*)[r1 objectWithUinstID:1];
    WTMPackage*p1=[s1.packages lastObject];
    WTMLibrary*l1=[p1.libraries lastObject];
    WTMMember*m1=[l1.members lastObject];
    WTLog(@"p1:%@ l1:%@ m1:%@ ",p1,l1,m1);
    

    //2- We serialize the registry R1 to a linear structure a1
    NSArray *a1=[r1 arrayRepresentation];
    WTLog(@"%i element(s) ",[a1 count]);
    for (NSDictionary*d in a1) {
        WTLog(@"%@|%@",[d objectForKey:__uinstID__],d);
    }
    
    //3- We generate a new Registry (r2) from a1 by deserializing
    WattRegistry*r2=[WattRegistry instanceFromArray:a1 resolveAliases:YES];
    WTLog(@"r2 : %@",r2);
    
    //4- We  grab the root object uinstID==1
    WTMShelf *s2=(WTMShelf*)[r2 objectWithUinstID:1];
    WTMPackage*p2=[s2.packages lastObject];
    WTMLibrary*l2=[p2.libraries lastObject];
    WTMMember*m2=[l2.members lastObject];
    WTLog(@"p2:%@ l2:%@ m2:%@ ",p2,l2,m2);
    WTLog(@"objectWithUinstID:7 %@",[r2 objectWithUinstID:7]);

    
    // OTHER ATTEMPT : 

    // Request a collection of members.
    WTMCollectionOfMember *members=[r2 objectsWithClass:[WTMMember class]
                                              andPrefix:@"WTM"
                                      returningRegistry:nil];// You can use r2 as returningRegistry to save the result
    // Use the collection
    // ...
    WTLog(@"%@",members);
    WTLog(@"%@",[members lastObject]);
    // And unRegisterObject the collection if from the register if necessary
    //[r2 unRegisterObject:members];
    
    
    // ANY WattObject should be unRegisterObject to purge it from its register.
    // OR you can "purge" the whole registry (Best practice)


    // Graph representations
    WTLog(@"%@",[s dictionaryRepresentationWithChildren:NO]);     // Graph
#warning dictionaryRepresentationWithChildren:YES can loop infinitely in case of reciprocity of relationship
    //WTLog(@"%@",[s dictionaryRepresentationWithChildren:YES]);     // Graph
    
    
    NSDictionary* d=[s dictionaryRepresentationWithChildren:NO];
    WTMShelf *s3=[WTMShelf instanceFromDictionary:d inRegistry:r2 includeChildren:YES];
    
    WTLog(@"%@",r2);    // Registry
#warning dictionaryRepresentationWithChildren:YES can loop infinitely
   // WTLog(@"%@",[s3 dictionaryRepresentationWithChildren:YES]);
     
    [s2 localize];
    
}


- (WTMShelf*)_createAShelfInRegistry:(WattRegistry*)registry{
    // We create a Shelf
    WTMShelf *shelf=[[WTMShelf alloc]initInRegistry:registry];
    
    // With one package
    WTMPackage *p=[[WTMPackage alloc]initInRegistry:registry];
    [shelf.packages_auto addObject:p];
    p.shelf=shelf;// Reciprocity
    
    // With one lang dictionary
    [p langDictionary_auto];
    
    // Containing one library
    WTMLibrary*castLib=[[WTMLibrary alloc] initInRegistry:registry];
    [p.libraries_auto addObject:castLib];
    castLib.package=p;// Reciprocity
    return shelf;
}


- (void)didReceiveMemoryWarning{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
