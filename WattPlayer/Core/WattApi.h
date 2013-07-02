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
//  WTMApi.h
//
//  Created by Benoit Pereira da Silva on 17/05/13.
//  Copyright (c) 2013 Pereira da Silva. All rights reserved.
//

#import "WattObject.h"
#import "WattRegistry.h"


#pragma mark - WattApi

@protocol WTMlocalizationDelegateProtocol;

@interface WattApi : NSObject

@property (nonatomic,assign)id<WTMlocalizationDelegateProtocol>localizationDelegate;

@property (readonly)WattRegistry*defaultRegistry;

// WattMApi singleton accessor
+ (WattApi*)sharedInstance;

#pragma mark facility

- (NSString *) applicationDocumentsDirectory;

#pragma mark localization

//You should normaly not call directly that method
//This method is called from WTMObject from the @selector(localize) implementation.
//Calls the localizationDelegate if it is set or invokes the default implementation
- (void)localize:(WattObject*)reference withKey:(NSString*)key andValue:(id)value;

@end

#pragma mark localization delegate prototocol

// You can implement this protocol if you want to customize the internationalization process.
@protocol WTMlocalizationDelegateProtocol <NSObject>
@required
- (void)localize:(id)reference withKey:(NSString*)key andValue:(id)value;
@end

#