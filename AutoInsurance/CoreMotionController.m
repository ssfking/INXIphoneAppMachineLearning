//
//  CoreMotionController.m
//  AutoInsurance
//
//  Created by Spencer King on 2/24/13.
//  Copyright (c) 2013 Spencer King. All rights reserved.
//

#import "CoreMotionController.h"
#import "AppDelegate.h"
#include <sys/types.h>
#include <sys/sysctl.h>

@interface CoreMotionController ()

@property (atomic) double accelerationPreviousFrame;
@property (atomic) BOOL positiveYIsSet;
@property (atomic) BOOL transformedSystemIsSet;
@property (atomic) double positiveYX;
@property (atomic) double positiveYY;
@property (atomic) double positiveYZ;
@property (atomic) double positiveXX;
@property (atomic) double positiveXY;
@property (atomic) double positiveXZ;
@property (atomic) double positiveZX;
@property (atomic) double positiveZY;
@property (atomic) double positiveZZ;

@property (atomic) BOOL canUpdateY;
@property (atomic) int countGrav;

@property (atomic) double averageX;
@property (atomic) double averageY;
@property (atomic) double averageZ;
@property (atomic) double totalAngle;
@property (atomic) int numberOfSignificantFrames;
@property (atomic) int numberOfConsecutiveInsignificantFrames;
@property (atomic) int numberOfTotalFramesPassed;
@property (atomic, strong) NSMutableArray *curAccelerations;
@property (atomic, strong) NSMutableDictionary *curAccelerationIntervalDict;

@property (atomic, strong) NSMutableArray *accelerationCandidatesArray;
@property (atomic) BOOL isInASequence;


- (void) moveConsecutiveSignificantFramesToCandidateArray;
- (NSDictionary *) findTransformedAccelerationXYFromUserAcceleration:(CMAcceleration)userAcceleration WithGravity: (CMAcceleration)gravity;
- (double) getVectorLengthWithX:(double) x Y:(double) y Z: (double) z;
- (NSDictionary *) getNormalizedVectorWithX:(double) x Y:(double) y Z:(double) z;
- (NSDictionary *) getCrossProductFromVector1WithX:(double)x1 Y:(double)y1 Z:(double)z1 AndVector2WithX:(double)x2 Y:(double)y2 Z:(double) z2;
- (double) getDotProductFromVector1WithX:(double)x1 Y:(double)y1 Z:(double)z1 AndVector2WithX:(double)x2 Y:(double)y2 Z:(double) z2;
- (double) getAngleBetweenVector1WithX:(double)x1 Y:(double)y1 Z:(double)z1 AndVector2WithX:(double)x2 Y:(double)y2 Z:(double) z2;
- (void) calibratePositiveYWithAcceleration: (CMAcceleration) acc;
- (NSDictionary *) findPositiveYAxisFromUserAcceleration:(CMAcceleration) userAcceleration;
- (void) createTransformedSystemXYZFromPositiveYWithX: (double) yX Y: (double) yY Z: (double) yZ AndGravityWithX: (double) gX Y: (double) gY Z: (double) gZ;
- (NSDictionary *) findTransformedAccelerationFromOriginalAccelerationWithX:(double)x Y:(double)y Z:(double)z;

@end

@implementation CoreMotionController

@synthesize delegates = _delegates;
@synthesize bootDate = _bootDate;
@synthesize motionManager = _motionManager;
@synthesize queue = _queue;
@synthesize databaseController = _databaseController;
@synthesize coreLocationController = _coreLocationController;
@synthesize positiveYIsSet = _positiveYIsSet;
@synthesize transformedSystemIsSet = _transformedSystemIsSet;
@synthesize positiveYX = _positiveYX;
@synthesize positiveYY = _positiveYY;
@synthesize positiveYZ = _positiveYZ;
@synthesize positiveXX = _positiveXX;
@synthesize positiveXY = _positiveXY;
@synthesize positiveXZ = _positiveXZ;
@synthesize positiveZX = _positiveZX;
@synthesize positiveZY = _positiveZY;
@synthesize positiveZZ = _positiveZZ;

@synthesize shouldCalibrate = _shouldCalibrate;
@synthesize canUpdateY = _canUpdateY;
@synthesize countGrav = _countGrav;
@synthesize averageX = _averageX;
@synthesize averageY = _averageY;
@synthesize averageZ = _averageZ;
@synthesize numberOfSignificantFrames = _numberOfSignificantFrames;
@synthesize curAccelerations = _curAccelerations;
@synthesize accelerationCandidatesArray = _accelerationCandidatesArray;
@synthesize isInASequence = _isInASequence;
@synthesize numberOfConsecutiveInsignificantFrames = _numberOfConsecutiveInsignificantFrames;
@synthesize curAccelerationIntervalDict = _curAccelerationIntervalDict;
@synthesize numberOfTotalFramesPassed = _numberOfTotalFramesPassed;

//@synthesize delegate =_delegate;
- (id) init {
    self = [super init];
    if (self != nil) {
        self.motionManager = [[CMMotionManager alloc] init];
        self.motionManager.deviceMotionUpdateInterval = 0.1;
        self.queue = [[NSOperationQueue alloc] init];
        self.delegates = [[NSMutableArray alloc] init];
        // Get NSTimeInterval of uptime i.e. the delta: now - bootTime
        NSTimeInterval uptime = [NSProcessInfo processInfo].systemUptime;
        NSDate *now = [[NSDate alloc] init];
        self.bootDate = [now dateByAddingTimeInterval: -1.0 *uptime];
        self.positiveYIsSet = NO;
        self.transformedSystemIsSet = NO;
        self.positiveYX = 0;
        self.positiveYY = 0;
        self.positiveYZ = 0;
        self.positiveXX = 0;
        self.positiveXY = 0;
        self.positiveXZ = 0;
        self.positiveZX = 0;
        self.positiveZY = 0;
        self.positiveZZ = 0;
        
        self.accelerationPreviousFrame = -1;
        self.shouldCalibrate = NO;
        self.canUpdateY = YES;
        self.countGrav = 0;
        
        self.averageX = 0;
        self.averageY = 0;
        self.averageZ = 0;
        self.numberOfSignificantFrames = 0;
        self.curAccelerations = [[NSMutableArray alloc] init];
        self.curAccelerationIntervalDict = [[NSMutableDictionary alloc] init];
        
        self.accelerationCandidatesArray = [[NSMutableArray alloc] init];
        self.isInASequence = NO;
        self.numberOfConsecutiveInsignificantFrames = 0;
        self.numberOfTotalFramesPassed = 0;
        
        ///NSLog(@"Boot Date %@\n",self.bootDate);
    }
    return self;
}

- (void)startUpdate {
    [self.motionManager startDeviceMotionUpdatesToQueue: self.queue withHandler: ^(CMDeviceMotion *motion, NSError *error) {
        CMAcceleration acceleration = motion.userAcceleration;
        double aSum = [self getVectorLengthWithX:acceleration.x Y:acceleration.y Z:acceleration.z];
        
        //[self calibratePositiveYWithAcceleration:acceleration];
        NSDictionary *result = [self findTransformedAccelerationXYFromUserAcceleration:acceleration WithGravity:motion.gravity];
        if (result == NULL){
            //NSLog(@"in startUpdate.. no transformedAcceleration found so return early");
            return;
        }
        double accX = [[result valueForKey:@"x"] doubleValue];
        double accY = [[result valueForKey:@"y"] doubleValue];
        /*
        NSMutableDictionary *result = [[NSMutableDictionary alloc]init];
        [result setValue:[NSNumber numberWithDouble:1.0] forKey:@"x"];
        [result setValue:[NSNumber numberWithDouble:1.0] forKey:@"y"];
        NSLog(@"acceleration x: %f y:%f z:%f sum:%f\n", acceleration.x, acceleration.y, acceleration.z, aSum );
        NSLog(@"Gravity x:%f y:%f z:%f\n", motion.gravity.x, motion.gravity.y, motion.gravity.z);
        */
        dispatch_async(dispatch_get_main_queue(), ^{
            for (id <CoreMotionControllerDelegate> delegate in self.delegates) {
                [delegate deviceMotionUpdate:motion WithAcclerationX: accX AcclerationY: accY AccelerationSum:aSum];
            }
        });
        if (aSum >= 0.1){
            AppDelegate *appdelegate = [[UIApplication sharedApplication] delegate];
            NSManagedObjectContext *ctx = [[NSManagedObjectContext alloc] init];
            [ctx setUndoManager:nil];
            [ctx setPersistentStoreCoordinator: [appdelegate persistentStoreCoordinator]];
            NSDate *time =  [self.bootDate dateByAddingTimeInterval:motion.timestamp];
            [self.databaseController addNewMotionRecordWithX:accX Y:accY Length:aSum Time:time Context:ctx];
             //addNewMotionRecordWithMotionObject:motion WithSum:aSum WithTime:time WithContext:ctx];
        }
    }];
}

- (void)stopUpdate {
    [self.motionManager stopDeviceMotionUpdates];
}

- (void) moveConsecutiveSignificantFramesToCandidateArray {
    NSDictionary *normalizedAverageAcc = [self getNormalizedVectorWithX: self.averageX Y:self.averageY Z:self.averageZ];
    
    //doMathChecking here....
    int curAccelerationsSize = [self.curAccelerations count];
    NSLog(@"curAccelerationsSize: %i ", curAccelerationsSize);
    NSLog(@"x:%f y:%f z:%f\n", [[normalizedAverageAcc valueForKey:@"x"] doubleValue],[[normalizedAverageAcc valueForKey:@"y"] doubleValue],[[normalizedAverageAcc valueForKey:@"z"] doubleValue]);
    if (curAccelerationsSize >= minNumberOfSignificantAccelerationFrames){
        double totalAngle = 0;
        for (int i = 0; i < curAccelerationsSize; i++) {
            NSDictionary *curVector = [self.curAccelerations objectAtIndex:i];
            double angle = [self getAngleBetweenVector1WithX: [[normalizedAverageAcc valueForKey:@"x"] doubleValue] Y: [[normalizedAverageAcc valueForKey:@"y"] doubleValue] Z: [[normalizedAverageAcc valueForKey:@"z"] doubleValue] AndVector2WithX:[[curVector valueForKey:@"x"] doubleValue] Y:[[curVector valueForKey:@"y"] doubleValue] Z:[[curVector valueForKey:@"z"] doubleValue] ];
            angle = angle * 180/M_PI;
            if (angle > 90) {
                angle = 180 - angle;
            }
            totalAngle += angle;
        }
        double averageAngle = totalAngle / curAccelerationsSize;
        NSLog(@"Average Angle: %f x:%f y:%f z:%f\n", averageAngle, [[normalizedAverageAcc valueForKey:@"x"] doubleValue],[[normalizedAverageAcc valueForKey:@"y"] doubleValue],[[normalizedAverageAcc valueForKey:@"z"] doubleValue]);
        if (averageAngle <= maxAverageAngleDifferential){
            [self.curAccelerationIntervalDict setValue: [normalizedAverageAcc valueForKey:@"x"] forKey:@"averageX"];
            [self.curAccelerationIntervalDict setValue: [normalizedAverageAcc valueForKey:@"y"] forKey:@"averageY"];
            [self.curAccelerationIntervalDict setValue: [normalizedAverageAcc valueForKey:@"z"] forKey:@"averageZ"];
            [self.curAccelerationIntervalDict setValue: [NSNumber numberWithDouble:averageAngle] forKey:@"averageAngle"];
            [self.curAccelerationIntervalDict setValue: [NSNumber numberWithDouble:curAccelerationsSize] forKey:@"numberOfFramesInInterval"];
            [self.curAccelerationIntervalDict setValue: [NSNumber numberWithInt:0] forKey:@"numberOfFramesAterCompletion"];
            NSLog(@"Entered into candidate array: Average Angle:%f numberOfFrames:%i x: %f y:%f z:%f speed:%f\n",averageAngle, curAccelerationsSize, [[normalizedAverageAcc valueForKey:@"x"] doubleValue], [[normalizedAverageAcc valueForKey:@"y"] doubleValue], [[normalizedAverageAcc valueForKey:@"z"] doubleValue], [[self.curAccelerationIntervalDict valueForKey:@"initialSpeed"] doubleValue]);
            [self.accelerationCandidatesArray addObject:self.curAccelerationIntervalDict];
        }
        
    }
    
    //[curDict setValue: [NSNumber numberWithInt:self.numberOfSignificantFrames] forKey:@"numberOfSignificantFrames"];
    //[curDict setValue: [NSNumber numberWithBool:YES] forKey:@"sequenceHasEnded"];
    
    self.averageX = 0;
    self.averageY = 0;
    self.averageZ = 0;
    self.numberOfSignificantFrames = 0;
    self.numberOfConsecutiveInsignificantFrames = 0;
    self.numberOfTotalFramesPassed = 0;
    self.curAccelerationIntervalDict = [[NSMutableDictionary alloc] init];
    self.curAccelerations = [[NSMutableArray alloc] init];
    self.isInASequence = NO;

}

- (NSDictionary *) findTransformedAccelerationFromOriginalAccelerationWithX:(double)x Y:(double)y Z:(double)z {
    NSMutableDictionary * result = [[NSMutableDictionary alloc] init];
    double newX = [self getDotProductFromVector1WithX:x Y:y Z:z AndVector2WithX:self.positiveXX Y:self.positiveXY Z:self.positiveXZ];
    double newY = [self getDotProductFromVector1WithX:x Y:y Z:z AndVector2WithX:self.positiveYX Y:self.positiveYY Z:self.positiveYZ];
    double newZ = [self getDotProductFromVector1WithX:x Y:y Z:z AndVector2WithX:self.positiveZX Y:self.positiveZY Z:self.positiveZZ];
    [result setValue:[NSNumber numberWithDouble:newX] forKey:@"x"];
    [result setValue:[NSNumber numberWithDouble:newY] forKey:@"y"];
    [result setValue:[NSNumber numberWithDouble:newZ] forKey:@"z"];
    NSLog(@"Transformed acceleration is (%f, %f, %f)\n",newX, newY, newZ);
    return result;
}

- (void) createTransformedSystemXYZFromPositiveYWithX: (double) yX Y: (double) yY Z: (double) yZ AndGravityWithX: (double) gX Y: (double) gY Z: (double) gZ {
    NSLog(@"Creating transformed system with gravity (%f, %f, %f)\n", gX, gY, gZ);
    
    NSDictionary *xVector = [self getCrossProductFromVector1WithX:gX Y:gY Z:gZ AndVector2WithX:yX Y:yY Z:yZ];
    NSDictionary *normalizedX = [self getNormalizedVectorWithX:[[xVector valueForKey:@"x"] doubleValue] Y:[[xVector valueForKey:@"y"] doubleValue] Z:[[xVector valueForKey:@"z"] doubleValue]];
    NSDictionary *zVector = [self getCrossProductFromVector1WithX:[[normalizedX valueForKey:@"x"] doubleValue] Y:[[normalizedX valueForKey:@"y"] doubleValue] Z:[[normalizedX valueForKey:@"z"] doubleValue] AndVector2WithX:yX Y:yY Z:yZ];
    //NSLog(@"z vector (%f, %f, %f)\n", [[zVector valueForKey:@"x"] doubleValue], [[zVector valueForKey:@"y"] doubleValue], [[zVector valueForKey:@"z"] doubleValue]);
    NSDictionary *normalizedY = [self getNormalizedVectorWithX:yX Y:yY Z:yZ];
    NSDictionary *normalizedZ = [self getNormalizedVectorWithX:[[zVector valueForKey:@"x"] doubleValue] Y:[[zVector valueForKey:@"y"] doubleValue] Z:[[zVector valueForKey:@"z"] doubleValue]];
    //NSLog(@"normalized z vector (%f, %f, %f)\n", [[normalizedZ valueForKey:@"x"] doubleValue], [[normalizedZ valueForKey:@"y"] doubleValue], [[normalizedZ valueForKey:@"z"] doubleValue]);
    self.positiveXX = [[normalizedX valueForKey:@"x"] doubleValue];
    self.positiveXY = [[normalizedX valueForKey:@"y"] doubleValue];
    self.positiveXZ = [[normalizedX valueForKey:@"z"] doubleValue];
    self.positiveYX = [[normalizedY valueForKey:@"x"] doubleValue];
    self.positiveYY = [[normalizedY valueForKey:@"y"] doubleValue];
    self.positiveYZ = [[normalizedY valueForKey:@"z"] doubleValue];
    self.positiveZX = [[normalizedZ valueForKey:@"x"] doubleValue];
    self.positiveZY = [[normalizedZ valueForKey:@"y"] doubleValue];
    self.positiveZZ = [[normalizedZ valueForKey:@"z"] doubleValue];
    self.transformedSystemIsSet = YES;
    NSLog(@"Created New Transformed System XYZ:\n x-axis: (%f, %f, %f) y-axis (%f, %f, %f) z-axis (%f, %f, %f)\n", self.positiveXX, self.positiveXY, self.positiveXZ, self.positiveYX, self.positiveYY, self.positiveYZ, self.positiveZX, self.positiveZY, self.positiveZZ);
}

- (NSDictionary *) findPositiveYAxisFromUserAcceleration:(CMAcceleration) userAcceleration {
    NSMutableDictionary *result = NULL;
    
    double curSpeed = self.coreLocationController.speed;
    int accelerationCandidatesArraySize = [self.accelerationCandidatesArray count];
    
    NSMutableArray * indicesToRemove = [[NSMutableArray alloc] init];
    
    for (int i = 0; i < accelerationCandidatesArraySize; i++) {
        NSLog(@"n is %i",i);
        NSDictionary * curDict = [self.accelerationCandidatesArray objectAtIndex: i];
        int numberOfFramesAfterCompletion = [[curDict objectForKey:@"numberOfFramesAfterCompletion"] intValue];
        numberOfFramesAfterCompletion += 1;
        NSLog(@"Number of frames after completion: %i\n", numberOfFramesAfterCompletion);
        [curDict setValue: [NSNumber numberWithInt:numberOfFramesAfterCompletion]  forKey:@"numberOfFramesAfterCompletion"];
        if (numberOfFramesAfterCompletion <= maxNumberOfFramesAfterCompletion) {
            if (curSpeed > -1 && numberOfFramesAfterCompletion >= minNumberOfFramesAfterCompletion) {
                NSLog(@"Inside\n");
                double initialSpeed = [[curDict objectForKey:@"initialSpeed"] doubleValue];
                if (curSpeed >= (initialSpeed + minSpeedDifferenceForFindingYAxisAcceleration)) {
                    NSLog(@"Found positive Y");
                    double posYX = [[curDict valueForKey:@"averageX"] doubleValue];
                    double posYY = [[curDict valueForKey:@"averageY"] doubleValue];
                    double posYZ = [[curDict valueForKey:@"averageZ"] doubleValue];
                    //[self.accelerationCandidatesArray removeObjectAtIndex:i];
                    [indicesToRemove addObject:[NSNumber numberWithInt:i]];
                    self.positiveYIsSet = YES;
                    NSLog(@"Found a new positive Y with x: %f y:%f z:%f\n", posYX, posYY, posYZ);
                    result = [[NSMutableDictionary alloc] init];
                    [result setValue:[NSNumber numberWithDouble:posYX] forKey:@"x"];
                    [result setValue:[NSNumber numberWithDouble:posYY] forKey:@"y"];
                    [result setValue:[NSNumber numberWithDouble:posYZ] forKey:@"z"];
                    //return result;
                }
                else if (curSpeed <= (initialSpeed - minSpeedDifferenceForFindingYAxisAcceleration)){
                    NSLog(@"Found negative Y");
                    double posYX = -1.0*[[curDict valueForKey:@"averageX"] doubleValue];
                    double posYY = -1.0*[[curDict valueForKey:@"averageY"] doubleValue];
                    double posYZ = -1.0*[[curDict valueForKey:@"averageZ"] doubleValue];
                    //[self.accelerationCandidatesArray removeObjectAtIndex:i];
                    [indicesToRemove addObject:[NSNumber numberWithInt:i]];
                    self.positiveYIsSet = YES;
                    NSLog(@"Found a new positive Y with x: %f y:%f z:%f\n", posYX, posYY, posYZ);
                    result = [[NSMutableDictionary alloc] init];
                    [result setValue:[NSNumber numberWithDouble:posYX] forKey:@"x"];
                    [result setValue:[NSNumber numberWithDouble:posYY] forKey:@"y"];
                    [result setValue:[NSNumber numberWithDouble:posYZ] forKey:@"z"];
                    //return result;
                }
            }
        } else {
            //[self.accelerationCandidatesArray removeObjectAtIndex:i];
            [indicesToRemove addObject:[NSNumber numberWithInt:i]];
        }
    }
    
    for (int i = ([indicesToRemove count] - 1); i >= 0; i--) {
        [self.accelerationCandidatesArray removeObjectAtIndex: [[indicesToRemove objectAtIndex:i] intValue] ];
        NSLog(@"An acceleration candidate is removed\n");
    }
    
    
    double accelerationLength = [self getVectorLengthWithX:userAcceleration.x Y:userAcceleration.y Z:userAcceleration.z];
    if (self.isInASequence) {
        self.numberOfTotalFramesPassed += 1;
        if (self.numberOfTotalFramesPassed == numFrameDelaysToFindInitialSpeed) {
            [self.curAccelerationIntervalDict setValue: [NSNumber numberWithDouble:curSpeed] forKey:@"initialSpeed"];
            NSLog(@"Speed for this curInterval set as %f\n", curSpeed);
        }
        
        
        if (accelerationLength >= accelerationMinimumDetectionThreshold){
            NSDictionary *normalizedAcc = [self getNormalizedVectorWithX:userAcceleration.x Y:userAcceleration.y Z:userAcceleration.z];
            self.averageX += [[normalizedAcc valueForKey:@"x"] doubleValue];
            self.averageY += [[normalizedAcc valueForKey:@"y"] doubleValue];
            self.averageZ += [[normalizedAcc valueForKey:@"z"] doubleValue];
            [self.curAccelerations addObject:normalizedAcc];
            self.numberOfSignificantFrames += 1;
            self.numberOfConsecutiveInsignificantFrames = 0;
            
            
            //doMath here to compare average angle to candidates

            if (self.numberOfSignificantFrames >= minNumberOfFramesForAccelerationComparisonWithCandidates){
                NSDictionary *normalizedAverageAcc = [self getNormalizedVectorWithX: self.averageX Y:self.averageY Z:self.averageZ];
                NSLog(@"Tester normalized x: %f y:%f z:%f", [[normalizedAverageAcc valueForKey:@"x"] doubleValue], [[normalizedAverageAcc valueForKey:@"y"] doubleValue], [[normalizedAverageAcc valueForKey:@"z"] doubleValue] );
                for (int i = ([self.accelerationCandidatesArray count] - 1); i >=0 ; i--) {
                    NSLog(@"testing candidate number %i\n", i);
                    NSDictionary *curVector = [self.accelerationCandidatesArray objectAtIndex:i];
                    int numberOfFramesAfterCompletion = [[curVector objectForKey:@"numberOfFramesAfterCompletion"] intValue];
                    if (numberOfFramesAfterCompletion <= maxNumberOfFramesForTestingAfterCompletion){
                        double angle = [self getAngleBetweenVector1WithX: [[normalizedAverageAcc valueForKey:@"x"] doubleValue] Y: [[normalizedAverageAcc valueForKey:@"y"] doubleValue] Z: [[normalizedAverageAcc valueForKey:@"z"] doubleValue] AndVector2WithX:[[curVector valueForKey:@"averageX"] doubleValue] Y:[[curVector valueForKey:@"averageY"] doubleValue] Z:[[curVector valueForKey:@"averageZ"] doubleValue] ];
                        angle = angle * 180/M_PI;
                        NSLog(@"Angle difference is %f\n", angle);
                        /*
                        if (angle > 90) {
                            angle = 180 - angle;
                        }
                         */
                        if (angle > maxAngleToPassTestAfterCompletion){
                            [self.accelerationCandidatesArray removeObjectAtIndex:i];
                            NSLog(@"Candidate at %i removed because of not passing angle test\n", i);
                        }
                    }
                }
            }
            
            if (self.numberOfSignificantFrames > maxNumberOfSignificantAccelerationFrames) {
                [self moveConsecutiveSignificantFramesToCandidateArray];
            }
            
        } else {
            self.numberOfConsecutiveInsignificantFrames += 1;
            if (self.numberOfConsecutiveInsignificantFrames > maxNumberOfConsecutiveInsignificantAccelerationFrames) {
                [self moveConsecutiveSignificantFramesToCandidateArray];
            }
        }
        
        
    } else {
        if ((accelerationLength >= accelerationMinimumDetectionThreshold) && (curSpeed > -1) ){
            NSDictionary *normalizedAcc = [self getNormalizedVectorWithX:userAcceleration.x Y:userAcceleration.y Z:userAcceleration.z];
            self.averageX += [[normalizedAcc valueForKey:@"x"] doubleValue];
            self.averageY += [[normalizedAcc valueForKey:@"y"] doubleValue];
            self.averageZ += [[normalizedAcc valueForKey:@"z"] doubleValue];
            [self.curAccelerations addObject:normalizedAcc];
            self.numberOfSignificantFrames += 1;
            self.numberOfConsecutiveInsignificantFrames = 0;
            self.numberOfTotalFramesPassed += 1;
            //[self.curAccelerationIntervalDict setValue: [NSNumber numberWithDouble:curSpeed] forKey:@"initialSpeed"];
            self.isInASequence = YES;
        }
    }
    return result;
}

//can return NULL if no y-axis is found
- (NSDictionary *) findTransformedAccelerationXYFromUserAcceleration:(CMAcceleration)userAcceleration WithGravity: (CMAcceleration)gravity {
    
    /*
     double posYX = 0.5;
     double posYY = 0.5;
     double posYZ = 0.5;
     
     CMAcceleration fakeGravityAcceleration;
     fakeGravityAcceleration.x = 0.0;
     fakeGravityAcceleration.y = -1.0;
     fakeGravityAcceleration.z = 0.0;
     gravity = fakeGravityAcceleration;
     
     CMAcceleration fakeUserAcceleration;
     fakeUserAcceleration.x = 0.1;
     fakeUserAcceleration.y = 0.0;
     fakeUserAcceleration.z = -2.0;
     userAcceleration = fakeUserAcceleration;
    
     [self createTransformedSystemXYZFromPositiveYWithX:posYX Y:posYY Z:posYZ AndGravityWithX:gravity.x Y:gravity.y Z:gravity.z];
    */
    /*
    if (self.countGrav == 3){
        NSLog(@"Gravity frame with x: %f y:%f z:%f\n", gravity.x, gravity.y, gravity.z);
    }
    self.countGrav ++;
    */

    double curAccelerationLength = [self getVectorLengthWithX:userAcceleration.x Y:userAcceleration.y Z:userAcceleration.z];
    NSLog(@"%f %f %f %f %f\n" ,userAcceleration.x, userAcceleration.y, userAcceleration.z, curAccelerationLength, self.coreLocationController.speed);
    
    NSDictionary * posYVector = [self findPositiveYAxisFromUserAcceleration:userAcceleration];
    if (posYVector != NULL){
        double posYX = [[posYVector valueForKey:@"x"] doubleValue];
        double posYY = [[posYVector valueForKey:@"y"] doubleValue];
        double posYZ = [[posYVector valueForKey:@"z"] doubleValue];
        [self createTransformedSystemXYZFromPositiveYWithX:posYX Y:posYY Z:posYZ AndGravityWithX:gravity.x Y:gravity.y Z:gravity.z];
    }
    
    
    if (!self.transformedSystemIsSet) {
        return NULL;
    }
    
    NSDictionary *transformedVector = [self findTransformedAccelerationFromOriginalAccelerationWithX:userAcceleration.x Y:userAcceleration.y Z:userAcceleration.z];
    return transformedVector;    
}

- (NSDictionary *) find2TransformedAccelerationXYFromUserAcceleration:(CMAcceleration)userAcceleration WithGravity: (CMAcceleration)gravity {
    
    /*
    self.positiveYIsSet = YES;
    self.positiveYX = 0.0;
    self.positiveYY = 0.0;
    self.positiveYZ = 1.0;

    CMAcceleration fakeGravityAcceleration;
    fakeGravityAcceleration.x = 0.0;
    fakeGravityAcceleration.y = -1.0;
    fakeGravityAcceleration.z = 0.0;
    
    gravity = fakeGravityAcceleration;

    
    CMAcceleration fakeUserAcceleration;
    fakeUserAcceleration.x = 0.1;
    fakeUserAcceleration.y = 0.0;
    fakeUserAcceleration.z = -2.0;
    userAcceleration = fakeUserAcceleration;
    */
    if (self.countGrav == 3){
        NSLog(@"Gravity frame with x: %f y:%f z:%f\n", gravity.x, gravity.y, gravity.z);
    }
    self.countGrav ++;
    
    
    
    NSMutableDictionary *result = [[NSMutableDictionary alloc] init];
    double curAccelerationLength = [self getVectorLengthWithX:userAcceleration.x Y:userAcceleration.y Z:userAcceleration.z];
    //if (curAccelerationLength >= 0.1) {
        NSLog(@"%f %f %f %f %f\n" ,userAcceleration.x, userAcceleration.y, userAcceleration.z, curAccelerationLength, self.coreLocationController.speed);
    //NSLog(@"Normalized: ");
    //}
    //NSLog(@"Gravity frame with x: %f y:%f z:%f\n", gravity.x, gravity.y, gravity.z);
    
    
    //NSLog(@"speed: %f\n", self.coreLocationController.speed);
    
    // && self.accelerationPreviousFrame >= 0.0 && self.accelerationPreviousFrame < accelerationMinimumDetectionThreshold

    /*
    if (self.coreLocationController.speed == 0 && self.canUpdateY && curAccelerationLength >= accelerationMinimumDetectionThreshold) {
        //we have found a new positive y-axis
        self.positiveYX = userAcceleration.x;
        self.positiveYY = userAcceleration.y;
        self.positiveYZ = userAcceleration.z;
        self.positiveYIsSet = YES;
        self.canUpdateY = NO;
        NSLog(@"Found a new positive Y with x: %f y:%f z:%f\n", self.positiveYX, self.positiveYY, self.positiveYZ);
    } else {
        if (self.coreLocationController.speed > 0) {
            self.canUpdateY = YES;
        }
        if (!self.positiveYIsSet) {
            self.positiveYX = userAcceleration.x;
            self.positiveYY = userAcceleration.y;
            self.positiveYZ = userAcceleration.z;
        }
    }
     */
    
    [self findPositiveYAxisFromUserAcceleration:userAcceleration];
    
    
    if (!self.positiveYIsSet) {
        self.positiveYX = userAcceleration.x;
        self.positiveYY = userAcceleration.y;
        self.positiveYZ = userAcceleration.z;
    }
    
    self.accelerationPreviousFrame = curAccelerationLength;
    //actually can't be parallel
    
    if (self.positiveYX == userAcceleration.x && self.positiveYY == userAcceleration.y && self.positiveYZ == userAcceleration.z){
        [result setValue: [NSNumber numberWithDouble: curAccelerationLength] forKey:@"y"];
        [result setValue:[NSNumber numberWithDouble: 0] forKey:@"x"];
        //NSLog(@"user acceleration same as postive Y.. return early\n");
        return result;
    }
    
    double yComponent = (1.0 * [self getDotProductFromVector1WithX: self.positiveYX Y:self.positiveYY Z:self.positiveYZ AndVector2WithX:userAcceleration.x Y:userAcceleration.y Z:userAcceleration.z]) / [self getVectorLengthWithX:self.positiveYX Y:self.positiveYY Z:self.positiveYZ] ;
    
    if (fabs(yComponent) == curAccelerationLength) {
        NSLog(@"user acceleration parallel with postive Y.. return early\n");
        if (yComponent >= 0) {
            NSLog(@"no change in parallel");
            [result setValue: [NSNumber numberWithDouble: curAccelerationLength] forKey:@"y"];
            [result setValue:[NSNumber numberWithDouble: 0] forKey:@"x"];
            //NSLog(@"result x: %f y: %f length:%f\n", 0.0, curAccelerationLength, curAccelerationLength);
            return result;
        } else {
            NSLog(@"negative in parallel");
            [result setValue: [NSNumber numberWithDouble: (-1.0 * curAccelerationLength)] forKey:@"y"];
            [result setValue:[NSNumber numberWithDouble: 0] forKey:@"x"];
            //NSLog(@"result x: %f y: %f length:%f\n", 0.0, -1.0 * curAccelerationLength, curAccelerationLength);
            return result;
        }
    }
    //NSLog(@"Heavy calculations...\n");
    NSDictionary * positiveZVector = [self getCrossProductFromVector1WithX:userAcceleration.x Y:userAcceleration.y Z:userAcceleration.z AndVector2WithX:self.positiveYX Y:self.positiveYY Z:self.positiveYZ];
    double positiveZX = [[positiveZVector valueForKey:@"x"] doubleValue];
    double positiveZY = [[positiveZVector valueForKey:@"y"] doubleValue];
    double positiveZZ = [[positiveZVector valueForKey:@"z"] doubleValue];
    
    double angle = [self getAngleBetweenVector1WithX: positiveZX Y: positiveZY Z: positiveZZ AndVector2WithX: gravity.x Y: gravity.y Z: gravity.z];
    if (angle > M_PI){
        angle = 2*M_PI - angle;
    }
    if (angle < (M_PI/2.0)) {
        positiveZX = -1.0 * positiveZX;
        positiveZY = -1.0 * positiveZY;
        positiveZZ = -1.0 * positiveZZ;
    }
    
    NSDictionary * positiveXVector = [self getCrossProductFromVector1WithX:self.positiveYX Y:self.positiveYY Z:self.positiveYZ AndVector2WithX:positiveZX Y:positiveZY Z:positiveZZ];
    
    double positiveXX = [[positiveXVector valueForKey:@"x"] doubleValue];
    double positiveXY = [[positiveXVector valueForKey:@"y"] doubleValue];
    double positiveXZ = [[positiveXVector valueForKey:@"z"] doubleValue];
    
    //NSLog(@"Positive X with x: %f y:%f z:%f\n", positiveXX, positiveXY, positiveXZ);
    
    double xComponent = (1.0 * [self getDotProductFromVector1WithX: positiveXX Y:positiveXY Z:positiveXZ AndVector2WithX:userAcceleration.x Y:userAcceleration.y Z:userAcceleration.z]) / [self getVectorLengthWithX:positiveXX Y:positiveXY Z:positiveXZ] ;
    //double yComponent = (1.0 * [self getDotProductFromVector1WithX: self.positiveYX Y:self.positiveYY Z:self.positiveYZ AndVector2WithX:userAcceleration.x Y:userAcceleration.y Z:userAcceleration.z]) / [self getVectorLengthWithX:self.positiveYX Y:self.positiveYY Z:self.positiveYZ] ;
    
    [result setValue: [NSNumber numberWithDouble: xComponent ] forKey:@"x"];
    [result setValue:[NSNumber numberWithDouble: yComponent] forKey:@"y"];
    //NSLog(@"result x: %f y: %f length:%f\n", xComponent, yComponent, sqrt(xComponent * xComponent + yComponent * yComponent));
    return result;
}

- (double) getVectorLengthWithX:(double) x Y:(double) y Z: (double) z {
    return sqrt(x * x + y * y + z * z);
}

- (NSDictionary *) getCrossProductFromVector1WithX:(double)x1 Y:(double)y1 Z:(double)z1 AndVector2WithX:(double)x2 Y:(double)y2 Z:(double) z2 {
    NSMutableDictionary * result = [[NSMutableDictionary alloc] init];
    [result setValue:[NSNumber numberWithDouble:(y1*z2 - z1*y2)] forKey:@"x"];
    [result setValue:[NSNumber numberWithDouble:(z1*x2 - x1*z2)] forKey:@"y"];
    [result setValue:[NSNumber numberWithDouble:(x1*y2 - y1*x2)] forKey:@"z"];
    return result;
}

- (double) getDotProductFromVector1WithX:(double)x1 Y:(double)y1 Z:(double)z1 AndVector2WithX:(double)x2 Y:(double)y2 Z:(double) z2 {
    return x1 * x2 + y1 * y2 + z1 * z2;
}

//returns in radians
- (double) getAngleBetweenVector1WithX:(double)x1 Y:(double)y1 Z:(double)z1 AndVector2WithX:(double)x2 Y:(double)y2 Z:(double) z2 {
    double dotProduct = x1*x2 + y1*y2 + z1*z2;
    double v1Length = [self getVectorLengthWithX:x1 Y:y1 Z:z1];
    double v2Length = [self getVectorLengthWithX:x2 Y:y2 Z:z2];
    double total = (dotProduct * 1.0)/(v1Length * v2Length);
    return acos(total);
}

- (NSDictionary *) getNormalizedVectorWithX:(double) x Y:(double) y Z:(double) z {
    double vectorLength = [self getVectorLengthWithX:x Y:y Z:z];
    NSMutableDictionary * result = [[NSMutableDictionary alloc] init];
    [result setValue:[NSNumber numberWithDouble: (x/vectorLength)] forKey:@"x"];
    [result setValue:[NSNumber numberWithDouble:(y/vectorLength)] forKey:@"y"];
    [result setValue:[NSNumber numberWithDouble:(z/vectorLength)] forKey:@"z"];
    return result;
}

- (void) calibratePositiveYWithAcceleration: (CMAcceleration) acc {
    if (self.shouldCalibrate) {
        NSLog(@"Inside should calibrate\n");
        double length = [self getVectorLengthWithX:acc.x Y:acc.y Z:acc.z];
        if (length >= accelerationMinimumDetectionThreshold){
            self.positiveYX = acc.x;
            self.positiveYY = acc.y;
            self.positiveYZ = acc.z;
            self.positiveYIsSet = YES;
            self.shouldCalibrate = NO;
            NSLog(@"Positive Y now points at x: %f y:%f z:%f length:%f\n", acc.x, acc.y, acc.z, length);
        }
    }
}

@end
