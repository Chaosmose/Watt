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
//
//  WattRegistry.m
//  PlayerSample
//
//  Created by Benoit Pereira da Silva on 22/05/13.
//  Copyright (c) 2013 Pereira da Silva. All rights reserved.
//

#import "WattRegistry.h"
#import "Watt.h"
#import "WattRegistryPool.h"

#pragma  mark - WattObject reIdentification invisible category

@interface WattObject (Invisible){
}
/**
 *  Do not call directly
 *  This selector is used during initialization or merging
 *
 *  @param identifier the uinsID;
 */
- (void)identifyWithUinstId:(NSInteger)identifier;

/**
 *  Do not call directly
 *  This selector is used during merging
 *
 *  @param registry the destination registry
 */
- (void)moveToRegistry:(WattRegistry*)registry;

@end

@interface WattRegistryPool (Invisible){
}
/**
 *  Adds the registry to the pool
 *  You should not call this method directly
 
 *  @param registry the instance
 *
 *  @return YES if there was no instance.
 */
- (BOOL)addRegistry:(WattRegistry*)registry;
@end


@implementation WattObject(Invisible)

- (void)identifyWithUinstId:(NSInteger)identifier{
    self->_uinstID=identifier;
}

- (void)moveToRegistry:(WattRegistry*)registry{
    if(![self.registry isEqual:registry]){
        // We proceed to reidentification
        [self identifyWithUinstId:self.uinstID+[registry nextUinstID]];
        self->_registry=registry;
    }
}
@end

#pragma  mark - WattRegistry

@interface WattRegistry (){
}
@end

@implementation WattRegistry{
    NSInteger             _uinstIDCounter;
    NSMutableDictionary    *_registry;
    NSMutableArray         *_history;
    NSArray               *__sortedKeys;
}

@synthesize hasChanged = _hasChanged;
@synthesize autosave = _autosave;


#pragma mark - constructors

/**
 *  Invalid initializer
 *  You must use @selector(initWithSerializationMode:name:andContainerName:) to initialize a WattRegistry
 *  @return nil
 */
- (id)init{
    [NSException raise:@"WattRegistry initialization exception"
                format:@"You must use @selector(initWithSerializationMode:name:andContainerName:) to initialize a WattRegistry"];
    return nil;
}


/**
 * The factory constructor
 *
 *  @param serializationMode The format (json,plist, ...) +  soup or not
 *  @param identifier        The unique string to indentifiy of the registry
 *  @param pool              The pool container
 *
 *  @return The new created instance
 */
+(instancetype)registryWithUniqueStringIdentifier:(NSString*)identifier
                                           inPool:(WattRegistryPool*)pool{
    return [[WattRegistry alloc] initRegistryWithUniqueStringIdentifier:identifier
                                                            inPool:pool];
}


/**
 * The constructor (you should not use the simple init)
 *
 *  @param serializationMode The format (json,plist, ...) +  soup or not
 *  @param identifier        The unique string to indentifiy of the registry
 *  @param pool              The pool container
 *  @return The new created instance
 */
-(instancetype)initRegistryWithUniqueStringIdentifier:(NSString*)identifier
                                               inPool:(WattRegistryPool*)pool{
    self=[super init];
    if(!pool)
        [self raiseExceptionWithFormat:@"WattRegistryPool must be set to create a registry"];
    if(self){
        _uinstIDCounter=0;
        _registry=[NSMutableDictionary dictionary];
        _autosave=YES;// By default
        _uidString=identifier;
        _pool=pool;
        // We add this registry to the pool
        [_pool addRegistry:self];// Invisible public method
    }
    return self;
}

#pragma mark - save


- (void)setAutosave:(BOOL)autosave{
    _autosave=autosave;
    if(_autosave){
        if([self hasChanged]){
            [self saveIfNecessary];
        }
    }
}

- (BOOL)autosave{
    return _autosave;
}


/**
 *  Execute the block and autosaves
 *
 *  @param block of modification of object in the registry.
 */
- (void)executeBlockAndSaveIfNecessary:(void (^)())block{
    BOOL autoSaveInitialValue=self.autosave;
    self.autosave=NO;
    block();
    [self saveIfNecessary];
    self.autosave=autoSaveInitialValue;
}


/**
 *  Saves if hasChanged==YES;
 */
- (void)saveIfNecessary{
    if([self.uidString length]>=1){
        if([self hasChanged]){
            [self save];
        }
    }else{
        [_pool raiseExceptionWithFormat:@"invalid registry name : %@ ",self.uidString];
    }
}

/**
 *  Saves
 */
- (void)save{
    [_pool saveRegistry:self];
}

#pragma mark - Serialization/Deserialization facilities


- (NSString*)serializationPath{
    return [_pool  absolutePathForRegistryFileWithName:self.uidString];
}


/**
 * A facility constructor for a registry fron an array instance
 *
 *  @param array             the array flat representation
 *  @param serializationMode the mode
 *  @param identifier        the registry unique string identifier
 *  @param pool              the pool
 *  @param resolveAliases    resolveAliases directly (can be defered to runtine for lazy resolution)
 *
 *  @return the registry
 */
+ (WattRegistry*)instanceFromArray:(NSArray*)array
             withSerializationMode:(WattSerializationMode)serializationMode
            uniqueStringIdentifier:(NSString*)identifier
                            inPool:(WattRegistryPool*)pool
                    resolveAliases:(BOOL)resolveAliases{
    
    WattRegistry *r=[WattRegistry registryWithUniqueStringIdentifier:identifier
                                                              inPool:pool];
    
    // Double step deserialization
    // and allows circular referencing any object graph can be serialized.
    // First step   :  deserializes the registry with member's aliases
    // Second step  :  resolves the aliases (and the force the caches computation)
    // The second step is optionnal as the generated getters
    // can proceed to dealiasing (runtime aliases resolution)


    // First step :
    NSUInteger i=1;
    for (NSDictionary *d in array) {
        WattObject *liveObject=[WattObject instanceFromDictionary:d
                                                       inRegistry:r
                                                  includeChildren:NO];
        if(liveObject){
            [r registerObject:liveObject];
        }
        i++;
    }
    if(resolveAliases){
        // Second step :
        [r enumerateObjectsUsingBlock:^(WattObject *obj, NSUInteger idx, BOOL *stop) {
            [obj resolveAliases];
            
        }];
    }
    r.hasChanged=NO;
    return r;
}



- (NSArray*)arrayRepresentation{
    NSMutableArray*registryArray=[NSMutableArray array];
    NSArray *sortedKeys=[self _sortedKeys];
    for (NSString *k in sortedKeys) {
        id o=[_registry objectForKey:k];
        if([o respondsToSelector:@selector(dictionaryRepresentationWithChildren:)]){
            [registryArray addObject:[o dictionaryRepresentationWithChildren:NO]];
        }else{
            [NSException raise:@"Registry" format:@"%@ do not respond to @selector(dictionaryRepresentationWithChildren:)",NSStringFromClass([o class])];
        }
    }
    return registryArray;
}

- (NSArray*)_sortedKeys{
    // We prefer to have a fast key based random access using a NSDictionary
    // allKeys selector returns an unordered key array.
    // So we sort the keys to store in the linear creation order.
    
    // Check _invalidateSortedKeys?
    if(__sortedKeys)
        return __sortedKeys;
    NSArray *keys=[_registry allKeys];
    NSArray *sortedKeys=[keys sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {
        if ( [obj1 integerValue] < [obj2 integerValue]) {
            return NSOrderedAscending;
        } else  {
            return NSOrderedDescending;
        }
        // In this case NSOrderedSame is not possible (two keys cannot be equals)
    }];
    __sortedKeys=sortedKeys;
    return __sortedKeys;
}


- (void)_invalidateSortedKeys{
    __sortedKeys=nil;
}

- (WattObject*)instanceFromDictionary:(NSDictionary*)dictionary{
    NSInteger uinstID=[[dictionary objectForKey:__uinstID__] integerValue];
    WattObject*o=[self objectWithUinstID:uinstID];
    if(o){
        return o;
    }else{
        return [WattObject instanceFromDictionary:dictionary inRegistry:self includeChildren:YES];
    }
}


#pragma runtime object graph identification


- (NSInteger)_createAnUinstID{
    _uinstIDCounter++;
    return _uinstIDCounter;
}

- (id)objectWithUinstID:(NSInteger)uinstID{
    return [_registry objectForKey:[self _keyFrom:uinstID]];
}


- (id)objectsWithClass:(Class)theClass andPrefix:(NSString*)prefix returningRegistry:(WattRegistry*)registry{
    NSString *collectionClassName;
    NSString *baseClassName=[NSStringFromClass(theClass) stringByReplacingOccurrencesOfString:prefix withString:@""];
    if(prefix){
        collectionClassName=[NSString stringWithFormat:@"%@%@%@",prefix,@"CollectionOf",baseClassName];
    }else{
        collectionClassName=[NSString stringWithFormat:@"%@%@",@"CollectionOf",baseClassName];
    }
    Class collectionClass=NSClassFromString(collectionClassName);
    if(!collectionClass)
        collectionClass=[WattCollectionOfObject class];
    WattCollectionOfObject*collection=[[collectionClass alloc ]initInRegistry:registry];
    NSArray *sortedKeys=[self _sortedKeys];
    for (NSString*key in sortedKeys) {
        WattObject*o=[_registry objectForKey:key];
        if([o isKindOfClass:theClass]){
            [collection addObject:o];
        }
    }
    return collection;
}


- (NSString*)_keyFrom:(NSInteger)uinstID{
    return [NSString stringWithFormat:@"%i",uinstID];
}


- (void)registerObject:(WattObject*)reference{
    if(![reference isAnAlias]){
        if(reference.uinstID==0){
            [reference identifyWithUinstId:[self _createAnUinstID]];
        }
        _uinstIDCounter=MAX(reference.uinstID, _uinstIDCounter);
        [self addObject:reference];
    }
}

- (void)addObject:(WattObject *)reference{
    if(reference.uinstID>0){
        NSString*referenceKey=[self _keyFrom:reference.uinstID];
        if([[self _sortedKeys] indexOfObject:referenceKey]!=NSNotFound){
            // The reference is already Registred.
            if([[_registry objectForKey:referenceKey] isEqual:reference]){
                // we do nothing ..
                return;
            }else{
                [NSException raise:@"Registry" format:@"Reference missmatch"];
            }
        }
    }
    [self _invalidateSortedKeys];
    if(reference.uinstID>0){
        [_registry setValue:reference forKey:[self _keyFrom:reference.uinstID]];
    }else{
        [NSException raise:@"Registry" format:@"Unsuccessfull attempt to add a reference"];
    }
    _uinstIDCounter=MAX(reference.uinstID, _uinstIDCounter);
    self.hasChanged=YES;
}


- (void)unRegisterObject:(WattObject*)reference{
    [self _invalidateSortedKeys];
    [_registry removeObjectForKey:[self _keyFrom:reference.uinstID]];
    self.hasChanged=YES;
}


- (NSString*)description{
	NSMutableString *s=[NSMutableString string];
    [s appendFormat:@"Registry with %i members\n\n",[[self _sortedKeys] count]];
    NSUInteger i=1;
    NSArray *sortedKeys=[self _sortedKeys];
    for (NSString*key in sortedKeys) {
        WattObject*o=[_registry objectForKey:key];
        [s appendFormat:@"%i|#%i|%@\n",i,o.uinstID,o];
        i++;
    }
	return s;
}

#pragma  mark - Enumeration


- (void)enumerateObjectsUsingBlock:(void (^)(WattObject *obj, NSUInteger idx, BOOL *stop))block{
    NSUInteger idx = 0;
    BOOL stop = NO;
    NSArray *sortedKeys=[self _sortedKeys];
    for(NSString*key  in sortedKeys){
        WattObject*obj =[_registry objectForKey:key];
        block(obj, idx++, &stop);
        if( stop )
            break;
    }
}


- (void)enumerateObjectsUsingBlock:(void (^)(WattObject *obj, NSUInteger idx, BOOL *stop))block reverse:(BOOL)useReverseEnumeration{
    NSUInteger idx = 0;
    BOOL stop = NO;
    NSEnumerator * enumerator=useReverseEnumeration?[[self _sortedKeys] reverseObjectEnumerator]: [[self _sortedKeys] objectEnumerator];
    for(NSString*key  in enumerator){
        WattObject*obj =[_registry objectForKey:key];
        block(obj, idx++, &stop);
        if( stop )
            break;
    }
    
}


#pragma mark - Counters

/**
 *  Returns the number of live referenced objects.
 *
 *  @return the count
 */
- (NSUInteger)count{
    return [[self _sortedKeys] count];
}



/**
 *  Gives the next uisntID (used for merging for example)
 *
 *  @return return an uinstID > the last uinstID
 */
- (NSUInteger)nextUinstID{
    return _uinstIDCounter+1;
}



#pragma mark - Merging

/**
 *  Merge the registryToAdd into the current registry
 *
 *  @param registryToAdd the registry to add
 *
 *  @return a success flag
 */
- (BOOL)mergeWithRegistry:(WattRegistry*)registryToAdd{
    BOOL __block success=YES;
    [registryToAdd enumerateObjectsUsingBlock:^(WattObject *obj, NSUInteger idx, BOOL *stop) {
        [obj moveToRegistry:self];
        [self addObject:obj];
    }];
    [registryToAdd purgeRegistry];
    return success;
}



#pragma mark - Destroy

/**
 *  Destroys the registry ( used in merging process for example)
 */
- (void)purgeRegistry{
    _uinstIDCounter=0;
    _registry=nil;
    _history=nil;
    __sortedKeys=nil;
    _uidString=nil;
    _hasChanged=NO;
    _autosave=NO;
    _pool=nil;
}




@end
