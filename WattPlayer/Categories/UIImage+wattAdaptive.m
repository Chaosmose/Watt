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



#import "UIImage+wattAdaptive.h"

@implementation UIImage(wattAdaptive)

+(UIImage*)adaptiveWithRelativePath:(NSString *)relativePath{
    
    NSString *baseRelativePath = [relativePath copy];
    NSArray *orientation_modifiers=@[@"-Landscape",@"-Portrait",@""];
    NSArray *device_modifiers=@[@"~ipad",@"~iphone5",@"~iphone",@""];
    NSArray *pixel_density_modifiers=@[@"@2x",@""];
    NSArray *extensions=nil;
    
    // Clean up the basename

    baseRelativePath=[baseRelativePath stringByDeletingPathExtension];
    for (NSString*deviceModifier in  device_modifiers) {
        baseRelativePath=[baseRelativePath stringByReplacingOccurrencesOfString:deviceModifier withString:@""];
    }
    
    for (NSString*orientationModifier in  orientation_modifiers) {
        baseRelativePath=[baseRelativePath stringByReplacingOccurrencesOfString:orientationModifier withString:@""];
    }
    
    for (NSString*pixelDensity in  pixel_density_modifiers) {
        baseRelativePath=[baseRelativePath stringByReplacingOccurrencesOfString:pixelDensity withString:@""];
    }
    
    
    // Define the current context
    
    NSString *currentExtension = [baseRelativePath pathExtension];
    if([currentExtension length]>1){
        extensions=@[currentExtension];
    }else{
        extensions=@[@"png",@"jpg"];
    }
    if(isLandscapeOrientation()){
        orientation_modifiers=@[@"-Landscape",@""];
    }else{
        orientation_modifiers=@[@"-Portrait",@""];
    }
    if(isIpad()){
        device_modifiers=@[@"~ipad",@""];
    }else if(isWidePhone()){
        device_modifiers=@[@"~iphone5",@"~iphone",@""];
    }else{
        device_modifiers=@[@"~iphone",@""];
    }
    
    // Find the most relevant image
    
    for (NSString*orientationModifier in  orientation_modifiers) {
        for (NSString*deviceModifier in  device_modifiers) {
            for (NSString*pixelDensity in  pixel_density_modifiers) {
                for (NSString*extension in  extensions) {
                    NSString *component=[NSString stringWithFormat:@"%@%@%@%@",baseRelativePath,orientationModifier,pixelDensity,deviceModifier];
                    // DOCUMENT DIRECTORY
                     NSString *pth=[NSString stringWithFormat:@"%@%@",[wattAPI applicationDocumentsDirectory],component];
                    if([[NSFileManager defaultManager] fileExistsAtPath:pth]){
                        return [UIImage imageWithContentsOfFile:pth];
                    }
                    // BUNDLE ATTEMPT
                    pth=[[NSBundle mainBundle] pathForResource:component ofType:extension];
                    if(pth && [pth length]>1){
                        // Take the most relevant image.
                        return [UIImage imageWithContentsOfFile:pth];
                    }
                }
            }
        }
    }
    
    return nil;
}




@end
