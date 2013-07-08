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
//  UIImage+adaptive.h
//
//
//  Created by Benoit Pereira da Silva on 05/04/13.
//  Copyright (c) 2013 Azurgate. All rights reserved.
//

#if TARGET_OS_IPHONE
#import <UIKit/UIKit.h>

@interface UIImage(wattAdaptive)

/*
 Support of multiple modifiers
 
 Standard <ImageName><orientation_modifier><device_modifier>.<filename_extension>
 Retina <ImageName><orientation_modifier>@2x<device_modifier>.<filename_extension>
 */
+(UIImage*)adaptiveWithRelativePath:(NSString *)relativePath;
+(NSString*)absolutePathFromRelativePath:(NSString *)relativePath;
+(NSArray*)absolutePathsFromRelativePath:(NSString *)relativePath all:(BOOL)returnAll;

@end
#endif