//
//  WTMApi.h
//  PlayerSample
//
//  Created by Benoit Pereira da Silva on 10/08/13.
//  Copyright (c) 2013 Pereira da Silva. All rights reserved.
//

#import "WTM.h"
//Import of flexion generated classes
#import "WTMModelsImports.h"



// WTM is a cross platform authoring and runtime
// to developp multimedia project
// That intent to be fully supported by mac os X and IOS

// Port to Java targetting Android & non android system soon.
// Watt is a model driven framework relying on files.
//

/*
 
    WTMShelf defines menus and hierarchy of multimedia packages.
    A WTMPackage contains assets and data for bunches of activities.
    
    A shelf organizes the packages, members (Hyperlink,etc), activities.
    A shelf is in a specific registry (loosely coupled with packages by external references)
 
 */


/**
 * The WTM Api 
 */
@interface WTMApi : WattACL

@property (nonatomic,strong)WattRegistryFilesUtils *utils;

/**
 *  Its singleton accessor
 *
 *  @return the unique instance of WTMApi
 */
+ (WTMApi*)sharedInstance;

#pragma mark - /// SHELF ///
#pragma mark -


/**
 *  Create a shelf in a new registry and add it to the pool
 *
 *  @param pool              the pool
 *  @param registryUidString the registryUidString or nil
 *
 *  @return The shelf
 */
-(WTMShelf*)createShelfInPool:(WattRegistryPool*)pool
        withRegistryUidString:(NSString*)registryUidString;

#pragma mark - User and groups

/**
 *  Creates a user on
 *
 *  @param shelf The shelf
 *
 *  @return the user
 */
- (WattUser*)createUserInShelf:(WTMShelf*)shelf;

/**
 *  Creates a group
 *
 *  @param shelf the shelf
 *
 *  @return the group
 */
- (WattGroup*)createGroupInShelf:(WTMShelf*)shelf;

/**
 *  Adds a user to a group
 *
 *  @param user  the user
 *  @param group the group
 */
- (void)addUser:(WattUser*)user toGroup:(WattGroup*)group;

// No remove method actually (need to be analyzed)


#pragma mark - Menus & section

/**
 *  Create a section in the shelf
 *
 *  @param shelf the shelf
 *
 *  @return the menu section
 */
- (WTMMenuSection*)createSectionInShelf:(WTMShelf*)shelf;


/**
 *  Creates a menu
 *
 *  @param section   the section
 *  @param object    the menu reference
 *
 *  @return the menu
 */
- (WTMMenu*)createMenuInSection:(WTMMenuSection*)section thatRefersTo:(WattObject*)object;


/**
 * Removes the section and all its menus and derivated files
 *
 *
 *  @param section the section to remove
 */
- (void)removeAndDestroySection:(WTMMenuSection*)section;

/**
 *  Removes a menu from all its menu section and destroys the menu
 *
 *  @param menu the menu to destroy
 */
- (void)removeAndDestroyMenu:(WTMMenu*)menu;

/**
 *  Remove a men from a section but keeps the "menu alive"
 *
 *  @param menu    the menu to remove
 *  @param section the section to update
 */
- (void)removeMenu:(WTMMenu *)menu fromSection:(WTMMenuSection*)section;





#pragma mark - /// PACKAGE ///
#pragma mark -


/**
 *  Creates a package and its default library in a new registry
 *
 *  @param pool              the pool
 *  @param registryUidString the registryUidString or nil
 *
 *  @return The package
 */
-(WTMPackage*)createPackageInPool:(WattRegistryPool*)pool
        withRegistryUidString:(NSString*)registryUidString;


/**
 *  Moves the package and all its dependencies to the trash
 *
 *  @param package the package
 */
- (void)removePackage:(WTMPackage*)package;


#pragma mark - Library

- (WTMLibrary*)createLibraryInPackage:(WTMPackage*)package;
- (void)removeLibrary:(WTMLibrary*)library;


#pragma mark - Activity

- (WTMActivity*)createActivityInPackage:(WTMPackage*)package;
- (void)removeActivity:(WTMActivity*)activity;


#pragma mark - Scene

- (WTMScene*)createSceneInActivity:(WTMActivity*)activity;
- (void)removeScene:(WTMScene*)scene;

#pragma mark - Table 

- (WTMTable*)createTableInSceneIfNecessary:(WTMScene*)scene;
- (void)removeTable:(WTMTable*)table;

#pragma mark - Column

- (WTMColumn*)createColumnInTableOfScene:(WTMScene*)scene;
- (WTMLine*)createLineInTableOfScene:(WTMScene*)scene;

#pragma mark - Element + cells

/**
 *  Creates a new element
 *
 *  @param asset    a valid asset (not nil)
 *  @param behavior optionnal reference to a behavior
 *  @param scene    the parent scene
 *
 *  @return a new WTMELement
 */
- (WTMElement*)createElementWithAsset:(WTMAsset*)asset
                          andBehavior:(WTMBehavior*)behavior
                              inScene:(WTMScene*)scene;


/**
 *  Removes and unregisters the element and all it cells.
 *
 *  @param element the WTMELement to be removed from the scene.
 */
- (void)removeElement:(WTMElement*)element;
    
/**
 *  Creates a new line in the column, and a cell referecing an element
 *  If the element is not
 *
 *  @param element    an element is an "occurence" of a member
 *  @param attributes a dictionary with key, value attributes
 *  @param column     the destination column, if nil a new column is created
 *
 *  @return a new WTMcell.
 */
- (WTMCell*)createCellInANewLineFor:(WTMElement*)element
                     withAttributes:(NSDictionary*)attributes
                           inColumn:(WTMColumn*)column;

/**
 *  Creates a new column in the line, and a cell referencing an element
 *
 *
 *  @param element    an element is an "occurence" of a member
 *  @param attributes a dictionary with key, value attributes
 *  @param column     the destination column, if nil a new column is created
 *
 *  @return a new WTMcell.
 */
- (WTMCell*)createCellInANewColumnFor:(WTMElement*)element
                       withAttributes:(NSDictionary*)attributes
                               inLine:(WTMLine*)line;

/**
 *  Removes the colum and all its cells.
 *
 *  @param column to be removed
 */
- (void)removeColumn:(WTMColumn*)column;

/**
 *  Removes the line and all its cells.
 *
 *  @param line to be removed
 */
- (void)removeLine:(WTMLine*)line;


/**
 *  Removes and unregisters the cell
 *  But preserves the element,in the scene
 *  and preserves the column and the line
 *
 *  @param cell the cell to be removed.
 */
-(void)removeCell:(WTMCell*)cell;

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
