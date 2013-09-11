//
//  WIOSSoundManagerTableViewController.h
//  WTM
//
//  Created by Benoit Pereira da Silva on 02/09/13.
//  Copyright (c) 2013 Pereira da Silva. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WTM.h"
#import "WIOSSoundRecorderViewController.h"
#import "WIOSSoundListCell.h"

@protocol WIOSSoundRecorderDelegate <NSObject>
@required
- (void) selectedSoundIs:(WTMSound*)sound;
- (void) willDeleteSound:(WTMSound*)sound;
- (void) noSound;
@end

@interface WIOSSoundManagerTableViewController : UITableViewController


- (void)setUpWithSound:(WTMSound*)sound
           fromLibrary:(WTMLibrary*)library
       useCategoryName:(NSString*)category
            anDelegate:(id<WIOSSoundRecorderDelegate>)delegate;

- (IBAction)editSound:(id)sender;




@end
