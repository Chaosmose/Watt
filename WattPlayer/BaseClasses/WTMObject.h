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
//  WTMObject.h
//  PlayerSample
//
//  Created by Benoit Pereira da Silva on 09/05/13.
//  Copyright (c) 2013 Pereira da Silva. All rights reserved.
//

#import <Foundation/Foundation.h>


@class WattMApi;

@interface WTMObject : NSObject{
    @private
    NSString *_currentLocale;           // The locale that has been used for localization
    NSMutableArray *_propertiesKeys;    // Used by the WTMObject root object to store the properties name
    WattMApi *_wapi;
}

#pragma mark - registry

-(id)initInDefaultRegistry;


@property (readonly)NSInteger uinstID;
// Should be used once during deserialisation or serialisation phases.
// Do not use during runtime.
-(void)identifyWithUinstId:(NSInteger)identifier;

#pragma mark - localization

-(WTMObject*)localized; // Usually overriden for strong typing during Flexions
-(void)localize;
-(BOOL)hasBeenLocalized;

// Reflexion utility that is not as fast as NSFastEnumeration on the first call 
// But this approach is much more flexible in our context KVC, inheritance & universal persistency.
-(NSArray*)allPropertiesName;

@end

#pragma mark WattCoding

@protocol WattCoding <NSObject>
+ (WTMObject*)instanceFromDictionary:(NSDictionary *)aDictionary; // Usually overriden for strong typing during Flexions
- (void)setAttributesFromDictionary:(NSDictionary *)aDictionary;
- (NSDictionary *)dictionaryRepresentation;
@end
