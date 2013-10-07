//
//  WIOSMatrixViewController.m
//  Watt
//
//  Created by Benoit Pereira da Silva on 02/10/13.
//  Copyright (c) 2013 pereira-da-silva.com All rights reserved.
//

#import "WIOSMatrixViewController.h"
#import "WIOSMatrixCellViewController.h"

@interface WIOSMatrixViewController(){
}
@property (strong,nonatomic)NSMutableArray* matrixCellViewControllers;
@property (strong,nonatomic)NSMutableArray* positions;
@end

@implementation WIOSMatrixViewController

@synthesize matrixCellViewControllers = _matrixCellViewControllers;
@synthesize positions = _positions;
@synthesize selectedIndex = _selectedIndex;



- (void)setSelectedIndex:(NSUInteger)selectedIndex{
    _selectedIndex=selectedIndex;
    for (WIOSMatrixCellViewController  *cellViewController in self.matrixCellViewControllers) {
        if(cellViewController.matrixIndex!=selectedIndex){
            [cellViewController setSelected:NO animated:YES];
        }
        if(cellViewController.matrixIndex==selectedIndex){
            [cellViewController setSelected:YES animated:YES];
        }
    }
}


- (NSUInteger)selectedIndex{
    return _selectedIndex;
}


/**
 *  Display the cells animated or not
 *
 *  @param animated should the cell transition be animated
 */
- (void)reloadCellsAnimated:(BOOL)animated{
    [self reloadCellsAnimated:animated
          withAnimationOptions:UIViewAnimationOptionCurveEaseInOut|UIViewAnimationOptionTransitionCurlUp];
}

/**
 *   Display the cells animated or not with animations options
 *
 *  @param animated should the cell transition be animated
 *  @param options  check UIViewAnimationOptions
 */
- (void)reloadCellsAnimated:(BOOL)animated withAnimationOptions:(NSUInteger)options{
    if([self _isConform]){
        WIOSMatrixViewController *__weak weakSelf=self;
        [self _loadMatrixCellViewControllersWith:^{
            [weakSelf displayCellsAnimated:animated withAnimationOptions:options];
        }animated:animated withAnimationOptions:options];
    }
}


/**
 *  Displays the celles according to the current geometry (without reloading)
 *
 *  @param animated  should the transition be animated
 */
- (void)displayCellsAnimated:(BOOL)animated{
    [self displayCellsAnimated:animated
          withAnimationOptions:UIViewAnimationOptionCurveEaseInOut|UIViewAnimationOptionTransitionCurlUp];
}

/**
 *  Displays the celles according to the current geometry (without reloading)
 *
 *  @param animated hould the cell transition be animated
 *  @param options  check UIViewAnimationOptions
 */
- (void)displayCellsAnimated:(BOOL)animated withAnimationOptions:(NSUInteger)options{
    WIOSMatrixViewController *__weak weakSelf=self;
    NSInteger n=[[weakSelf _casted] viewControllersCount];
    if(n>0){
        
        [UIView animateWithDuration:animated?0.2f:0.f
                              delay:0.f
                            options:options
                         animations:^{
                             CGSize containerSize=weakSelf.view.bounds.size;
                             CGSize cellSize=[weakSelf _computeCellSize];
                             
                             CGFloat minHSP=[[weakSelf _casted] cellMinimumHorizontalSpacing];
                             CGFloat minVSP=[[weakSelf _casted] cellMinimumVerticalSpacing];
                             
                             NSInteger numberOfCellPerLine=(containerSize.width-(minHSP*2))/cellSize.width;
                             
                             _positions=[NSMutableArray array];
                             
                             
                             NSUInteger nb=[[weakSelf _casted] viewControllersCount];
                             NSInteger lineNumber=0;
                             NSInteger columnNumber=0;
                             
                             CGFloat maxX=0.f;
                             CGFloat maxY=0.f;
                             
                             // WTLog( @"numberOfCellPerLine:%i for %i items",numberOfCellPerLine,nb);
                             
                             for (int i=0; i<nb; i++) {
                                 
                                 WIOSMatrixCellViewController*cellViewController=[[weakSelf _casted] viewControllerForIndex:i];
                                 
                                 // We register the view controller
                                 [weakSelf _registerViewController:cellViewController];
                                 
                                 CGRect destination=[weakSelf _destinationatLineNumber:lineNumber
                                                                       andColumnNumber:columnNumber
                                                                          withCellSize:cellSize];
                                 
                                 // We store the raw position
                                 [_positions addObject:[NSValue valueWithCGRect:destination]];
                                 
                                 if(columnNumber>=numberOfCellPerLine-1){
                                     maxX=destination.origin.x+destination.size.width+minHSP;
                                     columnNumber=0;
                                     lineNumber++;
                                 }else{
                                     columnNumber++;
                                 }
                                 maxY=destination.origin.y+destination.size.height+minVSP;
                             }
                             
                             
                             CGFloat deltaX=containerSize.width-maxX;
                             CGFloat deltaY=containerSize.height-maxY;
                             
                             for (int i=0; i<nb; i++) {
                                 
                                 // We do proceed to adjustement Vertical an horizontal of the box.
                                 CGRect destination=[[_positions objectAtIndex:i] CGRectValue];
                                 
                                 // Centering of the block
                                 destination.origin.x+= roundf(deltaX/2.f);
                                 destination.origin.y+= roundf(deltaY/2.f);
                                 
                                 WIOSMatrixCellViewController*cellViewController=[_matrixCellViewControllers objectAtIndex:i];
                                 [weakSelf _addCellViewController:cellViewController
                                                    atDestination:destination];
                             }
                         }
                         completion:^(BOOL finished) {
                             
                         }];
        
        
    }
}

- (void)_loadMatrixCellViewControllersWith:(void (^)(void))displayBlock
                                  animated:(BOOL)animated
                      withAnimationOptions:(NSUInteger)options{
    WIOSMatrixViewController *__weak weakSelf=self;
    [UIView animateWithDuration:animated?0.2f:0.f
                              delay:0.f
                            options:options
                         animations:^{
                             [weakSelf _removeMatrixCells];
                         }
                         completion:^(BOOL finished) {
                             [weakSelf _postCellRemoval];
                             displayBlock();
                         }];
}


- (void)_removeMatrixCells{
    for (WIOSMatrixCellViewController  *cellViewController in self.matrixCellViewControllers) {
        [cellViewController willMoveToParentViewController:nil];
        [cellViewController.view removeFromSuperview];
        [cellViewController removeFromParentViewController];
    }
}


- (void)_postCellRemoval{
    [self.matrixCellViewControllers removeAllObjects];
    self.matrixCellViewControllers=[NSMutableArray array];
}



- (void)_registerViewController:(WIOSMatrixCellViewController*)cellViewController{
    // We reference the matrix controller
    cellViewController.matrix=[self _casted];
    [_matrixCellViewControllers addObject:cellViewController];
    // And its index
    cellViewController.matrixIndex=[_matrixCellViewControllers count]-1;
}




- (void)_addCellViewController:(WIOSMatrixCellViewController*)cellViewController
                 atDestination:(CGRect)destination{
    
    // We add the view controller.
    [self addChildViewController:cellViewController];
    // We setup the frame
    [cellViewController.view setFrame:destination];
    // We add its subview
    [self.view addSubview:cellViewController.view];
    // We notify the move to parent.
    [cellViewController didMoveToParentViewController:self];
}


- (CGRect)_destinationatLineNumber:(NSInteger)lineNumber
                   andColumnNumber:(NSInteger)columnNumber
                      withCellSize:(CGSize)cellSize{
    
    CGFloat hSpace=[[self _casted] cellMinimumHorizontalSpacing];
    CGFloat vSpace=[[self _casted] cellMinimumVerticalSpacing];
    CGFloat x=columnNumber*(cellSize.width+hSpace)+hSpace;
    CGFloat y=lineNumber*(cellSize.height+vSpace)+vSpace;
    CGRect destination=CGRectMake(x,y, cellSize.width, cellSize.height);
    
    return destination;
    
}



#pragma mark - Cell size computation

- (CGSize)_computeCellSize{
    NSInteger n=[[self _casted] viewControllersCount];
    CGSize cellSize=CGSizeZero;
    if(n>0){
        // We try to find a solution to arrange the cells in the matrix
        CGSize containerSize=self.view.bounds.size;
        CGFloat containerSurface=(CGFloat)containerSize.width*containerSize.height;
        CGFloat surfacePerCell=(containerSurface/(CGFloat)n); // WE should remove padding surface for a more accurate approximation
        
        BOOL isLandscapeOrientation= UIDeviceOrientationIsLandscape([[UIApplication sharedApplication] statusBarOrientation]);
        CGSize desiredCellSize=isLandscapeOrientation?  [[self _casted] cellDesiredSizeForLandscapeOrientation]:\
        [[self _casted] cellDesiredSizeForPortraitOrientation];
        
        CGFloat ratioHW=desiredCellSize.height/desiredCellSize.width;
        CGFloat cellWidth= sqrtf(surfacePerCell/ratioHW);
        CGFloat cellHeight=cellWidth*ratioHW;
        
        CGSize spacerSize=CGSizeMake([[self _casted] cellMinimumHorizontalSpacing], [[self _casted] cellMinimumVerticalSpacing]);
        cellSize=CGSizeMake(cellWidth, cellHeight);
        BOOL fits=NO;
        while (!fits) {
            fits=[self _anEnsembleOfCellNumber:n
                                  cellWithSize:cellSize
                         fitsContainerWithSize:containerSize
                                withSpacerSize:spacerSize];
            cellSize.width--;
            cellSize.height= cellSize.width*ratioHW;
        }
    }
    cellSize=CGSizeMake(floorf(cellSize.width), floorf(cellSize.height));
    return cellSize;
}


- (BOOL)_anEnsembleOfCellNumber:(NSInteger)n
                   cellWithSize:(CGSize)cellSize
          fitsContainerWithSize:(CGSize)containerSize
                 withSpacerSize:(CGSize)spacerSize{
    CGFloat line=1;
    CGFloat rowCumulatedWidth=spacerSize.width;
    for (int i=0; i<n; i++) {
        if(rowCumulatedWidth+spacerSize.width+cellSize.width>=containerSize.width){
            rowCumulatedWidth=spacerSize.width;//We reinitialize the row cumulated width
            line++;//we increment the line number.
        }
        rowCumulatedWidth=rowCumulatedWidth+spacerSize.width+cellSize.width;
        CGFloat cumulatedHeight=(line*(cellSize.height+spacerSize.height*2.f))-spacerSize.height;
        if(cumulatedHeight>containerSize.height){
            return NO;
        }
    }
    return YES;
}


#pragma - mark facilities


- (WIOSMatrixViewController<WIOSMatrixCellDelegateProtocol>*)_casted{
    return (WIOSMatrixViewController<WIOSMatrixCellDelegateProtocol>*)self;
}


- (BOOL)_isConform{
    if([self conformsToProtocol:@protocol(WIOSMatrixCellDelegateProtocol)]){
        return YES;
    }else{
        [NSException raise:NSStringFromClass([self class])
                    format:@"%@ must conforms to @protocol(WIOSMatrixCellDelegateProtocol)",NSStringFromClass([self class])];
    }
    return NO;
}



#pragma - mark UIGestureRecognizerDelegatew

- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer{
    return YES;
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer{
    return YES;
}

@end
