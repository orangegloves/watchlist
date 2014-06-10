//
//  StockDetailViewController.m
//  watchlist
//
//  Created by Fernandes, Ashley on 6/5/14.
//  Copyright (c) 2014 Intuit. All rights reserved.
//

#import "StockDetailViewController.h"
#import "Stock.h"
#import "Theme.h"

@interface StockDetailViewController ()

@property (strong, nonatomic) IBOutlet UILabel *stockNameLabel;
@property (strong, nonatomic) IBOutlet UILabel *stockExchangeLabel;
@property (strong, nonatomic) IBOutlet UILabel *stockPriceLabel;
@property (strong, nonatomic) IBOutlet UILabel *stockSharesLabel;
@property (strong, nonatomic) IBOutlet UILabel *stockUserValueLabel;
@property (strong, nonatomic) IBOutlet UILabel *stockUserGainLossLabel;
@property (strong, nonatomic) IBOutlet UILabel *stockDayOpenLabel;
@property (strong, nonatomic) IBOutlet UILabel *stockDayHighLabel;
@property (strong, nonatomic) IBOutlet UILabel *stockDayLowLabel;
@property (strong, nonatomic) IBOutlet UILabel *stockMktCapLabel;
@property (strong, nonatomic) IBOutlet UILabel *stockPeratioLabel;
@property (strong, nonatomic) IBOutlet UILabel *stockDivYieldLabel;

@property (strong, nonatomic) IBOutlet UIView *stockChartView;
@property (strong, nonatomic) IBOutlet UIScrollView *stockNewsScrollView;
@property (strong, nonatomic) UIWebView *stockNewsWebView;

@property Stock *stockData;

- (IBAction)openChatter:(id)sender;

@end

@implementation StockDetailViewController

- (id)initWithSymbol:(NSString *)symbol {
    self = [[StockDetailViewController alloc] init];
    self.stockData = [[Stock alloc] initWithSymbol:symbol];
    
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self displayStockData];
}

- (IBAction)openChatter:(id)sender {
    [self.stockNewsWebView removeFromSuperview];
}

- (void)displayStockData {
    self.stockNameLabel.text = self.stockData.stockName;
    self.stockExchangeLabel.text = [NSString stringWithFormat:@"%@: %@", [self.stockData.stockExchange uppercaseString], self.stockData.stockSymbol];
    self.stockPriceLabel.text = [NSString stringWithFormat:@"%.2f  %@%.2f (%.2f%%)", self.stockData.stockPrice, (self.stockData.stockChange >= 0)?@"+":@"", self.stockData.stockChange, self.stockData.stockChangePercent];
    self.stockSharesLabel.text = [NSString stringWithFormat:@"%li Shares @ %@", (long)self.stockData.userPurchaseQuantity, self.stockData.userBrokerage];
    self.stockUserValueLabel.text = [NSString stringWithFormat:@"$%.2f", self.stockData.userValue];
    self.stockUserGainLossLabel.text = [NSString stringWithFormat:@"%@$%.2f", (self.stockData.userGainLoss >= 0)?@"+":@"", self.stockData.userGainLoss];
    self.stockDayOpenLabel.text = [NSString stringWithFormat:@"%.2f", self.stockData.stockDayOpen];
    self.stockDayHighLabel.text = [NSString stringWithFormat:@"%.2f", self.stockData.stockDayHigh];
    self.stockDayLowLabel.text = [NSString stringWithFormat:@"%.2f", self.stockData.stockDayLow];
    self.stockMktCapLabel.text = self.stockData.stockMktCap;
    self.stockPeratioLabel.text = self.stockData.stockPeratio;
    self.stockDivYieldLabel.text = self.stockData.stockDivYield;
    
    if (self.stockData.stockChange > 0) {
        self.stockPriceLabel.textColor = [Theme watchlistDarkGreenColor];
    } else if (self.stockData.stockChange < 0) {
        self.stockPriceLabel.textColor = [Theme watchlistDarkRedColor];
    }
    if (self.stockData.userGainLoss > 0) {
        self.stockUserGainLossLabel.textColor = [Theme watchlistDarkGreenColor];
    } else if (self.stockData.userGainLoss < 0) {
        self.stockUserGainLossLabel.textColor = [Theme watchlistDarkRedColor];
    }
    
    [self.stockChartView addSubview:self.stockData.chartImageView];
    
    
    UIEdgeInsets contentInsets = UIEdgeInsetsZero;
    self.stockNewsScrollView.contentInset = contentInsets;
    self.stockNewsScrollView.scrollIndicatorInsets = contentInsets;
    [[self.stockNewsScrollView subviews] makeObjectsPerformSelector:@selector(removeFromSuperview)];
    
    NSArray *feeds = self.stockData.newsStories;
    CGFloat y = 0.0f;
    CGFloat width = 240.0f;
    CGFloat height = 0.0f;
    UIFont *font = [UIFont fontWithName:@"HelveticaNeue-Light" size:12.0f];
    for (int i = 0; i < [self.stockData.newsStories count]; i++) {
        NSString *title = [feeds[i] objectForKey: @"title"];
        //NSString *link = [feeds[i] objectForKey: @"link"];
        //NSString *description = [feeds[i] objectForKey: @"description"];
        NSString *pubdate = [feeds[i] objectForKey: @"pubdate"];
        
        y = y + height;
        height = [self heightOfCellWithString:title withSuperviewWidth:width withFont:font];
        UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(10.0f, y, width, height)];
        button.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        button.titleLabel.lineBreakMode = NSLineBreakByWordWrapping;
        button.titleLabel.textAlignment = NSTextAlignmentLeft;
        button.titleLabel.font = font;
        button.tag = i;
        [button setTitle:title forState: UIControlStateNormal];
        [button setTitleColor:[UIColor colorWithRed:(51.0/255.0) green:(153.0/255.0) blue:(255.0/255.0) alpha:1.0] forState:UIControlStateNormal];
        [button addTarget:self
                   action:@selector(viewNewsArticle:)
         forControlEvents:UIControlEventTouchUpInside];
        [self.stockNewsScrollView addSubview:button];
        NSLog(@"%f", height);
        
        y = y + height;
        height = [self heightOfCellWithString:pubdate withSuperviewWidth:width withFont:font];
        UILabel *dateLabel = [[UILabel alloc] initWithFrame:CGRectMake(10.0f, y, width, height)];
        dateLabel.lineBreakMode = NSLineBreakByWordWrapping;
        dateLabel.numberOfLines = 0;
        dateLabel.font = font;
        dateLabel.textColor = [UIColor colorWithRed:(51.0/255.0) green:(51.0/255.0) blue:(51.0/255.0) alpha:1.0];
        dateLabel.text = pubdate;
        [self.stockNewsScrollView addSubview:dateLabel];

        y = y + height + 10;
    }
    
    self.stockNewsScrollView.contentSize = CGSizeMake(self.stockNewsScrollView.frame.size.width, y+10);
}

- (void)viewNewsArticle:(id)sender {
    UIButton *button = (UIButton*)sender;
    NSString *link = [self.stockData.newsStories[button.tag] objectForKey: @"link"];
    
    NSURL *url = [NSURL URLWithString:link];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    [self.stockNewsWebView removeFromSuperview];
    self.stockNewsWebView = nil;
    self.stockNewsWebView = [[UIWebView alloc] initWithFrame:CGRectMake(0,self.view.frame.size.height, self.view.frame.size.width, self.view.frame.size.height-50)];
    [self.view addSubview:self.stockNewsWebView];
    [self.stockNewsWebView setScalesPageToFit:YES];
    NSString* loadString = [NSString stringWithFormat: @"Loading..."];
    [self.stockNewsWebView loadHTMLString:loadString baseURL:nil];
    [self.stockNewsWebView loadRequest:request];
    
    [UIView animateWithDuration:1.0
                     animations:^{
                         self.stockNewsWebView.frame = CGRectMake(0, 50, self.view.frame.size.width, self.view.frame.size.height-50);

                     }];
}

- (CGFloat)heightOfCellWithString:(NSString *)ingredientLine withSuperviewWidth:(CGFloat)superviewWidth withFont:(UIFont *)font {
    CGFloat labelWidth = superviewWidth - 0.0f;
    CGSize labelContraints = CGSizeMake(labelWidth, 100.0f);
    NSStringDrawingContext *context = [[NSStringDrawingContext alloc] init];
    CGRect labelRect = [ingredientLine boundingRectWithSize:labelContraints
                                                    options:NSStringDrawingUsesLineFragmentOrigin
                                                 attributes:@{NSFontAttributeName:font}
                                                    context:context];
    return labelRect.size.height;
}

@end
