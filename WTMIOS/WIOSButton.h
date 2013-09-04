//
//  WIOButton.h
//  HopNBook
//
//  Created by Benoit Pereira da Silva on 04/09/13.
//  Copyright (c) 2013 HopToys. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WIOSButton : UIButton
/**
 *  We use this property to embed buttons in a collection view or table view easily
 */
@property (strong,nonatomic) NSIndexPath *indexPath;
@end
