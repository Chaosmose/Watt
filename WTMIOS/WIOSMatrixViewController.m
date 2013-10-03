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
    NSMutableArray*_matrixCellViewControllers;
}
@end

@implementation WIOSMatrixViewController

- (void)displayCells{
    if([self _isConform]){
    
        NSInteger n=[[self _casted] viewControllersCount];
        if(n>0){
            [self _removeMatrixCellViewControllers];
            CGSize containerSize=self.view.bounds.size;
            CGSize cellSize=[self _computeCellSize];
            NSInteger numberOfCellPerLine=(containerSize.width-[[self _casted] cellMinimumHorizontalSpacing])/(cellSize.width+[[self _casted] cellMinimumHorizontalSpacing]);
            
            NSUInteger nb=[[self _casted] viewControllersCount];
            NSInteger lineNumber=0;
            NSInteger columnNumber=0;
            for (int i=0; i<nb; i++) {
                WIOSMatrixCellViewController*cellViewController=[[self _casted] viewControllerForIndex:i];
                
                [self _addCellViewController:cellViewController
                                atLineNumber:lineNumber
                             andColumnNumber:columnNumber
                                withCellSize:cellSize];
                
                if(columnNumber>numberOfCellPerLine){
                    columnNumber=0;
                    lineNumber++;
                }else{
                    columnNumber++;
                }
            }
        }
    }
}

- (void)_removeMatrixCellViewControllers{
    for (WIOSMatrixCellViewController  *cellViewController in _matrixCellViewControllers) {
        [cellViewController willMoveToParentViewController:nil];
        [cellViewController.view removeFromSuperview];
        [cellViewController removeFromParentViewController];
    }
    [_matrixCellViewControllers removeAllObjects];
    _matrixCellViewControllers=nil;
}


- (void)_addCellViewController:(WIOSMatrixCellViewController*)cellViewController
                  atLineNumber:(NSInteger)lineNumber
               andColumnNumber:(NSInteger)columnNumber
                  withCellSize:(CGSize)cellSize{
    
    if(!_matrixCellViewControllers)
        
        
        // We reference the matrix controller
        cellViewController.matrix=[self _casted];
    [_matrixCellViewControllers addObject:cellViewController];
    // And its index
    cellViewController.matrixIndex=[_matrixCellViewControllers count]-1;
    
    CGFloat hSpace=[[self _casted] cellMinimumHorizontalSpacing];
    CGFloat vSpace=[[self _casted] cellMinimumVerticalSpacing];
    
    CGRect destination=CGRectMake(columnNumber*cellSize.width+hSpace, lineNumber*cellSize.height+vSpace, cellSize.width, cellSize.height);
    
    
    [self addChildViewController:cellViewController];
    [cellViewController.view setFrame:destination];
    [cellViewController.view setBackgroundColor:randomColor()];
    [self.view addSubview:cellViewController.view];
    [cellViewController didMoveToParentViewController:self];
    
    
    //Do We need to configure the autolayout ?
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
        
        CGSize desiredCellSize=isLandscapeOrientation()?  [[self _casted] cellDesiredSizeForLandscapeOrientation]:\
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
        [NSException raise:@"WIOSMatrixViewController"
                    format:@"%@ must conforms to @protocol(WIOSMatrixCellDelegateProtocol)",NSStringFromClass([self class])];
    }
    return NO;
}


UIColor *randomColor() {
    UIColor *theColor = [UIColor colorWithRed:((random() % 255) / 255.0f)
                                        green:((random() % 255) / 255.0f)
                                         blue:((random() % 255) / 255.0f)
                                        alpha:1.0f];
    return theColor;
}




@end
