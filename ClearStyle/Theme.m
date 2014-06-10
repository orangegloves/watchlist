//
//  Theme.m
//  watchlist
//
//  Created by Fernandes, Ashley on 6/6/14.
//  Copyright (c) 2014 Intuit. All rights reserved.
//

#import "Theme.h"

@implementation Theme



#pragma mark colors
//+ (UIColor *)getColor:(NSInteger)color;

+ (UIColor *)watchlistLightGreenColor {
    return [UIColor colorWithRed:(82/255.0) green:(204/255.0) blue:(102/255.0) alpha:1.0];
}

+ (UIColor *)watchlistGreenColor {
    return [UIColor colorWithRed:(36/255.0) green:(179/255.0) blue:(60/255.0) alpha:1.0];
}

+ (UIColor *)watchlistDarkGreenColor {
    return [UIColor colorWithRed:(0/255.0) green:(153/255.0) blue:(26/255.0) alpha:1.0];
}

+ (UIColor *)watchlistLightRedColor {
    return [UIColor colorWithRed:(255/255.0) green:(61/255.0) blue:(51/255.0) alpha:1.0];
}

+ (UIColor *)watchlistRedColor {
    return [UIColor colorWithRed:(230/255.0) green:(33/255.0) blue:(23/255.0) alpha:1.0];
}

+ (UIColor *)watchlistDarkRedColor {
    return [UIColor colorWithRed:(204/255.0) green:(10/255.0) blue:(0/255.0) alpha:1.0];
}

+ (UIColor *)watchlistGrayColor {
    return [UIColor colorWithRed:(57/255.0) green:(57/255.0) blue:(57/255.0) alpha:1.0];
}

@end
