//
//  WIOSSoundListCell.h
//  Watt
//
//  Created by Benoit Pereira da Silva on 02/09/13.
//  Copyright (c) 2013 http://pereira-da-silva.com All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WIOSButton.h"

@protocol WIOSSOundSelectionProtocol
- (void)selectedIndexPathHasChanged:(NSIndexPath*)indexPath;
@end

@interface WIOSSoundListCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *soundNameLabel;
@property (weak, nonatomic) IBOutlet WIOSButton *editSoundButton;
@property (weak, nonatomic) IBOutlet UISwitch *selectedSwitch;
@property (weak, nonatomic) id <WIOSSOundSelectionProtocol>delegate;
- (IBAction)switched:(id)sender;
@end
