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
    WattUser     *  _system;
    WattGroup    * _systemGroup;
    Watt_F_TYPE  _ftype;
    NSString    *_applicationDocumentsDirectory;
}

- (instancetype)init{
    self=[super init];
    if(self){
        self.fileManager=[[NSFileManager alloc] init];
        self.mixableExtensions=[NSMutableArray array];
        self.forcedSoupPaths=[NSMutableArray array];
    }
    return self;
}


-(void)use:(Watt_F_TYPE)ftype{
    _ftype=ftype;
}



// system and systemGroup are not in any registry
// Their uinstID is NSIntegerMax

-(WattUser*)system{
    if(!_system){
        _system=[[WattUser alloc] initInRegistry:nil
                            withPresetIdentifier:NSIntegerMax];
        _system.group=[self systemGroup];
    }
    return _system;
}

-(WattGroup*)systemGroup{
    if(!_systemGroup){
        _systemGroup=[[WattGroup alloc] initInRegistry:nil
                                  withPresetIdentifier:NSIntegerMax];
    }
    return _systemGroup;
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


#pragma mark - ACL 

#pragma mark - rights facilities

- (void)applyRights:(NSUInteger)rights
           andOwner:(WattUser*)owner
                 on:(WattModel*)model{
    if(!model)
        [self raiseExceptionWithFormat:@"WattAcl attempt to setup rights on void model"];
    model.rights=rights;
    if(owner){
        model.ownerID=owner.uinstID;
        model.groupID=owner.group.uinstID;
    }
}

/*
 
 @"RWXRWXRWX"
 
 OWNER 400-200-100
 GROUP 40-20-10
 OTHERS 4-2-1
 
 */


- (NSString*)rightsFromInteger:(NSUInteger)numericRights{
    
    if(numericRights>777){
        numericRights=0;
    }
    
    NSInteger values[9];
    values[0]=400;
    values[1]=200;
    values[2]=100;
    values[3]=40;
    values[4]=20;
    values[5]=10;
    values[6]=4;
    values[7]=2;
    values[8]=1;
    
    NSString *allRightsString= @"RWXRWXRWX";
    NSMutableString *rights=[NSMutableString string];
    NSInteger nRights=numericRights;
    
    for (NSInteger i=0; i<9; i++) {
        if(nRights-values[i]>=0){
            nRights=nRights-values[i];
            NSString * unitaryString = [allRightsString substringWithRange:NSMakeRange(i, 1)];
            [rights appendString:unitaryString];
        }else{
            [rights appendString:@"-"];
        }
    }
    return rights;
}

- (NSUInteger)rightsFromString:(NSString*)stringRights{
    
    while ([stringRights length]<9) {
        stringRights=[NSString stringWithFormat:@"-%@",stringRights];
    }
    
    NSInteger values[9];
    values[0]=400;
    values[1]=200;
    values[2]=100;
    values[3]=40;
    values[4]=20;
    values[5]=10;
    values[6]=4;
    values[7]=2;
    values[8]=1;
    
    NSString *allRightsString= @"RWXRWXRWX";
    
    NSUInteger rights=0;
    for (NSInteger i=0; i<9; i++) {
        NSString * unitaryString = [stringRights substringWithRange:NSMakeRange(i, 1)];
        NSString * unitaryStringForAllRights = [allRightsString substringWithRange:NSMakeRange(i, 1)];
        if([[unitaryString lowercaseString] isEqualToString:[unitaryStringForAllRights lowercaseString]]){
            rights=rights+values[i];
        }
    }
    
    return rights;
}




#pragma  mark - access control

// The acl method
- (BOOL)actionIsAllowed:(Watt_Action)action on:(WattModel*)model{
    WattGroup*modelGroup=(WattGroup*)[model.registry objectWithUinstID:model.groupID];
    if(model.groupID==0 && model.ownerID==0){
        return YES; // If ownerID and groupID are not defined the operation is allowed.
    }else{
        BOOL authorized=[self actionIsAllowed:action
                                   withRights:model.rights
                                   imTheOwner:[self mIOwnerOf:model]
                            imInTheOwnerGroup:[self mIIntheGroup:modelGroup]];
        
        if(!authorized){
            [[NSNotificationCenter defaultCenter] postNotificationName:WATT_ACTION_IS_NOT_AUTHORIZED_NOTIFICATION_NAME
                                                                object:self
                                                              userInfo:@{@"reference":model,@"action":@(action)}];
        }
        
        
        return authorized;
    }
}


- (BOOL)actionIsAllowed:(Watt_Action)action
             withRights:(NSUInteger)rights
             imTheOwner:(BOOL)owned
      imInTheOwnerGroup:(BOOL)inTheGroup{
    
    WTLog(@"Rights %@ (%i) action %i",[self rightsFromInteger:rights],rights,action);
    
    NSInteger values[9];
    values[0]=400;
    values[1]=200;
    values[2]=100;
    values[3]=40;
    values[4]=20;
    values[5]=10;
    values[6]=4;
    values[7]=2;
    values[8]=1;
    
    NSInteger hasTheRight[9];
    NSInteger nRights=rights;
    NSUInteger castedAction=(NSUInteger)action;
    
    for (NSInteger i=0; i<9; i++) {
        if(nRights-values[i]>=0){
            nRights=nRights-values[i];
            hasTheRight[i]=1;
        }else{
            hasTheRight[i]=0;
        }
    }
    
    if(owned){
        // The user is the owner
        if(hasTheRight[castedAction+0]==1){
            return YES;
        }
    }else if(inTheGroup){
        // In the group
        if(hasTheRight[castedAction+3]==1){
            return YES;
        }
    }else{
        // Public
        if(hasTheRight[castedAction+6]==1){
            return YES;
        }
    }
    
    return NO;
}

- (BOOL)mIOwnerOf:(WattModel*)model{
    if(model.ownerID==0 || model.groupID==0){
        return YES;
    }
    WattUser*owner=nil;
    if (model.groupID==self.system.uinstID) {
        owner=self.system;
    }else{
        owner=(WattUser*)[model.registry objectWithUinstID:model.groupID];
    }
    if(owner && self.me){
        return [owner isEqual:self.me];
    }
    return NO;
}

- (BOOL)mIIntheGroup:(WattGroup*)group{
    if(!group){
        return YES;
    }else {
        return [[self me].group isEqual:group];
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
                
                if([self.fileManager fileExistsAtPath:pth]){
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
    data=[self _dataSoup:data mix:[self _shouldMixPath:path]];
    return [data writeToFile:path atomically:YES];
}

-(NSData*)readDataFromPath:(NSString*)path{
    NSData *data=[NSData dataWithContentsOfFile:path];
    data=[self _dataSoup:data mix:[self _shouldMixPath:path]];
    return data;
}

-(BOOL)_shouldMixPath:(NSString*)path{
    if([_forcedSoupPaths indexOfObject:path]!=NSNotFound){
        return YES;
    }
    BOOL modeAllowsToMix=((_ftype==WattJx)||(_ftype==WattPx));
    if(modeAllowsToMix){
        if([_mixableExtensions indexOfObject:[path pathExtension]]!=NSNotFound ||
           [[path pathExtension] isEqualToString:@"jx"]||
           [[path pathExtension] isEqualToString:@"px"]){
            return YES;
        }
    }
    return NO;
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
    
    if(![self.fileManager fileExistsAtPath:path]){
        NSError *error=nil;
        [self.fileManager createDirectoryAtPath:path
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


-(BOOL)writeRegistryIfNecessary:(WattRegistry*)registry toFile:(NSString*)path{
    if([registry hasChanged]){
        [registry setHasChanged:NO];
        return  [self writeRegistry:registry toFile:path];
    }
    return YES;
}

-(BOOL)writeRegistry:(WattRegistry*)registry toFile:(NSString*)path{
    NSArray *array=[registry arrayRepresentation];
    if(((_ftype==WattPx)||(_ftype==WattP))){
        NSData *data = [NSKeyedArchiver archivedDataWithRootObject:array];
        return [self writeData:data toPath:path];
    }else{
        return [self _serializeToJson:array toPath:path];
    }
    
}

-(WattRegistry*)readRegistryFromFile:(NSString*)path{
    
    if(self.fileManager && ![self.fileManager fileExistsAtPath:path isDirectory:NO]){
        [self raiseExceptionWithFormat:@"Unexisting registry path %@",path];
    }
    if(((_ftype==WattPx)||(_ftype==WattP))){
        NSData *data=[self readDataFromPath:path];
        NSArray *array = [NSKeyedUnarchiver unarchiveObjectWithData:data];
        WattRegistry *registry=[WattRegistry instanceFromArray:array resolveAliases:YES];
        registry.apiReference=self;
        return registry;
    }else{
        NSArray *array=[self _deserializeFromJsonWithPath:path];
        if(array){
            WattRegistry *registry=[WattRegistry instanceFromArray:array resolveAliases:YES];
            registry.apiReference=self;
            return registry;
        }
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

-(void)wattTodo:(NSString*)message{
    if(!message)
        message=@"todo";
    [self raiseExceptionWithFormat:@"%@",message];
}

@end