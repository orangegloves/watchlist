//
//  StockDetailViewController.h
//  watchlist
//
//  Created by Fernandes, Ashley on 6/5/14.
//  Copyright (c) 2014 Intuit. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Stock.h"

@interface StockDetailViewController : UIViewController

- (id)initWithSymbol:(NSString *)symbol;
- (id)initWithStock:(Stock *)stockData;

@end
