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
    NSString *p=[wattAPI absolutePathFromRelativePath:relativePath];
    if(p){
        if ([p rangeOfString:[wattAPI applicationDocumentsDirectory]].location!=NSNotFound) {
            //Unsoup if necessary
            NSData *data=[wattAPI readDataFromPath:p];
            return [UIImage imageWithData:data];
        }else{
            //It is bundled asset.
            //No soup there.
            return [UIImage imageWithContentsOfFile:p];
        }
    }
    return nil;
}

- (BOOL)writePNGToAbsolutePath:(NSString*)path{
    NSData *data=UIImagePNGRepresentation(self);
    return [wattAPI writeData:data toPath:path];
}

- (BOOL)writeJPGToAbsolutePath:(NSString*)path{
    NSData *data=UIImageJPEGRepresentation(self, 0.5f);
    return [wattAPI writeData:data toPath:path];
}



@end
