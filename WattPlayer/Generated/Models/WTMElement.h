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

@interface WTMElement:WattObject<WattCoding>{
}

@property (nonatomic,copy) NSString * assetLibUID;
@property (nonatomic,assign) NSInteger  assetMemberIndex;
@property (nonatomic,copy) NSString * behaviorLibUID;
@property (nonatomic,assign) NSInteger  behaviorMemberIndex;
@property (nonatomic,copy) NSString * controllerClass;
@property (nonatomic,copy) NSString * ownerUserUID;
@property (nonatomic,assign) CGRect  rect;
@property (nonatomic,copy) NSString * rights;
@property (nonatomic,assign) NSInteger  sceneIndex;


+ (WTMElement *)instanceFromDictionary:(NSDictionary *)aDictionary  inRegistry:(WattRegistry*)registry includeChildren:(BOOL)includeChildren;
- (WTMElement *)localized;
@end
