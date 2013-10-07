//
//  WIOSMatrixCellViewController.m
//  HopNBook
//
//  Created by Benoit Pereira da Silva on 02/10/13.
//  Copyright (c) 2013 HopToys. All rights reserved.
//

#import "WIOSMatrixCellViewController.h"

@interface WIOSMatrixCellViewController (){
    UITapGestureRecognizer *_tapRecognizer;
}

@end

@implementation WIOSMatrixCellViewController


#pragma mark -view life cycle and UIGesture tap management


- (BOOL)selected{
    if(!self.matrix || self.matrixIndex==NSNotFound)
        return NO;
    else
        return (self.matrixIndex==self.matrix.selectedIndex);
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    // We add the UITapGestureRecognizer
    _tapRecognizer=[[UITapGestureRecognizer alloc] initWithTarget:self
                                                           action:@selector(_handleTap:)];
    [_tapRecognizer setNumberOfTapsRequired:1];
    [_tapRecognizer setNumberOfTouchesRequired:1];
    [_tapRecognizer setDelegate:self.matrix];
    [self.view addGestureRecognizer:_tapRecognizer];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [_tapRecognizer removeTarget:self action:@selector(_handleTap:)];
    [self.view removeGestureRecognizer:_tapRecognizer];
    _tapRecognizer=nil;
}


- (void)_handleTap:(UITapGestureRecognizer *)sender{
    if (sender.state == UIGestureRecognizerStateEnded){
        if(self.selected==NO)
            self.matrix.selectedIndex=self.matrixIndex;
        [self didPerformActionWithIdentifier:WIOS_MATRIX_CELL_TAPPED_ACTION_IDENTIFIER];
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated{
    // Currently no default implementation
}

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
