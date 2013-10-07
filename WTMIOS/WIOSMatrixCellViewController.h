//
//  WIOSMatrixCellViewController.h
//  HopNBook
//
//  Created by Benoit Pereira da Silva on 02/10/13.
//  Copyright (c) 2013 HopToys. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WIOSMatrixViewController.h"

#define WIOS_MATRIX_CELL_TAPPED_ACTION_IDENTIFIER 0

/**
 *  You matrix cell must inheritate from WIOSMatrixCellViewController 
 *  and conforms WIOSMatrixCellDataProtocol
 */
@class WIOSMatrixCellViewController;


@interface WIOSMatrixCellViewController : UIViewController

/**
 *  This property is automatically set by the WIOSMatrixViewController
 */
@property (weak,nonatomic) WIOSMatrixViewController<WIOSMatrixCellDelegateProtocol> *matrix;

@property (readonly,nonatomic) BOOL selected;

/**
 *  This property is automatically set by the WIOSMatrixViewController
 */
@property (nonatomic)NSInteger matrixIndex;

/**
 *  You should call this method to pass actions to the delegate matrix
 *
 *  @param identifier of the action to relay to the matrix
 */
- (void)didPerformActionWithIdentifier:(NSInteger)identifier;

/**
 *  You should call this method to pass actions to the delegate matrix
 *
 *  @param identifier identifier of the action to relay to the matrix
 *  @param infos      optional informations
 */
- (void)didPerformActionWithIdentifier:(NSInteger)identifier withInfos:(NSDictionary*)infos;


/**
 *  Called on selection
 *
 *  @param selected the selection status
 *  @param animated should we animate
 */
- (void)setSelected:(BOOL)selected animated:(BOOL)animated;




@end
