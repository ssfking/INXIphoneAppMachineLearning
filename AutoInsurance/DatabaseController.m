//
//  DatabaseController.m
//  AutoInsurance
//
//  Created by Spencer King on 3/3/13.
//  Copyright (c) 2013 Spencer King. All rights reserved.
//

#import "DatabaseController.h"
#import "AppDelegate.h"
#import "AFNetworking.h"

@interface DatabaseController()

- (NSDate *) findMostRecentTimeInEntity: (NSString *) entity WithContext:(NSManagedObjectContext *) context;
- (NSArray *) findAllRecordsWithTimeBeforeOrEqualTo: (NSDate *) time InEntity: (NSString *) entity WithContext:(NSManagedObjectContext *) context;
- (void) deleteAllRecordsWithTimeBeforeOrEqualTo: (NSDate *) time InEntity: (NSString *) entity WithContext:(NSManagedObjectContext *) context;
- (void) sendPostRequestWithParams: (NSDictionary *) params WithTimeLocation:(NSDate *)timeLoc WithTimeMotion:(NSDate *)timeMotion WithSuccess: (void (^)(NSURLRequest *request, NSHTTPURLResponse *response, id JSON)) success WithFailure: (void (^)(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON)) failure;

@end

@implementation DatabaseController

@synthesize dateFormatter = _dateFormatter;
@synthesize serialQueue = _serialQueue;

- (id)init {
    NSDateFormatter *formatter=[[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss.SSS"];
    self.dateFormatter = formatter;
    self.serialQueue = dispatch_queue_create("com.example.serialQueue", NULL);
    return self;
}

- (void) addNewUserRecordWithUsername: (NSString*) username WithContext: (NSManagedObjectContext *) context WithError: (NSError **) error{
    NSFetchRequest *request= [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"User" inManagedObjectContext:context];
    NSPredicate *predicate =[NSPredicate predicateWithFormat:@"username==%@", username];
    [request setEntity:entity];
    [request setPredicate:predicate];
    
    NSError *error1;
    NSArray *userArr = [context executeFetchRequest:request error:&error1];
    if ([userArr count] <= 0 ){
        NSManagedObject *newUser = [NSEntityDescription insertNewObjectForEntityForName: @"User" inManagedObjectContext:context];
        [newUser setValue:username forKey:@"username"];
        [newUser setValue:[NSNumber numberWithBool:YES] forKey:@"isRegistered"];
        ///NSLog(@"New user:%@\n", username);
        NSError *error;
        bool success = [context save:&error];
        if (!success){
            ///NSLog(@"Error saving: %@\n", [error localizedDescription]);
        } else {
            ///NSLog(@"Save successful!");
        }
    } else {
        NSManagedObject *oldUser = [userArr objectAtIndex:0];
        if ([[oldUser valueForKey:@"isRegistered"] boolValue] == YES) {
            *error = [[NSError alloc] initWithDomain:@"Database" code: 1 userInfo:nil];
        } else {
            [oldUser setValue:[NSNumber numberWithBool:YES] forKey:@"isRegistered"];
            ///NSLog(@"Register old user\n");
            NSError *error2;
            bool success = [context save:&error2];
            if (!success){
                ///NSLog(@"Error saving: %@\n", [error2 localizedDescription]);
            } else {
                ///NSLog(@"Save successful!");
            }
        }
    }
}

- (void) deleteRegisteredUserWithUsername: (NSString*) username WithContext: (NSManagedObjectContext *) context {
    NSFetchRequest *request= [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"User" inManagedObjectContext:context];
    NSPredicate *predicate =[NSPredicate predicateWithFormat:@"username==%@", username];
    [request setEntity:entity];
    [request setPredicate:predicate];
    
    NSError *error;
    NSArray *userArr = [context executeFetchRequest:request error:&error];
    if ([userArr count] > 0 ){
        NSManagedObject *oldUser = [userArr objectAtIndex:0];
        [oldUser setValue:[NSNumber numberWithBool: FALSE] forKey:@"isRegistered"];
        ///NSLog(@"de-registered user\n");
        NSError *error;
        bool success = [context save:&error];
        if (!success){
            ///NSLog(@"Error saving: %@\n", [error localizedDescription]);
        } else {
            ///NSLog(@"Save successful!");
        }
    }
}

- (NSArray *) findRegisteredUsersWithContext: (NSManagedObjectContext *) context {
    NSFetchRequest *request= [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"User" inManagedObjectContext:context];
    NSPredicate *predicate =[NSPredicate predicateWithFormat:@"isRegistered==YES"];
    [request setEntity:entity];
    [request setPredicate:predicate];
    
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"username" ascending:YES selector:@selector(caseInsensitiveCompare:)];
    NSArray *sortDescriptors = [[NSArray alloc] initWithObjects:sortDescriptor, nil];
    [request setSortDescriptors:sortDescriptors];
    
    NSError *error;
    NSArray *userArr = [context executeFetchRequest:request error:&error];
    NSMutableArray *result = [[NSMutableArray alloc] init];
    for (NSManagedObject *obj in userArr) {
        [result addObject: [obj valueForKey:@"username"]];
    }
    return result;
}

- (void) addNewLocationRecordWithLocationObject:(CLLocation *)location DistanceTraveled:(double) distanceTraveled CalcSpeed: (double) calcSpeed Context: (NSManagedObjectContext *) context {
    
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    NSString * username = [prefs stringForKey:@"username"];
    
    NSFetchRequest *request= [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"User" inManagedObjectContext:context];
    NSPredicate *predicate =[NSPredicate predicateWithFormat:@"username==%@", username];
    [request setEntity:entity];
    [request setPredicate:predicate];
    
    NSError *error;
    NSArray *userArr = [context executeFetchRequest:request error:&error];
    ///NSLog(@"UserArr:%@\n",userArr);
    if ([userArr count] <= 0) {
        ///NSLog(@"This is bad... adding records but there is no such user record");
    } else {
        NSManagedObject *newCoreLocation = [NSEntityDescription insertNewObjectForEntityForName: @"CoreLocation" inManagedObjectContext:context];
        [newCoreLocation setValue: [NSNumber numberWithDouble: location.coordinate.latitude] forKey:@"latitude"];
        [newCoreLocation setValue: [NSNumber numberWithDouble: location.coordinate.longitude] forKey:@"longitude"];
        [newCoreLocation setValue: [NSNumber numberWithDouble: location.altitude] forKey:@"altitude"];
        [newCoreLocation setValue: [NSNumber numberWithDouble: location.horizontalAccuracy] forKey:@"horizontalAccuracy"];
        [newCoreLocation setValue: [NSNumber numberWithDouble: location.verticalAccuracy] forKey:@"verticalAccuracy"];
        [newCoreLocation setValue: [NSNumber numberWithDouble: calcSpeed] forKey:@"speed"];
        [newCoreLocation setValue: [NSNumber numberWithDouble: distanceTraveled] forKey:@"distanceTraveled"];
        [newCoreLocation setValue: [NSNumber numberWithDouble: location.course] forKey:@"direction"];
        [newCoreLocation setValue: location.timestamp forKey:@"time"];
        [newCoreLocation setValue: [userArr objectAtIndex:0] forKey:@"user"];
        //NSLog(@"New location time:%@ latitude:%f longitude:%f altitude:%f hAccuracy:%f speed:%f username:%@\n",[self.dateFormatter stringFromDate:location.timestamp], location.coordinate.latitude, location.coordinate.longitude, location.altitude, location.horizontalAccuracy, location.speed, [[userArr objectAtIndex:0] valueForKey:@"username"]);
        /*
         NSManagedObject *newCoreMotion = [NSEntityDescription insertNewObjectForEntityForName: @"CoreMotion" inManagedObjectContext:context];
         double a_x = 1.001234;
         double a_y = 1.202020;
         double a_z = 3.345678;
         double sum = 4.654321;
         NSDate *time = location.timestamp;
         [newCoreMotion setValue: [NSNumber numberWithDouble:a_x]  forKey: @"accelerationX"];
         [newCoreMotion setValue: [NSNumber numberWithDouble:a_y]  forKey: @"accelerationY"];
         [newCoreMotion setValue: [NSNumber numberWithDouble:a_z]  forKey: @"accelerationZ"];
         [newCoreMotion setValue: [NSNumber numberWithDouble:sum]  forKey: @"accelerationSum"];
         [newCoreMotion setValue: time forKey: @"time"];
         */
        
        NSError *error;
        bool success = [context save:&error];
        if (!success){
            ///NSLog(@"Error saving: %@\n", [error localizedDescription]);
        } else {
            ///NSLog(@"Save successful!");
        }
    }
}

- (void) addNewMotionRecordWithX:(double)x Y:(double)y Length:(double)length Time:(NSDate *)time Context:(NSManagedObjectContext *)context{
    //NSLog(@"Add New Motion\n");
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    NSString * username = [prefs stringForKey:@"username"];
    
    NSFetchRequest *request= [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"User" inManagedObjectContext:context];
    NSPredicate *predicate =[NSPredicate predicateWithFormat:@"username==%@", username];
    [request setEntity:entity];
    [request setPredicate:predicate];
    
    NSError *error;
    NSArray *userArr = [context executeFetchRequest:request error:&error];
    if ([userArr count] <= 0) {
        ///NSLog(@"This is bad... adding records but there is no such user record");
    } else {
        
        NSManagedObject *newCoreMotion = [NSEntityDescription insertNewObjectForEntityForName: @"CoreMotion" inManagedObjectContext:context];
/*
        double a_x = deviceMotion.userAcceleration.x;
        double a_y = deviceMotion.userAcceleration.y;
        double a_z = deviceMotion.userAcceleration.z;
*/
        [newCoreMotion setValue: [NSNumber numberWithDouble:x]  forKey: @"accelerationX"];
        [newCoreMotion setValue: [NSNumber numberWithDouble:y]  forKey: @"accelerationY"];
        //[newCoreMotion setValue: [NSNumber numberWithDouble:a_z]  forKey: @"accelerationZ"];
        [newCoreMotion setValue: [NSNumber numberWithDouble:length]  forKey: @"accelerationSum"];
        [newCoreMotion setValue: time forKey: @"time"];
        [newCoreMotion setValue: [userArr objectAtIndex:0] forKey:@"user"];
        //NSLog(@"New acceleration in time:%@ x:%f y:%f username:%@\n", [self.dateFormatter stringFromDate:time], x, y, [[userArr objectAtIndex:0] valueForKey:@"username"]);
        NSError *error;
        bool success = [context save:&error];
        if (!success){
            ///NSLog(@"Error saving: %@\n", [error localizedDescription]);
        } else {
            ///NSLog(@"Save successful!");
        }
    }
}

//bug here? needs queue that is sequenced
- (void) syncDBWithServer {
    //dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT,0), ^{
    dispatch_async(self.serialQueue, ^{
        NSLog(@"SyncDBWithServer!!!!\n");
        
        // Create context on background thread
        AppDelegate *appdelegate = [[UIApplication sharedApplication] delegate];
        
        NSManagedObjectContext *ctx = [[NSManagedObjectContext alloc] init];
        [ctx setUndoManager:nil];
        [ctx setPersistentStoreCoordinator: [appdelegate persistentStoreCoordinator]];
        
        NSDate * maxTimeLocation = [self findMostRecentTimeInEntity:@"CoreLocation" WithContext:ctx];
        NSDate * maxTimeMotion = [self findMostRecentTimeInEntity:@"CoreMotion" WithContext:ctx];
        if (maxTimeMotion != nil || maxTimeLocation != nil){
            NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
            int entered = 0;
            NSArray *locations = [self findAllRecordsWithTimeBeforeOrEqualTo:maxTimeLocation InEntity:@"CoreLocation" WithContext:ctx];
            if (locations != nil && [locations count] > 0){
                NSArray *keys = [NSArray arrayWithObjects:@"latitude", @"longitude", @"altitude" ,@"verticalAccuracy" ,@"horizontalAccuracy" ,@"speed" ,@"distanceTraveled" ,@"direction" ,nil];
                NSMutableArray *arrLoc = [[NSMutableArray alloc] init];
                NSMutableDictionary *usersDict = [[NSMutableDictionary alloc] init];
                
                for (NSManagedObject *obj in locations) {
                    NSString * username = [[obj valueForKey:@"user"] valueForKey:@"username"];
                    if ([usersDict objectForKey: username] == nil) {
                        NSMutableArray * newArr = [[NSMutableArray alloc] init];
                        [usersDict setValue:newArr forKey:username];
                    }
                    NSMutableArray * userArr = [usersDict objectForKey:username];
                    NSMutableDictionary * dictLoc = [[obj dictionaryWithValuesForKeys:keys] mutableCopy];
                    NSDate * date = [obj valueForKey:@"time"];
                    NSString *dateString = [self.dateFormatter stringFromDate:date];
                    [dictLoc setValue:dateString forKey:@"time"];
                    [userArr addObject:dictLoc];
                }
                for (NSString *key in [usersDict allKeys]){
                    NSMutableDictionary *userArr = [usersDict valueForKey:key];
                    NSMutableDictionary *userDict = [[NSMutableDictionary alloc] init];
                    [userDict setValue:key forKey:@"user"];
                    [userDict setValue:userArr forKey:@"locations"];
                    [arrLoc addObject:userDict];
                }
                [dict setObject:arrLoc forKey:@"CoreLocation"];
                entered++;
            }
            
            NSArray *motions = [self findAllRecordsWithTimeBeforeOrEqualTo:maxTimeMotion InEntity:@"CoreMotion" WithContext:ctx];
            if (motions != nil && [motions count] > 0) {
                NSArray *keys = [NSArray arrayWithObjects: @"accelerationX", @"accelerationY", @"accelerationSum", nil];
                NSMutableArray *arrMotion = [[NSMutableArray alloc] init];
                NSMutableDictionary *usersDict = [[NSMutableDictionary alloc] init];
                for (NSManagedObject *obj in motions) {
                    NSString * username = [[obj valueForKey:@"user"] valueForKey:@"username"];
                    if ([usersDict objectForKey: username] == nil) {
                        NSMutableArray * newArr = [[NSMutableArray alloc] init];
                        [usersDict setValue:newArr forKey:username];
                    }
                    NSMutableArray * userArr = [usersDict objectForKey:username];
                    NSMutableDictionary * dictMotion = [[obj dictionaryWithValuesForKeys:keys] mutableCopy];
                    NSDate * date = [obj valueForKey:@"time"];
                    NSString *dateString = [self.dateFormatter stringFromDate:date];
                    [dictMotion setValue:dateString forKey:@"time"];
                    [userArr addObject:dictMotion];
                }
                for (NSString *key in [usersDict allKeys]){
                    NSMutableDictionary *userArr = [usersDict valueForKey:key];
                    NSMutableDictionary *userDict = [[NSMutableDictionary alloc] init];
                    [userDict setValue:key forKey:@"user"];
                    [userDict setValue:userArr forKey:@"motions"];
                    [arrMotion addObject:userDict];
                }
                
                [dict setObject:arrMotion forKey:@"CoreMotion"];
                entered++;
            }
            if (entered > 0){
                [self sendPostRequestWithParams: dict WithTimeLocation:maxTimeLocation WithTimeMotion:maxTimeMotion WithSuccess:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON){
                    dispatch_async(self.serialQueue, ^{
                    NSLog(@"Success\n");
                    AppDelegate *appdelegate = [[UIApplication sharedApplication] delegate];
                    NSManagedObjectContext *ctx = [[NSManagedObjectContext alloc] init];
                    [ctx setUndoManager:nil];
                    [ctx setPersistentStoreCoordinator: [appdelegate persistentStoreCoordinator]];
                    [self deleteAllRecordsWithTimeBeforeOrEqualTo:maxTimeLocation InEntity:@"CoreLocation" WithContext:ctx];
                    [self deleteAllRecordsWithTimeBeforeOrEqualTo:maxTimeMotion InEntity:@"CoreMotion" WithContext:ctx];
                    NSLog(@"DONE!!!!");
                    });
                } WithFailure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON){
                     NSLog(@"error opening connection");
                }];
            }
        }
        /*        if (maxTimeLocation != nil) {
         [self deleteAllRecordsWithTimeBeforeOrEqualTo:maxTimeLocation InEntity:@"CoreLocation" WithContext:ctx];
         }
         if (maxTimeMotion != nil){
         [self deleteAllRecordsWithTimeBeforeOrEqualTo:maxTimeMotion InEntity:@"CoreMotion" WithContext:ctx];
         }*/
    });
}

- (NSDate *) findMostRecentTimeInEntity: (NSString *) entity WithContext:(NSManagedObjectContext *) context {
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    NSEntityDescription *entityDes = [NSEntityDescription entityForName:entity inManagedObjectContext:context];
    [request setEntity:entityDes];
    [request setResultType:NSDictionaryResultType];
    
    NSExpression *time = [NSExpression expressionForKeyPath:@"time"];
    NSExpression *maxTime = [NSExpression expressionForFunction:@"max:" arguments:[NSArray arrayWithObject:time]];
    NSExpressionDescription *d = [[NSExpressionDescription alloc] init];
    [d setName:@"maxTime"];
    [d setExpression:maxTime];
    [d setExpressionResultType:NSDateAttributeType];
    
    [request setPropertiesToFetch:[NSArray arrayWithObject:d]];
    
    NSError *error = nil;
    NSArray *objects = [context executeFetchRequest:request error:&error];
    if (objects == nil) {
        // Handle the error.
        return nil;
    } else {
        if ([objects count] > 0) {
            NSDate* timeNewest = [[objects objectAtIndex:0] valueForKey:@"maxTime"];
            ///NSLog(@"Most recent time: %@\n", timeNewest);
            return timeNewest;
        }
    }
    return nil;
}

- (NSArray *)findAllRecordsWithTimeBeforeOrEqualTo:(NSDate *)time InEntity:(NSString *)entity WithContext:(NSManagedObjectContext *)context
{
    if (time == nil) return nil;
    NSEntityDescription *entityDesc = [NSEntityDescription entityForName:entity  inManagedObjectContext:context];
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    [request setEntity:entityDesc];
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"(time <= %@)", time];
    [request setPredicate:pred];
    
    NSError *error;
    NSArray *objects = [context executeFetchRequest:request
                                              error:&error];
    ///NSLog(@"%d matches found\n", [objects count]);
    return objects;
}

- (void) deleteAllRecordsWithTimeBeforeOrEqualTo: (NSDate *) time InEntity: (NSString *) entity WithContext:(NSManagedObjectContext *) context {
    if (time == nil) return;
    ///NSLog(@"Delete from entity:%@ at: %@\n", entity, time);
    NSEntityDescription *entityDesc = [NSEntityDescription entityForName:entity  inManagedObjectContext:context];
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    [request setEntity:entityDesc];
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"(time <= %@)", time];
    [request setPredicate:pred];
    
    NSError *error;
    NSArray *objects = [context executeFetchRequest:request
                                              error:&error];
    ///NSLog(@"%d matches found\n", [objects count]);
    for (NSManagedObject *obj in objects) {
        ///NSDate *time = [obj valueForKey:@"time"];
        ///NSLog(@"Time:%@",time);
        [context deleteObject:obj];
    }
    [context save:&error];
    /*
     NSNumber *latitude = [obj valueForKey:@"latitude"];
     NSNumber *longitude = [obj valueForKey:@"longitude"];
     NSNumber *horizontalAccuracy = [obj valueForKey:@"horizontalAccuracy"];
     NSNumber *speed = [obj valueForKey:@"speed"];
     NSNumber *direction = [obj valueForKey:@"direction"];
     ///NSLog(@"latitude:%f; longitude:%f, hoizontal accuracy:%f, speed:%f; direction: %f\n", [latitude doubleValue], [longitude doubleValue], [horizontalAccuracy doubleValue], [speed doubleValue],[direction doubleValue]);
     
     */
}

- (void) sendPostRequestWithParams: (NSDictionary *) params WithTimeLocation:(NSDate *)timeLoc WithTimeMotion:(NSDate *)timeMotion WithSuccess: (void (^)(NSURLRequest *request, NSHTTPURLResponse *response, id JSON)) success WithFailure: (void (^)(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON)) failure {
    ///NSLog(@"Going to send Post request\n");
    AFHTTPClient *client = [[AFHTTPClient alloc] initWithBaseURL: [NSURL URLWithString:SERVER_URL]];
    client.parameterEncoding = AFJSONParameterEncoding;
    ///NSLog(@"%@",params);
    NSMutableURLRequest *request = [client requestWithMethod:@"POST" path:@"/data/add" parameters:params];
    AFJSONRequestOperation *operation =[AFJSONRequestOperation JSONRequestOperationWithRequest:request success: success failure: failure];
    [operation start];
}

@end
