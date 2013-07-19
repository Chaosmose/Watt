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
//  WTMApi.m
//
//  Created by Benoit Pereira da Silva on 17/05/13.
//  Copyright (c) 2013 Pereira da Silva. All rights reserved.
//

#import "WattApi.h"

@interface WattApi()
@end

@implementation WattApi{
    WTMUser     *  _system;
    WTMGroup    * _systemGroup;
    Watt_F_TYPE  _ftype;
    NSString    *_applicationDocumentsDirectory;
}

-(void)use:(Watt_F_TYPE)ftype{
    _ftype=ftype;
}

+ (WattApi*)sharedInstance {
    static WattApi *sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[self alloc] init];
        sharedInstance.fileManager=[[NSFileManager alloc] init];
    });
    return sharedInstance;
}


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


#pragma mark - Registry


- (void)mergeRegistry:(WattRegistry*)sourceRegistry
                 into:(WattRegistry*)destinationRegistry
       reIndexUinstID:(BOOL)index{
    NSMutableDictionary *idsIndex=[NSMutableDictionary dictionary];
    [sourceRegistry enumerateObjectsUsingBlock:^(WattObject *obj, NSUInteger idx, BOOL *stop) {
        NSInteger olderUinstID=obj.uinstID;
        [destinationRegistry registerObject:obj];
        NSInteger newUinstID=obj.uinstID;
        // we save the older
        [idsIndex setValue:[NSNumber numberWithInteger:newUinstID]
                    forKey:[NSString stringWithFormat:@"%i",olderUinstID]];
    }];
    if(index){
        [sourceRegistry enumerateObjectsUsingBlock:^(WattObject *obj, NSUInteger idx, BOOL *stop) {
            
        }];
        //_idIndex;
    }
    
    sourceRegistry=nil;
    
}

#pragma mark - MULTIMEDIA API

#pragma mark - ACL


- (BOOL)user:(WTMUser*)user canPerform:(Watt_Action)action onObject:(WTMModel*)object{
    BOOL authorized=YES;
    if((!_me)||(!object)){
        authorized=NO;
    }
    
    if([object rights]){
        //
    }
    
    if(!authorized){
        [[NSNotificationCenter defaultCenter] postNotificationName:WATT_ACTION_IS_NOT_AUTHORIZED_NOTIFICATION_NAME
                                                            object:self
                                                          userInfo:@{@"reference":object,@"action":[NSNumber numberWithInteger:action]}];
    }
    // Return if the action is authorized or not.
    return authorized;
}

-(WTMUser*)system{
    if(!_system){
        _system=[[WTMUser alloc] initInRegistry:_currentRegistry];
    }
    return _system;
}

-(WTMGroup*)systemGroup{
    if(_systemGroup){
        _systemGroup=[[WTMGroup alloc] initInRegistry:_currentRegistry];
    }
    return _systemGroup;
}


#pragma mark -Shelf


- (WTMShelf*)createShelfWithName:(NSString*)name{
    
    WTMShelf *shelf=[[WTMShelf alloc] initInRegistry:_currentRegistry];
    shelf.name=name;
    
    if(!_me){
        self.me=[self createUserInShelf:shelf];
        WTMGroup *group=[self createGroupInShelf:shelf];
        group.name=@"me";
        [self addUser:_me toGroup:group];
    }
    
    
    WTMPackage*package=[self createPackageInShelf:shelf];
    package.category=kCategoryNameShared;
    
    
    WTMLibrary*library=[self createLibraryInPackage:package];
    library.category=kCategoryNameShared;
    
    return shelf;
}

- (void)removeShelf:(WTMShelf*)shelf{
    //
    
}


// A facility to generate symboliclink for package and libraries
- (void)generateSymbolicLinkForShelf:(WTMShelf*)shelf{
    if(shelf){
        [shelf.packages enumerateObjectsUsingBlock:^(WTMPackage *obj, NSUInteger idx, BOOL *stop) {
            if(obj.name && obj.objectName){
                NSError *error=nil;
                NSString *pb=[wattAPI absolutePathForRegistryBundleWithName:wattAPI.currentRegistry.name];
                
                NSString *s=[pb stringByAppendingString:obj.objectName ];
                NSString *d=[pb stringByAppendingString:[obj.name stringByReplacingOccurrencesOfString:@" " withString:@"-"] ];
                
                if([wattAPI.fileManager fileExistsAtPath:s] && ![wattAPI.fileManager fileExistsAtPath:d]){
                    // WTLog(@"Hardlinking :\nS: %@\nD:%@",s,d)
                    [wattAPI.fileManager createSymbolicLinkAtPath:d
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
                    WTLog(@"Hardlinking :\nLS: %@\nLD:%@",ls,ld)
                    if([wattAPI.fileManager fileExistsAtPath:ls] && ![wattAPI.fileManager fileExistsAtPath:ld]){
                        
                        [wattAPI.fileManager createSymbolicLinkAtPath:ld
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

- (WTMUser*)createUserInShelf:(WTMShelf*)shelf{
    if(!shelf)
        [self raiseExceptionWithFormat:@"shelf is nil in %@",NSStringFromSelector(@selector(createUserInShelf:))];
    
    WTMUser *user=[[WTMUser alloc]initInRegistry:_currentRegistry];
    [shelf.users_auto addObject:user];
    user.identity=[self uuidString];
    
    return user;
}

- (WTMGroup*)createGroupInShelf:(WTMShelf*)shelf{
    if(!shelf)
        [self raiseExceptionWithFormat:@"shelf is nil in %@",NSStringFromSelector(@selector(createGroupInShelf:))];
    
    WTMGroup *group=[[WTMGroup alloc]initInRegistry:_currentRegistry];
    [shelf.groups_auto addObject:group];
    
    return group;
}

- (void)addUser:(WTMUser*)user toGroup:(WTMGroup*)group{
    if(!user || !group)
        [self raiseExceptionWithFormat:@"user or group is nil in %@",NSStringFromSelector(@selector(addUser:toGroup:))];
    
    [group.users_auto addObject:user];
    [user.groups_auto addObject:group];
}

- (void)removeUser:(WTMUser*)user fromGroup:(WTMGroup*)group{
    [group.users_auto removeObject:user];
}

- (void)removeGroup:(WTMGroup*)group{
    //
    
}

#pragma mark - Menus & section


- (WTMMenuSection*)createSectionInShelf:(WTMShelf*)shelf{
    if([self user:_me
       canPerform:WattWRITE
         onObject:shelf]){
        WTMMenuSection *section=[[WTMMenuSection alloc]initInRegistry:_currentRegistry];
        section.index=[shelf.sections_auto count];//We compute the index 
        [shelf.sections_auto addObject:section];
        section.shelf=shelf;
        return section;
    }
    return nil;
}

- (void)removeSection:(WTMMenuSection*)section{
    [section.shelf.sections_auto removeObject:section];
    [section.menus enumerateObjectsUsingBlock:^(WTMMenu *obj, NSUInteger idx, BOOL *stop) {
        [self removeMenu:obj];
    }];
    section.shelf=nil;
    [section autoUnRegister];
}

- (WTMMenu*)createMenuInSection:(WTMMenuSection*)section{
    if([self user:_me
       canPerform:WattWRITE
         onObject:section]){
        
        WTMMenu *menu=[[WTMMenu alloc] initInRegistry:_currentRegistry];
        [section.menus_auto addObject:menu];
        menu.menuSection=section;
        return menu;
    }
    return nil;
}


- (void)removeMenu:(WTMMenu*)menu{
    [menu.menuSection.menus removeObject:menu];
    [menu autoUnRegister];
}



#pragma mark - Package

- (WTMPackage*)createPackageInShelf:(WTMShelf*)shelf{
    if([self user:_me
       canPerform:WattWRITE
         onObject:shelf]){
        if(!shelf)
            [self raiseExceptionWithFormat:@"shelf is nil in %@",NSStringFromSelector(@selector(createPackageInShelf:))];
        WTMPackage *package=[[WTMPackage alloc] initInRegistry:_currentRegistry];
        package.objectName=[self uuidString];// We create a uuid for each package and library to deal with linked assets
        [shelf.packages_auto addObject:package];
        [package langDictionary_auto];
        package.shelf=shelf;
        return package;
    }
    return nil;
}


- (void)removePackage:(WTMPackage*)package{
    if([self user:_me
       canPerform:WattWRITE
         onObject:package]){
        
        
    }
}

// Immport process this method can move a package from a registry to another
// Producing renamming of assets and performing re-identification including ACL
- (void)addPackage:(WTMPackage*)package
           toShelf:(WTMShelf*)shelf{
}


- (NSArray*)dependenciesPathForPackage:(WTMPackage*)package{
    NSMutableArray *array=[NSMutableArray array];
    [package.libraries_auto enumerateObjectsUsingBlock:^(WTMLibrary *obj, NSUInteger idx, BOOL *stop) {
        [array addObjectsFromArray:[wattAPI dependenciesPathForLibrary:obj]];
    }];
    return array;
}



#pragma mark - Library

- (WTMLibrary*)createLibraryInPackage:(WTMPackage*)package{
    if([self user:_me
       canPerform:WattWRITE
         onObject:package]){
        WTMLibrary *library=[[WTMLibrary alloc] initInRegistry:_currentRegistry];
        library.objectName=[self uuidString];// We create a uuid for each package and library to deal with linked assets
        [package.libraries_auto addObject:library];
        [library setPackage:package];
        return library;
    }
    return nil;
}

- (void)removeLibrary:(WTMLibrary*)library{
    if([self user:_me
       canPerform:WattWRITE
         onObject:library.package]){
        
        
    }
}

- (NSArray*)dependenciesPathForLibrary:(WTMLibrary*)library{
    NSMutableArray *array=[NSMutableArray array];
    [library.members_auto enumerateObjectsUsingBlock:^(WTMMember *obj, NSUInteger idx, BOOL *stop) {
        NSArray *pths=[wattAPI absolutePathsFromRelativePath:obj.thumbnailRelativePath all:YES];
        if(pths){
            [array addObjectsFromArray:pths];
        }
        if([[obj propertiesKeys] indexOfObject:@"relativePath"]!=NSNotFound){
            pths=[wattAPI absolutePathsFromRelativePath:[obj valueForKey:@"relativePath"] all:YES];
            if(pths){
                [array addObjectsFromArray:pths];
            }
        }
    }];
    return array;
}


#pragma mark - Activity

- (WTMActivity*)createActivityInPackage:(WTMPackage*)package{
    if([self user:_me
       canPerform:WattWRITE
         onObject:package]){
        
        
    }
    return nil;
}

- (void)removeActivity:(WTMActivity*)activity{
    if([self user:_me
       canPerform:WattWRITE
         onObject:activity]){
        
        
    }
}


#pragma mark - Scene

- (WTMScene*)createSceneInActivity:(WTMActivity*)activity{
    if([self user:_me
       canPerform:WattWRITE
         onObject:activity]){
        
        
    }
    return nil;
}

- (void)removeScene:(WTMScene*)scene{
    if([self user:_me
       canPerform:WattWRITE
         onObject:scene]){
        
        
    }
}

#pragma mark - Element

- (WTMElement*)createElementInScene:(WTMScene*)scene
                          withAsset:(WTMAsset*)asset
                        andBehavior:(WTMBehavior*)behavior{
    if([self user:_me
       canPerform:WattWRITE
         onObject:scene.activity]){
        
        
    }
    return nil;
}

- (void)removeElement:(WTMElement*)element{
    if([self user:_me
       canPerform:WattWRITE
         onObject:element]){
    }
    
}

#pragma mark -  Bands

// Bands
- (WTMBand*)createBandInLibrary:(WTMLibrary*)library
                    withMembers:(NSArray*)members{
    if([self user:_me
       canPerform:WattWRITE
         onObject:library]){
    }
    return nil;
}

- (void)purgeBandIfNecessary:(WTMBand*)band{
    if([self user:_me
       canPerform:WattWRITE
         onObject:band]){
    }
}


#pragma mark -  Members

// Use this section of the api to add member.
// The underlining refererCounter is automaticly managed
// Purging  a member or band from a library can automatically delete the linked files

// Linked assets dependencies
// Library 1<->n member

// Band n<->n member
// Library 1<->n member


- (void)addMember:(WTMMember*)member
        toLibrary:(WTMLibrary*)library {
    if([self user:_me
       canPerform:WattWRITE
         onObject:library]){
        
        if(!member|| !library){
            [self raiseExceptionWithFormat:@"member or library is nil in %@",NSStringFromSelector(@selector(addMember:toLibrary:))];
        }
        [library.members_auto addObject:member];
        member.library=library;
        member.refererCounter++;
    }
    
}


// A facility that deals with the refererCounter to decide if the member should be deleted;
// It also delete the linked files if necessary
- (void)purgeMemberIfNecessary:(WTMMember*)member{
    if([self user:_me
       canPerform:WattWRITE
         onObject:member]){
        
        member.refererCounter--;
        if(member.refererCounter<=0){
            if([member respondsToSelector:@selector(relativePath)]){
                NSString *relativePath=[member performSelector:@selector(relativePath)];
                if(relativePath){
                    NSArray *absolutePaths=[self absolutePathsFromRelativePath:relativePath
                                                                           all:YES];
                    for (NSString *pathToDelete in absolutePaths) {
                        NSError *error=nil;
                        [wattAPI.fileManager removeItemAtPath:pathToDelete
                                                                   error:&error];
                        if(error){
                            WTLog(@"Impossible to delete %@",pathToDelete);
                        }
                    }
                }
            }
            [member autoUnRegister];
        }
    }
}


#pragma mark - relative path and path discovery


- (NSString*)absolutePathFromRelativePath:(NSString *)relativePath{
    NSArray *r=[self absolutePathsFromRelativePath:relativePath all:NO];
    if([r count]>0)
        return [r objectAtIndex:0];
    return nil;
}


- (NSArray*)absolutePathsFromRelativePath:(NSString *)relativePath all:(BOOL)returnAll{
    NSString *baseRelativePath = [relativePath copy];
    NSArray *orientation_modifiers=@[@""];
    NSArray *device_modifiers=@[@""];
    NSArray *pixel_density_modifiers=@[@"@2x",@""];
    NSString *extension = [baseRelativePath pathExtension];
    NSMutableArray *result=[NSMutableArray array];
    
    // Clean up the basename
    
    baseRelativePath=[baseRelativePath stringByDeletingPathExtension];
    for (NSString*deviceModifier in  device_modifiers) {
        baseRelativePath=[baseRelativePath stringByReplacingOccurrencesOfString:deviceModifier withString:@""];
    }
    
    for (NSString*orientationModifier in  orientation_modifiers) {
        baseRelativePath=[baseRelativePath stringByReplacingOccurrencesOfString:orientationModifier withString:@""];
    }
    
    for (NSString*pixelDensity in  pixel_density_modifiers) {
        baseRelativePath=[baseRelativePath stringByReplacingOccurrencesOfString:pixelDensity withString:@""];
    }
#if TARGET_OS_IPHONE
    if(isLandscapeOrientation()){
        orientation_modifiers=@[@"-Landscape",@""];
    }else{
        orientation_modifiers=@[@"-Portrait",@""];
    }
    if(isIpad()){
        device_modifiers=@[@"~ipad",@""];
    }else if(isWidePhone()){
        device_modifiers=@[@"~iphone5",@"~iphone",@""];
    }else{
        device_modifiers=@[@"~iphone",@""];
    }
#endif
    // Find the most relevant asset
    
    for (NSString*orientationModifier in  orientation_modifiers) {
        for (NSString*deviceModifier in  device_modifiers) {
            for (NSString*pixelDensity in  pixel_density_modifiers) {
                NSString *component=[NSString stringWithFormat:@"%@%@%@%@",baseRelativePath,orientationModifier,pixelDensity,deviceModifier];
                
               
                NSString *pth=nil;
                if(self.currentRegistry.name){
                    // We use the current registry bundle
                    pth=[NSString stringWithFormat:@"%@%@.%@",[self absolutePathForRegistryBundleWithName:self.currentRegistry.name],component,extension?extension:@""];
                }else{
                    //
                    pth=[NSString stringWithFormat:@"%@%@.%@",[self applicationDocumentsDirectory],component,extension?extension:@""];
                }
                
                if([wattAPI.fileManager fileExistsAtPath:pth]){
                    [result addObject:pth];
                    if(!returnAll)
                        return result;
                }
                
                // APPLICATION BUNDLE ATTEMPT
                pth=[[NSBundle mainBundle] pathForResource:component ofType:extension];
                if(pth && [pth length]>1){
                    [result addObject:pth];
                    if(!returnAll)
                        return result;
                }
            }
            
        }
    }
    return result;
}


#pragma  mark - file paths 


- (NSString *) applicationDocumentsDirectory{
    if(!_applicationDocumentsDirectory){
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString *basePath = ([paths count] > 0) ? [paths objectAtIndex:0] : nil;
        _applicationDocumentsDirectory=[basePath stringByAppendingString:@"/"];
    }
    return _applicationDocumentsDirectory;
}

- (NSString*)absolutePathForRegistryFileWithName:(NSString*)name{
    return [[self applicationDocumentsDirectory] stringByAppendingFormat:@"%@",[self _wattRegistryFileRelativePathWithName:name]] ;
}


- (NSString *)absolutePathForRegistryBundleWithName:(NSString*)name{
    return [[self applicationDocumentsDirectory] stringByAppendingFormat:@"%@",[self _wattBundleRelativePathWithName:name]] ;
}

- (NSString*)_wattBundleRelativePathWithName:(NSString *)name{
    if(!name)
        name=kDefaultName;
    return [NSString stringWithFormat:@"%@-%@%@/",name,[self _suffix],kWattBundle];
}

- (NSString *)_wattRegistryFileRelativePathWithName:(NSString*)name{
    if(!name)
        name=kDefaultName;
    NSString *bPath=[self _wattBundleRelativePathWithName:name];
    return [bPath stringByAppendingFormat:@"%@.%@",name,[self _suffix]];
}

- (NSString*)_suffix{
    NSArray *suffixes=@[@"jx",@"j",@"px",@"p"];
    return [suffixes objectAtIndex:_ftype];
}




- (NSString*)_pathForFileName:(NSString*)fileName{
    return [[self applicationDocumentsDirectory] stringByAppendingFormat:@"/%@",fileName];
}


#pragma mark - files management


-(BOOL)writeData:(NSData*)data toPath:(NSString*)path{
    [self createRecursivelyRequiredFolderForPath:path];
    data=[self _dataSoup:data mix:((_ftype==WattJx)||(_ftype==WattPx))];
    return [data writeToFile:path atomically:YES];
}

-(NSData*)readDataFromPath:(NSString*)path{
    NSData *data=[NSData dataWithContentsOfFile:path];
    data=[self _dataSoup:data mix:((_ftype==WattJx)||(_ftype==WattPx))];
    return data;
}

//The data soup method is a simple and fast encoding / decoding method.
//That reverses the bytes array and reverse each byte value.
//It is a simple symetric encoding to prevent from manual editing.
//It is not a securized crypto method !
-(NSData*)_dataSoup:(NSData*)data  mix:(BOOL)mix{
    if(mix){
        const char *bytes = [data bytes];
        char *reverseBytes = malloc(sizeof(char) * [data length]);
        int index = [data length] - 1;
        for (int i = 0; i < [data length]; i++){
            reverseBytes[index--] = (~ bytes[i]); // double reverse
        }
        NSData *reversedData = [NSData dataWithBytes:reverseBytes length:[data length]];
        free(reverseBytes);
        return reversedData;
    }else{
        return data;
    }
}




-(BOOL)createRecursivelyRequiredFolderForPath:(NSString*)path{
    if([path rangeOfString:[self applicationDocumentsDirectory]].location==NSNotFound){
        return NO;
    }
    if(![[path substringFromIndex:path.length-1] isEqualToString:@"/"])
        path=[path stringByDeletingLastPathComponent];
    
    if(![wattAPI.fileManager fileExistsAtPath:path]){
        NSError *error=nil;
        [wattAPI.fileManager createDirectoryAtPath:path
                                   withIntermediateDirectories:YES
                                                    attributes:nil
                                                         error:&error];
        if(error){
            return NO;
        }
    }
    return YES;
}



#pragma mark -  serialization


-(BOOL)writeRegistry:(WattRegistry*)registry toFile:(NSString*)path{
    NSArray *array=[registry arrayRepresentation];
    if(((_ftype==WattJx)||(_ftype==WattJ))){
        NSData *data = [NSKeyedArchiver archivedDataWithRootObject:array];
        return [self writeData:data toPath:path];
    }else{
        return [self _serializeToJson:array toPath:path];
    }
    
}

-(WattRegistry*)readRegistryFromFile:(NSString*)path{
    if(((_ftype==WattJx)||(_ftype==WattJ))){
        NSData *data=[self readDataFromPath:path];
        NSArray *array = [NSKeyedUnarchiver unarchiveObjectWithData:data];
        return [WattRegistry instanceFromArray:array resolveAliases:YES];
    }else{
        NSArray *array=[self _deserializeFromJsonWithPath:path];
        if(array)
            return [WattRegistry instanceFromArray:array resolveAliases:YES];
    }
    return nil;
}

// JSON private methods

- (BOOL)_serializeToJson:(id)reference toPath:(NSString*)path{
    NSError*errorJson=nil;
    NSData *data=nil;
    @try {
        data=[NSJSONSerialization dataWithJSONObject:reference
                                             options:NSJSONWritingPrettyPrinted error:&errorJson];
    }
    @catch (NSException *exception) {
        return NO;
    }
    @finally {
    }
    if(data){
        [self writeData:data toPath:path];
    }else{
        return NO;
    }
}

- (id)_deserializeFromJsonWithPath:(NSString*)path{
    NSData *data=[self readDataFromPath:path];
    NSError*errorJson=nil;
    @try {
        // We use mutable containers and leaves by default.
        id result=[NSJSONSerialization JSONObjectWithData:data
                                                  options:NSJSONReadingMutableContainers|NSJSONReadingMutableLeaves|NSJSONReadingAllowFragments
                                                    error:&errorJson];
        return result;
    }
    @catch (NSException *exception) {
    }
    @finally {
    }
    return nil;
}


#pragma mark - localization

- (void)localize:(id)reference withKey:(NSString*)key andValue:(id)value{
    if(_localizationDelegate){
        [_localizationDelegate localize:reference withKey:key andValue:value];
    }else{
        // Default localization policy
    }
}

#pragma mark -utilities

- (void)raiseExceptionWithFormat:(NSString *)format, ...{
    va_list args;
    va_start(args, format);
    NSString *s = [[NSString alloc] initWithFormat:format arguments:args];
    va_end(args);
    if(s)
        [NSException raise:kWattAPIExecptionName format:@"%@",s];
    else
        [NSException raise:kWattAPIExecptionName format:@"Internal error"];
    
}


- (NSString*)uuidString {
    // Returns a UUID
    CFUUIDRef uuid = CFUUIDCreate(kCFAllocatorDefault);
    NSString *uuidStr = (__bridge_transfer NSString *)CFUUIDCreateString(kCFAllocatorDefault, uuid);
    CFRelease(uuid);
    return uuidStr;
}



@end