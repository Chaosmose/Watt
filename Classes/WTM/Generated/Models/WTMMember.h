// This file is part of "WTM"
// 
// "WTM" is free software: you can redistribute it and/or modify
// it under the terms of the GNU LESSER GENERAL PUBLIC LICENSE as published by
// the Free Software Foundation, either version 3 of the License, or
// (at your option) any later version.
// 
// "WTM" is distributed in the hope that it will be useful,
// but WITHOUT ANY WARRANTY; without even the implied warranty of
// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
// GNU LESSER GENERAL PUBLIC LICENSE for more details.
// 
// You should have received a copy of the GNU LESSER GENERAL PUBLIC LICENSE
// along with "WTM"  If not, see <http://www.gnu.org/licenses/>
// 
//  WTMMember.h
//  WTM
//
//  Generated by Flexions  
//  Copyright (c) 2013 Benoit Pereira da Silva All rights reserved.
 

#import "WattModel.h"
@class WTMLibrary;

@interface WTMMember:WattModel<WattCoding>{
}

@property (nonatomic,copy) NSString * name;
@property (nonatomic,assign) NSInteger  refererCounter;
@property (nonatomic,copy) NSString * thumbnailRelativePath;
@property (nonatomic,strong) WTMLibrary * library;// non extractible

- (WTMLibrary*)library_auto;

@end
