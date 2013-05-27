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
//  WTMActivity.h
//  Watt
//
//  Generated by Flexions  
//  Copyright (c) 2013 Benoit Pereira da Silva All rights reserved.
 

#import "WattObjectAlias.h"
#import "WattObject.h"
@class WTMCollectionOfScene;

@interface WTMActivity:WattObject<WattCoding>{
}

@property (nonatomic,copy) NSString * comment;
@property (nonatomic,copy) NSString * controllerClass;
@property (nonatomic,assign) NSInteger  level;
@property (nonatomic,copy) NSString * ownerUserUID;
@property (nonatomic,assign) NSInteger  packageIndex;
@property (nonatomic,assign) NSInteger  rating;
@property (nonatomic,copy) NSString * rights;
@property (nonatomic,copy) NSString * shortName;
@property (nonatomic,copy) NSString * title;
@property (nonatomic,copy) NSString * uid;
@property (nonatomic,strong) WTMCollectionOfScene * scenes;

- (WTMCollectionOfScene*)scenes_auto;

+ (WTMActivity *)instanceFromDictionary:(NSDictionary *)aDictionary  inRegistry:(WattRegistry*)registry includeChildren:(BOOL)includeChildren;
- (WTMActivity *)localized;
@end
