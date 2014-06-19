//
//  WIOS.h
//  Watt
//
//  Created by Benoit Pereira da Silva on 02/09/13.
//  Copyright (c) 2013 http://pereira-da-silva.com . All rights reserved.
//


#import <UIKit/UIKit.h>

#define wtodo() [[[UIAlertView alloc] initWithTitle:@"!" message:@"Todo" delegate:nil cancelButtonTitle:NSLocalizedString(@"OK", @"OK choice in alerts") otherButtonTitles:nil] show]


#ifndef WIOS_h
#define WIOS_h

#import "WTM.h" // WTM dependency

#import "WIOSSoundRecorderViewController.h"
#import "WIOSSoundListCell.h"
#import "WIOSButton.h"
#import "WIOSSoundListCell.h"
#import "WIOSSoundRecorderViewController.h"
#import "WIOSSoundManagerTableViewController.h"
#endif
