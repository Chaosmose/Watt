//
//  WIOSSoundManagerTableViewController.h
//  WTM
//
//  Created by Benoit Pereira da Silva on 02/09/13.
//  Copyright (c) 2013 Pereira da Silva. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WIOSSoundRecorderViewController.h"
#import "WIOSSoundListCell.h"
#import "WTMSound.h"
#import "WTMLibrary.h"

@protocol WIOSSoundRecorderDelegate <NSObject>
@required
- (void) soundHasBeenCreated:(WTMSound*)sound;
- (void) selectedSoundIs:(WTMSound*)sound;
@end

@interface WIOSSoundManagerTableViewController : UITableViewController


- (void)setUpWithSound:(WTMSound*)sound
           fromLibrary:(WTMLibrary*)library
       useCategoryName:(NSString*)category
            anDelegate:(id<WIOSSoundRecorderDelegate>)delegate;

- (IBAction)editSound:(id)sender;




@end
