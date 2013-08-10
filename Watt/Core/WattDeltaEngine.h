//
//  WattDeltaEngine.h
//  HopNBook
//
//  Created by Benoit Pereira da Silva on 10/08/13.
//  Copyright (c) 2013 HopToys. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WattRegistry.h"
#import "WattDelta.h"

@interface WattDeltaEngine : NSObject

- (WattDelta*)deltaFromStateA:(NSDictionary*)stateA toStateB:(NSDictionary*)stateB;
- (void)addDelta:(WattDelta*)delta on:(WattRegistry*)registry;
- (void)subtractDelta:(WattDelta*)delta from:(WattRegistry*)registry;

@end
