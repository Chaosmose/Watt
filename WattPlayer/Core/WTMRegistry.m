//
//  WTMObjectsRegister.m
//  PlayerSample
//
//  Created by Benoit Pereira da Silva on 22/05/13.
//  Copyright (c) 2013 Pereira da Silva. All rights reserved.
//

#import "WTMRegistry.h"

@implementation WTMRegistry{
    NSInteger _uinstIDCounter;
    NSMutableArray *_registry;
}


-(id)init{
    self=[super init];
    if(self){
        _uinstIDCounter=0;
        _registry=[NSMutableArray array];
        [_registry addObject:[NSNull null]];// We register NSnull at index 0
    }
    return self;
}

#pragma runtime object graph identification

-(NSInteger)_createAnUinstID{
    _uinstIDCounter++;
    return _uinstIDCounter;
}


-(WTMObject*)objectWithUinstID:(NSInteger)uinstID{
    if([_registry count]>uinstID){
        return [_registry objectAtIndex:uinstID];
    }else{
        return nil;
    }
}

-(void)registerObject:(WTMObject*)reference{
    if(reference.uinstID==0){
        [reference identifyWithUinstId:[self _createAnUinstID]];
    }else if([_registry count]>reference.uinstID){
        WTMObject *o=[_registry objectAtIndex:reference.uinstID];
        if(![o isEqual:reference]){
            [NSException raise:@"Registry" format:@"Identity missmatch"];
        }
    }else{
#if  !WT_ALLOW_MULTIPLE_REGISTRATION
       [NSException raise:@"Registry" format:@"Identity overflow"];
#endif
    }
}

-(void)unRegisterObject:(WTMObject*)reference{
    NSInteger i=[_registry indexOfObject:reference];
    if(i!=NSNotFound){
        // We nullify
        [_registry replaceObjectAtIndex:i withObject:[NSNull null]];
    }
}




@end
