//
//  WTMApi.h
//  PlayerSample
//
//  Created by Benoit Pereira da Silva on 10/08/13.
//  Copyright (c) 2013 Pereira da Silva. All rights reserved.
//

#import "WattApi.h"

@interface WTMApi : WattApi

// WattMApi singleton accessor
+ (WTMApi*)sharedInstance;

#pragma mark - /// MULTIMEDIA API ///


#pragma mark -Shelf

// Creates a shelf, a user , the local group, a package with a shared lib ...
-(WTMShelf*)createShelfWithName:(NSString*)name;

// A facility to generate symboliclink for package and libraries
- (void)generateSymbolicLinkForShelf:(WTMShelf*)shelf;

// No remove method actually (need to be analyzed)

#pragma mark - User and groups

- (WattUser*)createUserInShelf:(WTMShelf*)shelf;
- (WattGroup*)createGroupInShelf:(WTMShelf*)shelf;
- (void)addUser:(WattUser*)user toGroup:(WattGroup*)group;

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



@end
