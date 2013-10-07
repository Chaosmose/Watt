//
//  WIOSMatrixProtocol.h
//  Watt
//
//  Created by Benoit Pereira da Silva on 02/10/13.
//  Copyright (c) 2013 pereira-da-silva.com All rights reserved.
//

#import <Foundation/Foundation.h>

// The  WIOSMatrixViewController is a controller container
// that arrange cell view controllers (WIOSMatrixCellViewController) on one "screen"
// It adjust the cells according to the number of elements to fit the whole screen.

// Your matrix controller need to inheritate from WIOSMatrixViewController
// and conform to WIOSMatrixCellDelegateProtocol

//  You matrix cells must inheritate from WIOSMatrixCellViewController
//  and conforms WIOSMatrixCellDataProtocol


@class WIOSMatrixCellViewController;
@class WIOSMatrixViewController;


#pragma mark - WIOSMatrixCellDataProtocol

/**
 *  Your matrix cells view controller must adopt this protocol
 */
@protocol  WIOSMatrixCellDataProtocol
@required
/**
 *  The model is passed to the controller for configuration
 *
 *  @param model the reference to the model
 */
- (void)configureViewControllerWith:(id)model;

@end


#pragma mark - WIOSMatrixCellDelegateProtocol


/**
 *  The matrix must implement the WIOSMatrixCellDelegateProtocol
 */
@protocol WIOSMatrixCellDelegateProtocol

@required

/**
 *  Returns view controller for the given index
 *
 *  This selector should  :
 *  1- Instantiate the <WIOSMatrixCellViewController Class>*matrixCell=...;
 *  2- Reference the matriox  matrixCell.matrix=self;
 *  3- call id model=[self modelForIndex:index];
 *  4- configure the cell with : [cell configureViewControllerWith:model];
 *  You configureViewControllerWith:model may need to call if (self.view) to force the view loading
 *
 *  @param index of the viewController
 *
 *  @return return the viewController reference
 */
- (WIOSMatrixCellViewController<WIOSMatrixCellDataProtocol>*)viewControllerForIndex:(NSUInteger)index;

/**
 *  The number of view controller
 *
 *  @return NSUInteger
 */
- (NSUInteger)viewControllersCount;

/**
 *  The method should be used in the selector viewControllerForIndex:
 *  @param index the cell index
 *
 *  @return the model
 */
- (id)modelForIndex:(NSUInteger)index;

/**
 *  The desired size for landscape orientation
 *
 *  @return the size
 */
- (CGSize)cellDesiredSizeForLandscapeOrientation;


/**
 *  The desired size for portrait orientation
 *
 *  @return the size
 */
- (CGSize)cellDesiredSizeForPortraitOrientation;

/**
 *  The minimum vertical spacing between cells
 *
 *  @return the width
 */
- (CGFloat)cellMinimumVerticalSpacing;


/**
 *  The minimum horizontal spacing between cells
 *
 *  @return the height
 */
- (CGFloat)cellMinimumHorizontalSpacing;


@optional

/**
 *  This selector is call to pass actions to the matrix
 *
 *  @param identifier identifier of the action to relay to the matrix
 *  @param infos      optional informations
 */
- (void)matrixCell:(WIOSMatrixCellViewController*)cell didPerformActionWithIdentifier:(NSInteger)identifier withInfos:(NSDictionary*)infos;

@end
