//
//  Stock.h
//  watchlist
//
//  Created by Fernandes, Ashley on 6/6/14.
//  Copyright (c) 2014 Intuit. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Stock : NSObject <NSXMLParserDelegate>

@property (strong, nonatomic) NSString *stockName;
@property (strong, nonatomic) NSString *stockExchange;
@property (strong, nonatomic) NSString *stockSymbol;
@property CGFloat stockPrice;
@property CGFloat stockChange;
@property CGFloat stockChangePercent;
@property CGFloat stockDayOpen;
@property CGFloat stockDayHigh;
@property CGFloat stockDayLow;
@property (strong, nonatomic) NSString *stockMktCap;
@property (strong, nonatomic) NSString *stockPeratio;
@property (strong, nonatomic) NSString *stockDivYield;
@property UIImageView *chartImageView;

@property (strong, nonatomic) NSDate *userPurchaseDate;
@property (strong, nonatomic) NSString *userBrokerage;
@property CGFloat userPurchasePrice;
@property NSInteger userPurchaseQuantity;
@property CGFloat userValue;
@property CGFloat userGainLoss;

@property NSArray *newsStories;

- (id)initWithSymbol:(NSString *)symbol;

@end