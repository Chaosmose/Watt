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
#import "WTMShelf+WTMShelf_Packages.h"

/**
 * The WTM Api 
 */
@interface WTMApi : WattApi


@property (nonatomic,strong)WattUtils *utils;


/**
 *  Its singleton accessor
 *
 *  @return the unique instance of WTMApi
 */
+ (WTMApi*)sharedInstance;

#pragma mark - /// SHELF ///
#pragma mark -

// Creates a shelf, a user , the local group, a package with a shared lib ...
-(WTMShelf*)createShelfWithName:(NSString*)name inRegistry:(WattRegistry*)registry;

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


#pragma mark - /// PACKAGE ///
#pragma mark -

// Create a package and it default library
- (WTMPackage*)createPackageInShelf:(WTMShelf*)shelf;
- (void)removePackage:(WTMPackage*)package fromShelf:(WTMShelf*)shelf;
// Immport process this method can move a package from a registry to another
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
