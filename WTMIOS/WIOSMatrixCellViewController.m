//
//  WIOSMatrixCellViewController.m
//  HopNBook
//
//  Created by Benoit Pereira da Silva on 02/10/13.
//  Copyright (c) 2013 HopToys. All rights reserved.
//

#import "WIOSMatrixCellViewController.h"

@interface WIOSMatrixCellViewController ()

@end

@implementation WIOSMatrixCellViewController


#pragma mark  WIOSMatrixCellViewControllerProtocol


/**
 *  You should call this method to pass actions to the delegate matrix
 *
 *  @param identifier of the action to relay to the matrix
 */
- (void)didPerformActionWithIdentifier:(NSInteger)identifier{
    [self.matrix matrixCell:self didPerformActionWithIdentifier:identifier withInfos:nil];

}

/**
 *  You should call this method to pass actions to the delegate matrix
 *
 *  @param identifier identifier of the action to relay to the matrix
 *  @param infos      optional informations
 */
- (void)didPerformActionWithIdentifier:(NSInteger)identifier withInfos:(NSDictionary*)infos{
    [self.matrix matrixCell:self didPerformActionWithIdentifier:identifier withInfos:infos];
}


/**
 *  The model is passed to the controller for configuration
 *
 *  @param model the reference to the model
 */
- (void)configureViewControllerFor:(id)model{

}



@end
