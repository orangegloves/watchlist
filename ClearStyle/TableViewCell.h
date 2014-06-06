//
//  TableViewCell.h
//  ClearStyle
//
//  Created by Mick Storm on 2/14/14.
//  Copyright (c) 2014 Mick Storm. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ToDoItem.h"
#import "TableViewCellDelegate.h"

@interface TableViewCell : UITableViewCell

// The item that this cell renders.
@property (nonatomic) ToDoItem *todoItem;

// The object that acts as delegate for this cell.
@property (nonatomic, assign) id<TableViewCellDelegate> delegate;
@property (nonatomic) UILabel *companyName;
@property (nonatomic) UILabel *companyShortName;
@property (nonatomic) UILabel *priceChange;
@property (nonatomic) UILabel *price;




@end
