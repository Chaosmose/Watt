//
//  WIOSMatrixViewController.h
//  Watt
//
//  Created by Benoit Pereira da Silva on 02/10/13.
//  Copyright (c) 2013 pereira-da-silva.com All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WIOSMatrixProtocol.h"

/**
 *  Your matrix controller need to inheritate from WIOSMatrixViewController 
 *  and conform to WIOSMatrixCellDelegateProtocol
 */
@interface WIOSMatrixViewController : UIViewController

- (void)displayCells;

@end
