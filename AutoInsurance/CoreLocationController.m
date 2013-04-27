//
//  CoreLocationController.m
//  AutoInsurance
//
//  Created by Spencer King on 3/3/13.
//  Copyright (c) 2013 Spencer King. All rights reserved.
//

#import "CoreLocationController.h"
#import "AppDelegate.h"
#import "SignalStrengthView.h"

@interface CoreLocationController()
- (double) calculateSpeedWithNewLocation: (CLLocation *) newLocation;
@end

@implementation CoreLocationController

@synthesize locationManager = _locationManager;
@synthesize delegates = _delegates;
@synthesize lastLocation = _lastLocation;
@synthesize databaseController = _databaseController;
@synthesize speed = _speed;
@synthesize isUnderCalibrationThreshold = _isUnderCalibrationThreshold;

- (id) init {
    self = [super init];
    if (self != nil) {
        self.locationManager = [[CLLocationManager alloc] init];
        [self.locationManager setDistanceFilter:kCLDistanceFilterNone];
        [self.locationManager setDesiredAccuracy:kCLLocationAccuracyBestForNavigation];
        [self.locationManager setPausesLocationUpdatesAutomatically:NO];
        [self.locationManager setActivityType:CLActivityTypeOther];
        self.locationManager.delegate = self; // send loc updates to myself
        self.delegates = [[NSMutableArray alloc] init];
        self.lastLocation = nil;
        self.speed = -1;
        self.isUnderCalibrationThreshold = NO;
    }
    return self;
}

- (void)locationManager:(CLLocationManager *)manager
    didUpdateToLocation:(CLLocation *)newLocation
           fromLocation:(CLLocation *)oldLocation
{
    
    //CFAbsoluteTimeGetCurrent(); //in secs
    
    self.speed = newLocation.speed;
    NSLog(@"updating speed to: %f\n", self.speed);
    if (self.speed == 0) {
        self.isUnderCalibrationThreshold = YES;
        //NSLog(@"0 so calibrateion YES\n");
    } else {
        if (self.isUnderCalibrationThreshold) {
            if (self.speed > accelerationMaxSpeedThreshold){
                self.isUnderCalibrationThreshold = NO;
            }
        }
    }
    //NSLog(@"isUnderCaliThres: %d\n",self.isUnderCalibrationThreshold);
    
    double hAcc = newLocation.horizontalAccuracy;
    
    int signalStrength = 1;
    
    if (hAcc <= 5.0) {
        signalStrength = 5;
    }
    else if (hAcc <= 15) {
        signalStrength = 4;
    }
    else if (hAcc <= 35) {
        signalStrength = 3;
    }
    else if (hAcc <= 75) {
        signalStrength = 2;
    }
    
    [SignalStrengthView setGlobalSignalStrength:signalStrength];
   
    double distanceTraveled = 0;

    if (oldLocation != nil){
        distanceTraveled = [oldLocation distanceFromLocation:newLocation];
    }
    //NSLog(@"Distance Traveled: %f\n", distanceTraveled);
    
    //double calcSpeed = [self calculateSpeedWithNewLocation: newLocation];
    double calcSpeed = newLocation.speed;
    if (calcSpeed != -1 ) {
        calcSpeed = newLocation.speed * 2.23693629;
    }
    for (id <CoreLocationControllerDelegate> delegate in self.delegates) {
        [delegate locationUpdate:newLocation WithCalculatedSpeed: calcSpeed];
    }
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT,0), ^{
        AppDelegate *appdelegate = [[UIApplication sharedApplication] delegate];
        NSManagedObjectContext *ctx = [[NSManagedObjectContext alloc] init];
        [ctx setUndoManager:nil];
        [ctx setPersistentStoreCoordinator: [appdelegate persistentStoreCoordinator]];
        [self.databaseController addNewLocationRecordWithLocationObject:newLocation DistanceTraveled: distanceTraveled CalcSpeed: calcSpeed Context:ctx];
    });
}


- (void)locationManager:(CLLocationManager *)manager
       didFailWithError:(NSError *)error
{
    self.speed = -1;
    [SignalStrengthView setGlobalSignalStrength:0];
	///NSLog(@"Error: %@", [error description]);
    for (id <CoreLocationControllerDelegate> delegate in self.delegates) {
        [delegate locationError:error];
    }
}

//in miles/hour
- (double) calculateSpeedWithNewLocation: (CLLocation *) newLocation {
    double speed = -1;
    if (newLocation != NULL && newLocation.horizontalAccuracy <= 10) {
        if (self.lastLocation != NULL) {
            ///NSLog(@"calcuating speed real\n");
            double distance = [self.lastLocation distanceFromLocation: newLocation];
            double timeElapsed = [newLocation.timestamp timeIntervalSinceDate: self.lastLocation.timestamp];
            speed = distance/timeElapsed * 2.23693629;
        }
        self.lastLocation = newLocation;
    }
    return speed;
}

-(void)startUpdate {
    [self.locationManager startUpdatingLocation];
}

- (void)stopUpdate {
    [self.locationManager stopUpdatingLocation];
}

@end
