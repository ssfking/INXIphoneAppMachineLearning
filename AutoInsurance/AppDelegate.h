//
//  AppDelegate.h
//  AutoInsurance
//
//  Created by Spencer King on 2/21/13.
//  Copyright (c) 2013 Spencer King. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Reachability.h"
#import "CoreMotionController.h"
#import "CoreLocationController.h"
#import "DatabaseController.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (strong, atomic) NSTimer* timer;
@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;
@property (strong, atomic) Reachability * reachability;
@property (strong, atomic) CoreLocationController *coreLocationController;
@property (strong, atomic) CoreMotionController * coreMotionController;
@property (strong, atomic) DatabaseController *databaseController;
/*
@property (strong, atomic) OverviewViewController *overviewViewController;
@property (strong, atomic) DetailedViewController *detailedViewController;
*/
 @property (strong, atomic) UITabBarController * tabBarController;

- (void) startUpdate;
- (void) stopUpdate;
- (void) logOut;
- (void)saveContext;
- (NSURL *)applicationDocumentsDirectory;

@end
