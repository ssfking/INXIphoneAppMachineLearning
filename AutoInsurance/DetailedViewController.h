//
//  DetailedViewController.h
//  AutoInsurance
//
//  Created by Spencer King on 3/3/13.
//  Copyright (c) 2013 Spencer King. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CoreLocationController.h"
#import "DetailedView.h"
#import "AFNetworking.h"
//#import "LogInSignUpViewController.h"
#import "CoreMotionController.h"

@interface DetailedViewController : UIViewController <CoreMotionControllerDelegate, CoreLocationControllerDelegate>

@property (atomic, strong) DetailedView *detailedView;

- (void)locationUpdate:(CLLocation *)location WithCalculatedSpeed:(double) calcSpeed;
- (void)locationError:(NSError *)error;
- (void)deviceMotionUpdate:(CMDeviceMotion *) data WithAcclerationX:(double)aX AcclerationY:(double)aY AccelerationSum:(double)aSum;
- (void) setUsername;
-(void) restoreToDefault;

/*
- (void)addNewUserRecordWithUsername: (NSString*) username WithContext: (NSManagedObjectContext *) context;
*/
@end
