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
@interface WIOSMatrixViewController : UIViewController<UIGestureRecognizerDelegate>


@property (nonatomic) NSUInteger selectedIndex;

/**
 *  Reloads and displays the cells animated or not
 *
 *  @param animated should the cell transition be animated
 */
- (void)reloadCellsAnimated:(BOOL)animated;

/**
*  Reloads and displays the cells animated or not with animations options
*
*  @param animated should the cell transition be animated
*  @param options  check UIViewAnimationOptions
*/
- (void)reloadCellsAnimated:(BOOL)animated withAnimationOptions:(NSUInteger)options;


/**
 *  Displays the celles according to the current geometry (without reloading)
 *
 *  @param animated  should the transition be animated
 */
- (void)displayCellsAnimated:(BOOL)animated;

/**
 *  Displays the celles according to the current geometry (without reloading)
 *
 *  @param animated hould the cell transition be animated
 *  @param options  check UIViewAnimationOptions
 */
- (void)displayCellsAnimated:(BOOL)animated withAnimationOptions:(NSUInteger)options;





@end
