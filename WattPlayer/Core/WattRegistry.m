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
#import "WattObject.h"
#import "WattObjectAlias.h"
#import "WattCollectionOfObject.h"

@interface WattRegistry (){
}
// Call the selector on all the members of the registry
-(void)performSelectorOnMembers:(SEL)aSelector
                       onThread:(NSThread *)thr
                     withObject:(id)arg
                  waitUntilDone:(BOOL)wait;
@end

@implementation WattRegistry{
    NSInteger               _uinstIDCounter;
    NSMutableDictionary     *_registry;
    NSMutableArray          *_history;
    NSArray                *__sortedKeys;
}

- (id)init{
    self=[super init];
    if(self){
        _uinstIDCounter=0;
        _registry=[NSMutableDictionary dictionary];
    }
    return self;
}

- (NSUInteger)count{
    return _uinstIDCounter;
}

#pragma mark - Serialization/Deserialization facilities


// If you want serialize / deserialize the whole registry


+ (WattRegistry*)instanceFromArray:(NSArray*)array{
    WattRegistry *r=[[WattRegistry alloc] init];
    
    // Double step deserialization
    // This process prevent from using runtime aliases resolution.
    // and allows circular referencing any object graph can be serialized.
    // First step   :  deserializes the registry with member's aliases
    // Second step  :  resolves the aliases (and the force the caches computation)
    
    WTLog(@"Register");
    // First step :
    int i=1;
    for (NSDictionary *d in array) {
        WattObject *liveObject=[WattObject instanceFromDictionary:d
                                                    inRegistry:r
                                              includeChildren:NO];
        if(liveObject){
            [r registerObject:liveObject];
            WTLog(@"%i %@",i,liveObject);
        }
        i++;
    }
    
    // Second step :
    [r performSelectorOnMembers:@selector(resolveAliases)
                       onThread:[NSThread currentThread]
                     withObject:nil
                  waitUntilDone:YES];
    
    return r;
}

-(void)performSelectorOnMembers:(SEL)aSelector
                       onThread:(NSThread *)thr
                     withObject:(id)arg waitUntilDone:(BOOL)wait{
    NSArray *sortedKeys=[self _sortedKeys];
    for (NSString*key in sortedKeys) {
        WattObject*o=[_registry objectForKey:key];
        
        WTLog(@"Resolving aliases on  %@",o);
        
        if(o && [o respondsToSelector:aSelector]){
            [o performSelector:aSelector
                  onThread:thr
                withObject:arg
             waitUntilDone:wait];
        }else{
            WTLog(@"%@ do not respond to %@",o,NSStringFromSelector(aSelector));
        }
    }
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

// If you want serialize / deserialize an arbitrary object graph from a given object


- (NSDictionary*)dictionaryWithAliasesFrom:(WattObject*)object
                              resetHistory:(BOOL)resetHistory{
    if(resetHistory){
        _history=[NSMutableArray array];
    }
    BOOL inHistory=NO;
    for (NSNumber*uid in _history) {
        if([uid integerValue]==object.uinstID){
            inHistory=YES;
            break;
        }
    }
    if(inHistory){
        return [WattObjectAlias aliasDictionaryRepresentationFrom:object];
    }else{
        [_history addObject:@(object.uinstID)];
        return [object dictionaryRepresentationWithChildren:YES];
    }
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


- (WattObject*)objectWithUinstID:(NSInteger)uinstID{
    if([_registry count]>uinstID){
        return [_registry objectForKey:[self _keyFrom:uinstID]];
    }else{
        return nil;
    }
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
    if(reference.uinstID==0){
        [reference identifyWithUinstId:[self _createAnUinstID]];
        [self addObject:reference];
    }else if(_uinstIDCounter>reference.uinstID){
        if(![[self objectWithUinstID:reference.uinstID] isEqual:reference]){
            [NSException raise:@"Registry" format:@"Identity missmatch"];
        }
    }else{
#if  !WT_ALLOW_MULTIPLE_REGISTRATION
        [NSException raise:@"Registry" format:@"Identity overflow"];
#endif
    }
}


- (void)addObject:(WattObject *)reference{
    [self _invalidateSortedKeys];
    if(reference.uinstID>0 && ![self objectWithUinstID:reference.uinstID]){
        [_registry setValue:reference forKey:[self _keyFrom:reference.uinstID]];
        _uinstIDCounter=MAX(reference.uinstID, _uinstIDCounter);
    }else{
        [NSException raise:@"Registry" format:@"Unsuccessfull attempt to add a reference"];
    }
 
}


- (void)unRegisterObject:(WattObject*)reference{
    [self _invalidateSortedKeys];
    [_registry removeObjectForKey:[self _keyFrom:reference.uinstID]];
}


- (NSString*)description{
	NSMutableString *s=[NSMutableString string];
    [s appendFormat:@"Registry with %i members\n\n",[self count]];
    int i=1;
    NSArray *sortedKeys=[self _sortedKeys];
    for (NSString*key in sortedKeys) {
        WattObject*o=[_registry objectForKey:key];
        [s appendFormat:@"%i|#%i|%@\n",i,o.uinstID,o];
        i++;
    }
	return s;
}


@end
