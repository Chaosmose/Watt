//
//  WTMApi.m
//  PlayerSample
//
//  Created by Benoit Pereira da Silva on 10/08/13.
//  Copyright (c) 2013 Pereira da Silva. All rights reserved.
//

#import "WTMApi.h"

/*
 
 Best Pratices ?
 
 The Model are generated using Flexions so the code quality is constant and fix can be done by re-generating
 The api should be absolutely waterproof i ve listed a few rules to respect.
 
 1- Any required argument that is not set should raise :
 if(!arg)
 [self raiseExceptionWithFormat:@"arg is nil in %@",NSStringFromSelector(@selector(selectorName:))];
 
 2- Most of the calls should begin with an ACL Control
 if([self user:_me canPerform:WattWRITE onObject:object]){
 }
 return nil;
 
 */

@implementation WTMApi

+ (WTMApi*)sharedInstance {
    static WTMApi *sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[self alloc] init];
    });
    return sharedInstance;
}



#pragma mark - MULTIMEDIA API


#pragma mark - /// SHELF ///
#pragma mark -


/**
 *  Create a shelf and a new registry
 *
 *  @param pool       pool description
 *
 *  @return The shelf
 */
-(WTMShelf*)createShelfInPool:(WattRegistryPool*)pool{
    
    // IMPORTANT WE CREATE A NEW REGISTRY
    WattRegistry *registry=[pool registryWithUidString:nil];
    WTMShelf *shelf=[[WTMShelf alloc] initInRegistry:registry];
    if(!self.me){
        self.me=[self createUserInShelf:shelf];
        self.me.objectName=kWattMe;
        WattGroup *group=[self createGroupInShelf:shelf];
        group.name=kWattMyGroupName;
        group.objectName=kWattMyGroup;
        [self addUser:self.me toGroup:group];
    }
    return shelf;
}



#pragma mark - User and groups

- (WattUser*)createUserInShelf:(WTMShelf*)shelf{
    if(!shelf)
        [self raiseExceptionWithFormat:@"shelf is nil in %@",NSStringFromSelector(@selector(createUserInShelf:))];
    
    WattUser *user=[[WattUser alloc]initInRegistry:shelf.registry];
    [shelf.users_auto addObject:user];
    user.identity=[shelf.registry.pool uuidStringCreate];
    
    return user;
}

- (WattGroup*)createGroupInShelf:(WTMShelf*)shelf{
    if(!shelf)
        [self raiseExceptionWithFormat:@"shelf is nil in %@",NSStringFromSelector(@selector(createGroupInShelf:))];
    
    WattGroup *group=[[WattGroup alloc]initInRegistry:shelf.registry];
    [shelf.groups_auto addObject:group];
    
    return group;
}

- (void)addUser:(WattUser*)user toGroup:(WattGroup*)group{
    if(!user)
        [self raiseExceptionWithFormat:@"user is nil in %@",NSStringFromSelector(@selector(addUser:toGroup:))];
    if(!group)
        [self raiseExceptionWithFormat:@"group is nil in %@",NSStringFromSelector(@selector(addUser:toGroup:))];
    
    [group.users_auto addObject:user];
    [user setGroup:group];
}


#pragma mark - Menus & section


- (WTMMenuSection*)createSectionInShelf:(WTMShelf*)shelf{
    if(!shelf)
        [self raiseExceptionWithFormat:@"shelf is nil in %@",NSStringFromSelector(@selector(createSectionInShelf:))];
    
    if([self actionIsAllowed:WattWRITE on:shelf]){
        WTMMenuSection *section=[[WTMMenuSection alloc]initInRegistry:shelf.registry];
        section.index=[shelf.sections_auto count];//We compute the index
        [shelf.sections_auto addObject:section];
        section.shelf=shelf;
        section.index=[shelf.sections count];
        return section;
    }
    return nil;
}

- (void)removeSection:(WTMMenuSection*)section{
    if([self actionIsAllowed:WattWRITE on:section]){
        [section.shelf.sections removeObject:section];
        [section.menus enumerateObjectsUsingBlock:^(WTMMenu *obj, NSUInteger idx, BOOL *stop) {
            [self removeMenu:obj];
        }reverse:YES];
        section.shelf=nil;
        [section autoUnRegister];
    }
}

- (WTMMenu*)createMenuInSection:(WTMMenuSection*)section{
    if([self actionIsAllowed:WattWRITE on:section]){
        WTMMenu *menu=[[WTMMenu alloc] initInRegistry:section.shelf.registry];
        [section.menus_auto addObject:menu];
        menu.menuSection=section;
        menu.index=[section.menus count];
        return menu;
    }
    return nil;
}


- (void)removeMenu:(WTMMenu*)menu{
    if([self actionIsAllowed:WattWRITE on:menu]){
        [self _removeFilesWithRelativesPath:menu.pictureRelativePath inRegistry:menu.registry];
        [menu.menuSection.menus removeObject:menu];
        [menu autoUnRegister];
    }
}


#pragma mark - /// PACKAGE ///
#pragma mark -

- (WTMPackage*)createPackageInPool:(WattRegistryPool*)pool{
    
    // IMPORTANT WE CREATE A NEW REGISTRY
    WattRegistry *registry=[pool registryWithUidString:nil];
    WTMPackage *package=[[WTMPackage alloc] initInRegistry:registry];
    package.objectName=[pool uuidStringCreate];// We create a uuid for each package and library to deal with linked assets
        
    // We create a default library
    WTMLibrary*library=[self createLibraryInPackage:package];
    library.category=kCategoryNameShared;

    return package;
}


- (void)removePackage:(WTMPackage*)package{
    if([self actionIsAllowed:WattWRITE on:package]){
        [package.registry.pool trashRegistry:package.registry];
        //[package.registry.pool emptyTheTrash];// We currently do not empty the trash
    }
}


#pragma mark - Library

- (WTMLibrary*)createLibraryInPackage:(WTMPackage*)package{
    if(!package)
        [self raiseExceptionWithFormat:@"package is nil in %@",NSStringFromSelector(@selector(createLibraryInPackage:))];
    if([self actionIsAllowed:WattWRITE on:package]){
        WTMLibrary *library=[[WTMLibrary alloc] initInRegistry:package.registry];
        library.objectName=[package.registry.pool uuidStringCreate];// We create a uuid for each package and library to deal with linked assets
        [package.libraries_auto addObject:library];
        [library setPackage:package];
        return library;
    }
    return nil;
}


- (void)removeLibrary:(WTMLibrary*)library{
    if([self actionIsAllowed:WattWRITE on:library.package]){
        
        [library.members enumerateObjectsUsingBlock:^(WTMMember *obj, NSUInteger idx, BOOL *stop) {
            [self removeMember:obj];
        }reverse:YES];
        
        [library.package.libraries removeObject:library];
        [library autoUnRegister];
    }
}



#pragma mark - Activity

- (WTMActivity*)createActivityInPackage:(WTMPackage*)package{
    if(!package)
        [self raiseExceptionWithFormat:@"package is nil in %@",NSStringFromSelector(@selector(createActivityInPackage:))];
    if([self actionIsAllowed:WattWRITE on:package]){
        WTMActivity *activity=[[WTMActivity alloc] initInRegistry:package.registry];
        [package.activities_auto addObject:activity];
        activity.package=package;
        return activity;
    }
    return nil;
}

- (void)removeActivity:(WTMActivity*)activity{
    if([self actionIsAllowed:WattWRITE on:activity]){
        [activity.package.activities removeObject:activity];
        [activity autoUnRegister];
    }
}


#pragma mark - Scene

- (WTMScene*)createSceneInActivity:(WTMActivity*)activity{
    if(!activity)
        [self raiseExceptionWithFormat:@"activity is nil in %@",NSStringFromSelector(@selector(createSceneInActivity:))];
    if([self actionIsAllowed:WattWRITE on:activity]){
        WTMScene*scene=[[WTMScene alloc]initInRegistry:activity.registry];
        [activity.scenes_auto addObject:scene];
        scene.activity=activity;
        scene.table_auto.scene=scene;
        return scene;
        
    }
    return nil;
}

- (void)removeScene:(WTMScene*)scene{
    if([self actionIsAllowed:WattWRITE on:scene]){
        if(scene.picture)
            [self purgeMemberIfNecessary:scene.picture];
        [scene.elements enumerateObjectsUsingBlock:^(WTMElement *obj, NSUInteger idx, BOOL *stop) {
            [self removeElement:obj];
        }reverse:YES];
        [scene.activity.scenes removeObject:scene];
        [scene autoUnRegister];
        if([scene.behaviors count]>0){
            WTMApi *__weak weakSelf=self;
            [scene.behaviors enumerateObjectsUsingBlock:^(WTMBehavior *obj, NSUInteger idx, BOOL *stop) {
                [weakSelf purgeMemberIfNecessary:obj];
            } reverse:YES];
            
        }
        
    }
}


#pragma mark - Table

- (WTMTable*)createTableInSceneIfNecessary:(WTMScene*)scene{
    WTMTable*table=scene.table_auto;
    table.scene=scene;
    return table;
}

- (void)removeTable:(WTMTable*)table{
    table.scene=nil;
    WTMApi *__weak weakSelf=self;
    [table.columns enumerateObjectsUsingBlock:^(WTMColumn *obj, NSUInteger idx, BOOL *stop) {
        [weakSelf removeColumn:obj];
    } reverse:YES];
}

#pragma mark - Column and line

- (WTMColumn*)createColumnInTableOfScene:(WTMScene*)scene{
    WTMTable *table=[self createTableInSceneIfNecessary:scene];
    WTMColumn*column=[[WTMColumn alloc] initInRegistry:scene.registry];
    [table.columns_auto addObject:column];
    column.table=table;
    return column;
}

- (WTMLine*)createLineInTableOfScene:(WTMScene*)scene{
    WTMTable *table=[self createTableInSceneIfNecessary:scene];
    WTMLine*line=[[WTMLine alloc] initInRegistry:scene.registry];
    [table.lines_auto addObject:line];
    line.table=table;
    return line;
}

#pragma mark - Element


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
                              inScene:(WTMScene*)scene{
    if(!scene)
        [self raiseExceptionWithFormat:@"scene is nil in %@",NSStringFromSelector(@selector(createElementWithAsset:andBehavior:inScene:))];
    if(!asset)
        [self raiseExceptionWithFormat:@"asset is nil in %@",NSStringFromSelector(@selector(createElementWithAsset:andBehavior:inScene:))];
    // Behavior is optionnal
    
    if([self actionIsAllowed:WattWRITE on:scene.activity]){
        WTMElement *element=[[WTMElement alloc] initInRegistry:asset.registry];
        element.asset=asset;
        element.scene=scene;
        if(behavior){
            [element.behaviors_auto addObject:behavior];
            behavior.refererCounter++;
        }
        asset.refererCounter++;
        [scene.elements_auto addObject:element];
        
        return element;
    }
    return nil;
}


/**
 *  Removes and unregisters the element and all it cells.
 *
 *  @param element the WTMELement to be removed from the scene.
 */
- (void)removeElement:(WTMElement*)element{
    if([self actionIsAllowed:WattWRITE on:element]){
        
        [element.scene.elements removeObject:element];
        element.scene=nil;
        
        [element.cells enumerateObjectsUsingBlock:^(WTMCell *obj, NSUInteger idx, BOOL *stop) {
            [self removeCell:obj];
        }reverse:YES];
        
        [self purgeMemberIfNecessary:element.asset];
        
        WTMApi *__weak weakSelf=self;
        [element.behaviors enumerateObjectsUsingBlock:^(WTMBehavior *obj, NSUInteger idx, BOOL *stop) {
            [weakSelf purgeMemberIfNecessary:obj];
        } reverse:YES];
        
        [element autoUnRegister];
    }
}

/**
 *  Creates a new line in the column, and a cell referecing an element
 *
 *  @param element    an element is an "occurence" of a member
 *  @param attributes a dictionary with key, value attributes
 *  @param column     the destination column, if nil a new column is created
 *
 *  @return a new WTMcell.
 */
- (WTMCell*)createCellInANewLineFor:(WTMElement*)element
                     withAttributes:(NSDictionary*)attributes
                           inColumn:(WTMColumn*)column{
    
    if(!element)
        [self raiseExceptionWithFormat:@"element is nil in %@",NSStringFromSelector(@selector(createCellInANewLineFor:withAttributes:inColumn:))];
    
    if(!element.scene)
        [self raiseExceptionWithFormat:@"element.scene is nil in %@",NSStringFromSelector(@selector(createCellInANewLineFor:withAttributes:inColumn:))];
    
    
    WTMTable *table=[self createTableInSceneIfNecessary:element.scene];
    if(!column)
        column=[self createColumnInTableOfScene:element.scene];
    
    
    WTMLine *line=[[WTMLine alloc] initInRegistry:element.registry];
    [table.lines_auto addObject:line];
    line.table=table;
    
    
    WTMCell *cell=[[WTMCell alloc] initInRegistry:element.registry];
    cell.column=column;
    cell.line=line;
    cell.element=element;
    cell.attributes=attributes;
    
    [line.cells_auto addObject:cell];
    [column.cells_auto addObject:cell];
    
    return cell;
}


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
                               inLine:(WTMLine*)line{
    
    if(!element)
        [self raiseExceptionWithFormat:@"element is nil in %@",NSStringFromSelector(@selector(createCellInANewColumnFor:withAttributes:inLine:))];
    
    if(!element.scene)
        [self raiseExceptionWithFormat:@"element.scene is nil in %@",NSStringFromSelector(@selector(createCellInANewColumnFor:withAttributes:inLine:))];
    
    
    WTMTable *table=[self createTableInSceneIfNecessary:element.scene];
    if(!line){
        line=[[WTMLine alloc] initInRegistry:element.registry];
        [table.lines_auto addObject:line];
        line.table=table;
    }
    
    WTMColumn *column=[[WTMColumn alloc] initInRegistry:element.registry];
    [table.columns_auto addObject:column];
    column.table=table;
    
    WTMCell *cell=[[WTMCell alloc] initInRegistry:element.registry];
    cell.column=column;
    cell.line=line;
    cell.element=element;
    cell.attributes=attributes;
    
    [line.cells_auto addObject:cell];
    [column.cells_auto addObject:cell];
    
    return cell;
}


/**
 *  Removes the colum and all its cells.
 *
 *  @param column to be removed
 */
- (void)removeColumn:(WTMColumn*)column{
    [column.cells_auto enumerateObjectsUsingBlock:^(WTMCell *obj, NSUInteger idx, BOOL *stop) {
        [self removeCell:obj];
    }reverse:YES];
    [column.table.columns removeObject:column];
    [column autoUnRegister];
}

/**
 *  Removes the line and all its cells.
 *
 *  @param line to be removed
 */
- (void)removeLine:(WTMLine*)line{
    [line.cells_auto enumerateObjectsUsingBlock:^(WTMCell *obj, NSUInteger idx, BOOL *stop) {
        [self removeCell:obj];
    }reverse:YES];
    [line.table.lines removeObject:line];
    [line autoUnRegister];
}



/**
 *  Removes and unregisters the cell
 *  But preserves the element,in the scene
 *  and preserves the column and the line
 *
 *  @param cell the cell to be removed.
 */
-(void)removeCell:(WTMCell*)cell{
    
    [cell.element.cells removeObject:cell];
    cell.element=nil;
    
    [cell.line.cells removeObject:cell];
    [cell.column.cells removeObject:cell];
    
    cell.line=nil;
    cell.column=nil;
    [cell autoUnRegister];
}





#pragma mark -  Members

// Use this section of the api to add member.
// The underlining refererCounter is automaticly managed
// Purging  a member or band from a library can automatically delete the linked files

// Linked assets dependencies
// Library 1<->n member

// Band n<->n member
// Library 1<->n member


- (WTMBehavior*)createBehaviorMemberInLibrary:(WTMLibrary*)library{
    WTMBehavior *instance=[[WTMBehavior alloc]initInRegistry:library.registry];
    [self _addMember:instance toLibrary:library];
    return instance;
}

- (WTMHtml*)createHtmlMemberInLibrary:(WTMLibrary*)library{
    WTMHtml *instance=[[WTMHtml alloc]initInRegistry:library.registry];
    [self _addMember:instance toLibrary:library];
    return instance;
}

- (WTMVideo*)createVideoMemberInLibrary:(WTMLibrary*)library{
    WTMVideo *instance=[[WTMVideo alloc]initInRegistry:library.registry];
    [self _addMember:instance toLibrary:library];
    return instance;
}

- (WTMImage*)createImageMemberInLibrary:(WTMLibrary*)library{
    WTMImage *instance=[[WTMImage alloc]initInRegistry:library.registry];
    [self _addMember:instance toLibrary:library];
    return instance;
}

- (WTMSound*)createSoundMemberInLibrary:(WTMLibrary*)library{
    WTMSound *instance=[[WTMSound alloc]initInRegistry:library.registry];
    [self _addMember:instance toLibrary:library];
    return instance;
}

- (WTMPdf*)createPdfMemberInLibrary:(WTMLibrary*)library{
    WTMPdf *instance=[[WTMPdf alloc]initInRegistry:library.registry];
    [self _addMember:instance toLibrary:library];
    return instance;
}

- (WTMHyperlink*)createHyperlinkMemberInLibrary:(WTMLibrary*)library{
    WTMHyperlink *instance=[[WTMHyperlink alloc]initInRegistry:library.registry];
    [self _addMember:instance toLibrary:library];
    return instance;
}

- (WTMLabel*)createLabelMemberInLibrary:(WTMLibrary*)library{
    WTMLabel *instance=[[WTMLabel alloc]initInRegistry:library.registry];
    [self _addMember:instance toLibrary:library];
    return instance;
}


- (void)_addMember:(WTMMember*)member
         toLibrary:(WTMLibrary*)library {
    if([self actionIsAllowed:WattWRITE on:library]){
        if(!member)
            [self raiseExceptionWithFormat:@"member  is nil in %@",NSStringFromSelector(@selector(_addMember:toLibrary:))];
        if(!library)
            [self raiseExceptionWithFormat:@"library  is nil in %@",NSStringFromSelector(@selector(_addMember:toLibrary:))];
        
        [library.members_auto addObject:member];
        member.library=library;
        member.refererCounter++;
    }
}


// A facility that deals with the refererCounter to decide if the member should be deleted;
// It also delete the linked files if necessary
- (void)purgeMemberIfNecessary:(WTMMember*)member{
    if([self actionIsAllowed:WattWRITE on:member]){
        member.refererCounter--;
        if(member.refererCounter<=0){
            [self removeMember:member];
        }
    }
}


// Removing member  will remove and force the purge.
- (void)removeMember:(WTMMember*)member{
    NSString *relativePath=nil;
    // Deletion of dependent files
    if([member respondsToSelector:@selector(relativePath)]){
        relativePath=[member performSelector:@selector(relativePath)];
    }else if ([member respondsToSelector:@selector(urlString)]){
        relativePath=[member performSelector:@selector(urlString)];
    }
    if(relativePath){
        [self _removeFilesWithRelativesPath:relativePath inRegistry:member.registry];
    }
    [member.library.members removeObject:member];
    [member autoUnRegister];
}



#pragma  mark - file removal 


- (void)_removeFilesWithRelativesPath:(NSString*)relativePath inRegistry:(WattRegistry*)registry{
    NSArray *absolutePaths=[registry.pool absolutePathsFromRelativePath:relativePath inBundleWithName:registry.uidString all:YES];
    for (NSString *pathToDelete in absolutePaths) {
        [registry.pool removeItemAtPath:pathToDelete];
    }

}


@end