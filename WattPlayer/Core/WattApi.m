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
}

+ (WattApi*)sharedInstance {
    static WattApi *sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[self alloc] init];
    });
    return sharedInstance;
}



#pragma mark - localization

- (void)localize:(id)reference withKey:(NSString*)key andValue:(id)value{
    if(_localizationDelegate){
        [_localizationDelegate localize:reference withKey:key andValue:value];
    }else{
        // Default localization policy
    }
}


#pragma mark - relative path and path discovery


-(NSString*)absolutePathFromRelativePath:(NSString *)relativePath{
    NSArray *r=[self absolutePathsFromRelativePath:relativePath all:NO];
    if([r count]>0)
        return [r objectAtIndex:0];
    return nil;
}

-(NSArray*)absolutePathsFromRelativePath:(NSString *)relativePath all:(BOOL)returnAll{
    
    NSString *baseRelativePath = [relativePath copy];
    NSArray *orientation_modifiers=@[@"-Landscape",@"-Portrait",@""];
    NSArray *device_modifiers=@[@"~ipad",@"~iphone5",@"~iphone",@""];
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

#pragma mark - relative path and path discovery
#pragma mark -


// A facility that deals with the refererCounter to decide if the member should be deleted;
- (void)purgeMemberIfNecessary:(WTMMember*)member{
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



#pragma mark - serialization

- (BOOL)serialize:(id)reference toFileName:(NSString*)fileName{
    NSString*path=[self _pathForFileName:fileName];
    if([self _createRequirePaths:path]){
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



- (BOOL)_createRequirePaths:(NSString*)path{
    if([path rangeOfString:[self _applicationDocumentPath]].location==NSNotFound){
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
    return [[self _applicationDocumentPath ] stringByAppendingFormat:@"%@",fileName];
}

- (NSString*)_applicationDocumentPath{
    NSArray *searchPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *path=[searchPaths objectAtIndex:0];
    return [path stringByAppendingFormat:@"/"];
}


@end