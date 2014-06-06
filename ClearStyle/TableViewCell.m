//
//  TableViewCell.m
//  ClearStyle
//
//  Created by Mick Storm on 2/14/14.
//  Copyright (c) 2014 Mick Storm. All rights reserved.
//

#import "TableViewCell.h"
#import <QuartzCore/QuartzCore.h>


@implementation TableViewCell
{
    CAGradientLayer* _gradientLayer;
    CGPoint _originalCenter;
	BOOL _deleteOnDragRelease;
}



- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        _gradientLayer = [CAGradientLayer layer];
        _gradientLayer.frame = self.bounds;
        _gradientLayer.colors = @[(id)[[UIColor colorWithWhite:1.0f alpha:0.2f] CGColor],
                                  (id)[[UIColor colorWithWhite:1.0f alpha:0.1f] CGColor],
                                  (id)[[UIColor clearColor] CGColor],
                                  (id)[[UIColor colorWithWhite:0.0f alpha:0.1f] CGColor]];
        _gradientLayer.locations = @[@0.00f, @0.01f, @0.95f, @1.00f];
       //[self.layer insertSublayer:_gradientLayer atIndex:1];
        
        UIGestureRecognizer* recognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePan:)];
        recognizer.delegate = self;
        [self addGestureRecognizer:recognizer];
        //[self setBackgroundColor:[UIColor orangeColor]];
        NSLog(@"running cell init");
        //layout cell
        
        //companyname
        self.companyName = [[UILabel alloc]initWithFrame:CGRectMake(7, 33, 200, 50)];
        self.companyName.textColor = [UIColor whiteColor];
        self.companyName.font = [UIFont systemFontOfSize:12];
        self.companyName.alpha = 0.0;
        [self addSubview:self.companyName];
        
        //companyShortName
        
        self.companyShortName = [[UILabel alloc]initWithFrame:CGRectMake(7, 10, 200, 50)];
        self.companyShortName.textColor = [UIColor whiteColor];
        self.companyShortName.font = [UIFont systemFontOfSize:35];
        self.companyShortName.alpha = 0.0;
        [self addSubview:self.companyShortName];
        
        //companyPrice
        
        self.price = [[UILabel alloc]initWithFrame:CGRectMake(105, 10, 120, 50)];
        self.price.textColor = [UIColor whiteColor];
        self.price.font = [UIFont systemFontOfSize:28];
        self.price.textAlignment = NSTextAlignmentRight;
        self.price.alpha = 0.0;
        [self addSubview:self.price];
        
        //companyPriceChange
        
        self.priceChange = [[UILabel alloc]initWithFrame:CGRectMake(160, 10, 150, 50)];
        self.priceChange.textColor = [UIColor whiteColor];
        self.priceChange.font = [UIFont systemFontOfSize:28];
        self.priceChange.textAlignment = NSTextAlignmentRight;
        self.priceChange.alpha = 0;
        [self addSubview:self.priceChange];
        
        
        NSLog(@"*****************FRAME HEIGHT: %f", self.bounds.size.height );
        
       
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void) layoutSubviews {
    [super layoutSubviews];
    // ensure the gradient layers occupies the full bounds
    _gradientLayer.frame = self.bounds;
    NSLog(@"---------------------------bounds %f", self.bounds.size.height);
    if (self.bounds.size.height < 70) {
        float fontsize = self.bounds.size.height * .4;
        float padding = (self.bounds.size.height - fontsize) / 2;
        
        self.companyName.frame = CGRectMake(7, padding, 140, fontsize);
        self.companyName.font =[UIFont systemFontOfSize:fontsize];
        
        
        
        self.priceChange.frame = CGRectMake(160, padding, 150, fontsize);
        self.priceChange.font = [UIFont systemFontOfSize:fontsize];
        
        self.price.frame = CGRectMake(105, padding, 120, fontsize);
        self.price.font = [UIFont systemFontOfSize:fontsize];
        
    }
 
        
        if (self.frame.size.height > 69) {
            self.companyShortName.alpha = 1.0;
            self.companyName.alpha = 1.0;
            self.price.alpha = 1.0;
            self.priceChange.alpha = 1.0;
        } else {
            //self.companyShortName.alpha = 1.0;
            self.companyName.alpha = 1.0;
            self.price.alpha = 1.0;
            self.priceChange.alpha = 1.0;
        }
        
    

    
    
}

#pragma mark - horizontal pan gesture methods
-(BOOL)gestureRecognizerShouldBegin:(UIPanGestureRecognizer *)gestureRecognizer {
    CGPoint translation = [gestureRecognizer translationInView:[self superview]];
    // Check for horizontal gesture
    if (fabsf(translation.x) > fabsf(translation.y)) {
        return YES;
    }
    return NO;
}

-(void)handlePan:(UIPanGestureRecognizer *)recognizer {
    // 1
    if (recognizer.state == UIGestureRecognizerStateBegan) {
        // if the gesture has just started, record the current centre location
        _originalCenter = self.center;
    }
    
    // 2
    if (recognizer.state == UIGestureRecognizerStateChanged) {
        // translate the center
        CGPoint translation = [recognizer translationInView:self];
        self.center = CGPointMake(_originalCenter.x + translation.x, _originalCenter.y);
        // determine whether the item has been dragged far enough to initiate a delete / complete
        _deleteOnDragRelease = self.frame.origin.x < -self.frame.size.width / 4;
        
    }
    
    // 3
    if (recognizer.state == UIGestureRecognizerStateEnded) {
        // the frame this cell would have had before being dragged
        CGRect originalFrame = CGRectMake(0, self.frame.origin.y,
                                          self.bounds.size.width, self.bounds.size.height);
        if (!_deleteOnDragRelease) {
            // if the item is not being deleted, snap back to the original location
            [UIView animateWithDuration:0.2
                             animations:^{
                                 self.frame = originalFrame;
                             }
             ];
        }
        if (_deleteOnDragRelease) {
            // notify the delegate that this item should be deleted
            [self.delegate toDoItemDeleted:self.todoItem];
        }
    }
}


@end
