//
//  WIOButton.h
//  Watt
//
//  Created by Benoit Pereira da Silva on 04/09/13.
//  Copyright (c) 2013 pereira-da-silva.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WIOSButton : UIButton
/**
 *  We use this property to embed buttons in a collection view or table view easily
 */
@property (strong,nonatomic) NSIndexPath *indexPath;
@end
