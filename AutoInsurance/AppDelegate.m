//
//  AppDelegate.m
//  AutoInsurance
//
//  Created by Spencer King on 2/21/13.
//  Copyright (c) 2013 Spencer King. All rights reserved.
//

#import "AppDelegate.h"
#import "OverviewViewController.h"
#import "DetailedViewController.h"
#import "SettingsViewController.h"
#import "UsersViewController.h"
#import "SignalStrengthView.h"

@interface AppDelegate ()
-(void) syncDBWithServer;
- (void)handleNetworkChange:(NSNotification *)notice;
@end

@implementation AppDelegate

@synthesize managedObjectContext = _managedObjectContext;
@synthesize managedObjectModel = _managedObjectModel;
@synthesize persistentStoreCoordinator = _persistentStoreCoordinator;
@synthesize window = _window;
@synthesize timer = _timer;
@synthesize reachability = _reachability;
@synthesize coreLocationController = _coreLocationController;
@synthesize coreMotionController = _coreMotionController;
@synthesize databaseController = _databaseController;
/*
@synthesize overviewViewController = _overviewViewController;
@synthesize detailedViewController = _detailedViewController;
*/
@synthesize tabBarController = _tabBarController;


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    // Override point for customization after application launch.
    self.window.backgroundColor = [UIColor whiteColor];

    self.coreLocationController = [[CoreLocationController alloc] init];
    self.coreMotionController = [[CoreMotionController alloc] init];
    self.databaseController = [[DatabaseController alloc] init];
    
    OverviewViewController *overviewViewController = [[OverviewViewController alloc] init];
    DetailedViewController *detailedViewController = [[DetailedViewController alloc] init];
    SettingsViewController *settingsViewController = [[SettingsViewController alloc] init];
    
    [self.coreLocationController.delegates addObject:overviewViewController];
    [self.coreLocationController.delegates addObject:detailedViewController];
    self.coreLocationController.databaseController = self.databaseController;
    
    [self.coreMotionController.delegates addObject:overviewViewController];
    [self.coreMotionController.delegates addObject:detailedViewController];
    self.coreMotionController.databaseController = self.databaseController;
    self.coreMotionController.coreLocationController = self.coreLocationController;
    
    [overviewViewController view];
    [detailedViewController view];
    [settingsViewController view];
    
    overviewViewController.overviewView.coreMotionController = self.coreMotionController;
    
    UINavigationController *navController1 = [[UINavigationController alloc] initWithRootViewController:overviewViewController];
    navController1.navigationBar.tintColor = [UIColor blackColor];
    navController1.tabBarItem.title = @"Overview";
    navController1.tabBarItem.image = [UIImage imageNamed:@"81-dashboard.png"];
    
    UINavigationController *navController2 = [[UINavigationController alloc] initWithRootViewController:detailedViewController];
    navController2.navigationBar.tintColor = [UIColor blackColor];
    navController2.tabBarItem.title = @"Details";
    navController2.tabBarItem.image = [UIImage imageNamed:@"179-notepad.png"];

    UINavigationController *navController3 = [[UINavigationController alloc] initWithRootViewController:settingsViewController];
    navController3.navigationBar.tintColor = [UIColor blackColor];
    navController3.tabBarItem.title = @"Settings";
    navController3.tabBarItem.image = [UIImage imageNamed:@"19-gear.png"];
    
    NSArray * array = [[NSArray alloc] initWithObjects:navController1, navController2, navController3, nil];
    
    self.tabBarController = [[UITabBarController alloc] init];
    
    [self.tabBarController setViewControllers: array];
    self.tabBarController.tabBar.tintColor = [UIColor blackColor];
    
    for(UIViewController * viewController in self.tabBarController.viewControllers){
        [viewController view];
    }
    
    self.window.rootViewController = self.tabBarController;
    [self.window makeKeyAndVisible];
    
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    NSString * username = [prefs stringForKey:@"username"];
    ///NSLog(@"username is %@", username);
    if (username == nil) {
        //LogInSignUpViewController *logInSignUpViewController = [[LogInSignUpViewController alloc] init];
        UsersViewController *usersViewController = [[UsersViewController alloc] init];
        usersViewController.databaseController = self.databaseController;
        UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:usersViewController];
        navController.navigationBar.tintColor = [UIColor blackColor];
        //logInSignUpViewController.delegate = detailedViewController;
        [self.window.rootViewController presentViewController:navController animated:NO completion:nil];
    } else {
        //[detailedViewController setUsername];
        [self startUpdate];
        //also overview?
    }
    
    [NSTimer scheduledTimerWithTimeInterval:30 target:self selector:@selector(syncDBWithServer) userInfo:nil repeats:YES];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(handleNetworkChange:)
                                                 name:kReachabilityChangedNotification object:nil];
    self.reachability = [Reachability reachabilityForInternetConnection];
    [self.reachability startNotifier];
    //NetworkStatus status = [self.reachability currentReachabilityStatus];

    return YES;
}

- (void)startUpdate {
    [self.coreLocationController startUpdate];
    [self.coreMotionController startUpdate];
}

- (void) stopUpdate {
    [self.coreLocationController stopUpdate];
    [self.coreMotionController stopUpdate];
    
}
- (void) logOut {
    [self stopUpdate];
    //may hvae to roll each tab bar navigation controller back to root
    
    UsersViewController *usersViewController = [[UsersViewController alloc] init];
    usersViewController.databaseController = self.databaseController;
    UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:usersViewController];
    navController.navigationBar.tintColor = [UIColor blackColor];
    //logInSignUpViewController.delegate = detailedViewController;
    [self.window.rootViewController presentViewController:navController animated:NO completion:nil];

    self.tabBarController.selectedViewController = [self.tabBarController.viewControllers objectAtIndex:0];
    NSArray * viewControllers = [self.tabBarController viewControllers];
    [SignalStrengthView setGlobalSignalStrength:0];
    
    for (UINavigationController *cur in viewControllers){
        [[cur.viewControllers objectAtIndex:0] restoreToDefault];
        [cur popToRootViewControllerAnimated:NO];
    }
    
}

- (void) syncDBWithServer {
    [self.databaseController syncDBWithServer];
}

- (void)handleNetworkChange:(NSNotification *)notice {
    ///NSLog(@"handleNetworkChange");
    Reachability* curReach = [notice object];
    if ([curReach isKindOfClass:[Reachability class]]){
        NetworkStatus status = [curReach currentReachabilityStatus];
        if (status == NotReachable) {
            ///NSLog(@"No Internet");
        } else {
            ///NSLog(@"Internet is up and running!!");
            [self syncDBWithServer];
            //Relaunch online application
        }
    }
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Saves changes in the application's managed object context before the application terminates.
    [self saveContext];
}

- (void)saveContext
{
    NSError *error = nil;
    NSManagedObjectContext *managedObjectContext = self.managedObjectContext;
    if (managedObjectContext != nil) {
        if ([managedObjectContext hasChanges] && ![managedObjectContext save:&error]) {
             // Replace this implementation with code to handle the error appropriately.
             // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development. 
            ///NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            abort();
        } 
    }
}

#pragma mark - Core Data stack

// Returns the managed object context for the application.
// If the context doesn't already exist, it is created and bound to the persistent store coordinator for the application.
- (NSManagedObjectContext *)managedObjectContext
{
    if (_managedObjectContext != nil) {
        return _managedObjectContext;
    }
    
    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    if (coordinator != nil) {
        _managedObjectContext = [[NSManagedObjectContext alloc] init];
        [_managedObjectContext setPersistentStoreCoordinator:coordinator];
    }
    return _managedObjectContext;
}

// Returns the managed object model for the application.
// If the model doesn't already exist, it is created from the application's model.
- (NSManagedObjectModel *)managedObjectModel
{
    if (_managedObjectModel != nil) {
        return _managedObjectModel;
    }
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"AutoInsurance" withExtension:@"momd"];
    _managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    return _managedObjectModel;
}

// Returns the persistent store coordinator for the application.
// If the coordinator doesn't already exist, it is created and the application's store added to it.
- (NSPersistentStoreCoordinator *)persistentStoreCoordinator
{
    @synchronized(self) {
    if (_persistentStoreCoordinator != nil) {
        return _persistentStoreCoordinator;
    }
    
    NSURL *storeURL = [[self applicationDocumentsDirectory] URLByAppendingPathComponent:@"AutoInsurance.sqlite"];
    
    NSError *error = nil;
    _persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
    if (![_persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:nil error:&error]) {
        /*
         Replace this implementation with code to handle the error appropriately.
         
         abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development. 
         
         Typical reasons for an error here include:
         * The persistent store is not accessible;
         * The schema for the persistent store is incompatible with current managed object model.
         Check the error message to determine what the actual problem was.
         
         
         If the persistent store is not accessible, there is typically something wrong with the file path. Often, a file URL is pointing into the application's resources directory instead of a writeable directory.
         
         If you encounter schema incompatibility errors during development, you can reduce their frequency by:
         * Simply deleting the existing store:
         [[NSFileManager defaultManager] removeItemAtURL:storeURL error:nil]
         
         * Performing automatic lightweight migration by passing the following dictionary as the options parameter:
         @{NSMigratePersistentStoresAutomaticallyOption:@YES, NSInferMappingModelAutomaticallyOption:@YES}
         
         Lightweight migration will only work for a limited set of schema changes; consult "Core Data Model Versioning and Data Migration Programming Guide" for details.
         
         */
        ///NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
        }
    }
    
    return _persistentStoreCoordinator;
}

#pragma mark - Application's Documents directory

// Returns the URL to the application's Documents directory.
- (NSURL *)applicationDocumentsDirectory
{
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}

@end
