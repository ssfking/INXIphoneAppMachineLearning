//
//  DatabaseController.h
//  AutoInsurance
//
//  Created by Spencer King on 3/3/13.
//  Copyright (c) 2013 Spencer King. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DatabaseController : NSObject

@property (atomic, strong) NSDateFormatter *dateFormatter;
@property (atomic, strong)  dispatch_queue_t serialQueue;

- (void) syncDBWithServer;
- (void) addNewUserRecordWithUsername: (NSString*) username WithContext: (NSManagedObjectContext *) context WithError: (NSError **) error;
- (void) addNewLocationRecordWithLocationObject:(CLLocation *)location DistanceTraveled:(double) distanceTraveled CalcSpeed: (double) calcSpeed Context: (NSManagedObjectContext *) context;
- (void) addNewMotionRecordWithX:(double)x Y:(double)y Length:(double)length Time:(NSDate *)time Context:(NSManagedObjectContext *) context;
- (void) deleteRegisteredUserWithUsername: (NSString*) username WithContext: (NSManagedObjectContext *) context;
- (NSArray *) findRegisteredUsersWithContext: (NSManagedObjectContext *) context;

@end
