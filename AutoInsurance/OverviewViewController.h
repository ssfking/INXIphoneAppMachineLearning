//
//  OverviewViewController.h
//  AutoInsurance
//
//  Created by Spencer King on 3/3/13.
//  Copyright (c) 2013 Spencer King. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SignalStrengthView.h"
#import "BeepView.h"
#import "OverviewView.h"
#import "CoreMotionController.h"
#import "CoreLocationController.h"

@interface OverviewViewController : UIViewController <CoreMotionControllerDelegate, CoreLocationControllerDelegate>

@property (atomic, strong) OverviewView *overviewView;

- (void)locationUpdate:(CLLocation *)location WithCalculatedSpeed:(double) calcSpeed;
- (void)locationError:(NSError *)error;
- (void)deviceMotionUpdate:(CMDeviceMotion *) data WithAcclerationX:(double)aX AcclerationY:(double)aY AccelerationSum:(double)aSum;
- (void) setUsername;
-(void) restoreToDefault;



@end
