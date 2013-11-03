//
//  WattDeltaEngine.h
//  Watt
//
//  Created by Benoit Pereira da Silva on 10/08/13.
//  Copyright (c) 2013 pereira-da-silva.com. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WattRegistry.h"
#import "WattDelta.h"

@interface WattDeltaEngine : NSObject

- (WattDelta*)deltaFromStateA:(NSDictionary*)stateA toStateB:(NSDictionary*)stateB;
- (void)addDelta:(WattDelta*)delta on:(WattRegistry*)registry;
- (void)subtractDelta:(WattDelta*)delta from:(WattRegistry*)registry;

@end
