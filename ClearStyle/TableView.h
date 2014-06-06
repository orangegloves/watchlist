//
//  TableView.h
//  ClearStyle
//
//  Created by Mick Storm on 2/21/14.
//  Copyright (c) 2014 Mick Storm. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TableViewDataSource.h"

@interface TableView : UIView <UIScrollViewDelegate>


// dequeues a cell that can be reused
-(UIView*)dequeueReusableCell;

// registers a class for use as new cells
-(void)registerClassForCells:(Class)cellClass;
// an array of cells that are currently visible, sorted from top to bottom.
-(NSArray*)visibleCells;
// forces the table to dispose of all the cells and re-build the table.
-(void)reloadData;


// the object that acts as the data source for this table
@property (nonatomic, assign) id<TableViewDataSource> dataSource;


@end
