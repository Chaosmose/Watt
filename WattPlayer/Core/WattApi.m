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

@implementation WattApi{
    WTMUser *_system;
    WTMGroup *_systemGroup;
}

+ (WattApi*)sharedInstance {
    static WattApi *sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[self alloc] init];
    });
    return sharedInstance;
}



#pragma mark - Registry

- (void)mergeRegistry:(WattRegistry*)sourceRegistry
                 into:(WattRegistry*)destinationRegistry{
    
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
        _system=[[WTMUser alloc] initInRegistry:self.currentRegistry];
    }
    return _system;
}

-(WTMGroup*)systemGroup{
    if(_systemGroup){
        _systemGroup=[[WTMGroup alloc] initInRegistry:self.currentRegistry];
    }
    return _systemGroup;
}


#pragma mark -Shelf


- (WTMShelf*)createShelfWithName:(NSString*)name{
    return nil;
}

- (void)removeShelf:(WTMShelf*)shelf{
}

#pragma mark - User and groups

- (WTMUser*)createUserInShelf:(WTMShelf*)shelf{
    return nil;
}

- (WTMGroup*)createGroupInShelf:(WTMShelf*)shelf{
    return nil;
}

- (void)addUser:(WTMUser*)user toGroup:(WTMGroup*)group{
    
}

- (void)removeUser:(WTMUser*)User fromGroup:(WTMGroup*)group{
    
}

- (void)removeGroup:(WTMGroup*)group{
    
}

#pragma mark - Menus & section


- (WTMMenuSection*)createSectionInShelf:(WTMShelf*)shelf{
    if([self user:_me
       canPerform:WattWRITE
         onObject:shelf]){
        
        
    }
    return nil;
}

- (void)removeSection:(WTMMenuSection*)section fromShelf:(WTMShelf*)shelf{
    
}

- (WTMMenu*)createMenuInSection:(WTMMenuSection*)section{
    if([self user:_me
       canPerform:WattWRITE
         onObject:section]){
        
        
    }
    return nil;
}


- (void)removeMenu:(WTMMenu*)menu{
    
}



#pragma mark - Package

- (WTMPackage*)createPackageInShelf:(WTMShelf*)shelf{
    return nil;
}

- (void)removePackage:(WTMPackage*)package{
    if([self user:_me
       canPerform:WattWRITE
         onObject:package]){
        
        
    }
}

// Immport process this method can move a package from a registry to another
// Producing renamming of assets and performing re-identification
- (void)addPackage:(WTMPackage*)package
           toShelf:(WTMShelf*)shelf{
}


#pragma mark - Library

- (WTMLibrary*)createLibraryInPackage:(WTMPackage*)package{
    if([self user:_me
       canPerform:WattWRITE
         onObject:package]){
        
        
    }
    return nil;
}

- (void)removeLibrary:(WTMLibrary*)library{
    if([self user:_me
       canPerform:WattWRITE
         onObject:library.package]){
        
        
    }
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
                        [[NSFileManager defaultManager] removeItemAtPath:pathToDelete
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


#pragma mark - serialization

- (BOOL)serialize:(id)reference toFileName:(NSString*)fileName{
    NSString*path=[self _pathForFileName:fileName];
    if([self _createRequiredPaths:path]){
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
            return [data writeToFile:path atomically:YES];
        }else{
            return NO;
        }
    }
}

- (id)deserializeFromFileName:(NSString*)fileName{
    NSString *path=[self _pathForFileName:fileName];
    if(path){
        NSData *data=[NSData dataWithContentsOfFile:path];
        NSError*errorJson=nil;
        @try {
            // We use mutable containers and leaves by default.
            id result=[NSJSONSerialization JSONObjectWithData:data
                                                      options:NSJSONReadingMutableContainers|NSJSONReadingMutableLeaves|NSJSONReadingAllowFragments
                                                        error:&errorJson];
            if([result respondsToSelector:@selector(mutableCopy)]){
                return [result mutableCopy];
            }
            return result;
        }
        @catch (NSException *exception) {
            return nil;
        }
        @finally {
        }
    }else{
        return nil;
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
                // DOCUMENT DIRECTORY
                NSString *pth=[NSString stringWithFormat:@"%@/%@.%@",[self applicationDocumentsDirectory],component,extension?extension:@""];
                if([[NSFileManager defaultManager] fileExistsAtPath:pth]){
                    [result addObject:pth];
                    if(!returnAll)
                        return result;
                }
                // BUNDLE ATTEMPT
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


- (NSString *) applicationDocumentsDirectory{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *basePath = ([paths count] > 0) ? [paths objectAtIndex:0] : nil;
    return basePath;
}


#pragma mark - Paths

- (BOOL)_createRequiredPaths:(NSString*)path{
    if([path rangeOfString:[self applicationDocumentsDirectory]].location==NSNotFound){
        NSLog(@"Illegal path %@", path);
        return NO;
    }
    if(![[path substringFromIndex:path.length-1] isEqualToString:@"/"])
        path=[path stringByDeletingLastPathComponent];
    
    if(![[NSFileManager defaultManager] fileExistsAtPath:path]){
        NSError *error=nil;
        [[NSFileManager defaultManager] createDirectoryAtPath:path
                                  withIntermediateDirectories:YES
                                                   attributes:nil error:&error];
        if(error){
            NSLog(@"Error on path creation  %@ %@", path,[error localizedDescription]);
            return NO;
        }
    }
    return YES;
}



- (NSString*)_pathForFileName:(NSString*)fileName{
    return [[self applicationDocumentsDirectory] stringByAppendingFormat:@"/%@",fileName];
}

#pragma mark - localization

- (void)localize:(id)reference withKey:(NSString*)key andValue:(id)value{
    if(_localizationDelegate){
        [_localizationDelegate localize:reference withKey:key andValue:value];
    }else{
        // Default localization policy
    }
}



@end