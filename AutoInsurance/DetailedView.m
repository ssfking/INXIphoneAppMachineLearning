//
//  MainView.m
//  AutoInsurance
//
//  Created by Spencer King on 2/21/13.
//  Copyright (c) 2013 Spencer King. All rights reserved.
//

#import "DetailedView.h"

@implementation DetailedView

@synthesize latitude = _latitude;
@synthesize longitude = _longitude;
@synthesize altitude = _altitude;
@synthesize speed = _speed;
@synthesize username = _username;
@synthesize accelerationX = _accelerationX;
@synthesize accelerationY = _accelerationY;
@synthesize accelerationSum = _accelerationSum;
@synthesize horizontalAccuracy = _horizontalAccuracy;

@synthesize latitudeLabel = _latitudeLabel;
@synthesize longitudeLabel = _longitudeLabel;
@synthesize altitudeLabel = _altitudeLabel;
@synthesize speedLabel = _speedLabel;
@synthesize accelerationXLabel = _accelerationXLabel;
@synthesize accelerationYLabel = _accelerationYLabel;
@synthesize accelerationSumLabel = _accelerationSumLabel;
@synthesize horizontalAccuracyLabel = _horizontalAccuracyLabel;


//@synthesize mainView = _mainView;
@synthesize signalStrengthView = _signalStrengthView;
@synthesize beepView = _beepView;
@synthesize signalStrength = _signalStrength;


- (id)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        //self.backgroundColor = [UIColor colorWithRed:176.0/255 green:196.0/255 blue:222.0/255 alpha:1];
        self.backgroundColor = [UIColor colorWithRed:248/255.0 green:248/255.0 blue:255/255.0 alpha:1];
                
		self.latitude = [[UILabel alloc] initWithFrame:CGRectMake(10, 80, 320.0f, 30.0f)];
		//self.latitude.text = @"Latitude (degrees)";
		self.latitude.backgroundColor = [UIColor clearColor];
		self.latitude.textAlignment = NSTextAlignmentRight;
        [self.latitude setFont:[UIFont fontWithName:@"Helvetica" size:15.0]];
		[self addSubview:self.latitude];
        
		self.longitude = [[UILabel alloc] initWithFrame:CGRectMake(10, 120, 320.0f, 30.0f)];
		//self.longitude.text = @"Longitude (degrees)";
		self.longitude.backgroundColor = [UIColor clearColor];
		self.longitude.textAlignment = NSTextAlignmentRight;
        [self.longitude setFont:[UIFont fontWithName:@"Helvetica" size:15.0]];
		[self addSubview:self.longitude];

        self.altitude = [[UILabel alloc] initWithFrame:CGRectMake(10, 160, 320.0f, 30.0f)];
		//self.altitude.text = @"Altitude (m)";
		self.altitude.backgroundColor = [UIColor clearColor];
		self.altitude.textAlignment = NSTextAlignmentRight;
        [self.altitude setFont:[UIFont fontWithName:@"Helvetica" size:15.0]];
		[self addSubview:self.altitude];
        
        self.horizontalAccuracy = [[UILabel alloc] initWithFrame:CGRectMake(10, 200, 320.0f, 30.0f)];
		//self.horizontalAccuracy.text = @"Accuracy (m):";
		self.horizontalAccuracy.backgroundColor = [UIColor clearColor];
		self.horizontalAccuracy.textAlignment = NSTextAlignmentRight;
        [self.horizontalAccuracy setFont:[UIFont fontWithName:@"Helvetica" size:15.0]];
		[self addSubview:self.horizontalAccuracy];

        self.speed = [[UILabel alloc] initWithFrame:CGRectMake(10, 280, 320.0f, 30.0f)];
		//self.speed.text = @"Speed (mi/hr):";
		self.speed.backgroundColor = [UIColor clearColor];
		self.speed.textAlignment = NSTextAlignmentRight;
        [self.speed setFont:[UIFont fontWithName:@"Helvetica" size:15.0]];
		[self addSubview:self.speed];
        
        self.accelerationX = [[UILabel alloc] initWithFrame:CGRectMake(10, 360, 320.0f, 30.0f)];
		//self.accelerationX.text = @"Acceleration along x (g):";
		self.accelerationX.backgroundColor = [UIColor clearColor];
		self.accelerationX.textAlignment = NSTextAlignmentRight;
        [self.accelerationX setFont:[UIFont fontWithName:@"Helvetica" size:15.0]];
		[self addSubview:self.accelerationX];

        self.accelerationY = [[UILabel alloc] initWithFrame:CGRectMake(10, 360, 320.0f, 30.0f)];
		//self.accelerationY.text = @"Acceleration along y (g):";
		self.accelerationY.backgroundColor = [UIColor clearColor];
		self.accelerationY.textAlignment = NSTextAlignmentRight;
        [self.accelerationY setFont:[UIFont fontWithName:@"Helvetica" size:15.0]];
		[self addSubview:self.accelerationY];

        self.accelerationSum = [[UILabel alloc] initWithFrame:CGRectMake(30, 360, 320.0f, 30.0f)];
		//self.accelerationSum.text = @"Total acceleration (g):";
		self.accelerationSum.backgroundColor = [UIColor clearColor];
		self.accelerationSum.textAlignment = NSTextAlignmentRight;
        [self.accelerationSum setFont:[UIFont fontWithName:@"Helvetica" size:15.0]];
		[self addSubview:self.accelerationSum];

        
        self.latitudeLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 80, 320.0f, 30.0f)];
		self.latitudeLabel.text = @"Latitude (\u00b0)";
		self.latitudeLabel.backgroundColor = [UIColor clearColor];
		self.latitudeLabel.textAlignment = NSTextAlignmentLeft;
        [self.latitudeLabel setFont:[UIFont fontWithName:@"Helvetica-Bold" size:15.0]];
		[self addSubview:self.latitudeLabel];
        
		self.longitudeLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 120, 320.0f, 30.0f)];
		self.longitudeLabel.text = @"Longitude (\u00b0)";
		self.longitudeLabel.backgroundColor = [UIColor clearColor];
		self.longitudeLabel.textAlignment = NSTextAlignmentLeft;
        [self.longitudeLabel setFont:[UIFont fontWithName:@"Helvetica-Bold" size:15.0]];
		[self addSubview:self.longitudeLabel];
        
        self.altitudeLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 160, 320.0f, 30.0f)];
		self.altitudeLabel.text = @"Altitude (m)";
		self.altitudeLabel.backgroundColor = [UIColor clearColor];
		self.altitudeLabel.textAlignment = NSTextAlignmentLeft;
        [self.altitudeLabel setFont:[UIFont fontWithName:@"Helvetica-Bold" size:15.0]];
		[self addSubview:self.altitudeLabel];
        
        self.horizontalAccuracyLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 200, 320.0f, 30.0f)];
		self.horizontalAccuracyLabel.text = @"Horizontal accuracy (m)";
		self.horizontalAccuracyLabel.backgroundColor = [UIColor clearColor];
		self.horizontalAccuracyLabel.textAlignment = NSTextAlignmentLeft;
        self.horizontalAccuracyLabel.numberOfLines = 0;
        [self.horizontalAccuracyLabel setFont:[UIFont fontWithName:@"Helvetica-Bold" size:15.0]];
		[self addSubview:self.horizontalAccuracyLabel];
        
        self.speedLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 280, 320.0f, 30.0f)];
		self.speedLabel.text = @"Speed (mi/hr)";
		self.speedLabel.backgroundColor = [UIColor clearColor];
		self.speedLabel.textAlignment = NSTextAlignmentLeft;
        [self.speedLabel setFont:[UIFont fontWithName:@"Helvetica-Bold" size:15.0]];
		[self addSubview:self.speedLabel];
        
        self.accelerationXLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 360, 320.0f, 30.0f)];
		self.accelerationXLabel.text = @"X-axis acceleration (g)";
		self.accelerationXLabel.backgroundColor = [UIColor clearColor];
		self.accelerationXLabel.textAlignment = NSTextAlignmentLeft;
        self.accelerationXLabel.numberOfLines = 0;
        [self.accelerationXLabel setFont:[UIFont fontWithName:@"Helvetica-Bold" size:15.0]];
		[self addSubview:self.accelerationXLabel];
        
        self.accelerationYLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 360, 320.0f, 30.0f)];
		self.accelerationYLabel.text = @"Y-axis acceleration (g)";
		self.accelerationYLabel.backgroundColor = [UIColor clearColor];
		self.accelerationYLabel.textAlignment = NSTextAlignmentLeft;
        self.accelerationYLabel.numberOfLines = 0;
        [self.accelerationYLabel setFont:[UIFont fontWithName:@"Helvetica-Bold" size:15.0]];
		[self addSubview:self.accelerationYLabel];
        
        self.accelerationSumLabel = [[UILabel alloc] initWithFrame:CGRectMake(30, 360, 320.0f, 30.0f)];
		self.accelerationSumLabel.text = @"Total acceleration (g)";
		self.accelerationSumLabel.backgroundColor = [UIColor clearColor];
		self.accelerationSumLabel.textAlignment = NSTextAlignmentLeft;
        self.accelerationSumLabel.numberOfLines = 0;
        [self.accelerationSumLabel setFont:[UIFont fontWithName:@"Helvetica-Bold" size:15.0]];
		[self addSubview:self.accelerationSumLabel];
        
        
        [self restoreToDefault];
        
        /*
        self.timeStamp = [[UILabel alloc] initWithFrame:CGRectMake(10, 400, 320.0f, 30.0f)];
		self.timeStamp.text = @"";
		self.timeStamp.backgroundColor = [UIColor clearColor];
		self.timeStamp.textAlignment = NSTextAlignmentCenter;
		[mainView addSubview:self.timeStamp];
*/
        //[self addSubview:mainView];
        /*
         CGRect buttonFrame = CGRectMake(60, 209.0, 234.0, 37.0);;
         
         
         UIButton *buttonPress;
         buttonPress = [UIButton buttonWithType:UIButtonTypeRoundedRect];
         buttonPress.frame=buttonFrame;
         
         buttonPress.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
         buttonPress.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
         
         [buttonPress setTitle:@"PressMe" forState:UIControlStateNormal];
         
         [buttonPress addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchUpInside];
         
         [self addSubview:buttonPress];
         */
        self.signalStrengthView = [[SignalStrengthView alloc] init];
        //self.signalStrengthView.signalStrength = 5;
        [self addSubview:self.signalStrengthView];
        
        self.beepView = [[BeepView alloc] init];
        [self addSubview:self.beepView];
        self.beepView.hidden = YES;
        
        /*
        self.signalStrength = [[UILabel alloc] initWithFrame:CGRectMake(10, 80, 320.0f, 30.0f)];
		self.signalStrength.text = @"Signal";
		self.signalStrength.backgroundColor = [UIColor clearColor];
		self.signalStrength.textAlignment = NSTextAlignmentCenter;
        self.signalStrength.textAlignment = UIControlContentVerticalAlignmentBottom;
        [self.signalStrength setFont:[UIFont fontWithName:@"Helvetica" size:15.0]];
		[self addSubview:self.signalStrength];
         */
	}
    return self;
}

-(void) resetFrame:(CGRect)rect {
    self.frame = rect;
    /*
    CGFloat parentHeight = rect.size.height - 20;
    CGFloat parentWidth = rect.size.width - 20;
    self.mainView.frame = CGRectMake(10, 10, parentWidth, parentHeight);
    */
    CGFloat parentHeight = self.bounds.size.height;
    CGFloat parentWidth = self.bounds.size.width;
    
    self.latitudeLabel.frame = CGRectMake(25, parentHeight/2.0 - 160, parentWidth/2.0 + 20, 30);
    self.longitudeLabel.frame = CGRectMake(25, parentHeight/2.0 - 125, parentWidth/2.0 + 20, 30);
    self.altitudeLabel.frame = CGRectMake(25, parentHeight/2.0 - 90, parentWidth/2.0 + 20, 30);
    self.horizontalAccuracyLabel.frame = CGRectMake(25, parentHeight/2.0 - 55, parentWidth/2.0 + 20, 30);
    self.speedLabel.frame = CGRectMake(25, parentHeight/2.0 - 20, parentWidth/2.0, 30);
    self.accelerationXLabel.frame = CGRectMake(25, parentHeight/2.0 + 15, parentWidth/2.0 + 20, 30);
    self.accelerationYLabel.frame = CGRectMake(25, parentHeight/2.0 + 50, parentWidth/2.0 + 20, 30);
    self.accelerationSumLabel.frame = CGRectMake(25, parentHeight/2.0 + 85, parentWidth/2.0 + 20, 30);

    
    self.latitude.frame = CGRectMake(parentWidth/2.0 + 35, parentHeight/2.0 - 160, parentWidth/2.0 - 60, 30);
    self.longitude.frame = CGRectMake(parentWidth/2.0 + 35, parentHeight/2.0 - 125, parentWidth/2.0 - 60, 30);
    self.altitude.frame = CGRectMake(parentWidth/2.0 + 35, parentHeight/2.0 - 90, parentWidth/2.0 - 60, 30);
    self.horizontalAccuracy.frame = CGRectMake(parentWidth/2.0 + 35, parentHeight/2.0 - 55, parentWidth/2.0 - 60, 30);
    self.speed.frame = CGRectMake(parentWidth/2.0 + 35, parentHeight/2.0 - 20, parentWidth/2.0 - 60, 30);
    self.accelerationX.frame = CGRectMake(parentWidth/2.0 + 35, parentHeight/2.0 + 15, parentWidth/2.0 - 60, 30);
    self.accelerationY.frame = CGRectMake(parentWidth/2.0 + 35, parentHeight/2.0 + 50, parentWidth/2.0 - 60, 30);
    self.accelerationSum.frame = CGRectMake(parentWidth/2.0 + 35, parentHeight/2.0 + 85, parentWidth/2.0 - 60, 30);
    //self.timeStamp.frame = CGRectMake(10, parentHeight/2.0 + 145, parentWidth - 20, 30);
    //self.signalStrength.frame = CGRectMake(25, parentHeight - 50, 47, 50);
    [self.signalStrengthView resetFrame: CGRectMake(25, parentHeight - 50, parentWidth/3.0, 50)];
    self.beepView.frame = CGRectMake(parentWidth - 45 , parentHeight - 36, 20, 20);
}

-(void) restoreToDefault {
    self.latitude.text = @"0";
    self.longitude.text = @"0";
    self.altitude.text = @"0";
    self.horizontalAccuracy.text = @"0";
    self.speed.text = @"0";
    self.accelerationX.text = @"0";
    self.accelerationY.text = @"0";
    self.accelerationSum.text = @"0";
    //[SignalStrengthView setGlobalSignalStrength:0];
    [self.signalStrengthView setNeedsDisplay];
}

/*
-(void)buttonClicked:(id)sender
{
	UIButton *button = (UIButton *)sender;
	NSString *text = button.currentTitle;
	
	
	NSString *string = [ [NSString alloc] initWithFormat:@"Button %@ pressed.",text];
	
    ///NSLog(@"button clicked. button title:%@", text);
	
	self.label.text = string;
}
*/
@end
