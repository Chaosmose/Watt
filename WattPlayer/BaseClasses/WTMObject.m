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
//  WTMObject.m
//  PlayerSample
//
//  Created by Benoit Pereira da Silva on 09/05/13.
//  Copyright (c) 2013 Pereira da Silva. All rights reserved.
//

#import "WTMObject.h"
#import "WattMApi.h"
#import <objc/runtime.h>

@implementation WTMObject{
    NSInteger _uinstID;
}

-(id)initInDefaultRegistry{
    self=[self init];
    if(self){
        [[wattMAPI defaultRegistry] registerObject:self];
    }
    return self;
}


-(id)init{
    self=[super init];
    if(self){
        _wapi=[WattMApi sharedInstance];
        _uinstID=0;// no registration
    }
    return self;
}

-(WTMObject*)localized{
    [self localize];
    return self;
}

-(NSInteger)uinstID{
    return _uinstID;
}

-(void)identifyWithUinstId:(NSInteger)identifier{
    if(_uinstID==0){
        _uinstID=identifier;
    }else if(identifier==_uinstID){
        [NSException raise:@"Registry" format:@"Attempt to re-identify an instance"];
    }else{
        [NSException raise:@"Registry" format:@"Attempt to change the identity of an instance"];
    }
}

-(void)localize{
    if([self hasBeenLocalized]){
        NSArray *keys=[self allPropertiesName];
        for (NSString*key in keys) {
            id o=[self valueForKey:key];
            if([o respondsToSelector:@selector(localize)]){
                [o localize];
            }else{
                [_wapi localize:self withKey:key andValue:o];
            }
        }
    }
    _currentLocale=[[NSLocale currentLocale] localeIdentifier];
}


-(BOOL)hasBeenLocalized{
    return ([[[NSLocale currentLocale] localeIdentifier] isEqualToString:_currentLocale]);
}

// _keys dictionary caches the responses for future uses.
// the seconds invocation for a given class is costless.
-(NSArray*)allPropertiesName{
    if(_propertiesKeys){
        // If the keys have allready been computed
        return _propertiesKeys;
    }else{
        _propertiesKeys=[NSMutableArray array];
    }
    Class currentClass=[self class];
    NSUInteger count;
    // (!) IMPORTANT
    // Each class has its own set o property in the inheritance chain.
    // So we do perform while "currentClass" has a superClass
    while (currentClass) {
        objc_property_t *propList = class_copyPropertyList(currentClass, &count);
        for ( int i = 0; i < count; i++ ){
            objc_property_t property = propList[i];
            const char *propName = property_getName(property);
            NSString*keyString=[NSString stringWithCString:propName encoding:NSASCIIStringEncoding];
            [_propertiesKeys addObject:keyString];
        }
        free(propList);
        currentClass=[currentClass superclass];
    }
    return [NSArray arrayWithArray:_propertiesKeys];
    
}


@end
