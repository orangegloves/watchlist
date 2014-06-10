//
//  TableViewCellDelegate.h
//  ClearStyle
//
//  Created by Mick Storm on 2/14/14.
//  Copyright (c) 2014 Mick Storm. All rights reserved.
//

#import "ToDoItem.h"

// A protocol that the SHCTableViewCell uses to inform of state change
@protocol TableViewCellDelegate <NSObject>

// indicates that the given item has been deleted
-(void) toDoItemDeleted:(ToDoItem*)todoItem;
-(void) showStock;

@end

