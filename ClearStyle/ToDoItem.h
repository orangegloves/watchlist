//
//  ToDoItem.h
//  ClearStyle
//
//  Created by Mick Storm on 2/14/14.
//  Copyright (c) 2014 Mick Storm. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ToDoItem : NSObject

// A text description of this item.
@property (nonatomic, copy) NSString *text;
@property (nonatomic, copy) NSString *companyName;
@property (nonatomic, copy) NSString *companyShortName;
@property (nonatomic) float price;
@property (nonatomic) float priceChange;



// A Boolean value that determines the completed state of this item.
@property (nonatomic) BOOL completed;

// Returns an SHCToDoItem item initialized with the given text.
-(id)initWithText:(NSString*)text;
-(id)initWithCompanyName:(NSString*)companyName andShortName:(NSString*)companyShortName andPrice:(float)price andPriceChange:(float)priceChange;

// Returns an SHCToDoItem item initialized with the given text.
+(id)toDoItemWithText:(NSString*)text;

+(id)toDoItemWithCompanyName:(NSString*)companyName andShortName:(NSString*)companyShortName andPrice:(float)price andPriceChange:(float)priceChange;

@end
