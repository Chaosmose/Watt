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
#import "WattUtils.h"

@implementation UIImage(WattAdaptive)



+(UIImage*)adaptiveWithRelativePath:(NSString *)relativePath inRegistry:(WattRegistry*)registry{
    WattUtils *utils=[[WattUtils alloc] init];
    [utils use:registry.serializationMode];
    NSString *p=[utils absolutePathFromRelativePath:relativePath
                                            inBundleWithName:registry.name];
    if(p){
        if ([p rangeOfString:[utils applicationDocumentsDirectory]].location!=NSNotFound) {
            //Unsoup if necessary
            NSData *data=[utils readDataFromPath:p];
            return [UIImage imageWithData:data];
        }else{
            //It is bundled asset.
            //No soup there.
            return [UIImage imageWithContentsOfFile:p];
        }
    }
    return nil;
}

- (BOOL)writePNGToAbsolutePath:(NSString*)path using:(WattSerializationMode)serializationMode{
    WattUtils *utils=[[WattUtils alloc] init];
    [utils use:serializationMode];
    NSData *data=UIImagePNGRepresentation(self);
    return [utils writeData:data toPath:path];
}

- (BOOL)writeJPGToAbsolutePath:(NSString*)path using:(WattSerializationMode)serializationMode{
    WattUtils *utils=[[WattUtils alloc] init];
    [utils use:serializationMode];
    NSData *data=UIImageJPEGRepresentation(self, 0.5f);
    return [utils writeData:data toPath:path];
}



@end
