//
//  ViewController.h
//  ClearStyle
//
//  Created by Mick Storm on 2/14/14.
//  Copyright (c) 2014 Mick Storm. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TableViewCellDelegate.h"
#import "TableView.h"
#import <Parse/Parse.h>

@interface ViewController : UIViewController <PFLogInViewControllerDelegate, PFSignUpViewControllerDelegate,TableViewCellDelegate, TableViewDataSource>

@property (weak, nonatomic) IBOutlet TableView *tableView;

@end
