//
//  TableViewDataSource.h
//  ClearStyle
//
//  Created by Mick Storm on 2/21/14.
//  Copyright (c) 2014 Mick Storm. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol TableViewDataSource <NSObject>

// Indicates the number of rows in the table
-(NSInteger)numberOfRows;

// Obtains the cell for the given row
-(UIView *)cellForRow:(NSInteger)row;

@end
