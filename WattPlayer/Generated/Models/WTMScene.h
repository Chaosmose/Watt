// This file is part of "Watt-Multimedia-Engine"
// 
// "Watt-Multimedia-Engine" is free software: you can redistribute it and/or modify
// it under the terms of the GNU LESSER GENERAL PUBLIC LICENSE as published by
// the Free Software Foundation, either version 3 of the License, or
// (at your option) any later version.
// 
// "Watt-Multimedia-Engine" is distributed in the hope that it will be useful,
// but WITHOUT ANY WARRANTY; without even the implied warranty of
// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
// GNU LESSER GENERAL PUBLIC LICENSE for more details.
// 
// You should have received a copy of the GNU LESSER GENERAL PUBLIC LICENSE
// along with "Watt-Multimedia-Engine"  If not, see <http://www.gnu.org/licenses/>
// 
//  WTMScene.h
//  Watt-Multimedia-Engine
//
//  Generated by Flexions  
//  Copyright (c) 2013 Benoit Pereira da Silva All rights reserved.
 

#import <Foundation/Foundation.h>

@class WTMCollectionOfElement;
@class WTMCollectionOfDatum;

@interface WTMScene:NSObject{
}

@property (nonatomic,assign) NSInteger  activityIndex;
@property (nonatomic,copy) NSString * comment;
@property (nonatomic,copy) NSString * controllerClass;
@property (nonatomic,assign) NSInteger  number;
@property (nonatomic,copy) NSString * ownerUserUID;
@property (nonatomic,assign) CGRect  rect;
@property (nonatomic,copy) NSString * rights;
@property (nonatomic,copy) NSString * title;
@property (nonatomic,copy) NSString * uid;
@property (nonatomic,strong) WTMCollectionOfElement * elements;
@property (nonatomic,strong) WTMCollectionOfDatum * metadata;
 
+ (WTMScene *)instanceFromDictionary:(NSDictionary *)aDictionary;
- (void)setAttributesFromDictionary:(NSDictionary *)aDictionary;
- (NSDictionary *)dictionaryRepresentation;

@end
