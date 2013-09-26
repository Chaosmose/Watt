//
//  WIOSSoundListCell.m
//  Watt
//
//  Created by Benoit Pereira da Silva on 02/09/13.
//  Copyright (c) 2013 pereira-da-silva.com. All rights reserved.
//

#import "WIOSSoundListCell.h"

@implementation WIOSSoundListCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setEditing:(BOOL)editing animated:(BOOL)animated{
    [super setEditing:editing animated:animated];
    if(editing){
        [self.editSoundButton setAlpha:0.f];
        [self.editSoundButton setEnabled:NO];
    }else{
        [self.editSoundButton setAlpha:1.f];
        [self.editSoundButton setEnabled:YES];
    }
}

- (IBAction)switched:(id)sender {
    if (self.selectedSwitch.isOn) {
        [self.delegate selectedIndexPathHasChanged:self.editSoundButton.indexPath];
    }else{
        [self.delegate selectedIndexPathHasChanged:nil];
    }
}
@end
