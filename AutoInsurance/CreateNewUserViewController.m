//
//  CreateNewUserViewController.m
//  AutoInsurance
//
//  Created by Spencer King on 3/4/13.
//  Copyright (c) 2013 Spencer King. All rights reserved.
//

#import "CreateNewUserViewController.h"
#import "AppDelegate.h"
#import "AFNetworking.h"

@interface CreateNewUserViewController ()

@end

@implementation CreateNewUserViewController

@synthesize username = _username;
@synthesize password = _password;
@synthesize createNewUserButton = _createNewUserButton;
@synthesize feedback = _feedback;
@synthesize createUserMessageView = _createUserMessageView;
@synthesize activityIndicator = _activityIndicator;

- (void)loadView
{
    self.view = [[UIView alloc] init];
    self.view.backgroundColor = [UIColor colorWithRed:176.0/255 green:196.0/255 blue:222.0/255 alpha:1];
    self.username = [[UITextField alloc] initWithFrame:CGRectMake(60, 150.0, 234.0, 37.0)];
    self.username.borderStyle = UITextBorderStyleRoundedRect;
    self.username.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    self.username.placeholder = @"Username";
    self.username.delegate = self;
    [self.view addSubview:self.username];
    
    self.password = [[UITextField alloc] initWithFrame:CGRectMake(60, 209.0, 234.0, 37.0)];
    self.password.borderStyle = UITextBorderStyleRoundedRect;
    self.password.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    self.password.placeholder = @"Password";
    self.password.secureTextEntry = YES;
    self.password.delegate = self;
    [self.view addSubview:self.password];
    
    self.createNewUserButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    self.createNewUserButton.frame= CGRectMake(60, 268.0, 234.0, 37.0);
    self.createNewUserButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
    self.createNewUserButton.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    [self.createNewUserButton setTitle:@"Create New User" forState:UIControlStateNormal];
    [self.createNewUserButton addTarget:self action:@selector(createNewUserButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview: self.createNewUserButton];
    
    self.feedback = [[UILabel alloc] initWithFrame:CGRectMake(10, 250, 320.0f, 30.0f)];
    self.feedback.text = @"";
    self.feedback.backgroundColor = [UIColor clearColor];
    self.feedback.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:self.feedback];
    
    self.createUserMessageView = [[UIAlertView alloc] initWithTitle:@"" message:@"" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles: nil];
    
    self.navigationItem.title = @"Create New User";
    UIBarButtonItem * tempButtonItem = [[ UIBarButtonItem alloc] init];
    tempButtonItem .title = @"Back";
    
    self.navigationItem.backBarButtonItem = tempButtonItem;
    
    self.activityIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    self.activityIndicator.frame = CGRectMake(7, 7, 26, 26);
    self.activityIndicator.hidden = YES;
    [self.createNewUserButton addSubview:self.activityIndicator];
    /*
     self.logInButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
     self.logInButton.frame= CGRectMake(60, 150.0, 234.0, 37.0);
     self.logInButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
     self.logInButton.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
     [self.logInButton setTitle:@"Log In" forState:UIControlStateNormal];
     [self.logInButton addTarget:self action:@selector(logInbuttonClicked:) forControlEvents:UIControlEventTouchUpInside];
     [self.view addSubview: self.logInButton];
     
     self.createNewUserButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
     self.createNewUserButton.frame= CGRectMake(60, 209.0, 234.0, 37.0);
     self.createNewUserButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
     self.createNewUserButton.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
     [self.createNewUserButton setTitle:@"Log In" forState:UIControlStateNormal];
     [self.createNewUserButton addTarget:self action:@selector(createNewUserButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
     [self.view addSubview: self.createNewUserButton];
     */
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)viewWillAppear:(BOOL)animated
{
    CGFloat parentHeight =self.view.bounds.size.height;
    CGFloat parentWidth =self.view.bounds.size.width;
    self.feedback.frame = CGRectMake((parentWidth - 300)/2,  parentHeight/3.0 - (5 +17.5 + 10 + 35 + 10 + 35), 300.0, 35.0);
    self.username.frame = CGRectMake(50,  parentHeight/3.0 - (5 +17.5 + 10 + 35), 220.0, 35.0);
    self.password.frame = CGRectMake(50, parentHeight/3.0 - (5+17.5), 220.0, 35.0);
    self.createNewUserButton.frame = CGRectMake(50, parentHeight/3.0 - 5 + (17.5 + 10), 220.0, 35.0);
    self.activityIndicator.frame = CGRectMake((self.activityIndicator.superview.bounds.size.width - 30)/2, (self.activityIndicator.superview.bounds.size.height - 30)/2, 30, 30);
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)createNewUserButtonClicked:(id)sender
{
    ///NSLog(@"Create New User button clicked\n");
    
    if ([self.username.text length] < 3) {
        self.createUserMessageView.message = @"Username field must have at least 3 characters";
        [self.createUserMessageView show];
    }
    else if ([self.password.text length] < 5) {
        self.createUserMessageView.message = @"Password field must have at least 5 characters";
        [self.createUserMessageView show];
    }
    else {
        NSDictionary *params = [[NSMutableDictionary alloc] init];
        [params setValue:self.username.text forKey:@"username"];
        [params setValue:self.password.text forKey:@"password"];
        AFHTTPClient *client = [[AFHTTPClient alloc] initWithBaseURL: [NSURL URLWithString:SERVER_URL]];
        client.parameterEncoding = AFJSONParameterEncoding;
        ///NSLog(@"%@",params);
        NSMutableURLRequest *request = [client requestWithMethod:@"POST" path:@"/user/add" parameters:params];
        AFJSONRequestOperation *operation =[AFJSONRequestOperation JSONRequestOperationWithRequest:request success: ^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON){
            self.activityIndicator.hidden = YES;
            [self.activityIndicator stopAnimating];
            [self.createNewUserButton setTitle:@"Create New User" forState:UIControlStateNormal];
            NSDictionary * responseDictionary = JSON;
            ///NSLog(@"Response dictionary:%@\n", responseDictionary);
            NSString *result = [responseDictionary valueForKey:@"result"];
            if ([result isEqualToString:@"success"]){
                AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
                NSManagedObjectContext *ctx = [[NSManagedObjectContext alloc] init];
                [ctx setUndoManager:nil];
                [ctx setPersistentStoreCoordinator: [appDelegate persistentStoreCoordinator]];
                NSError *error;
                [appDelegate.databaseController addNewUserRecordWithUsername:self.username.text WithContext:ctx WithError:&error];
                [self.navigationController popToRootViewControllerAnimated:NO];
            } else {
                self.createUserMessageView.message = @"Username has been taken.";
                [self.createUserMessageView show];
            }
        } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON){
            self.activityIndicator.hidden = YES;
            [self.activityIndicator stopAnimating];
            [self.createNewUserButton setTitle:@"Create New User" forState:UIControlStateNormal];
            self.createUserMessageView.message = @"Cannot connect to server.";
            [self.createUserMessageView show];
            ///NSLog(@"error opening connection");
        }];
        [self.createNewUserButton setTitle:@"" forState:UIControlStateNormal];
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

