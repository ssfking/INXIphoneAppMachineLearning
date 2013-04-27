//
//  DeleteUserViewController.m
//  AutoInsurance
//
//  Created by Spencer King on 3/13/13.
//  Copyright (c) 2013 Spencer King. All rights reserved.
//

#import "DeleteUserViewController.h"
#import "AppDelegate.h"
#import "DetailedViewController.h"
#import "AFNetworking.h"


@interface DeleteUserViewController ()
-(void)deleteButtonClicked:(id)sender;
//- (void)deleteButtonClicked:(id)sender;
@end

@implementation DeleteUserViewController

@synthesize usernameString = _usernameString;
@synthesize password = _password;
@synthesize deleteButton = _deleteButton;
@synthesize feedback = _feedback;
@synthesize username = _username;
//@synthesize deleteButton = _deleteButton;
@synthesize databaseController = _databaseController;
@synthesize confirmDeleteView = _confirmDeleteView;
@synthesize loginMessageView = _loginMessageView;
@synthesize activityIndicator = _activityIndicator;

- (void)loadView
{
    ///NSLog(@"Login loadview\n");
    self.view = [[UIView alloc] init];
    self.view.backgroundColor = [UIColor colorWithRed:176.0/255 green:196.0/255 blue:222.0/255 alpha:1];
    
    self.username = [[UILabel alloc] initWithFrame:CGRectMake(10, 50, 320.0f, 30.0f)];
    self.username.text = self.usernameString;
    self.username.backgroundColor = [UIColor clearColor];
    self.username.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:self.username];
    
    self.password = [[UITextField alloc] initWithFrame:CGRectMake(60, 100.0, 234.0, 40.0)];
    self.password.borderStyle = UITextBorderStyleRoundedRect;
    self.password.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    self.password.placeholder = @"Password";
    self.password.secureTextEntry = YES;
    self.password.delegate = self;
    [self.view addSubview:self.password];
    
    self.deleteButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    self.deleteButton.frame= CGRectMake(60, 180.0, 234.0, 40.0);
    self.deleteButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
    self.deleteButton.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    [self.deleteButton setTitle:@"Delete User" forState:UIControlStateNormal];
    [self.deleteButton addTarget:self action:@selector(deleteButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview: self.deleteButton];
    
    self.feedback = [[UILabel alloc] initWithFrame:CGRectMake(10, 250, 320.0f, 30.0f)];
    self.feedback.text = @"";
    self.feedback.backgroundColor = [UIColor clearColor];
    self.feedback.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:self.feedback];
    
    /*
    self.deleteButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    self.deleteButton.frame= CGRectMake(60, 300.0, 234.0, 40.0);
    self.deleteButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
    self.deleteButton.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    [self.deleteButton setTitle:@"Delete User" forState:UIControlStateNormal];
    [self.deleteButton addTarget:self action:@selector(deleteButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview: self.deleteButton];
    */
    
    self.activityIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    self.activityIndicator.frame = CGRectMake(7, 7, 26, 26);
    self.activityIndicator.hidden = YES;
    [self.deleteButton addSubview:self.activityIndicator];
    
    self.confirmDeleteView = [[UIAlertView alloc] initWithTitle:@"" message:@"Are you sure you want to delete this user from this phone?" delegate:self cancelButtonTitle:@"Delete" otherButtonTitles:@"Cancel", nil];
    
    self.loginMessageView = [[UIAlertView alloc] initWithTitle:@"" message:@"Password is incorrect." delegate:self cancelButtonTitle:@"Ok" otherButtonTitles: nil];
    
    self.navigationItem.title = @"Delete User";
    UIBarButtonItem * tempButtonItem = [[ UIBarButtonItem alloc] init];
    tempButtonItem .title = @"Back";
    
    self.navigationItem.backBarButtonItem = tempButtonItem ;
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
    self.username.frame = CGRectMake(50, 20, 220.0, 35.0);
    self.feedback.frame = CGRectMake((parentWidth - 300)/2,  parentHeight/3.0 - (5 +17.5 + 10 + 35 + 10 + 35), 300.0, 35.0);
    //self.username.frame = CGRectMake(50,  parentHeight/3.0 - (5 +17.5 + 10 + 35), 220.0, 35.0);
    self.password.frame = CGRectMake(50, parentHeight/3.0 - (10+17.5 + 35), 220.0, 35.0);
    self.deleteButton.frame = CGRectMake(50, parentHeight/3.0 - 17.5, 220.0, 35.0);
    //self.activityIndicator.frame = CGRectMake(self.deleteButton.frame.origin.x + (self.deleteButton.frame.size.width - 30)/2, self.deleteButton.frame.origin.y, 30, 30);
    self.activityIndicator.frame = CGRectMake((self.activityIndicator.superview.bounds.size.width - 30)/2, (self.activityIndicator.superview.bounds.size.height - 30)/2, 30, 30);
    //self.deleteButton.frame =CGRectMake(50, parentHeight/3.0 * 2.0, 220, 35);
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)deleteButtonClicked:(id)sender
{
    ///NSLog(@"log in button clicked\n");
    //processing code with server
    
    if ([self.password.text length] < 5){
        self.loginMessageView.message = @"Password field must have at least 5 characters.";
        [self.loginMessageView show];
    } else {
        NSDictionary *params = [[NSMutableDictionary alloc] init];
        [params setValue:self.username.text forKey:@"username"];
        [params setValue:self.password.text forKey:@"password"];
        AFHTTPClient *client = [[AFHTTPClient alloc] initWithBaseURL: [NSURL URLWithString:SERVER_URL]];
        client.parameterEncoding = AFJSONParameterEncoding;
        ///NSLog(@"%@",params);
        NSMutableURLRequest *request = [client requestWithMethod:@"GET" path:@"/user/login" parameters:params];
        AFJSONRequestOperation *operation =[AFJSONRequestOperation JSONRequestOperationWithRequest:request success: ^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON){
            self.activityIndicator.hidden = YES;
            [self.activityIndicator stopAnimating];
            [self.deleteButton setTitle:@"Delete User" forState:UIControlStateNormal];
            NSDictionary * responseDictionary = JSON;
            ///NSLog(@"Response dictionary:%@\n", responseDictionary);
            NSString *result = [responseDictionary valueForKey:@"result"];
            if ([result isEqualToString:@"success"]){
                [self.confirmDeleteView show];
            } else {
                self.loginMessageView.message = @"Password is incorrect";
                //maybe user no longer exists?
                [self.loginMessageView show];
            }
        } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON){
            self.activityIndicator.hidden = YES;
            [self.activityIndicator stopAnimating];
            [self.deleteButton setTitle:@"Delete User" forState:UIControlStateNormal];
            self.loginMessageView.message = @"Cannot connect to server.";
            [self.loginMessageView show];
            ///NSLog(@"error opening connection");
        }];
        [self.deleteButton setTitle:@"" forState:UIControlStateNormal];
        self.activityIndicator.hidden = NO;
        [self.activityIndicator startAnimating];
        [operation start];
        //get out of modal
        //need to start update
        
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

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (alertView == self.confirmDeleteView) {
        if (buttonIndex == 0) {
            AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
            NSManagedObjectContext *ctx = [[NSManagedObjectContext alloc] init];
            [ctx setUndoManager:nil];
            [ctx setPersistentStoreCoordinator: [appDelegate persistentStoreCoordinator]];
            [self.databaseController deleteRegisteredUserWithUsername:self.usernameString WithContext:ctx];
            [self.navigationController popToRootViewControllerAnimated:NO];
        }
    }
}

@end
