//
//  BeepView.m
//  AutoInsurance
//
//  Created by Spencer King on 3/6/13.
//  Copyright (c) 2013 Spencer King. All rights reserved.
//

#import "BeepView.h"

@implementation BeepView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
    }
    return self;
}

-(void) resetFrame:(CGRect)rect {
    self.frame = rect;
    //self.noSignal.frame = CGRectMake(10, self.bounds.size.height- 30, 100, 30);
}

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetFillColorWithColor(context, [UIColor colorWithRed:139.0/255 green:125.0/255 blue:107.0/255 alpha:1].CGColor);
    //CGContextSetAlpha(context, 0.5);
    CGContextFillEllipseInRect(context, CGRectMake(1,1,self.bounds.size.width-2,self.bounds.size.height-2));
    
    /*
    CGContextSetStrokeColorWithColor(context, [UIColor blueColor].CGColor);
     CGContextStrokeEllipseInRect(context,CGRectMake(0,0,self.frame.size.width,self.frame.size.height));
     */
}


@end
