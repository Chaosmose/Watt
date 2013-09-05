//
//  WIOSSoundListCell.m
//  HopNBook
//
//  Created by Benoit Pereira da Silva on 02/09/13.
//  Copyright (c) 2013 HopToys. All rights reserved.
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

- (void)setSelected:(BOOL)selected animated:(BOOL)animated{
    [super setSelected:selected animated:animated];
    if(selected){
        [self setAccessoryType:UITableViewCellAccessoryCheckmark];
    }else{
        [self setAccessoryType:UITableViewCellAccessoryNone];
    }
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



@end
