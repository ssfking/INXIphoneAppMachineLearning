//
//  SignalStrengthView.m
//  AutoInsurance
//
//  Created by Spencer King on 3/6/13.
//  Copyright (c) 2013 Spencer King. All rights reserved.
//

#import "SignalStrengthView.h"

@implementation SignalStrengthView

//@synthesize signalStrength = _signalStrength;

static int signalStrength = 0;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        //self.signalStrength = 0;
        self.noSignal = [[UILabel alloc] initWithFrame:CGRectMake(0, 10, 100, 40)];
        self.noSignal.text = @"No signal";
        self.noSignal.backgroundColor = [UIColor clearColor];
        self.noSignal.textAlignment = NSTextAlignmentLeft;
        [self.noSignal setFont:[UIFont fontWithName:@"Helvetica" size:15.0]];
        [self addSubview:self.noSignal];
        // Initialization code
    }
    return self;
}

-(void) resetFrame:(CGRect)rect {
    self.frame = rect;
    self.noSignal.frame = CGRectMake(self.bounds.origin.x, self.bounds.origin.y + 2, 100 , self.bounds.size.height-2);//self.bounds;
    //self.noSignal.frame.size.width = 50;
}

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    
    //int signalStrength = signalStrength;
    double currentHeight = 10;
    double currentX = 0;
    CGContextRef context = UIGraphicsGetCurrentContext();
    double totalHeight = self.bounds.size.height;
    double startingY = totalHeight/2 + 7.5 ;//totalHeight - (totalHeight - (currentHeight + 4*5))/2.0;
    /*
    CGContextSetFillColorWithColor(context, [UIColor redColor].CGColor);
    //CGContextSetAlpha(context, 0.5);
    CGContextFillEllipseInRect(context, CGRectMake(0,0,self.frame.size.width,self.frame.size.height));
    
    CGContextSetStrokeColorWithColor(context, [UIColor blueColor].CGColor);
    CGContextStrokeEllipseInRect(context, CGRectMake(0,0,self.frame.size.width,self.frame.size.height));
    */
    //what if signal strength is 0?
    int curSignalStrength = [SignalStrengthView getGlobalSignalStrength];
    
    if (curSignalStrength <=0) {
        self.noSignal.hidden = NO;
    } else {
        self.noSignal.hidden = YES;
        for (int i =1; i <=5; i++) {
            if (i <= curSignalStrength){
                CGRect rectangle = CGRectMake(currentX, startingY, 10, -1 *currentHeight);
                CGContextSetFillColorWithColor(context, [UIColor colorWithRed:139.0/255 green:125.0/255 blue:107.0/255 alpha:1].CGColor);
                CGContextAddRect(context, rectangle);
                CGContextFillRect(context,rectangle);
            } else {
                CGRect rectangle = CGRectMake(currentX, startingY, 10, -2);
                CGContextSetFillColorWithColor(context, [UIColor colorWithRed:205.0/255 green:192.0/255 blue:176.0/255 alpha:1].CGColor);
                CGContextAddRect(context, rectangle);
                CGContextFillRect(context,rectangle);
                
            }
            currentHeight+= 5;
            currentX += 12;
        }
    }

}

+ (void)setGlobalSignalStrength:(int)strength {
    @synchronized(self) {
    signalStrength = strength;
    }
}

+ (int) getGlobalSignalStrength {
    @synchronized(self) {
        return signalStrength;
    }
}


@end
