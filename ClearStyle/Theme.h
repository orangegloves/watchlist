//
//  Theme.h
//  watchlist
//
//  Created by Fernandes, Ashley on 6/6/14.
//  Copyright (c) 2014 Intuit. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Theme : NSObject

#pragma mark colors
//+ (UIColor *)getColor:(NSInteger)color;
+ (UIColor *)watchlistLightGreenColor;
+ (UIColor *)watchlistGreenColor;
+ (UIColor *)watchlistDarkGreenColor;
+ (UIColor *)watchlistLightRedColor;
+ (UIColor *)watchlistRedColor;
+ (UIColor *)watchlistDarkRedColor;
+ (UIColor *)watchlistGrayColor;

@end
