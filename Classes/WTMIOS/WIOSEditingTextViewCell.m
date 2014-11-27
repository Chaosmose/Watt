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
//  WIOSEditingTextViewCell.h
//
//
//  Created by Benoit Pereira da Silva on 05/04/13.
//  Copyright (c) 2013 http://pereira-da-silva.com All rights reserved.
//


#import "WIOSEditingTextViewCell.h"

@implementation WIOSEditingTextViewCell

@synthesize reference = _reference;
@synthesize propertyName = _propertyName;

- (void)setReference:(WattObject*)reference{
    _reference=reference;
    [self _updateTextIfPossible];
}

- (WattObject*)reference{
    return _reference;
}

- (void)setPropertyName:(NSString *)propertyName{
    _propertyName=propertyName;
    [self _updateTextIfPossible];
}

- (NSString*)propertyName{
    return _propertyName;
}


- (void)_updateTextIfPossible{
    if(_reference && self.propertyName){
        self.textView.text=[self _textFromReference];
    }
     [self.textView setDelegate:self];
}

- (NSString*)_textFromReference{
    if(_reference && self.propertyName){
        SEL s=selectorGetterFromPropertyName(_propertyName);
        BOOL ok=[_reference respondsToSelector:s];
        if(ok){
             [_reference.registry setHasChanged:YES];
            return [_reference valueForKey:_propertyName];
        }else{
            [ NSException raise:@"Dynamic invokation failure"
                         format:@"_reference : %@ does not respond to %@", _reference, NSStringFromSelector(s)];
        }
    }
    return nil;
}

- (void)_applyTextToReference:(NSString*)text{
     if(_reference && self.propertyName){
         SEL s=selectorSetterFromPropertyName(_propertyName);
         BOOL ok=[_reference respondsToSelector:s];
         if(ok){
             [_reference.registry setHasChanged:YES];
             [_reference setValue:text
                           forKey:_propertyName];
         }else{
             [ NSException raise:@"Dynamic invokation failure"
                          format:@"_reference : %@ does not respond to %@", _reference, NSStringFromSelector(s)];
         }
     }
}

#pragma  mark UITextViewDelegate

- (void)textViewDidChange:(UITextView *)textView{
    [self _checkChanges];
}


- (void)_checkChanges{
    if((self.reference && ![[self _textFromReference] isEqualToString:self.textView.text]) || ![self _textFromReference]){
        [self _applyTextToReference:self.textView.text];
        if([self.reference respondsToSelector:@selector(registry)]){
            WattRegistry*r=[self.reference performSelector:@selector(registry) withObject:nil];
            r.hasChanged=YES;
        }
        
    }
}

@end
