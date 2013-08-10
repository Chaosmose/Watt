//
//  WattDelta.h
//  HopNBook
//
//  Created by Benoit Pereira da Silva on 10/08/13.
//  Copyright (c) 2013 HopToys. All rights reserved.
//

#import <Foundation/Foundation.h>

#define kWattDeltaMessageKey        @"m"
#define kWattDeltaAdditionsKey      @"a"
#define kWattDeltaSubtractionsKey   @"s"
#define kWattDeltaIdentifierKey     @"i"
#define kWattDeltaTimeStampKey      @"t"


@interface WattDelta : NSObject

@property (strong,nonatomic) NSString* message;// user message
@property (strong,nonatomic) NSDictionary* additions;
@property (strong,nonatomic) NSDictionary* subtractions;
@property (assign,nonatomic) NSUInteger identifier;// Comes from the registry;
@property (assign,nonatomic) NSTimeInterval timeStamp;

+ (WattDelta*)instanceFromDictionary:(NSDictionary *)aDictionary;
+ (NSDictionary*)dictionaryFromInstance:(WattDelta*)delta;


@end
