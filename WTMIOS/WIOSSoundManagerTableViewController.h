//
//  WIOSSoundManagerTableViewController.h
//  WTM
//
//  Created by Benoit Pereira da Silva on 02/09/13.
//  Copyright (c) 2013 Pereira da Silva. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WIOSSoundManagerTableViewController : UITableViewController

@property (nonatomic,strong)    WTMLibrary *library;
@property (nonatomic,readonly)  WTMCollectionOfMember *sounds;

@end
