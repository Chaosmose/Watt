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
// to developp multimedia project
// That intent to be fully supported by mac os x and IOS

// Port to Java targetting Android & non android system is possible.
// Watt is a model driven framework relying on files.


#import "Watt.h"
#import "WattObject.h"
#import "WattAcl.h"
#import "WTMModelsImports.h"



typedef enum watt_F_TYPES{
    WattJx=0,   // Json + soup      * Default
    WattJ=1,    // Json  + no soup
    WattPx=2,   // Plist + soup
    WattP=3     // Plist + no soup
}Watt_F_TYPE;


#pragma mark - WattApi

@protocol WTMlocalizationDelegateProtocol;

@interface WattApi : NSObject

@property (nonatomic,assign)    id<WTMlocalizationDelegateProtocol>localizationDelegate;
@property (nonatomic,strong)    WTMUser *me;
@property (nonatomic,strong)    WattRegistry *currentRegistry; // Used to register & create object ( you can change its reference at runtime)
@property (nonatomic,readonly)  WTMUser *system;
@property (nonatomic,readonly)  WTMGroup *systemGroup;
@property (nonatomic,strong)    NSFileManager *fileManager;

//Advanced runtime configuration
//That defines the format & soup behaviour
-(void)use:(Watt_F_TYPE)ftype;


// WattMApi singleton accessor
+ (WattApi*)sharedInstance;


#pragma mark - Registry 


- (void)mergeRegistry:(WattRegistry*)sourceRegistry
                 into:(WattRegistry*)destinationRegistry
       reIndexUinstID:(BOOL)index;


#pragma mark - /// MULTIMEDIA API ///

#pragma mark - ACL

- (BOOL)user:(WTMUser*)user canPerform:(Watt_Action)action onObject:(WTMModel*)object;

#pragma mark -Shelf

// Creates a shelf, a user , the local group, a package with a shared lib ...
-(WTMShelf*)createShelfWithName:(NSString*)name;

// A facility to generate symboliclink for package and libraries
- (void)generateSymbolicLinkForShelf:(WTMShelf*)shelf;

// No remove method actually (need to be analyzed)

#pragma mark - User and groups

- (WTMUser*)createUserInShelf:(WTMShelf*)shelf;
- (WTMGroup*)createGroupInShelf:(WTMShelf*)shelf;
- (void)addUser:(WTMUser*)user toGroup:(WTMGroup*)group;

// No remove method actually (need to be analyzed) 

#pragma mark - Menus & section 

- (WTMMenuSection*)createSectionInShelf:(WTMShelf*)shelf;
- (void)removeSection:(WTMMenuSection*)section;
- (WTMMenu*)createMenuInSection:(WTMMenuSection*)section;
- (void)removeMenu:(WTMMenu*)menu;

#pragma mark - Package

// Create a package and it default library
- (WTMPackage*)createPackageInShelf:(WTMShelf*)shelf;

- (void)removePackage:(WTMPackage*)package;

// Immport process this method can move a package from a registry to another
// Producing renamming of assets and performing re-identification
- (void)addPackage:(WTMPackage*)package
          toShelf:(WTMShelf*)shelf;

- (NSArray*)dependenciesPathForPackage:(WTMPackage*)package;


#pragma mark - Library

- (WTMLibrary*)createLibraryInPackage:(WTMPackage*)package;
- (void)removeLibrary:(WTMLibrary*)library;

- (NSArray*)dependenciesPathForLibrary:(WTMLibrary*)library;

#pragma mark - Activity

- (WTMActivity*)createActivityInPackage:(WTMPackage*)package;
- (void)removeActivity:(WTMActivity*)activity;


#pragma mark - Scene

- (WTMScene*)createSceneInActivity:(WTMActivity*)activity;
- (void)removeScene:(WTMScene*)scene;

#pragma mark - Element 

// scene & asset must not be nil
// behavior is optionnal
-(WTMElement*)createElementInScene:(WTMScene*)scene
                         withAsset:(WTMAsset*)asset
                       andBehavior:(WTMBehavior*)behavior;

-(void)removeElement:(WTMElement*)element;

#pragma mark -  Bands 

// Bands
- (WTMBand*)createBandInLibrary:(WTMLibrary*)library
             withMembers:(NSArray*)members;


// Call purgeMemberIfNecessary on any member.

- (void)purgeBandIfNecessary:(WTMBand*)band;

// Removing band  will remove and force the purge.
- (void)removeBand:(WTMBand*)band;


#pragma mark -  Members

// Use this section of the api to add member.
// The underlining refererCounter is automaticly managed
// Purging  a member or band from a library can automatically delete the linked files

// Linked assets dependencies
// Library 1<->n member

// Band n<->n member
// Library 1<->n member


- (WTMBehavior*)createBehaviorMemberInLibrary:(WTMLibrary*)library;

- (WTMHtml*)createHtmlMemberInLibrary:(WTMLibrary*)library;

- (WTMVideo*)createVideoMemberInLibrary:(WTMLibrary*)library;

- (WTMImage*)createImageMemberInLibrary:(WTMLibrary*)library;

- (WTMSound*)createSoundMemberInLibrary:(WTMLibrary*)library;

- (WTMPdf*)createPdfMemberInLibrary:(WTMLibrary*)library;

- (WTMHyperlink*)createHyperlinkMemberInLibrary:(WTMLibrary*)library;

- (WTMLabel*)createLabelMemberInLibrary:(WTMLibrary*)library;

- (void)purgeMemberIfNecessary:(WTMMember*)member;

// Removing member  will remove and force the purge.
- (void)removeMember:(WTMMember*)member;


#pragma mark localization

//You should normaly not call directly that method
//This method is called from WTMObject from the @selector(localize) implementation.
//Calls the localizationDelegate if it is set or invokes the default implementation
- (void)localize:(WattObject*)reference withKey:(NSString*)key andValue:(id)value;


#pragma mark - relative path and path discovery

- (NSString*)absolutePathFromRelativePath:(NSString *)relativePath;
- (NSArray*)absolutePathsFromRelativePath:(NSString *)relativePath all:(BOOL)returnAll;

#pragma  mark - file paths 

// The current applicationDocumentDirectory
- (NSString*)applicationDocumentsDirectory;

// The absolute of the registry file
- (NSString*)absolutePathForRegistryFileWithName:(NSString*)name;
    
// The absolute path of the registry bundle 
- (NSString*)absolutePathForRegistryBundleWithName:(NSString*)name;


#pragma mark - files 

- (BOOL)writeData:(NSData*)data toPath:(NSString*)path;
- (NSData*)readDataFromPath:(NSString*)path;
- (BOOL)createRecursivelyRequiredFolderForPath:(NSString*)path;

#pragma mark - File serialization / deserialization

-(BOOL)writeRegistry:(WattRegistry*)registry toFile:(NSString*)path;
-(WattRegistry*)readRegistryFromFile:(NSString*)path;



#pragma mark - utilities 
- (NSString *)uuidString;

- (void)raiseExceptionWithFormat:(NSString *)format, ... NS_FORMAT_FUNCTION(1,2);

- (void)wattTodo:(NSString*)message; // A way to mark the job to be done;
@end

#pragma mark localization delegate prototocol

// You can implement this protocol if you want to customize the internationalization process.
@protocol WTMlocalizationDelegateProtocol <NSObject>
@required
- (void)localize:(id)reference withKey:(NSString*)key andValue:(id)value;
@end

#