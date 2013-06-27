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
//  WTMElement.h
//  Watt
//
//  Generated by Flexions  
//  Copyright (c) 2013 Benoit Pereira da Silva All rights reserved.
 

#import "WattObject.h"
@class WTMAsset;
@class WTMBehavior;
@class WTMScene;

@interface WTMElement:WattObject<WattCoding>{
}

@property (nonatomic,copy) NSString * category;
@property (nonatomic,copy) NSString * controllerClass;
@property (nonatomic,strong) NSDictionary * extras;
@property (nonatomic,assign) CGRect  rect;
@property (nonatomic,copy) NSString * rights;
@property (nonatomic,assign) NSInteger  sceneIndex;
@property (nonatomic,strong) WTMAsset * asset;
@property (nonatomic,strong) WTMBehavior * behavior;
@property (nonatomic,strong) WTMScene * scene;

- (WTMAsset*)asset_auto;
- (WTMBehavior*)behavior_auto;
- (WTMScene*)scene_auto;

@end
