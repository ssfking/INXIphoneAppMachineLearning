//
//  AddExistingUserViewController.m
//  AutoInsurance
//
//  Created by Spencer King on 3/4/13.
//  Copyright (c) 2013 Spencer King. All rights reserved.
//

#import "AddExistingUserViewController.h"
#import "AppDelegate.h"
#import "AFNetworking.h"
@interface AddExistingUserViewController ()

@end

@implementation AddExistingUserViewController

@synthesize username = _username;
//@synthesize password = _password;
@synthesize addExistingUserButton = _addExistingUserButton;
@synthesize feedback = _feedback;
@synthesize usernameMessageView = _usernameMessageView;
@synthesize activityIndicator = _activityIndicator;

- (void)loadView
{
    NSLog(@"Login loadview\n");
    self.view = [[UIView alloc] init];
    self.view.backgroundColor = [UIColor colorWithRed:176.0/255 green:196.0/255 blue:222.0/255 alpha:1];
    self.username = [[UITextField alloc] initWithFrame:CGRectMake(60, 60.0, 234.0, 40.0)];
    self.username.borderStyle = UITextBorderStyleRoundedRect;
    self.username.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    self.username.placeholder = @"Username";
    self.username.delegate = self;
    [self.view addSubview:self.username];
    
    /*
    self.password = [[UITextField alloc] initWithFrame:CGRectMake(60, 100.0, 234.0, 40.0)];
    self.password.borderStyle = UITextBorderStyleRoundedRect;
    self.password.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    self.password.placeholder = @"Password";
    self.password.secureTextEntry = YES;
    self.password.delegate = self;
    [self.view addSubview:self.password];
    */
    
    self.addExistingUserButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    self.addExistingUserButton.frame= CGRectMake(60, 180.0, 234.0, 40.0);
    self.addExistingUserButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
    self.addExistingUserButton.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    [self.addExistingUserButton setTitle:@"Add Existing User" forState:UIControlStateNormal];
    [self.addExistingUserButton addTarget:self action:@selector(addExistingUserButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview: self.addExistingUserButton];
    
    self.feedback = [[UILabel alloc] initWithFrame:CGRectMake(10, 250, 320.0f, 30.0f)];
    self.feedback.text = @"";
    self.feedback.backgroundColor = [UIColor clearColor];
    self.feedback.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:self.feedback];
    
    self.usernameMessageView = [[UIAlertView alloc] initWithTitle:@"" message:@"" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles: nil];
    
    self.navigationItem.title = @"Add Existing User";
    UIBarButtonItem * tempButtonItem = [[ UIBarButtonItem alloc] init];
    tempButtonItem .title = @"Back";
    
    self.navigationItem.backBarButtonItem = tempButtonItem ;
    
    self.activityIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    self.activityIndicator.frame = CGRectMake(7, 7, 26, 26);
    self.activityIndicator.hidden = YES;
    [self.addExistingUserButton addSubview:self.activityIndicator];
    
    /*
     self.signUpButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
     self.signUpButton.frame= CGRectMake(60, 209.0, 234.0, 37.0);
     self.signUpButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
     self.signUpButton.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
     [self.signUpButton setTitle:@"Log In" forState:UIControlStateNormal];
     [self.signUpButton addTarget:self action:@selector(signUpbuttonClicked:) forControlEvents:UIControlEventTouchUpInside];
     [self.view addSubview: self.signUpButton];
     */
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)viewWillAppear:(BOOL)animated {
    CGFloat parentHeight =self.view.bounds.size.height;
    CGFloat parentWidth =self.view.bounds.size.width;
    self.feedback.frame = CGRectMake((parentWidth - 300)/2,  parentHeight/3.0 - (5 +17.5 + 10 + 35 + 10 + 35), 300.0, 35.0);
    self.username.frame = CGRectMake(50,  parentHeight/3.0 - (17.5 + 10 + 35), 220.0, 35.0);
    //self.password.frame = CGRectMake(50, parentHeight/3.0 - (5+17.5), 220.0, 35.0);
    self.addExistingUserButton.frame = CGRectMake(50, parentHeight/3.0 - 17.5, 220.0, 35.0);
    self.activityIndicator.frame = CGRectMake((self.activityIndicator.superview.bounds.size.width - 30)/2, (self.activityIndicator.superview.bounds.size.height - 30)/2, 30, 30);
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)addExistingUserButtonClicked:(id)sender
{
    NSLog(@"log in button clicked\n");
    //processing code with server
    if ([self.username.text length] <= 0){
        self.feedback.text = @"Username field must not be empty";
    } else {
        NSDictionary *params = [[NSMutableDictionary alloc] init];
        [params setValue:self.username.text forKey:@"username"];
        //[params setValue:self.password.text forKey:@"password"];
        AFHTTPClient *client = [[AFHTTPClient alloc] initWithBaseURL: [NSURL URLWithString:SERVER_URL]];
        client.parameterEncoding = AFJSONParameterEncoding;
        NSLog(@"Params:%@\n",params);
        NSMutableURLRequest *request = [client requestWithMethod:@"GET" path:@"/user/username" parameters:params];
        AFJSONRequestOperation *operation =[AFJSONRequestOperation JSONRequestOperationWithRequest:request success: ^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
            self.activityIndicator.hidden = YES;
            [self.activityIndicator stopAnimating];
            [self.addExistingUserButton setTitle:@"Add Existing User" forState:UIControlStateNormal];
            NSDictionary * responseDictionary = JSON;
            NSLog(@"Response dictionary:%@\n", responseDictionary);
            NSString *result = [responseDictionary valueForKey:@"result"];
            if ([result isEqualToString:@"success"]){
                AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
                NSManagedObjectContext *ctx = [[NSManagedObjectContext alloc] init];
                [ctx setUndoManager:nil];
                [ctx setPersistentStoreCoordinator: [appDelegate persistentStoreCoordinator]];
                NSError *error = nil;
                [appDelegate.databaseController addNewUserRecordWithUsername:self.username.text WithContext:ctx WithError:&error];
                if (error != nil && error.code == 1) {
                    self.usernameMessageView.message = @"Username has already been added.";
                    [self.usernameMessageView show];
                } else {
                    [self.navigationController popToRootViewControllerAnimated:NO];
                }
            } else {
                self.usernameMessageView.message = @"Username does not exist.";
                [self.usernameMessageView show];
            }
        }failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON){
            self.activityIndicator.hidden = YES;
            [self.activityIndicator stopAnimating];
            [self.addExistingUserButton setTitle:@"Add Existing User" forState:UIControlStateNormal];
            self.usernameMessageView.message = @"Cannot connect to server.";
            [self.usernameMessageView show];
        }];
        [self.addExistingUserButton setTitle:@"" forState:UIControlStateNormal];
        self.activityIndicator.hidden = NO;
        [self.activityIndicator startAnimating];
        [operation start];
    }
}

- (BOOL) textFieldShouldEndEditing:(UITextField *)textField {
    return YES;
}

- (BOOL) textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    [self.view endEditing:TRUE];
}

@end
