//
//  ViewController.m
//  ClearStyle
//
//  Created by Mick Storm on 2/14/14.
//  Copyright (c) 2014 Mick Storm. All rights reserved.
//

#import "ViewController.h"
#import "ToDoItem.h"
#import "TableViewCell.h"
#import "StockDetailViewController.h"

@interface ViewController ()

@end

@implementation ViewController {
    // an array of to-do items
    NSMutableArray* _toDoItems;
    BOOL _isStockShowing;
    StockDetailViewController* _stockViewController;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// create a dummy to-do list
    _stockViewController = [[StockDetailViewController alloc] init];
    _toDoItems = [[NSMutableArray alloc] init];
    
    [_toDoItems addObject:[ToDoItem toDoItemWithCompanyName:@"Intuit" andShortName:@"INTU" andPrice:69.89f andPriceChange:+0.70f]];
    [_toDoItems addObject:[ToDoItem toDoItemWithCompanyName:@"Apple" andShortName:@"APPL" andPrice:550.12f andPriceChange:-45.93f]];
    [_toDoItems addObject:[ToDoItem toDoItemWithCompanyName:@"Umbrella Corp" andShortName:@"ZOMB" andPrice:11.01f andPriceChange:1.24f]];
    [_toDoItems addObject:[ToDoItem toDoItemWithCompanyName:@"Google" andShortName:@"GOOG" andPrice:1123.11f andPriceChange:34.92f]];
    [_toDoItems addObject:[ToDoItem toDoItemWithCompanyName:@"Cyberdyne" andShortName:@"CYBR" andPrice:88.66f andPriceChange:6.20f]];
    [_toDoItems addObject:[ToDoItem toDoItemWithCompanyName:@"AT&T" andShortName:@"T" andPrice:39.26f andPriceChange:0.66f]];
    [_toDoItems addObject:[ToDoItem toDoItemWithCompanyName:@"Tyrell Corp" andShortName:@"TYRL" andPrice:71.88f andPriceChange:-0.10f]];
    [_toDoItems addObject:[ToDoItem toDoItemWithCompanyName:@"Weyland-Yutani" andShortName:@"WY" andPrice:232.43f andPriceChange:0.50f]];
    [_toDoItems addObject:[ToDoItem toDoItemWithCompanyName:@"Activision Blizzard, Inc." andShortName:@"ATVI" andPrice:71.00f andPriceChange:0.00f]];
    [_toDoItems addObject:[ToDoItem toDoItemWithCompanyName:@"Take-Two Interactive Software" andShortName:@"TTWO" andPrice:21.75f andPriceChange:-0.10f]];
    [_toDoItems addObject:[ToDoItem toDoItemWithCompanyName:@"Trask Industries" andShortName:@"TRSK" andPrice:9.19f andPriceChange:0.09f]];
    [_toDoItems addObject:[ToDoItem toDoItemWithCompanyName:@"Sony" andShortName:@"SNY" andPrice:89.89f andPriceChange:-2.38f]];
    [_toDoItems addObject:[ToDoItem toDoItemWithCompanyName:@"Oscorp" andShortName:@"OSC" andPrice:41.25f andPriceChange:0.60f]];
    [_toDoItems addObject:[ToDoItem toDoItemWithCompanyName:@"CHOAM" andShortName:@"C" andPrice:3469.89f andPriceChange:200.70f]];
    [_toDoItems addObject:[ToDoItem toDoItemWithCompanyName:@"Dolby Laboratories" andShortName:@"DLBY" andPrice:5.50f andPriceChange:0.01f]];
    [_toDoItems addObject:[ToDoItem toDoItemWithCompanyName:@"Yoyodyne Propulsion Sys" andShortName:@"YOYO" andPrice:33.22f andPriceChange:-0.66]];
    [_toDoItems addObject:[ToDoItem toDoItemWithCompanyName:@"Microsoft Corporation" andShortName:@"MSFT" andPrice:54.12f andPriceChange:0.23f]];
    [_toDoItems addObject:[ToDoItem toDoItemWithCompanyName:@"Nakatomi Trading Corp" andShortName:@"NTC" andPrice:81.37f andPriceChange:0.55f]];
    
    _isStockShowing = false;
    self.tableView.dataSource = self;
    self.tableView.backgroundColor = [UIColor blackColor];
    [self.tableView registerClassForCells:[TableViewCell class]];
    
   // self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    //self.tableView.backgroundColor = [UIColor blackColor];
   // [self.tableView registerClass:[TableViewCell class] forCellReuseIdentifier:@"cell"];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - TableViewDataSource methods
-(NSInteger)numberOfRows {
    return _toDoItems.count;
    NSLog(@"number of items");
}

-(UITableViewCell *)cellForRow:(NSInteger)row {
   // NSString *ident = @"cell";
    
    
   // TableViewCell *cell = [[TableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:ident];
    TableViewCell* cell = (TableViewCell*)[self.tableView dequeueReusableCell];
    
    ToDoItem *item = _toDoItems[row];
    cell.todoItem = item;
    cell.delegate = self;
    cell.backgroundColor = [UIColor yellowColor];
    NSLog(@"New Cell");
   
       float percentChange = (item.price -(item.price - item.priceChange))/(item.price - item.priceChange);
        if (percentChange > 0.05) {
            cell.backgroundColor = [UIColor colorWithRed: (60/255.0f) green:(126/255.0f) blue: (51/255.0f) alpha:1.0];
        } else if(percentChange > 0.025) {
            cell.backgroundColor = [UIColor colorWithRed: (86/255.0f) green:(179/255.0f) blue: (73/255.0f) alpha:1.0];
        } else if (percentChange > 0.0 && percentChange < 0.025) {
            cell.backgroundColor = [UIColor colorWithRed: 0.2 green:0.6 blue: 0.2 alpha:1.0];
        } else if (percentChange == 0.0) {
            cell.backgroundColor = [UIColor colorWithRed: 0.2 green:0.2 blue: 0.2 alpha:1.0];
        } else if (percentChange < -0.05) {
            cell.backgroundColor = [UIColor colorWithRed: (227/255.0f) green:(61/255.0f) blue: (67/255.0f) alpha:1.0];
        } else if (percentChange < -0.025) {
            cell.backgroundColor = [UIColor colorWithRed: 0.8 green:0.2 blue: 0.2 alpha:1.0];
        } else {
            cell.backgroundColor = [UIColor colorWithRed: 1.0 green:0.2 blue: 0.2 alpha:1.0];
        }
    
        cell.companyName.text = item.companyName;
        cell.companyShortName.text = item.companyShortName;
        cell.priceChange.text = [NSString stringWithFormat:@"%.02f", item.priceChange];
        cell.price.text = [NSString stringWithFormat:@"%.02f", item.price];
        //set the text
        //cell.textLabel.text = item.companyName;

    return cell;
}

//-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
//    NSString *ident = @"cell";
//    // re-use or create a cell
//    TableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ident forIndexPath:indexPath];
//    cell.textLabel.backgroundColor = [UIColor clearColor];
//    // find the to-do item for this index
//    int index = [indexPath row];
//    //    cell.delegate = self;
//    cell.todoItem = item;
//    return cell;
//}

-(UIColor*)colorForIndex:(NSInteger) index {
    NSUInteger itemCount = _toDoItems.count - 1;
    float val = ((float)index / (float)itemCount) * 0.6;
    return [UIColor colorWithRed: 1.0 green:val blue: 0.0 alpha:1.0];
}

#pragma mark - UITableViewDataDelegate protocol methods
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 75.0f;
}
-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    //cell.backgroundColor = [self colorForIndex:indexPath.row];
    
}
-(void)showStock {
    NSLog(@"showingStock!");
    
 //   [self presentViewController:viewController animated:YES completion:nil];
    

    if(_isStockShowing) {
        
        
        [_stockViewController willMoveToParentViewController:nil];
        [_stockViewController.view removeFromSuperview];
        [_stockViewController removeFromParentViewController];
        NSLog(@"removing controller");
    } else {
    
        [self.view addSubview:_stockViewController.view];
        _stockViewController.view.frame = CGRectInset(self.view.bounds, 60,0);
        [_stockViewController didMoveToParentViewController:self];
        NSLog(@"adding controller");
        
    }
    _isStockShowing = !_isStockShowing;
    
}
-(void)toDoItemDeleted:(id)todoItem {
//    
//    float delay = 0.0;
//    //remove the model object
//    
//    [_toDoItems removeObject:todoItem];
//    
//    //find visible cells
//    NSArray *visibleCells = [self.tableView visibleCells];
//    UIView *lastView = [visibleCells lastObject];
//    bool startAnimating = false;
//    
//    for (TableViewCell *cell in visibleCells) {
//        if (startAnimating) {
//            [UIView animateWithDuration:0.3
//                                  delay:delay
//                                options:UIViewAnimationOptionCurveEaseInOut
//                             animations:^{
//                                 cell.frame = CGRectOffset(cell.frame, 0.0f, -cell.frame.size.height);
//                             }
//                             completion:^(BOOL finished){
//                                 if (cell == lastView) {
//                                     [self.tableView reloadData];
//                                 }
//                             }];
//            delay+=0.03;
//        }
//        
//        // if you have reached the item that was deleted, start animating
//        if (cell.todoItem == todoItem) {
//            startAnimating = true;
//            cell.hidden = YES;
//        }
//    }

    // use the UITableView to animate the removal of this row
   // NSUInteger index = [_toDoItems indexOfObject:todoItem];
    //[self.tableView beginUpdates];
    //[_toDoItems removeObject:todoItem];
    //[self.tableView deleteRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:index inSection:0]]
    //                      withRowAnimation:UITableViewRowAnimationFade];
    //[self.tableView endUpdates];
}


@end
