//
//  WattFileUtilities.m
//  PlayerSample
//
//  Created by Benoit Pereira da Silva on 02/11/2013.
//  Copyright (c) 2013 Pereira da Silva. All rights reserved.
//

#import "WattRegistryFilesUtils.h"
#import "watt.h"

#define kDefaultName                @"default"
#define kRegistryFileName           @"registry"
#define kWattBundle                 @".watt"

static NSString* rimbaud =@"Q9tbWVqZWRlc2NlbmRhaXNkZXNGbGV1dmVzaW1wYXNzaWJsZXMsSmVuZW1lc2VudGlzcGx1c2d1aWTpcGFybGVzaGFsZXVyczpEZXNQZWF1eC1Sb3VnZXNjcmlhcmRzbGVzYXZhaWVudHByaXNwb3VyY2libGVzLExlc2F5YW50Y2xvdelzbnVzYXV4cG90ZWF1eGRlY291bGV1cnMuSjpdGFpc2luc291Y2lldXhkZXRvdXNsZXPpcXVpcGFnZXMsUG9ydGV1cmRlYmzpc2ZsYW1hbmRzb3VkZWNvdG9uc2FuZ2xhaXMuUXVhbmRhdmVjbWVzaGFsZXVyc29udGZpbmljZXN0YXBhZ2VzLExlc0ZsZXV2ZXNtP29udGxhaXNz6WRlc2NlbmRyZW5amV2b3VsYWlzLkRhbnNsZXNjbGFwb3RlbWVudHNmdXJpZXV4ZGVzbWFy6WVzLE1vaSxsP2F1dHJlaGl2ZXIscGx1c3NvdXJkcXVlbGVzY2VydmVhdXhkP2VuZmFudHMsSmVjb3VydXMhRXRsZXNQ6W5pbnN1bGVzZOltYXJy6WVzTj9vbnRwYXNzdWJpdG9odS1ib2h1c3BsdXN0cmlvbXBoYW50cy5MYXRlbXDqdGVhYuluaW1lcl2ZWlsc21hcml0aW1lcy5QbHVzbOlnZXJxdT91bmJvdWNob25qP2FpZGFuclzdXJsZXNmbG90c1F1P29uYXBwZWxsZXJvdWxldXJz6XRlcm5lbHNkZXZpY3RpbWVzLERpeG51aXRzLHNhbnNyZWdyZXR0ZXJsPz9pbG5pYWlzZGVzZmFsb3RzIVBsdXNkb3VjZXF1P2F1eGVuZmFudHNsYWNoYWlyZGVzcG9tbWVzc3VyZXMsTD9lYXV2ZXJ0ZXDpbul0";


@implementation WattRegistryFilesUtils{
    // We store temporary serilalization mode
    WattSerializationMode  _serializationMode;
    NSString *_applicationDocumentsDirectory;
    
    // DATA SOUP
    // Should be optimized in c.
    NSMutableArray   *_secretBooleanList; // [@(YES),@(NO), ....];
    NSUInteger       _secretLoopIndex;    // The looping index
    NSUInteger       _secretLength;       //
    
}

#pragma mark - relative path and path discovery

@synthesize fileManager = _fileManager;
@synthesize mixableExtensions = _mixableExtensions;
@synthesize forcedSoupPaths = _forcedSoupPaths;
@synthesize relativeFolderPath = _relativeFolderPath;


-(instancetype)initWithSecretKey:(NSString *)secretKey{
    self=[self init];
    if(self){
        if(!secretKey)
            secretKey=rimbaud;
        [self _generateTheSymetricKeyFrom:secretKey];
    }
    return self;
}




#pragma mark - SETTER and GETTERS


- (NSFileManager *)fileManager {
    if(!_fileManager)
        _fileManager=[[NSFileManager alloc] init];
    return _fileManager;
}

- (void)setFileManager:(NSFileManager *)aFileManager {
    _fileManager = aFileManager;
}

- (NSMutableArray *)mixableExtensions {
    if(!_mixableExtensions)
        _mixableExtensions=[NSMutableArray array];
    return _mixableExtensions;
}

- (void)setMixableExtensions:(NSMutableArray *)aMixableExtensions {
    _mixableExtensions = [aMixableExtensions mutableCopy];
}


- (NSMutableArray *)forcedSoupPaths {
    if(!_forcedSoupPaths)
        _forcedSoupPaths=[NSMutableArray array];
    return _forcedSoupPaths;
}

- (void)setForcedSoupPaths:(NSMutableArray *)aForcedSoupPaths {
    _forcedSoupPaths = [aForcedSoupPaths mutableCopy];
}


#pragma mark -

-(void)use:(WattSerializationMode)mode{
    _serializationMode=mode;
}


/**
 *  Returns the wattSerializationMode by parsing the path suffix
 *
 *  @param path the path
 *
 *  @return the serialization mode
 */
- (WattSerializationMode)serializationModeFromPath:(NSString*)path{
    NSArray *suffixes=[self _suffixes];
    if([path.pathExtension isEqualToString:[suffixes objectAtIndex:3]]){
        return WattP;
    }
    if([path.pathExtension isEqualToString:[suffixes objectAtIndex:2]]){
        return WattPx;
    }
    if([path.pathExtension isEqualToString:[suffixes objectAtIndex:1]]){
        return WattJ;
    }
    return WattJx;
}

- (NSArray*)_suffixes{
    return @[@"jx",@"j",@"px",@"p"];
}


- (NSString*)absolutePathFromRelativePath:(NSString *)relativePath
                         inBundleWithName:(NSString*)wattBundleName{
    NSArray *r=[self absolutePathsFromRelativePath:relativePath
                                  inBundleWithName:wattBundleName
                                               all:NO];
    if([r count]>0)
        return [r objectAtIndex:0];
    return nil;
}


- (NSArray*)absolutePathsFromRelativePath:(NSString *)relativePath
                         inBundleWithName:(NSString*)wattBundleName
                                      all:(BOOL)returnAll{
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
                if(wattBundleName){
                    pth=[NSString stringWithFormat:@"%@%@.%@",[self absolutePathForRegistryBundleFolderWithName:wattBundleName],component,extension?extension:@""];
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
    return [[self applicationDocumentsDirectory] stringByAppendingFormat:@"%@%@",_relativeFolderPath?[_relativeFolderPath stringByAppendingString:@"/"]:@"",[self _wattRegistryFileRelativePathWithName:name]] ;
}


- (NSString *)absolutePathForRegistryBundleFolderWithName:(NSString*)name{
    return [[self applicationDocumentsDirectory]stringByAppendingFormat:@"%@%@",_relativeFolderPath?[_relativeFolderPath stringByAppendingString:@"/"]:@"",[self _wattBundleRelativePathWithName:name]] ;
}


- (NSString*)_wattBundleRelativePathWithName:(NSString *)name{
    if(!name)
        name=kDefaultName;
    return [NSString stringWithFormat:@"%@-%@%@/",name,[self _suffix],kWattBundle];
}


- (NSString *)_wattRegistryFileRelativePathWithName:(NSString*)name{
    NSString *bPath=[self _wattBundleRelativePathWithName:name];
    return [bPath stringByAppendingFormat:@"%@.%@",kRegistryFileName,[self _suffix]];
}

- (NSString*)_suffix{
    return [[self _suffixes] objectAtIndex:_serializationMode];
}



- (NSString*)_pathForFileName:(NSString*)fileName{
    return [[self applicationDocumentsDirectory] stringByAppendingFormat:@"/%@",fileName];
}


#pragma mark - files I/O

/**
 *  Write the data mixing if necessary
 *
 *  @param data The nsdata to write to the path
 *  @param path the destination path
 *
 *  @return the success of the file operation
 */

-(BOOL)writeData:(NSData*)data toPath:(NSString*)path{
    [self createRecursivelyRequiredFolderForPath:path];
    data=[self _dataSoup:data mix:[self _shouldMixPath:path]];
    return [data writeToFile:path atomically:YES];
}

/**
 *  Reads the data and mix if necessary (mixing is reversible)
 *
 *  @param path the path
 *
 *  @return the Data
 */
-(NSData*)readDataFromPath:(NSString*)path{
    NSData *data=[NSData dataWithContentsOfFile:path];
    return [self _dataSoup:data mix:[self _shouldMixPath:path]];;
}


/**
 *  Write the data mixing if necessary
 *
 *  @param data The nsdata to write to the path
 *  @param path the destination path
 *
 *  @return the success of the file operation
 */
- (BOOL)writeData:(NSData*)data toPath:(NSString*)path withForcedSerializationMode:(WattSerializationMode)mode{
    [self createRecursivelyRequiredFolderForPath:path];
    data=[self _dataSoup:data mix:(mode==WattJx||mode==WattPx)];
    return [data writeToFile:path atomically:YES];
}

/**
 *  Reads the data and mix if necessary
 *
 *  @param path the path
 *  @param mode
 *
 *  @return the Data
 */
- (NSData*)readDataFromPath:(NSString*)path withForcedSerializationMode:(WattSerializationMode)mode{
    NSData *data=[NSData dataWithContentsOfFile:path];
    return [self _dataSoup:data mix:(mode==WattJx||mode==WattPx)];
}


-(BOOL)_shouldMixPath:(NSString*)path{
    if([_forcedSoupPaths indexOfObject:path]!=NSNotFound){
        return YES;
    }
    BOOL modeAllowsToMix=((_serializationMode==WattJx)||(_serializationMode==WattPx));
    if(modeAllowsToMix){
        if([_mixableExtensions indexOfObject:[path pathExtension]]!=NSNotFound ||
           [[path pathExtension] isEqualToString:@"jx"]||
           [[path pathExtension] isEqualToString:@"px"]){
            return YES;
        }
    }
    return NO;
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


- (BOOL)removeItemAtPath:(NSString*)path{
    NSError *error=nil;
    [self.fileManager removeItemAtPath:path
                                 error:&error];
    if(error){
        WTLog(@"Impossible to delete %@",path);
        return NO;
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
    if(((_serializationMode==WattPx)||(_serializationMode==WattP))){
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
    
     _serializationMode=[self serializationModeFromPath:path];
    NSArray *array=nil;
    if(((_serializationMode==WattPx)||(_serializationMode==WattP))){
        NSData *data=[self readDataFromPath:path];
        array = [NSKeyedUnarchiver unarchiveObjectWithData:data];
    }else{
       array=[self _deserializeFromJsonWithPath:path];
    }
    if(array){
        return [WattRegistry instanceFromArray:array
                     withSerializationMode:_serializationMode
                    uniqueStringIdentifier:nil
                                    inPool:nil
                            resolveAliases:YES];
    }
    
    return nil;
}


// JSON private methods

- (BOOL)_serializeToJson:(id)reference toPath:(NSString*)path{
    NSError*errorJson=nil;
    NSData *data=nil;
    @try {
        data=[NSJSONSerialization dataWithJSONObject:reference
                                             options:0
                                               error:&errorJson];
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


#pragma mark - Execptions 

- (void)raiseExceptionWithFormat:(NSString *)format, ...{
    va_list args;
    va_start(args, format);
    NSString *s = [[NSString alloc] initWithFormat:format arguments:args];
    va_end(args);
    if(s)
        [NSException raise:@"WattAPIException" format:@"%@",s];
    else
        [NSException raise:@"WattAPIException" format:@"Internal error"];
    
}
#pragma mark - Unique strings

- (NSString*)uuidString {
    return [WattRegistryFilesUtils uuidString];
}


+ (NSString*)uuidString {
    // Returns a UUID
    CFUUIDRef uuid = CFUUIDCreate(kCFAllocatorDefault);
    NSString *uuidStr = (__bridge_transfer NSString *)CFUUIDCreateString(kCFAllocatorDefault, uuid);
    CFRelease(uuid);
    return uuidStr;
}

#pragma mark - Data SOUP

/**
 * Mixes the data if necessary
 * The data soup method is a simple and fast encoding / decoding method.
 * That reverses the bytes array and reverse each byte value according to the _secretBooleanList
 * It is a simple symetric encoding to prevent from manual editing. 
 * It is not a super securized crypto method.
 *
 *  @param data the original data
 *  @param mix  should we mix ?
 *
 *  @return the mixed NSData
 */
-(NSData*)_dataSoup:(NSData*)data  mix:(BOOL)mix{
    if(mix && _secretBooleanList && [_secretBooleanList count]>1){
        const char *bytes = [data bytes];
        char *reverseBytes = malloc(sizeof(char) * [data length]);
        int index = [data length] - 1;
        for (int i = 0; i < [data length]; i++){
            #warning QUICK dirty and not memory efficient
            //Should be optimized in c.
            // Objective C is not efficient here (refactory needed)
            if([[_secretBooleanList objectAtIndex:_secretLoopIndex] boolValue]){
                reverseBytes[index--] = (~ bytes[i]); // double reverse
            }else{
                reverseBytes[index--] = (bytes[i]); // no reverse
            }
            _secretLoopIndex++;
            if(_secretLoopIndex>_secretLength){
                _secretLoopIndex=0;
            }
        }
        NSData *mixed = [NSData dataWithBytes:reverseBytes length:[data length]];
        free(reverseBytes);
        return mixed;
    }else{
        return data;
    }
}

/**
 *  Generate a _secretBooleanList from a secretKey
 *
 *  @param secretKey the string secret key
 */
- (void)_generateTheSymetricKeyFrom:(NSString*)secretKey{
    if(secretKey){
        // We gonna double the key to make it symetric.
        NSMutableString *symetricKey = [NSMutableString string];
        NSInteger charIndex = [secretKey length];
        while (charIndex > 0) {
            charIndex--;
            NSRange subStrRange = NSMakeRange(charIndex, 1);
            [symetricKey appendString:[secretKey substringWithRange:subStrRange]];
        }
        // we concat the keys "ABCD" becomes a symetric string "DCBAABCD"
        [symetricKey appendString:secretKey];
        // Then we transform "DCBAABCD" to a boolean list based on the binary representation of each char
        _secretBooleanList=[NSMutableArray array];
        NSString *previousChar=[symetricKey substringWithRange:NSMakeRange(0,1)];
        NSUInteger nbOfChar=[symetricKey length];
        for (int i=1; i<nbOfChar ; i++) {
            NSString *currentChar=[symetricKey substringWithRange:NSMakeRange(i, 1)];
            // We compare the previous and the current char.
            // If previousChar is > currentChar then we add YES to the _secretBooleanList
            // THE _secretBooleanList will be an array of : YES, NO, NO, YES ....
            if([previousChar compare:currentChar]==NSOrderedAscending){
                [_secretBooleanList addObject:@(YES)];
            }else{
                [_secretBooleanList addObject:@(NO)];
            }
        }
        _secretLoopIndex=-1;
        _secretLength=[_secretBooleanList count];
    }
}

@end
