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

@protocol WIOSSoundRecorderDelegate <NSObject>
@required
- (void) soundHasBeenCreated:(WTMSound*)sound;
@end

@interface WIOSSoundManagerTableViewController : UITableViewController

@property (weak,nonatomic)      id<WIOSSoundRecorderDelegate>delegate;
@property (nonatomic,strong)    WTMLibrary *library;
@property (nonatomic,strong)    WTMSound *selectedSound; // You can select a sound within the list.

- (IBAction)editSound:(id)sender;

@end
