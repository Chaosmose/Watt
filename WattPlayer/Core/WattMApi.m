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

#import "WattMApi.h"

@implementation WattMApi

+ (WattMApi*)sharedInstance {
    static WattMApi *sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[self alloc] init];
    });
    return sharedInstance;
}


#pragma mark - localization

-(void)localize:(id)reference withKey:(NSString*)key andValue:(id)value{
    if(_localizationDelegate){
        [_localizationDelegate localize:reference withKey:key andValue:value];
    }else{
        // Default localization policy
    }
}

#pragma mark - serialization 


-(BOOL)serialize:(id)reference toFileName:(NSString*)fileName{
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

-(id)deserializeFromFileName:(NSString*)fileName{
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




-(BOOL)_createRequirePaths:(NSString*)path{
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


-(NSString*)_pathForFileName:(NSString*)fileName{
    return [[self _applicationDocumentPath ] stringByAppendingFormat:@"%@",fileName];
}

-(NSString*)_applicationDocumentPath{
    NSArray *searchPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *path=[searchPaths objectAtIndex:0];
    return [path stringByAppendingFormat:@"/"];
}


@end