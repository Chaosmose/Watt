//
//  WTMObjectsRegister.h
//  PlayerSample
//
//  Created by Benoit Pereira da Silva on 22/05/13.
//  Copyright (c) 2013 Pereira da Silva. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WTMObject.h"

@interface WTMRegistry : NSObject

#pragma runtime object graph identification

-(WTMObject*)objectWithUinstID:(NSInteger)uinstID;
-(void)registerObject:(WTMObject*)reference;
-(void)unRegisterObject:(WTMObject*)reference;


@end
