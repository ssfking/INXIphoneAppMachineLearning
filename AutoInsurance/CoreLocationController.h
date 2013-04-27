//
//  CoreLocationController.h
//  AutoInsurance
//
//  Created by Spencer King on 3/3/13.
//  Copyright (c) 2013 Spencer King. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DatabaseController.h"

@protocol CoreLocationControllerDelegate
@required
- (void)locationUpdate:(CLLocation *)location WithCalculatedSpeed:(double) calcSpeed;
- (void)locationError:(NSError *)error;
@end

@interface CoreLocationController : NSObject <CLLocationManagerDelegate> {
}

@property (nonatomic, strong) CLLocationManager *locationManager;
@property (nonatomic, strong) NSMutableArray * delegates;
@property (atomic, strong) CLLocation * lastLocation;
@property (atomic, strong) DatabaseController *databaseController;
@property (atomic) double speed;
@property (atomic) BOOL isUnderCalibrationThreshold;

- (void)locationManager:(CLLocationManager *)manager
    didUpdateToLocation:(CLLocation *)newLocation
           fromLocation:(CLLocation *)oldLocation;

- (void)locationManager:(CLLocationManager *)manager
       didFailWithError:(NSError *)error;

- (void) startUpdate;
- (void) stopUpdate;

@end


