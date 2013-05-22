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
// 

- (void)viewDidLoad{
    [super viewDidLoad];

    WattRegistry*r1=[[WattRegistry alloc] init];
    WTMShelf *s=[self _createAShelfInRegistry:r1];
    WTMPackage*p=[s.packages lastObject];
    p.name=@"Package A";
    
    WTMLibrary*lib=[p.libraries lastObject];
    lib.name=@"Library #1";
    
    WTMHyperlink*h=[[WTMHyperlink alloc] initInRegistry:r1];
    h.urlString=@"http://www.secouchermoinsbete.fr";
    [lib.members addObject:h];
    
    NSArray *a1=[r1 arrayRepresentation];
    WTLog(@"%i element(s) : %@",[a1 count],a1);
    
    
     /*
    NSDictionary* d=[s dictionaryRepresentation];
    WTLog(@"%@",d);     // Graph
    WTLog(@"%@",r1);    // Registry
    
   
    WTMRegistry*r2=[[WTMRegistry alloc] init];    
    WTMShelf *s2=[WTMShelf instanceFromDictionary:d inRegistry:r2];
    WTLog(@"%@",r2);    // Registry
    WTLog(@"%@",[s2 dictionaryRepresentation]);
     
   
    
    [s2 localize];
 */
}


-(WTMShelf*)_createAShelfInRegistry:(WattRegistry*)registry{
    // We create a Shelf
    WTMShelf *shelf=[[WTMShelf alloc]initInRegistry:registry];
    // With one package
    WTMPackage *p=[[WTMPackage alloc]initInRegistry:registry];
    [shelf.packages addObject:p];
    // With one lang dictionary
    WTMCollectionOfLangDictionary *ld=[[WTMCollectionOfLangDictionary alloc] initInRegistry:registry];
    p.langDictionaries=ld;
    // Containing one library
    WTMLibrary*castLib=[[WTMLibrary alloc] initInRegistry:registry];
    [p.libraries addObject:castLib];
    return shelf;
}


- (void)didReceiveMemoryWarning{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
