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
//  WTMApi.h
//
//  Created by Benoit Pereira da Silva on 17/05/13.
//  Copyright (c) 2013 Pereira da Silva. All rights reserved.
//

// This is a cross platform authoring and runtime api
// That intent to be fully supported by mac os x and IOS


#import "WattObject.h"
#import "WTMModelsImports.h"


typedef enum watt_Actions{    
    WattREAD=0,     //view the file
    WattWRITE=1,    //create, edit or delete
    WattEXECUTE=2   //run a script or enter a directory ?
}Watt_Action;
// http://mason.gmu.edu/~montecin/UNIXpermiss.htm

#ifndef WTAPI_CONST
#define WTAPI_CONST
#define WATT_ACTION_IS_NOT_AUTHORIZED_NOTIFICATION_NAME @"WATT_ACTION_IS_NOT_AUTHORIZED_NOTIFICATION_NAME"
#endif



#pragma mark - WattApi

@protocol WTMlocalizationDelegateProtocol;

@interface WattApi : NSObject

@property (nonatomic,assign)id<WTMlocalizationDelegateProtocol>localizationDelegate;
@property (nonatomic,strong)  WattRegistry *currentRegistry;
@property (nonatomic,strong)  WTMUser *me;
//
@property (nonatomic,readonly)  WTMUser *system;
@property (nonatomic,readonly)  WTMGroup *systemGroup;

// WattMApi singleton accessor
+ (WattApi*)sharedInstance;

#pragma mark - Registry 

-(void)mergeRegistry:(WattRegistry*)sourceRegistry
                into:(WattRegistry*)destinationRegistry;

#pragma mark - MULTIMEDIA API



#pragma mark - ACL

- (BOOL)user:(WTMUser*)user canPerform:(Watt_Action)action onObject:(WTMModel*)object;

#pragma mark - Package

#pragma mark -Shelf

// Creates a shelf, a user , the local group, a package with a shared lib ...
-(WTMShelf*)createShelfWithName:(NSString*)name;

// Will remove the shelf folder including all data
-(void)removeShelf:(WTMShelf*)shelf;

#pragma mark - User and groups

- (WTMUser*)createUserInShelf:(WTMShelf*)shelf;
- (WTMGroup*)createGroupInShelf:(WTMShelf*)shelf;
- (void)addUser:(WTMUser*)user toGroup:(WTMGroup*)group;
- (void)removeUser:(WTMUser*)User fromGroup:(WTMGroup*)group;
- (void)removeGroup;



- (WTMPackage*)createPackageInShelf:(WTMShelf*)shelf;
- (void)removePackage:(WTMPackage*)package;

// Immport process this method can move a package from a registry to another
// Producing renamming of assets and performing re-identification
- (void)addPackage:(WTMPackage*)package
          toShelf:(WTMShelf*)shelf;


#pragma mark - Library

- (WTMLibrary*)createLibraryInPackage:(WTMPackage*)package;
- (void)removeLibrary:(WTMLibrary*)library;


#pragma mark - Activity

- (WTMActivity*)createActivityInPackage:(WTMPackage*)package;
- (void)removeActivity:(WTMActivity*)activity;


#pragma mark - Scene

- (WTMScene*)createSceneInActivity:(WTMActivity*)activity;
- (void)removeScene:(WTMScene*)scene;

#pragma mark - Element 

-(WTMElement*)createElementInScene:(WTMScene*)scene
                         withAsset:(WTMAsset*)asset
                       andBehavior:(WTMBehavior*)behavior;

-(void)removeElement:(WTMElement*)element;

#pragma mark -  Bands 

// Bands
- (WTMBand*)createBandInLibrary:(WTMLibrary*)library
             withMembers:(NSArray*)members;

- (void)purgeBandIfNecessary:(WTMBand*)band;


#pragma mark -  Members

// Use this section of the api to add member.
// The underlining refererCounter is automaticly managed
// Purging  a member or band from a library can automatically delete the linked files

// Linked assets dependencies
// Library 1<->n member

// Band n<->n member
// Library 1<->n member


- (void)addMember:(WTMMember*)member
        toLibrary:(WTMLibrary*)library;

- (void)purgeMemberIfNecessary:(WTMMember*)member;

#pragma mark localization

//You should normaly not call directly that method
//This method is called from WTMObject from the @selector(localize) implementation.
//Calls the localizationDelegate if it is set or invokes the default implementation
- (void)localize:(WattObject*)reference withKey:(NSString*)key andValue:(id)value;


#pragma mark - Paths 
#pragma mark - relative path and path discovery

- (NSString*)absolutePathFromRelativePath:(NSString *)relativePath;
- (NSArray*)absolutePathsFromRelativePath:(NSString *)relativePath all:(BOOL)returnAll;
- (NSString*)applicationDocumentsDirectory;

@end

#pragma mark localization delegate prototocol

// You can implement this protocol if you want to customize the internationalization process.
@protocol WTMlocalizationDelegateProtocol <NSObject>
@required
- (void)localize:(id)reference withKey:(NSString*)key andValue:(id)value;
@end

#