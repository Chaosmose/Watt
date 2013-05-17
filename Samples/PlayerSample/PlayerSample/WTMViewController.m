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



- (void)viewDidLoad{
    [super viewDidLoad];
    
    WTMShelf *s=[self _createAShelf];
    WTMPackage*p=[s.packages lastObject];
    p.name=@"Package A";
    
    WTMLibrary*lib=[p.libraries lastObject];
    lib.name=@"Library #1";
    
    WTMHyperlink*h=[[WTMHyperlink alloc] init];
    h.urlString=@"http://www.secouchermoinsbete.fr";
    
    [lib.members addObject:h];
    
    NSDictionary* d=[s dictionaryRepresentation];
    NSLog(@"%@",d);
    
    WTMShelf *s2;
    s2=[WTMShelf instanceFromDictionary:d];
    NSLog(@"%@",[s2 dictionaryRepresentation]);
    
    [s2 localize];

}



-(WTMShelf*)_createAShelf{
    // We create a Shelf
    WTMShelf *shelf=[[WTMShelf alloc] init];
    // With one package
    WTMPackage *p=[[WTMPackage alloc]init];
    [shelf.packages addObject:p];
    // With one lang dictionary
    WTMCollectionOfLangDictionary *ld=[[WTMCollectionOfLangDictionary alloc] init];
    p.langDictionaries=ld;
    // Containing one library
    WTMLibrary*castLib=[[WTMLibrary alloc] init];
    [p.libraries addObject:castLib];
    return shelf;
}


- (void)didReceiveMemoryWarning{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
