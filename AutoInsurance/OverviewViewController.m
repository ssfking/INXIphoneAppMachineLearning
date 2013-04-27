//
//  OverviewViewController.m
//  AutoInsurance
//
//  Created by Spencer King on 3/3/13.
//  Copyright (c) 2013 Spencer King. All rights reserved.
//

#import "OverviewViewController.h"
#import "Reachability.h"
#import "SignalStrengthView.h"

@interface OverviewViewController ()
@property (atomic, strong) NSNumberFormatter * formatter;
- (void) hideBeep: (NSTimer *) timer;
- (void)handleNetworkChange:(NSNotification *)notice;

@end

@implementation OverviewViewController

@synthesize overviewView = _overviewView;

-(void)loadView {
    ///NSLog(@"OverviewViewController loadview");
	self.overviewView = [[OverviewView alloc] init];
	self.view = self.overviewView;
    self.navigationItem.title = @"Tracker Overview";
    UIBarButtonItem * tempButtonItem = [[ UIBarButtonItem alloc] init];
    tempButtonItem .title = @"Back";
    self.navigationItem.backBarButtonItem = tempButtonItem ;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.formatter = [[NSNumberFormatter alloc] init];
    [self.formatter setMaximumFractionDigits:2];
    [self.formatter setMinimumFractionDigits:2];
    [self.formatter setMinimumIntegerDigits:1];
    //[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleNetworkChange:) name:kReachabilityChangedNotification object:nil];
	// Do any additional setup after loading the view.
}

-(void)viewWillAppear:(BOOL)animated {
    [self.overviewView resetFrame:self.view.frame];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)locationUpdate:(CLLocation *)location WithCalculatedSpeed:(double) calcSpeed{
    self.overviewView.beepView.hidden = NO;
    [NSTimer scheduledTimerWithTimeInterval:0.3
                                     target:self
                                   selector:@selector(hideBeep:)
                                   userInfo:nil
                                    repeats:NO];
    [self.overviewView newSpeed:[self.formatter stringFromNumber:[NSNumber numberWithDouble:calcSpeed]]];
    [self.overviewView.signalStrengthView setNeedsDisplay];
}
- (void)locationError:(NSError *)error {
    //[self.overviewView.signalStrengthView setNeedsDisplay];
    [self.overviewView restoreToDefault];
}
- (void)deviceMotionUpdate:(CMDeviceMotion *) data WithAcclerationX:(double)aX AcclerationY:(double)aY AccelerationSum:(double)aSum{
    [self.overviewView.accelerationCircleView setNewAccelerationWithX:aX Y: aY];
    [self.overviewView newAcceleration: [self.formatter stringFromNumber:[NSNumber numberWithDouble:aSum]]];
}
- (void) setUsername{
    
}

- (void) hideBeep: (NSTimer *) timer {
    self.overviewView.beepView.hidden = YES;
}
-(void) restoreToDefault {
    [self.overviewView restoreToDefault];
}

- (void)handleNetworkChange:(NSNotification *)notice {
    Reachability* curReach = [notice object];
    if ([curReach isKindOfClass:[Reachability class]]){
        NetworkStatus status = [curReach currentReachabilityStatus];
        if (status == NotReachable) {
            ///NSLog(@"handleNetworkChange in overview");
            [SignalStrengthView setGlobalSignalStrength:0];
            [self.overviewView.signalStrengthView setNeedsDisplay];
        } else {
            /////NSLog(@"Internet is up and running!!");
            //Relaunch online application
        }
    }
}

@end
