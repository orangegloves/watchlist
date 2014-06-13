//
//  Stock.m
//  watchlist
//
//  Created by Fernandes, Ashley on 6/6/14.
//  Copyright (c) 2014 Intuit. All rights reserved.
//

#import "Stock.h"

@interface Stock() {
    
NSXMLParser *parser;
NSMutableArray *feeds;
NSMutableDictionary *item;
NSMutableString *title;
NSMutableString *link;
NSMutableString *description;
NSMutableString *pubdate;
NSString *element;

}
@end

@implementation Stock

- (id)initWithSymbol:(NSString *)symbol {
    self = [[Stock alloc] init];
    
    self.stockSymbol = symbol;
    
    [self loadData];
    [self loadChart];
    [self loadNews];
    [self loadUser:nil];
    
    return self;
}

- (void)loadData {
    [self loadDataFromYahooFinance];
}

- (void)loadChart {
    [self loadChartFromYahooFinance];
}

- (void)loadNews {
    [self loadNewsFromYahooFinance];
}

- (void)loadUser:(NSObject *)user {
    NSDateComponents *comps = [[NSDateComponents alloc] init];
    [comps setDay:10];
    [comps setMonth:10];
    [comps setYear:2010];
    self.userPurchaseDate = [[NSCalendar currentCalendar] dateFromComponents:comps];
    
    self.userBrokerage = @"Charles Schwab";
    self.userPurchasePrice = 39.81;
    self.userPurchaseQuantity = 20;
    
    self.userValue = self.userPurchaseQuantity * self.stockPrice;
    CGFloat userPurchaseValue = self.userPurchaseQuantity * self.userPurchasePrice;
    self.userGainLoss = self.userValue - userPurchaseValue;
}

- (void)loadDataFromYahooFinance {
    NSMutableString *financeUrl = [[NSMutableString alloc] init];
    [financeUrl appendString:@"https://query.yahooapis.com/v1/public/yql?q=select%20*%20from%20yahoo.finance.quotes%20where%20symbol%20in%20(%22"];
    [financeUrl appendString:self.stockSymbol];
    [financeUrl appendString:@"%22)&format=json&env=store%3A%2F%2Fdatatables.org%2Falltableswithkeys&callback="];
    
    NSData *financeData = [[NSData alloc] initWithContentsOfURL: [NSURL URLWithString:[NSString stringWithString:financeUrl]]];
    NSError *error;
    NSMutableDictionary *json = [NSJSONSerialization
                                 JSONObjectWithData:financeData
                                 options:NSJSONReadingMutableContainers|NSJSONReadingMutableLeaves
                                 error:&error];
    
    if( error )
    {
        NSLog(@"%@", [error localizedDescription]);
    }
    else {
        NSArray *query = json[@"query"];
        
        self.stockMktCap = [[query valueForKeyPath:@"results.quote"] objectForKey:@"MarketCapitalization"];
        self.stockPeratio = [[query valueForKeyPath:@"results.quote"] objectForKey:@"PERatio"];
        self.stockPrice = [[[query valueForKeyPath:@"results.quote"] objectForKey:@"LastTradePriceOnly"] floatValue];
        self.stockChange = [[[query valueForKeyPath:@"results.quote"] objectForKey:@"Change"] floatValue];
        self.stockChangePercent = (self.stockChange / self.stockPrice) * 100.0;
        self.stockDayOpen = [[[query valueForKeyPath:@"results.quote"] objectForKey:@"Open"] floatValue];
        self.stockDayLow = [[[query valueForKeyPath:@"results.quote"] objectForKey:@"DaysLow"] floatValue];
        self.stockDayHigh = [[[query valueForKeyPath:@"results.quote"] objectForKey:@"DaysHigh"] floatValue];
        self.stockName = [[query valueForKeyPath:@"results.quote"] objectForKey:@"Name"];
        self.stockSymbol = [[query valueForKeyPath:@"results.quote"] objectForKey:@"Symbol"];
        self.stockExchange = [[query valueForKeyPath:@"results.quote"] objectForKey:@"StockExchange"];
        
        if ([[[query valueForKeyPath:@"results.quote"] objectForKey:@"DividendYield"] isKindOfClass:[NSString class]]) {
            self.stockDivYield = [[query valueForKeyPath:@"results.quote"] objectForKey:@"DividendYield"];
        }
    }
    
}

- (void)loadChartFromYahooFinance {
    NSMutableString *chartURL = [[NSMutableString alloc] init];
    [chartURL appendString:@"http://chart.finance.yahoo.com/z?s="];
    [chartURL appendString:self.stockSymbol];
    [chartURL appendString:@"&t=1d&q=l&l=on&z=s"];
    NSURL *chartImageURL = [NSURL URLWithString:[NSString stringWithString:chartURL]];
    self.chartImageView = [[UIImageView alloc] init];
    self.chartImageView.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:chartImageURL]];
    self.chartImageView.frame = CGRectMake(5, 0, 250, 105);
}

- (void)loadNewsFromYahooFinance {
    feeds = [[NSMutableArray alloc] init];
    
    NSMutableString *newsURL = [[NSMutableString alloc] init];
    [newsURL appendString:@"http://feeds.finance.yahoo.com/rss/2.0/headline?s="];
    [newsURL appendString:self.stockSymbol];
    [newsURL appendString:@"&region=US&lang=en-US"];

    NSURL *rssURL =[NSURL URLWithString:[NSString stringWithString:newsURL]];
    parser = [[NSXMLParser alloc] initWithContentsOfURL:rssURL];
    [parser setDelegate:self];
    [parser setShouldResolveExternalEntities:NO];
    [parser parse];
    
    self.newsStories = [NSArray arrayWithArray:feeds];
}

- (void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName attributes:(NSDictionary *)attributeDict {
    element = elementName;
    
    if ([element isEqualToString:@"item"]) {
        item    = [[NSMutableDictionary alloc] init];
        title   = [[NSMutableString alloc] init];
        link    = [[NSMutableString alloc] init];
        description   = [[NSMutableString alloc] init];
        pubdate    = [[NSMutableString alloc] init];
    }
}

- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string {
    if ([element isEqualToString:@"title"]) {
        [title appendString:string];
    } else if ([element isEqualToString:@"link"]) {
        [link appendString:string];
    } else if ([element isEqualToString:@"description"]) {
        [description appendString:string];
    } else if ([element isEqualToString:@"pubDate"]) {
        [pubdate appendString:string];
    }
}

- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName {
    if ([elementName isEqualToString:@"item"]) {
        [item setObject:title forKey:@"title"];
        [item setObject:link forKey:@"link"];
        [item setObject:description forKey:@"description"];
        [item setObject:pubdate forKey:@"pubdate"];
        
        [feeds addObject:[item copy]];        
    }
}


+ (NSMutableArray*)arrayForStockSymbols:(NSArray*)symbols {
    NSMutableArray *stocks = [[NSMutableArray alloc] init];
    NSMutableString *financeUrl = [[NSMutableString alloc] init];
    [financeUrl appendString:@"https://query.yahooapis.com/v1/public/yql?q=select%20*%20from%20yahoo.finance.quotes%20where%20symbol%20in%20("];
    for (int i = 0; i < [symbols count]; i++) {
        if (i > 0) {
            [financeUrl appendString:@"%2C"];
        }
        [financeUrl appendString:@"%22"];
        [financeUrl appendString:[symbols objectAtIndex:i]];
        [financeUrl appendString:@"%22"];
    }
    [financeUrl appendString:@")&format=json&env=store%3A%2F%2Fdatatables.org%2Falltableswithkeys&callback="];
    
    NSData *financeData = [[NSData alloc] initWithContentsOfURL: [NSURL URLWithString:[NSString stringWithString:financeUrl]]];
    NSError *error;
    NSMutableDictionary *json = [NSJSONSerialization
                                 JSONObjectWithData:financeData
                                 options:NSJSONReadingMutableContainers|NSJSONReadingMutableLeaves
                                 error:&error];
    
    if( error ) {
        NSLog(@"%@", [error localizedDescription]);
    } else {
        NSArray *query = json[@"query"];
        NSInteger numberOfStocks = [[json[@"query"] objectForKey:@"count"] intValue];
        
        for (int counter = 0; counter < numberOfStocks; counter++) {
            Stock *stockData = [[Stock alloc] init];
            
            if ([[[query valueForKeyPath:@"results.quote"][counter] objectForKey:@"MarketCapitalization"] isKindOfClass:[NSString class]]) {
                stockData.stockMktCap = [[query valueForKeyPath:@"results.quote"][counter] objectForKey:@"MarketCapitalization"];
            }
            if ([[[query valueForKeyPath:@"results.quote"][counter] objectForKey:@"PERatio"] isKindOfClass:[NSString class]]) {
                stockData.stockPeratio = [[query valueForKeyPath:@"results.quote"][counter] objectForKey:@"PERatio"];
            }
            if ([[[query valueForKeyPath:@"results.quote"][counter] objectForKey:@"LastTradePriceOnly"] isKindOfClass:[NSString class]]) {
                stockData.stockPrice = [[[query valueForKeyPath:@"results.quote"][counter] objectForKey:@"LastTradePriceOnly"] floatValue];
            }
            if ([[[query valueForKeyPath:@"results.quote"][counter] objectForKey:@"Change"] isKindOfClass:[NSString class]]) {
                stockData.stockChange = [[[query valueForKeyPath:@"results.quote"][counter] objectForKey:@"Change"] floatValue];
            }
            stockData.stockChangePercent = (stockData.stockChange / stockData.stockPrice) * 100.0;
            if ([[[query valueForKeyPath:@"results.quote"][counter] objectForKey:@"Open"] isKindOfClass:[NSString class]]) {
                stockData.stockDayOpen = [[[query valueForKeyPath:@"results.quote"][counter] objectForKey:@"Open"] floatValue];
            }
            if ([[[query valueForKeyPath:@"results.quote"][counter] objectForKey:@"DaysLow"] isKindOfClass:[NSString class]]) {
                stockData.stockDayLow = [[[query valueForKeyPath:@"results.quote"][counter] objectForKey:@"DaysLow"] floatValue];
            }
            if ([[[query valueForKeyPath:@"results.quote"][counter] objectForKey:@"DaysHigh"] isKindOfClass:[NSString class]]) {
                stockData.stockDayHigh = [[[query valueForKeyPath:@"results.quote"][counter] objectForKey:@"DaysHigh"] floatValue];
            }
            if ([[[query valueForKeyPath:@"results.quote"][counter] objectForKey:@"Name"] isKindOfClass:[NSString class]]) {
                stockData.stockName = [[query valueForKeyPath:@"results.quote"][counter] objectForKey:@"Name"];
            }
            if ([[[query valueForKeyPath:@"results.quote"][counter] objectForKey:@"Symbol"] isKindOfClass:[NSString class]]) {
                stockData.stockSymbol = [[query valueForKeyPath:@"results.quote"][counter] objectForKey:@"Symbol"];
            }
            if ([[[query valueForKeyPath:@"results.quote"][counter] objectForKey:@"StockExchange"] isKindOfClass:[NSString class]]) {
                stockData.stockExchange = [[query valueForKeyPath:@"results.quote"][counter] objectForKey:@"StockExchange"];
            }
            if ([[[query valueForKeyPath:@"results.quote"][counter] objectForKey:@"DividendYield"] isKindOfClass:[NSString class]]) {
                stockData.stockDivYield = [[query valueForKeyPath:@"results.quote"][counter] objectForKey:@"DividendYield"];
            }
            
            [stocks addObject:stockData];
        }
    }
    
    return stocks;
}


@end
