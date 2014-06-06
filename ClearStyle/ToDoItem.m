//
//  ToDoItem.m
//  ClearStyle
//
//  Created by Mick Storm on 2/14/14.
//  Copyright (c) 2014 Mick Storm. All rights reserved.
//

#import "ToDoItem.h"

@implementation ToDoItem

-(id)initWithText:(NSString*)text {
    if (self = [super init]) {
        self.text = text;
    }
    return self;
}

-(id)initWithCompanyName:(NSString*)companyName andShortName:(NSString*)companyShortName andPrice:(float)price andPriceChange:(float)priceChange {
    if (self = [super init]) {
        self.text = @"";
        self.companyName = companyName;
        self.companyShortName = companyShortName;
        self.price = price;
        self.priceChange = priceChange;
    }
    return self;
}


+(id)toDoItemWithText:(NSString *)text {
    return [[ToDoItem alloc] initWithText:text];
}

+(id)toDoItemWithCompanyName:(NSString*)companyName andShortName:(NSString*)companyShortName andPrice:(float)price andPriceChange:(float)priceChange {
    return [[ToDoItem alloc] initWithCompanyName:companyName andShortName:companyShortName andPrice:price andPriceChange:priceChange];
}


@end
