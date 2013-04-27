//
//  AccelerationCircleView.m
//  AutoInsurance
//
//  Created by Spencer King on 3/6/13.
//  Copyright (c) 2013 Spencer King. All rights reserved.
//

#import "AccelerationCircleView.h"

@interface AccelerationCircleView()
@property double x;
@property double y;
-(NSDictionary *) calculateFinalXYFromRawX:(double) x RawY:(double) y;
@end

@implementation AccelerationCircleView

@synthesize x = _x;
@synthesize y = _y;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        self.x = 0;
        self.y = 0;
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
    CGRect bounds = self.bounds;
    double circleWidth = bounds.size.width-20;
    CGContextSetFillColorWithColor(context, [UIColor colorWithRed:205.0/255 green:192.0/255 blue:176.0/255 alpha:1].CGColor);
    //CGContextSetAlpha(context, 0.5);
    CGContextFillEllipseInRect(context, CGRectMake(10,10,circleWidth,circleWidth));
    
    //draw smaller circle
    double xInCircle = (self.x +0.5)/1 * (circleWidth);
    double yInCircle = (0.5-self.y)/1 * (circleWidth);
    
    CGContextSetFillColorWithColor(context, [UIColor colorWithRed:139.0/255 green:125.0/255 blue:107.0/255 alpha:1].CGColor);
    //CGContextSetAlpha(context, 0.5);
    CGContextFillEllipseInRect(context, CGRectMake(10.0 + xInCircle - 9, 10.0 + yInCircle - 9, 18,18));
}

//returns {x:x, y:y}
- (NSDictionary *) calculateFinalXYFromRawX:(double) x RawY:(double) y{
    NSDictionary *dict = [[NSMutableDictionary alloc] init];
    double length = sqrt(x*x + y*y);
    double circleRadius = 0.5;
    double xFinal = x;
    double yFinal = y;
    if (length > circleRadius){
        double xNormalized = x/length;
        double yNormalized = y/length;
        xFinal = xNormalized * circleRadius;
        yFinal = yNormalized * circleRadius;
    }
    [dict setValue:[NSNumber numberWithDouble:xFinal] forKey:@"x"];
    [dict setValue:[NSNumber numberWithDouble:yFinal] forKey:@"y"];
    return dict;
}

- (void) setNewAccelerationWithX:(double) x Y:(double) y{
    NSDictionary *dict = [self calculateFinalXYFromRawX:x RawY:y];
    self.x = [[dict valueForKey:@"x"] doubleValue];
    self.y = [[dict valueForKey:@"y"] doubleValue];
    [self setNeedsDisplay];
}

@end
