//
//  TableView.m
//  ClearStyle
//
//  Created by Mick Storm on 2/21/14.
//  Copyright (c) 2014 Mick Storm. All rights reserved.
//

#import "TableView.h"
#import "TableViewCell.h"

@implementation TableView {
    // the scroll view that hosts the cells
    UIScrollView* _scrollView;
    float SHC_ROW_HEIGHT;
    // a set of cells that are reuseable
    NSMutableSet* _reuseCells;
    // the Class which indicates the cell type
    Class _cellClass;
    BOOL isScaling;
    BOOL _isBig;
    
}


-(id)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        _scrollView = [[UIScrollView alloc] initWithFrame:CGRectNull];
        _scrollView.delegate = self;
        [self addSubview:_scrollView];
        _scrollView.backgroundColor = [UIColor clearColor];
        self.backgroundColor = [UIColor clearColor];
        
        _reuseCells = [[NSMutableSet alloc] init];
        
        UIGestureRecognizer* recognizer = [[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(handlePinch:)];
        [self addGestureRecognizer:recognizer];
        SHC_ROW_HEIGHT = 60.0f;
        isScaling = NO;
        _isBig = YES;
    }
    return self;
}

-(void)layoutSubviews {
    _scrollView.frame = self.frame;
    [self refreshView];
}

// based on the current scroll location, recycles off-screen cells and
// creates new ones to fill the empty space.
-(void) refreshView {
    if (CGRectIsNull(_scrollView.frame)) {
        return;
    }
    // set the scrollview height
    _scrollView.contentSize = CGSizeMake(_scrollView.bounds.size.width,
                                         [_dataSource numberOfRows] * SHC_ROW_HEIGHT);
    // remove cells that are no longer visible
    for (UIView* cell in [self cellSubviews]) {
        // is the cell off the top of the scrollview?
        if (cell.frame.origin.y + cell.frame.size.height < _scrollView.contentOffset.y) {
          // [self recycleCell:cell];
        }
        // is the cell off the bottom of the scrollview?
        if (cell.frame.origin.y > _scrollView.contentOffset.y + _scrollView.frame.size.height) {
          // [self recycleCell:cell];
        }
    }
    
    // ensure you have a cell for each row
    int firstVisibleIndex = MAX(0, floor(_scrollView.contentOffset.y / SHC_ROW_HEIGHT));
    int lastVisibleIndex =(int) [_dataSource numberOfRows];
    //MIN([_dataSource numberOfRows],
      //                         firstVisibleIndex + 1 + ceil(_scrollView.frame.size.height / SHC_ROW_HEIGHT));
    for (int row = firstVisibleIndex; row < lastVisibleIndex; row++) {
        UIView* cell = [self cellForRow:row];
        if (!cell) {
            // create a new cell and add to the scrollview
            UIView* cell = [_dataSource cellForRow:row];
            float topEdgeForRow = row * SHC_ROW_HEIGHT;
            cell.frame = CGRectMake(0, topEdgeForRow, _scrollView.frame.size.width, SHC_ROW_HEIGHT);
            [_scrollView insertSubview:cell atIndex:0];
        }
    }
}

// recycles a cell by adding it the set of reuse cells and removing it from the view
-(void) recycleCell:(UIView*)cell {
    [_reuseCells addObject:cell];
    [cell removeFromSuperview];
}

// returns the cell for the given row, or nil if it doesn't exist
-(UIView*) cellForRow:(NSInteger)row {
    float topEdgeForRow = row * SHC_ROW_HEIGHT;
    for (UIView* cell in [self cellSubviews]) {
        if (cell.frame.origin.y == topEdgeForRow) {
            return cell;
        }
    }
    return nil;
}

-(NSArray*)cellSubviews {
    NSMutableArray* cells = [[NSMutableArray alloc] init];
    for (UIView* subView in _scrollView.subviews) {
        if ([subView isKindOfClass:[TableViewCell class]]) {
            [cells addObject:subView];
        }
    }
    return cells;
}

-(void)registerClassForCells:(Class)cellClass {
    _cellClass = cellClass;
}

-(UIView*)dequeueReusableCell {
    // first obtain a cell from the reuse pool
    UIView* cell = [_reuseCells anyObject];
    if (cell) {
        NSLog(@"Returning a cell from the pool");
        [_reuseCells removeObject:cell];
    }
    // otherwise create a new cell
    if (!cell) {
        NSLog(@"Creating a new cell");
        cell = [[_cellClass alloc] init];
    }
    return cell;
}

-(NSArray*) visibleCells {
    NSMutableArray* cells = [[NSMutableArray alloc] init];
    for (UIView* subView in [self cellSubviews]) {
        [cells addObject:subView];
        NSLog(@"cell added");
    }
    NSArray* sortedCells = [cells sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {
        UIView* view1 = (UIView*)obj1;
        UIView* view2 = (UIView*)obj2;
        float result = view2.frame.origin.y - view1.frame.origin.y;
        if (result > 0.0) {
            return NSOrderedAscending;
        } else if (result < 0.0){
            return NSOrderedDescending;
        } else {
            return NSOrderedSame;
        }
    }];
    return sortedCells;
}

-(void)reloadData {
    // remove all subviews
    [[self cellSubviews] makeObjectsPerformSelector:@selector(removeFromSuperview)];
    [self refreshView];
}


#pragma mark - UIScrollViewDelegate handlers
-(void)scrollViewDidScroll:(UIScrollView *)scrollView {
    [self refreshView];
}



#pragma mark - property setters
-(void)setDataSource:(id<TableViewDataSource>)dataSource {
    _dataSource = dataSource;
    [self refreshView];
}

-(void)handlePinch:(UIPinchGestureRecognizer *)recognizer {
    //TODO: Clever code goes here!
    
    
    UIView *lastView = [self.visibleCells lastObject];
    NSLog(@"pinching!");
    NSLog(@"Scale, %f", recognizer.scale);
    
    if (recognizer.scale < 0.7 && isScaling == NO && _isBig == YES) {
        SHC_ROW_HEIGHT = _scrollView.frame.size.height / [self.visibleCells count];
        NSLog(@"Height of frame %f", SHC_ROW_HEIGHT );
        
        isScaling = YES;
        _isBig = NO;
        [UIView animateWithDuration:0.01
                         animations:^{
                             //[_scrollView setContentOffset:CGPointMake(0, 0)];
                             //[_scrollView setContentOffset:CGPointZero animated:YES];
                              for (TableViewCell *cell in self.visibleCells) {
                                  cell.priceChange.alpha = 0;
                                  cell.price.alpha = 0;
                                  cell.companyShortName.alpha = 0;
                                  cell.companyName.alpha = 0;
                              }
                             
                         }
                         completion:^(BOOL finished) {
                             //hello
                             float delay = 0;
                             int numCells = 0;
                             for (TableViewCell *cell in self.visibleCells) {
                                 NSLog(@"Origin Start %f",cell.frame.origin.y);
                                 [UIView animateWithDuration:0.2
                                                       delay:delay
                                                     options:UIViewAnimationOptionCurveEaseInOut
                                                  animations:^{
                                                      NSLog(@"num:%i", numCells);
                                                      cell.frame = CGRectMake(cell.frame.origin.x, (SHC_ROW_HEIGHT * numCells),cell.frame.size.width ,SHC_ROW_HEIGHT );
                                                      
                                                      [_scrollView setContentOffset:CGPointMake(0, 0)];
                                                      
                                                  }
                                  
                                                  completion:^(BOOL finished){
                                                      NSLog(@"Origin End %f",cell.frame.origin.y);
                                                      if (cell == lastView) {
                                                          
                                                          [self reloadData];
                                                          isScaling = NO;
                                                          [self refreshView];
                                                      }
                                                  }];
                                 
                                 
                                 delay = delay + 0.00;
                                 numCells = numCells + 1;
                             }
                         }];
        
        
        
        
       
    } else if (recognizer.scale > 2 && isScaling == NO && _isBig == NO) {
        
        SHC_ROW_HEIGHT = 70;
        NSLog(@"Height of frame %f", SHC_ROW_HEIGHT );
        
        isScaling = YES;
        _isBig = YES;
        [UIView animateWithDuration:0.0
                         animations:^{
                             // [_scrollView setContentOffset:CGPointMake(0, 0) animated:YES];
                            // [_scrollView setContentOffset:CGPointZero];
                             
                         }
                         completion:^(BOOL finished) {
                             //hello
                             float delay = 0;
                             int numCells = 0;
                             for (TableViewCell *cell in self.visibleCells) {
                                 [UIView animateWithDuration:0.2
                                                       delay:delay
                                                     options:UIViewAnimationOptionCurveEaseInOut
                                                  animations:^{
                                                      NSLog(@"num:%i", numCells);
                                                      cell.frame = CGRectMake(cell.frame.origin.x, (SHC_ROW_HEIGHT * numCells) ,cell.frame.size.width ,SHC_ROW_HEIGHT );
                                                      cell.priceChange.alpha = 0;
                                                      cell.price.alpha = 0;
                                                      cell.companyShortName.alpha = 0;
                                                      cell.companyName.alpha = 0;
                                                      
                                                  }
                                  
                                                  completion:^(BOOL finished){
                                                      if (cell == lastView) {
                                                          [self reloadData];
                                                          isScaling = NO;
                                                          [self refreshView];
                                                      }
                                                  }];
                                 
                                 
                                 delay = delay + 0.0;
                                 numCells = numCells + 1;
                             }
                         }];

        
    }
    
   
       //   NSLog(@"Shrink!");
     //   SHC_ROW_HEIGHT = 20;
     //   [self refreshView];
  //  } else if (recognizer.scale < 0.5) {
     //   SHC_ROW_HEIGHT = 90.0f;
    
   // }
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
