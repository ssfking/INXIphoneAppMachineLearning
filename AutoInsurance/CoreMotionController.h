//
//  CoreMotionController.h
//  AutoInsurance
//
//  Created by Spencer King on 2/24/13.
//  Copyright (c) 2013 Spencer King. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DatabaseController.h"
#import "CoreLocationController.h"

@protocol CoreMotionControllerDelegate
@required
- (void)deviceMotionUpdate:(CMDeviceMotion *) data WithAcclerationX: (double) aX AcclerationY: (double) aY AccelerationSum: (double) aSum;
@end
 
@interface CoreMotionController : NSObject

@property (nonatomic, strong) CMMotionManager *motionManager;
//@property (atomic, strong) id<CoreMotionControllerDelegate> delegate ;
@property (atomic, strong) NSOperationQueue *queue;
@property (atomic, strong) NSMutableArray* delegates;
@property (atomic, strong) NSDate *bootDate;
@property (atomic, strong) DatabaseController *databaseController;
@property (atomic, strong) CoreLocationController *coreLocationController;
@property (atomic) BOOL shouldCalibrate;

- (void) startUpdate;
- (void) stopUpdate;

@end
