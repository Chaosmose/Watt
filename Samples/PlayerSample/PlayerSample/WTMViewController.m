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

- (void)viewDidLoad{
    [super viewDidLoad];

    // 1- We create a Graph of object within a WattRegistry (r1)
    
    WattRegistry*r1=[[WattRegistry alloc] init];
    WTMShelf *s=[self _createAShelfInRegistry:r1];
    WTMPackage*p=[s.packages_auto lastObject];
    p.name=@"Package A";
    
    WTMLibrary*lib=[p.libraries_auto lastObject];
    lib.name=@"First Library";
    
    WTMHyperlink*h=[[WTMHyperlink alloc] initInRegistry:r1];
    h.urlString=@"http://www.secouchermoinsbete.fr";
    [lib.members_auto addObject:h];
    
    //WTLog(@"r1 : %@",r1);
    
    //2- We serialize the registry R1 to a linear structure a1

    NSArray *a1=[r1 arrayRepresentation];
    WTLog(@"%i element(s) ",[a1 count]);
    for (NSDictionary*d in a1) {
        WTLog(@"%@|%@",[d objectForKey:__uinstID__],d);
    }

    //3- We regenerate a new Registry from a1 by deserializing
    WattRegistry*r2=[WattRegistry instanceFromArray:a1];
    WTLog(@"r2 : %@",r2);
    

    //4- We  grab the root object uinstID==1
    WTMShelf *s2=(WTMShelf*)[r2 objectWithUinstID:1];
    WTMPackage*p2=[s2.packages lastObject];
    WTMLibrary*l2=[p2.libraries lastObject];
    WTMMember*m2=[l2.members lastObject];
    WTLog(@"p2:%@ l2:%@ m2:%@ ",p2,l2,m2);
    
    
    WTMCollectionOfMember *members=[r2 objectsWithClass:[WTMMember class] andPrefix:@"WTM"];
    // Use the collection
    // ...
    WTLog(@"%@",members);
    
    // And deregister the collection
    [r2 unRegisterObject:members];
    
    // ANY WattObject should be unRegisterObject to purge it from its register.
    // OR you can "purge" the whole registry (Best practice)
    
    
    
    /*

    // Graph representations 
    WTLog(@"%@",[s dictionaryRepresentationWithChildren:NO]);     // Graph
    WTLog(@"%@",[s dictionaryRepresentationWithChildren:YES]);     // Graph
    
    
    NSDictionary* d=[s dictionaryRepresentationWithChildren:NO];
    WTMShelf *s2=[WTMShelf instanceFromDictionary:d inRegistry:r2 includeChildren:YES];
    
    WTLog(@"%@",r2);    // Registry
    WTLog(@"%@",[s2 dictionaryRepresentationWithChildren:YES]);
     
   
    [s2 localize];
     */

}


- (WTMShelf*)_createAShelfInRegistry:(WattRegistry*)registry{
    // We create a Shelf
    WTMShelf *shelf=[[WTMShelf alloc]initInRegistry:registry];
    
    // With one package
    WTMPackage *p=[[WTMPackage alloc]initInRegistry:registry];
    [shelf.packages_auto addObject:p];
    
    // With one lang dictionary
    [p langDictionaries_auto];
    
    //Will instanciate a new Collection if nil
    //  WTMCollectionOfLangDictionary *ld=[[WTMCollectionOfLangDictionary alloc] initInRegistry:registry];
    //  p.langDictionaries=ld;
    //OR
    //Will replace the alias with a live object.
    
    // Containing one library
    WTMLibrary*castLib=[[WTMLibrary alloc] initInRegistry:registry];
    [p.libraries_auto addObject:castLib];
    return shelf;
}


- (void)didReceiveMemoryWarning{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
