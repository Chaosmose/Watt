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



#import "UIImage+WattAdaptive.h"

@implementation UIImage(WattAdaptive)


+(UIImage*)adaptiveWithRelativePath:(NSString *)relativePath inRegistry:(WattRegistry*)registry{
    if(!registry){
        [NSException raise:@"Invalid registry exception" format:@"registry is nil"];
    }
    NSString *p=[registry.pool absolutePathFromRelativePath:relativePath
                                            inBundleWithName:registry.uidString];
    if(p){
        if ([p rangeOfString:[registry.pool applicationDocumentsDirectory]].location!=NSNotFound) {
            //Unsoup if necessary
            NSData *data=[registry.pool readDataFromPath:p];
            return [UIImage imageWithData:data];
        }else{
            //It is bundled asset.
            //No soup there.
            return [UIImage imageWithContentsOfFile:p];
        }
    }
    return nil;
}

- (BOOL)writePNGToAbsolutePath:(NSString*)path forPool:(WattRegistryPool*)pool{
    NSData *data=UIImagePNGRepresentation(self);
    return [pool writeData:data toPath:path];
}

- (BOOL)writeJPGToAbsolutePath:(NSString*)path forPool:(WattRegistryPool*)pool{
    NSData *data=UIImageJPEGRepresentation(self, 0.5f);
    return [pool writeData:data toPath:path];
}


@end
