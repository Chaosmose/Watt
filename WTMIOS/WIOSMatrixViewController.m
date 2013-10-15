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
@property (strong,nonatomic)UIViewController *header;
@property (strong,nonatomic)UIViewController *footer;
@property (strong,nonatomic)NSMutableArray* matrixCellViewControllers;
@property (strong,nonatomic)NSMutableArray* positions;
@property (strong,nonatomic)UIImageView*matrixBackgroundImageView;
@end

@implementation WIOSMatrixViewController

@synthesize matrixCellViewControllers = _matrixCellViewControllers;
@synthesize positions = _positions;
@synthesize selectedIndex = _selectedIndex;
@synthesize header = _header;
@synthesize footer = _footer;

@synthesize matrixBackgroundImage = _matrixBackgroundImage;
@synthesize matrixBackgroundImageView = _matrixBackgroundImageView;


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
    WIOSMatrixViewController *__block blockSelf=self;
    NSInteger n=[[blockSelf _casted] viewControllersCount];
    if(n>0){
        [UIView animateWithDuration:animated?0.2f:0.f
                              delay:0.f
                            options:options
                         animations:^{
                             BOOL isLandscapeOrientation= UIDeviceOrientationIsLandscape([[UIApplication sharedApplication] statusBarOrientation]);
                             
                             CGSize viewSize=blockSelf.view.bounds.size;
                             
                             if(blockSelf.matrixBackgroundImage){
                                 if(!blockSelf.matrixBackgroundImageView){
                                     blockSelf.matrixBackgroundImageView=[[UIImageView alloc] initWithFrame:blockSelf.view.bounds];
                                     [blockSelf.matrixBackgroundImageView setContentMode:UIViewContentModeScaleAspectFill];
                                     [_matrixBackgroundImageView setAutoresizingMask:UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight];
                                     [_matrixBackgroundImageView setImage:_matrixBackgroundImage];
                                 }else{
                                     [_matrixBackgroundImageView setImage:_matrixBackgroundImage];
                                 }
                                 if(!_matrixBackgroundImageView.superview){
                                     [blockSelf.view addSubview:_matrixBackgroundImageView];
                                 }
                             }else{
                                 [blockSelf.matrixBackgroundImageView removeFromSuperview];
                             }
                             
                             
                             CGFloat minHSP=[[blockSelf _casted] cellMinimumHorizontalSpacing];
                             CGFloat minVSP=[[blockSelf _casted] cellMinimumVerticalSpacing];
                             
                             CGFloat headerHeight=isLandscapeOrientation?[blockSelf headerHeightForLandscapeOrientation]:[blockSelf headerHeightForPortraitOrientation];
                             CGFloat footerHeight=isLandscapeOrientation?[blockSelf footerHeightForLandscapeOrientation]:[blockSelf footerHeightForPortraitOrientation];
                             
                             
                             _positions=[NSMutableArray array];
                             
                             // HEADER
                             
                             if(!blockSelf.header){
                                 blockSelf.header=[[blockSelf _casted] headerViewController];
                             }
                             if(blockSelf.header.view){
                                 [blockSelf _addSupplementaryViewController:blockSelf.header
                                                                       atY:0.f
                                                                withHeight:headerHeight];
                             }
                             
                             // FOOTER
                             if(!blockSelf.footer){
                                 blockSelf.footer=[[blockSelf _casted] footerViewController];
                             }
                             if(blockSelf.footer){
                                 [blockSelf _addSupplementaryViewController:blockSelf.footer
                                                                       atY:viewSize.height-footerHeight
                                                                withHeight:footerHeight];
                             }
                             
                             // CELLS
                             
                             CGSize containerSize=[blockSelf _containerSize];
                             CGSize cellSize=[blockSelf _computeCellSize];
                             
                             NSInteger numberOfCellPerLine=(containerSize.width-(minHSP*2))/cellSize.width;
                             
                             NSUInteger nb=[[blockSelf _casted] viewControllersCount];
                             NSInteger lineNumber=0;
                             NSInteger columnNumber=0;
                             
                             CGFloat maxX=0.f;
                             CGFloat maxY=0.f;
                             
                             // WTLog( @"numberOfCellPerLine:%i for %i items",numberOfCellPerLine,nb);
                             
                             for (int i=0; i<nb; i++) {
                                 
                                 WIOSMatrixCellViewController*cellViewController=[[blockSelf _casted] viewControllerForIndex:i];
                                 
                                 // We register the view controller
                                 [blockSelf _registerViewController:cellViewController];
                                 
                                 CGRect destination=[blockSelf _destinationAtLineNumber:lineNumber
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
                             
                             
                             CGFloat deltaX=viewSize.width-maxX;
                             CGFloat deltaY=(viewSize.height-maxY);
                             deltaY+=headerHeight;
                             deltaY-=footerHeight;
                             for (int i=0; i<nb; i++) {
                                 
                                 // We do proceed to adjustement Vertical an horizontal of the box.
                                 CGRect destination=[[_positions objectAtIndex:i] CGRectValue];
                                 
                                 // Centering of the block
                                 destination.origin.x+= roundf(deltaX/2.f);
                                 destination.origin.y+= roundf(deltaY/2.f);
                                 
                                 WIOSMatrixCellViewController*cellViewController=[_matrixCellViewControllers objectAtIndex:i];
                                 [blockSelf _addViewController:cellViewController
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
    NSMutableArray *toBeRemoved=[NSMutableArray arrayWithArray:self.matrixCellViewControllers];
    if(self.header){
        [toBeRemoved addObject:self.header];
    }
    if(self.footer){
        [toBeRemoved addObject:self.footer];
    }
    for (UIViewController  *vc in toBeRemoved) {
        [vc willMoveToParentViewController:nil];
        [vc.view removeFromSuperview];
        [vc removeFromParentViewController];
    }
    
    
}


- (void)_postCellRemoval{
    [self.matrixCellViewControllers removeAllObjects];
    self.matrixCellViewControllers=[NSMutableArray array];
    self.header=nil;
    self.footer=nil;
}



- (void)_registerViewController:(WIOSMatrixCellViewController*)cellViewController{
    // We reference the matrix controller
    cellViewController.matrix=[self _casted];
    [_matrixCellViewControllers addObject:cellViewController];
    // And its index
    cellViewController.matrixIndex=[_matrixCellViewControllers count]-1;
}




- (void)_addViewController:(UIViewController*)cellViewController
             atDestination:(CGRect)destination{
    
    // We add the view controller.
    [self addChildViewController:cellViewController];
    // We setup the frame
    [cellViewController.view setFrame:destination];
    // We add its subview
    [self.view addSubview:cellViewController.view];
    
    //[cellViewController.view setAlpha:0.3f];
    
    // We notify the move to parent.
    [cellViewController didMoveToParentViewController:self];
}



- (void)_addSupplementaryViewController:(UIViewController*)viewController
                                    atY:(CGFloat)y
                             withHeight:(CGFloat)height{
    
    CGRect destination=CGRectMake(0, roundf(y), [self _containerSize].width, roundf(height));
    
    [self _addViewController:viewController
               atDestination:destination];
}



- (CGRect)_destinationAtLineNumber:(NSInteger)lineNumber
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
        CGSize containerSize=[self _containerSize];
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

- (CGSize)_containerSize{
    CGSize containerSize=self.view.bounds.size;
    BOOL isLandscapeOrientation= UIDeviceOrientationIsLandscape([[UIApplication sharedApplication] statusBarOrientation]);
    CGFloat footerHeight=isLandscapeOrientation?[self footerHeightForLandscapeOrientation]:[self footerHeightForPortraitOrientation];
    CGFloat headerHeight=isLandscapeOrientation?[self headerHeightForLandscapeOrientation]:[self headerHeightForPortraitOrientation];
    containerSize.height=containerSize.height-(headerHeight+footerHeight);
    return containerSize;
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


#pragma mark - facilities


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



#pragma  mark - UIGestureRecognizerDelegatew

- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer{
    return YES;
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer{
    return YES;
}

#pragma  mark -



// Default placeholder implementation


/**
 *  The matrix header view controller
 *
 *  @return the header view controller;
 */
- (UIViewController*)headerViewController{
    return nil;
}

/**
 *  The matrix header view controller
 *
 *  @return the footer view controller;
 */
- (UIViewController*)footerViewController{
    return nil;
}


/**
 *  The height of the header
 *
 *  @return return the height
 */
- (CGFloat)headerHeightForLandscapeOrientation{
    return 0.f;
}

/**
 *  The height of the footer
 *
 *  @return return the height
 */
- (CGFloat)footerHeightForLandscapeOrientation{
    return 0.f;
}

/**
 *  The height of the header
 *
 *  @return return the height
 */
- (CGFloat)headerHeightForPortraitOrientation{
    return 0.f;
}
/**
 *  The height of the footer
 *
 *  @return return the height
 */
- (CGFloat)footerHeightForPortraitOrientation{
    return 0.f;
}




- (NSString*)description{
    NSMutableString *s=[NSMutableString string];
    [s appendString:[super description]];
    [s appendString:@"\n"];
    [s appendFormat:@"navigation controller : %@ \n",self.navigationController.navigationBar];
    [s appendFormat:@"header : %@ %@\n",self.header,self.header.view];
    [s appendFormat:@"footer : %@ %@\n",self.footer,self.footer.view];
    
    int i=0;
    for (WIOSMatrixCellViewController  *vc in self.matrixCellViewControllers) {
        [s appendFormat:@"Cell %i : %@ %@ \n",i,vc,vc.view];
        i++;
    }
    [s appendFormat:@"toolbar : %@ %@\n",self.navigationController.toolbar,self.navigationController.toolbar];
    return s;
}

@end
