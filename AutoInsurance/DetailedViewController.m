//
//  DetailedViewController.m
//  AutoInsurance
//
//  Created by Spencer King on 3/3/13.
//  Copyright (c) 2013 Spencer King. All rights reserved.
//

#import "DetailedViewController.h"
#import "AppDelegate.h"
#import "SignalStrengthView.h"

@interface DetailedViewController ()
- (void) hideBeep: (NSTimer *) timer;
- (void)handleNetworkChange:(NSNotification *)notice;
@end

@implementation DetailedViewController

@synthesize detailedView = _detailedView;

// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView
{
    
    ///NSLog(@"detailedviewcontroller loadview");
    //UIView *contentView = [[HelloView alloc] initWithFrame:[[UIScreen mainScreen] applicationFrame]];
    
	self.detailedView = [[DetailedView alloc] init];
	
	self.view = self.detailedView;
	
    self.navigationItem.title = @"Tracker Details";
    UIBarButtonItem * tempButtonItem = [[ UIBarButtonItem alloc] init];
    tempButtonItem .title = @"Back";
    self.navigationItem.backBarButtonItem = tempButtonItem ;
    
	// For testing the console pane
	///NSLog(@"root controller started.");
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    //[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleNetworkChange:) name:kReachabilityChangedNotification object:nil];
}

- (void)viewWillAppear:(BOOL)animated {
    ///NSLog(@"DetailedView will appear....\n");
    [self.detailedView resetFrame:self.view.bounds];
}

- (void) viewDidAppear:(BOOL)animated {
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)locationUpdate:(CLLocation *)location WithCalculatedSpeed:(double) calcSpeed {
    self.detailedView.beepView.hidden = NO;
    [NSTimer scheduledTimerWithTimeInterval:0.3 target:self selector:@selector(hideBeep:) userInfo:nil repeats:NO];
    self.detailedView.latitude.text = [NSString stringWithFormat:@"%f", location.coordinate.latitude];
    self.detailedView.longitude.text = [NSString stringWithFormat:@"%f",location.coordinate.longitude];
    self.detailedView.altitude.text = [NSString stringWithFormat:@"%f",location.altitude];
    self.detailedView.horizontalAccuracy.text = [NSString stringWithFormat:@"%f", location.horizontalAccuracy];
    //self.detailedView.verticalAccuracy.text = [NSString stringWithFormat:@"V. Accu (m): %f",location.verticalAccuracy];
    self.detailedView.speed.text = [NSString stringWithFormat:@"%f",calcSpeed];
    //self.detailedView.calculatedSpeed.text = [NSString stringWithFormat:@"Calc Speed (mi/hr): %f",calcSpeed];
    //self.detailedView.timeStamp.text = [NSString stringWithFormat:@"Time: %@", location.timestamp];
    [self.detailedView.signalStrengthView setNeedsDisplay];
}

- (void)deviceMotionUpdate:(CMDeviceMotion *) data WithAcclerationX:(double)aX AcclerationY:(double)aY AccelerationSum:(double)aSum {
    //CMAcceleration acceleration = data.userAcceleration;
    self.detailedView.accelerationSum.text= [NSString stringWithFormat:@"%f", aSum];
    self.detailedView.accelerationX.text = [NSString stringWithFormat:@"%f", aX];
    self.detailedView.accelerationY.text = [NSString stringWithFormat:@"%f", aY];
}

- (void)locationError:(NSError *)error {
    /*
    self.detailedView.longitude.text = [error description];
    self.detailedView.latitude.text = @"error";
    */
     //[self.detailedView.signalStrengthView setNeedsDisplay];
    [self.detailedView restoreToDefault];
}

/*
- (void)startUpdates {
    ///NSLog(@"Start Work");
    
    [self.locationController.locationManager startUpdatingLocation];
    [self.motionController startUpdate];
}
*/

- (void) setUsername{
    ///NSLog(@"set name");
    
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    NSString * username = [prefs stringForKey:@"username"];
    ///NSLog(@"username is %@", username);
    
    if (username != nil) {
        ///NSLog(@"WTF\n");
        self.detailedView.username.text = [NSString stringWithFormat:@"Hi %@", username];
        ///NSLog(@"sss:%@\n",self.detailedView.username.text);
    }
}

- (void) hideBeep: (NSTimer *) timer {
    self.detailedView.beepView.hidden = YES;
}

-(void) restoreToDefault {
    [self.detailedView restoreToDefault];
}

- (void)handleNetworkChange:(NSNotification *)notice {
    Reachability* curReach = [notice object];
    if ([curReach isKindOfClass:[Reachability class]]){
        NetworkStatus status = [curReach currentReachabilityStatus];
        if (status == NotReachable) {
            ///NSLog(@"handleNetworkChange in overview");
            [SignalStrengthView setGlobalSignalStrength:0];
            [self.detailedView.signalStrengthView setNeedsDisplay];
        } else {
            /////NSLog(@"Internet is up and running!!");
            //Relaunch online application
        }
    }
}

@end

