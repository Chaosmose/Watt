//
//  WTMApi.m
//  PlayerSample
//
//  Created by Benoit Pereira da Silva on 10/08/13.
//  Copyright (c) 2013 Pereira da Silva. All rights reserved.
//

#import "WTMApi.h"

@implementation WTMApi

+ (WTMApi*)sharedInstance {
    static WTMApi *sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[self alloc] init];
        [sharedInstance configureOnce];
    });
    return sharedInstance;
}

- (void)configureOnce{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        [super configureOnce];
    });
}


#pragma mark - MULTIMEDIA API



#pragma mark -Shelf


- (WTMShelf*)createShelfWithName:(NSString*)name{
    
    WTMShelf *shelf=[[WTMShelf alloc] initInRegistry:self.currentRegistry];
    shelf.name=name;
    
    if(!self.me){
        self.me=[self createUserInShelf:shelf];
        self.me.objectName=kWattMe;
        WattGroup *group=[self createGroupInShelf:shelf];
        group.name=kWattMyGroupName;
        group.objectName=kWattMyGroup;
        [self addUser:self.me toGroup:group];
    }
    
    WTMPackage*package=[self createPackageInShelf:shelf];
    package.category=kCategoryNameShared;
    
    
    
    return shelf;
}

// A facility to generate symboliclink for package and libraries
- (void)generateSymbolicLinkForShelf:(WTMShelf*)shelf{
    if(shelf){
        [shelf.packages enumerateObjectsUsingBlock:^(WTMPackage *obj, NSUInteger idx, BOOL *stop) {
            if(obj.name && obj.objectName){
                NSError *error=nil;
                NSString *pb=[self absolutePathForRegistryBundleWithName:self.currentRegistry.name];
                
                NSString *s=[pb stringByAppendingString:obj.objectName ];
                NSString *d=[pb stringByAppendingString:[obj.name stringByReplacingOccurrencesOfString:@" " withString:@"-"] ];
                
                if([self.fileManager fileExistsAtPath:s] && ![self.fileManager fileExistsAtPath:d]){
                    [self.fileManager createSymbolicLinkAtPath:d
                                              withDestinationPath:s
                                                            error:&error];
                    if(error){
                        WTLog(@"Error :%@",[error localizedDescription]);
                    }
                }
                // Libraries
                [obj.libraries enumerateObjectsUsingBlock:^(WTMLibrary *obj, NSUInteger idx, BOOL *stop) {
                    NSError *error=nil;
                    NSString *ls=[s stringByAppendingFormat:@"/%@",obj.objectName];
                    NSString *ld=[d stringByAppendingFormat:@"/%@",[obj.name stringByReplacingOccurrencesOfString:@" " withString:@"-"]];
                    if([self.fileManager fileExistsAtPath:ls] && ![self.fileManager fileExistsAtPath:ld]){
                        
                        [self.fileManager createSymbolicLinkAtPath:ld
                                                  withDestinationPath:ls
                                                                error:&error];
                        if(error){
                            WTLog(@"Error :%@",[error localizedDescription]);
                        }
                    }
                    
                }];
                
            }
        }];
    }
}



#pragma mark - User and groups

- (WattUser*)createUserInShelf:(WTMShelf*)shelf{
    if(!shelf)
        [self raiseExceptionWithFormat:@"shelf is nil in %@",NSStringFromSelector(@selector(createUserInShelf:))];
    
    WattUser *user=[[WattUser alloc]initInRegistry:self.currentRegistry];
    [shelf.users_auto addObject:user];
    user.identity=[self uuidString];
    
    return user;
}

- (WattGroup*)createGroupInShelf:(WTMShelf*)shelf{
    if(!shelf)
        [self raiseExceptionWithFormat:@"shelf is nil in %@",NSStringFromSelector(@selector(createGroupInShelf:))];
    
    WattGroup *group=[[WattGroup alloc]initInRegistry:self.currentRegistry];
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
        WTMMenuSection *section=[[WTMMenuSection alloc]initInRegistry:self.currentRegistry];
        section.index=[shelf.sections_auto count];//We compute the index
        [shelf.sections_auto addObject:section];
        section.shelf=shelf;
        return section;
    }
    return nil;
}

- (void)removeSection:(WTMMenuSection*)section{
    if([self actionIsAllowed:WattWRITE on:section]){
        [section.shelf.sections removeObject:section];
        [section.menus enumerateObjectsUsingBlock:^(WTMMenu *obj, NSUInteger idx, BOOL *stop) {
            [self removeMenu:obj];
        }];
        section.shelf=nil;
        [section autoUnRegister];
    }
}

- (WTMMenu*)createMenuInSection:(WTMMenuSection*)section{
    if([self actionIsAllowed:WattWRITE on:section]){
        WTMMenu *menu=[[WTMMenu alloc] initInRegistry:self.currentRegistry];
        [section.menus_auto addObject:menu];
        menu.menuSection=section;
        return menu;
    }
    return nil;
}


- (void)removeMenu:(WTMMenu*)menu{
    if([self actionIsAllowed:WattWRITE on:menu]){
        if(menu.picture){
            [self purgeMemberIfNecessary:menu.picture];
        }
        [menu.menuSection.menus removeObject:menu];
        [menu autoUnRegister];
    }
}



#pragma mark - Package

- (WTMPackage*)createPackageInShelf:(WTMShelf*)shelf{
    if(!shelf)
        [self raiseExceptionWithFormat:@"shelf is nil in %@",NSStringFromSelector(@selector(createPackageInShelf:))];
    if([self actionIsAllowed:WattWRITE on:shelf]){
        if(!shelf)
            [self raiseExceptionWithFormat:@"shelf is nil in %@",NSStringFromSelector(@selector(createPackageInShelf:))];
        WTMPackage *package=[[WTMPackage alloc] initInRegistry:self.currentRegistry];
        package.objectName=[self uuidString];// We create a uuid for each package and library to deal with linked assets
        [shelf.packages_auto addObject:package];
        [package langDictionary_auto];
        package.shelf=shelf;
        
        // We create a default library
        WTMLibrary*library=[self createLibraryInPackage:package];
        library.category=kCategoryNameShared;
        
        return package;
    }
    return nil;
}


- (void)removePackage:(WTMPackage*)package{
    if([self actionIsAllowed:WattWRITE on:package]){
        
        if(package.picture)
            [self purgeMemberIfNecessary:package.picture];
        
        [package.activities enumerateObjectsUsingBlock:^(WTMActivity *obj, NSUInteger idx, BOOL *stop) {
            [self removeActivity:obj];
        }];
        
        [package.libraries enumerateObjectsUsingBlock:^(WTMLibrary *obj, NSUInteger idx, BOOL *stop) {
            [self removeLibrary:obj];
        }];
        
        [package.langDictionary autoUnRegister];
        
        [package.shelf.packages removeObject:package];
        package.shelf=nil;
        [package autoUnRegister];
    }
}

// Immport process this method can move a package from a registry to another
// Producing renamming of assets and performing re-identification including ACL
- (void)addPackage:(WTMPackage*)package
           toShelf:(WTMShelf*)shelf{
#warning todo
    if(!package)
        [self raiseExceptionWithFormat:@"package is nil in %@",NSStringFromSelector(@selector(addPackage:toShelf:))];
    if(!shelf)
        [self raiseExceptionWithFormat:@"shelf is nil in %@",NSStringFromSelector(@selector(addPackage:toShelf:))];
    if([self actionIsAllowed:WattWRITE on:shelf]){
        
        
    }
}

- (NSArray*)dependenciesPathForPackage:(WTMPackage*)package{
    NSMutableArray *array=[NSMutableArray array];
    [package.libraries_auto enumerateObjectsUsingBlock:^(WTMLibrary *obj, NSUInteger idx, BOOL *stop) {
        [array addObjectsFromArray:[self dependenciesPathForLibrary:obj]];
    }];
    return array;
}



#pragma mark - Library

- (WTMLibrary*)createLibraryInPackage:(WTMPackage*)package{
    if(!package)
        [self raiseExceptionWithFormat:@"package is nil in %@",NSStringFromSelector(@selector(createLibraryInPackage:))];
    if([self actionIsAllowed:WattWRITE on:package]){
        WTMLibrary *library=[[WTMLibrary alloc] initInRegistry:self.currentRegistry];
        library.objectName=[self uuidString];// We create a uuid for each package and library to deal with linked assets
        [package.libraries_auto addObject:library];
        [library setPackage:package];
        return library;
    }
    return nil;
}


- (void)removeLibrary:(WTMLibrary*)library{
    if([self actionIsAllowed:WattWRITE on:library.package]){
        
        [library.bands enumerateObjectsUsingBlock:^(WTMBand *obj, NSUInteger idx, BOOL *stop) {
            [self removeBand:obj];
        }];
        
        [library.members enumerateObjectsUsingBlock:^(WTMMember *obj, NSUInteger idx, BOOL *stop) {
            [self removeMember:obj];
        }];
        
        [library.package.libraries removeObject:library];
        [library autoUnRegister];
    }
}

- (NSArray*)dependenciesPathForLibrary:(WTMLibrary*)library{
    if(!library)
        [self raiseExceptionWithFormat:@"library is nil in %@",NSStringFromSelector(@selector(dependenciesPathForLibrary:))];
    NSMutableArray *array=[NSMutableArray array];
    [library.members_auto enumerateObjectsUsingBlock:^(WTMMember *obj, NSUInteger idx, BOOL *stop) {
        NSArray *pths=[self absolutePathsFromRelativePath:obj.thumbnailRelativePath all:YES];
        if(pths){
            [array addObjectsFromArray:pths];
        }
        if([[obj propertiesKeys] indexOfObject:@"relativePath"]!=NSNotFound){
            pths=[self absolutePathsFromRelativePath:[obj valueForKey:@"relativePath"] all:YES];
            if(pths){
                [array addObjectsFromArray:pths];
            }
        }
    }];
    return array;
}


#pragma mark - Activity

- (WTMActivity*)createActivityInPackage:(WTMPackage*)package{
    if(!package)
        [self raiseExceptionWithFormat:@"package is nil in %@",NSStringFromSelector(@selector(createActivityInPackage:))];
    if([self actionIsAllowed:WattWRITE on:package]){
        WTMActivity *activity=[[WTMActivity alloc] initInRegistry:self.currentRegistry];
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
        WTMScene*scene=[[WTMScene alloc]initInRegistry:self.currentRegistry];
        [activity.scenes_auto addObject:scene];
        scene.activity=activity;
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
        }];
        [scene.activity.scenes removeObject:scene];
        [scene autoUnRegister];
        if(scene.behavior){
            [self purgeMemberIfNecessary:scene.behavior];
        }
        
    }
}

#pragma mark - Element

- (WTMElement*)createElementInScene:(WTMScene*)scene
                          withAsset:(WTMAsset*)asset
                        andBehavior:(WTMBehavior*)behavior{
    if(!scene)
        [self raiseExceptionWithFormat:@"scene is nil in %@",NSStringFromSelector(@selector(createElementInScene:withAsset:andBehavior:))];
    if(!asset)
        [self raiseExceptionWithFormat:@"asset is nil in %@",NSStringFromSelector(@selector(createElementInScene:withAsset:andBehavior:))];
    // Behavior is optionnal
    
    if([self actionIsAllowed:WattWRITE on:scene.activity]){
        WTMElement *element=[[WTMElement alloc] initInRegistry:self.currentRegistry];
        element.scene=scene;
        element.asset=asset;
        if(behavior){
            element.behavior=behavior;
            element.behavior.refererCounter++;
        }
        asset.refererCounter++;
        [scene.elements addObject:element];
    }
    return nil;
}


- (void)removeElement:(WTMElement*)element{
    if([self actionIsAllowed:WattWRITE on:element]){
        [element.scene.elements removeObject:element];
        element.scene=nil;
        [self purgeMemberIfNecessary:element.asset];
        [self purgeMemberIfNecessary:element.behavior];
        [element autoUnRegister];
    }
}

#pragma mark -  Bands

// Bands
- (WTMBand*)createBandInLibrary:(WTMLibrary*)library
                    withMembers:(NSArray*)members{
    if([self actionIsAllowed:WattWRITE on:library]){
        WTMBand *band=[[WTMBand alloc] initInRegistry:self.currentRegistry];
        band.library=library;
        [library.bands_auto addObject:band];
        for (WTMMember *member in members) {
            // We do verify the casting
            if([member isKindOfClass:[WTMMember class]]){
                [band.members_auto addObject:member];
            }else{
                [self raiseExceptionWithFormat:@"Attempt to add %@ in a non WTM Member %@",member,NSStringFromSelector(@selector(createBandInLibrary:withMembers:))];
            }
        }
        return band;
    }
    return nil;
}

- (void)purgeBandIfNecessary:(WTMBand*)band{
    if([self actionIsAllowed:WattWRITE on:band]){
        [band.members enumerateObjectsUsingBlock:^(WTMMember *obj, NSUInteger idx, BOOL *stop) {
            [self purgeMemberIfNecessary:obj];
        }];
        [band.library.bands removeObject:band];
        band.members=nil;
        [band autoUnRegister];
    }
}


// Removing band  will remove and force the purge.
- (void)removeBand:(WTMBand*)band{
    [band.members enumerateObjectsUsingBlock:^(WTMMember *obj, NSUInteger idx, BOOL *stop) {
        [self removeMember:obj];
    }];
    [band.library.bands removeObject:band];
    band.members=nil;
    [band autoUnRegister];
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
    
    // Deletion of dependent files
    if([member respondsToSelector:@selector(relativePath)]){
        NSString *relativePath=[member performSelector:@selector(relativePath)];
        if(relativePath){
            NSArray *absolutePaths=[self absolutePathsFromRelativePath:relativePath
                                                                   all:YES];
            for (NSString *pathToDelete in absolutePaths) {
                NSError *error=nil;
                [self.fileManager removeItemAtPath:pathToDelete
                                                error:&error];
                if(error){
                    WTLog(@"Impossible to delete %@",pathToDelete);
                }
            }
        }
    }
    [member.library.members removeObject:member];
    [member autoUnRegister];
    
}



@end
