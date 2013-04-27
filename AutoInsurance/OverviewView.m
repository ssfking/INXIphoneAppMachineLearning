//
//  OverviewView.m
//  AutoInsurance
//
//  Created by Spencer King on 3/6/13.
//  Copyright (c) 2013 Spencer King. All rights reserved.
//

#import "OverviewView.h"

@interface OverviewView()
//-(void)calibrateButtonClicked:(id)sender;
@end

@implementation OverviewView

@synthesize mainView = _mainView;
@synthesize signalStrengthView = _signalStrengthView;
@synthesize beepView = _beepView;
@synthesize signalStrength = _signalStrength;
@synthesize accelerationCircleView = _accelerationCircleView;
//@synthesize username = _username;
@synthesize speed = _speed;
@synthesize acceleration = _acceleration;
@synthesize accelerationUnit = _accelerationUnit;
@synthesize speedUnit = _speedUnit;
@synthesize speedLabel = _speedLabel;
@synthesize accelerationLabel = _accelerationLabel;
//@synthesize calibrateButton= _calibrateButton;
@synthesize coreMotionController = _coreMotionController;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        //self.backgroundColor = [UIColor colorWithRed:176.0/255 green:196.0/255 blue:222.0/255 alpha:1];
        self.backgroundColor = [UIColor colorWithRed:248/255.0 green:248/255.0 blue:255/255.0 alpha:1];
        /*
        UIView *mainView = [[UIView alloc] init];
        self.mainView = mainView;
        mainView.backgroundColor = [UIColor whiteColor];
        [self addSubview:mainView];
        */
        /*
        NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
        NSString * username = [prefs stringForKey:@"username"];
        ///NSLog(@"username is %@", username);
        self.username = [[UILabel alloc] initWithFrame:CGRectMake(10, 40, 320.0f, 30.0f)];
        if (username != nil) {
            self.username.text = [NSString stringWithFormat:@"Hi %@", username];
        } else {
            self.username.text = @"";
        }
		self.username.backgroundColor = [UIColor clearColor];
		self.username.textAlignment = NSTextAlignmentCenter;
		[mainView addSubview:self.username];
        */
        
        /*
        self.speedLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 280, 320.0f, 30.0f)];
		self.speedLabel.text = @"Speed:";
		self.speedLabel.backgroundColor = [UIColor clearColor];
		self.speedLabel.textAlignment = NSTextAlignmentCenter;
        [self.speedLabel setFont:[UIFont fontWithName:@"Helvetica" size:15.0]];
		[self addSubview:self.speedLabel];
        */
        
        /*
        self.calibrateButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        self.calibrateButton.frame= CGRectMake(60, 180.0, 234.0, 40.0);
        self.calibrateButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
        self.calibrateButton.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
        [self.calibrateButton setTitle:@"Calibrate" forState:UIControlStateNormal];
        [self.calibrateButton addTarget:self action:@selector(calibrateButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview: self.calibrateButton];
        */
        
        
        
        self.speed = [[UILabel alloc] initWithFrame:CGRectMake(10, 280, 320.0f, 30.0f)];
		//self.speed.text = @"0.00";
		self.speed.backgroundColor = [UIColor clearColor];
		self.speed.textAlignment = NSTextAlignmentCenter;
        [self.speed setFont:[UIFont fontWithName:@"Helvetica-Bold" size:70.0]];
		[self addSubview:self.speed];

        self.speedUnit = [[UILabel alloc] initWithFrame:CGRectMake(10, 280, 320.0f, 30.0f)];
		self.speedUnit.text = @"mi/hr";
		self.speedUnit.backgroundColor = [UIColor clearColor];
		self.speedUnit.textAlignment = NSTextAlignmentCenter;
        [self.speedUnit setFont:[UIFont fontWithName:@"Helvetica" size:15.0]];
		[self addSubview:self.speedUnit];
        
        self.accelerationCircleView = [[AccelerationCircleView alloc] init];
        [self addSubview:self.accelerationCircleView];

        /*
        self.accelerationLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 280, 320.0f, 30.0f)];
		self.accelerationLabel.text = @"Acceleration:";
		self.accelerationLabel.backgroundColor = [UIColor clearColor];
		self.accelerationLabel.textAlignment = NSTextAlignmentCenter;
        [self.accelerationLabel setFont:[UIFont fontWithName:@"Helvetica" size:15.0]];
		[self addSubview:self.accelerationLabel];
        */
        
        self.acceleration = [[UILabel alloc] initWithFrame:CGRectMake(10, 360, 320.0f, 30.0f)];
		//self.acceleration.text = @"0.00";
		self.acceleration.backgroundColor = [UIColor clearColor];
		self.acceleration.textAlignment = NSTextAlignmentCenter;
        [self.acceleration setFont:[UIFont fontWithName:@"Helvetica-Bold" size:30.0]];
		[self addSubview:self.acceleration];
        
        self.accelerationUnit = [[UILabel alloc] initWithFrame:CGRectMake(10, 360, 320.0f, 30.0f)];
		self.accelerationUnit.text = @"g";
		self.accelerationUnit.backgroundColor = [UIColor clearColor];
		self.accelerationUnit.textAlignment = NSTextAlignmentCenter;
		[self addSubview:self.accelerationUnit];
        
        self.signalStrengthView = [[SignalStrengthView alloc] init];
        //self.signalStrengthView.signalStrength = 5;
        [self addSubview:self.signalStrengthView];
        
        self.beepView = [[BeepView alloc] init];
        [self addSubview:self.beepView];
        self.beepView.hidden = YES;
        
        /*
        self.signalStrength = [[UILabel alloc] initWithFrame:CGRectMake(10, 80, 320.0f, 30.0f)];
		self.signalStrength.text = @"Signal:";
		self.signalStrength.backgroundColor = [UIColor clearColor];
		self.signalStrength.textAlignment = NSTextAlignmentCenter;
        self.signalStrength.textAlignment = UIControlContentVerticalAlignmentBottom;
		[self addSubview:self.signalStrength];
        */
        
        [self restoreToDefault];
    }
    return self;
}

- (void) resetFrame:(CGRect)rect {
    self.frame = rect;
    //self.mainView.frame = CGRectMake(10, 10, rect.size.width - 20, rect.size.height - 20);
    CGFloat mainHeight = self.bounds.size.height;
    CGFloat mainWidth = self.bounds.size.width;
    //self.username.frame = CGRectMake(10, 10, mainWidth-20, 30);
    
    CGSize speedSize = [self.speed.text sizeWithFont:self.speed.font constrainedToSize: CGSizeMake(800,800) lineBreakMode:self.speed.lineBreakMode];
    //double testing = self.speed.font.lineHeight;
    //self.calibrateButton.frame = CGRectMake(10,10,50,50);
    self.speed.frame = CGRectMake((mainWidth - speedSize.width)/2.0, mainHeight/7.0 - (self.speed.font.ascender/2.0), speedSize.width, speedSize.height);
    //CGRect yo = self.speed.frame;
    /////NSLog(@"%f\n",CGRectGetMinY(self.speed.frame));
    CGSize speedUnitSize = [self.speedUnit.text sizeWithFont:self.speedUnit.font constrainedToSize: CGSizeMake(800,100) lineBreakMode:self.speedUnit.lineBreakMode];
    self.speedUnit.frame = CGRectMake(CGRectGetMaxX(self.speed.frame) + 2, CGRectGetMinY(self.speed.frame) + self.speed.font.ascender - self.speedUnit.font.ascender, speedUnitSize.width, speedUnitSize.height);
    CGSize speedLabelSize = [self.speedLabel.text sizeWithFont:self.speedLabel.font constrainedToSize: CGSizeMake(800,800) lineBreakMode:self.speedLabel.lineBreakMode];
    self.speedLabel.frame = CGRectMake(10, CGRectGetMinY(self.speed.frame) - (speedLabelSize.height + 0)+ 5, mainWidth-20, speedLabelSize.height);

    self.accelerationCircleView.frame = CGRectMake((mainWidth - 140)/2.0,mainHeight/2.0 - (140/2),140,140);
    //CGSize accelerationLabelSize = [self.accelerationLabel.text sizeWithFont:self.accelerationLabel.font constrainedToSize: CGSizeMake(800,800) lineBreakMode:self.accelerationLabel.lineBreakMode];
    //self.accelerationLabel.frame = CGRectMake(10, CGRectGetMinY(self.accelerationCircleView.frame) - accelerationLabelSize.height - 5, mainWidth - 20, accelerationLabelSize.height);
    CGSize accSize = [self.acceleration.text sizeWithFont:self.acceleration.font constrainedToSize: CGSizeMake(800,800) lineBreakMode:self.acceleration.lineBreakMode];
    self.acceleration.frame = CGRectMake((mainWidth-accSize.width)/2,CGRectGetMaxY(self.accelerationCircleView.frame) + 1, accSize.width, accSize.height);
    CGSize accUnitSize = [self.accelerationUnit.text sizeWithFont:self.accelerationUnit.font constrainedToSize: CGSizeMake(800,100) lineBreakMode:self.accelerationUnit.lineBreakMode];
    self.accelerationUnit.frame = CGRectMake(CGRectGetMaxX(self.acceleration.frame) + 2, CGRectGetMinY(self.acceleration.frame) + self.acceleration.font.ascender - self.accelerationUnit.font.ascender, accUnitSize.width, accUnitSize.height);

    
    //self.signalStrength.frame = CGRectMake(30, mainHeight - 50, 52, 50);
    //[self.signalStrengthView resetFrame: CGRectMake(90, mainHeight - 50, mainWidth/3.0, 50)];
    //self.beepView.frame = CGRectMake(mainWidth - 45 , mainHeight - 36, 20, 20);
    [self.signalStrengthView resetFrame: CGRectMake(25, mainHeight - 50, mainWidth/3.0, 50)];
    self.beepView.frame = CGRectMake(mainWidth - 45 , mainHeight - 36, 20, 20);
    
}

-(void) restoreToDefault {
    [self newSpeed: @"0.00"];
    [self newAcceleration: @"0.00"];
    [self.accelerationCircleView setNewAccelerationWithX:0 Y:0];
    //[SignalStrengthView setGlobalSignalStrength:0];
    [self.signalStrengthView setNeedsDisplay];
    self.beepView.hidden = YES;
}

-(void) newSpeed: (NSString *) speed {
    self.speed.text = speed;
    
    CGFloat mainHeight = self.bounds.size.height;
    CGFloat mainWidth = self.bounds.size.width;
    CGSize speedSize = [self.speed.text sizeWithFont:self.speed.font constrainedToSize: CGSizeMake(800,800) lineBreakMode:self.speed.lineBreakMode];
    self.speed.frame = CGRectMake((mainWidth - speedSize.width)/2.0, mainHeight/7.0 - (self.speed.font.ascender/2.0), speedSize.width, speedSize.height);
    CGSize speedUnitSize = [self.speedUnit.text sizeWithFont:self.speedUnit.font constrainedToSize: CGSizeMake(800,100) lineBreakMode:self.speedUnit.lineBreakMode];
    self.speedUnit.frame = CGRectMake(CGRectGetMaxX(self.speed.frame) + 2, CGRectGetMinY(self.speed.frame) + self.speed.font.ascender - self.speedUnit.font.ascender, speedUnitSize.width, speedUnitSize.height);
}

-(void) newAcceleration: (NSString *) acceleration {
    self.acceleration.text = acceleration;
    
    //CGFloat mainHeight = self.bounds.size.height;
    CGFloat mainWidth = self.bounds.size.width;
    CGSize accSize = [self.acceleration.text sizeWithFont:self.acceleration.font constrainedToSize: CGSizeMake(800,800) lineBreakMode:self.acceleration.lineBreakMode];
    self.acceleration.frame = CGRectMake((mainWidth-accSize.width)/2,CGRectGetMaxY(self.accelerationCircleView.frame) + 1, accSize.width, accSize.height);
    CGSize accUnitSize = [self.accelerationUnit.text sizeWithFont:self.accelerationUnit.font constrainedToSize: CGSizeMake(800,100) lineBreakMode:self.accelerationUnit.lineBreakMode];
    self.accelerationUnit.frame = CGRectMake(CGRectGetMaxX(self.acceleration.frame) + 2, CGRectGetMinY(self.acceleration.frame) + self.acceleration.font.ascender - self.accelerationUnit.font.ascender, accUnitSize.width, accUnitSize.height);

}

/*
-(void)calibrateButtonClicked:(id)sender {
    self.coreMotionController.shouldCalibrate = YES;
}
*/

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
