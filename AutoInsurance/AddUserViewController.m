//
//  AddUserViewController.m
//  AutoInsurance
//
//  Created by Spencer King on 3/4/13.
//  Copyright (c) 2013 Spencer King. All rights reserved.
//

#import "AddUserViewController.h"
#import "AddExistingUserViewController.h"
#import "CreateNewUserViewController.h"

@interface AddUserViewController ()

@end

@implementation AddUserViewController

@synthesize createNewUserButton = _createNewUserButton;
@synthesize addExistingUserButton = _addExistingUserButton;

- (void)loadView
{
    
    self.view = [[UIView alloc] init];
    self.view.backgroundColor = [UIColor colorWithRed:176.0/255 green:196.0/255 blue:222.0/255 alpha:1];
    self.addExistingUserButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    self.addExistingUserButton.frame= CGRectMake(50, (self.view.frame.size.height/2.0) - 30, 220.0, 35.0);
    self.addExistingUserButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
    self.addExistingUserButton.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    [self.addExistingUserButton setTitle:@"Add Existing User" forState:UIControlStateNormal];
    [self.addExistingUserButton addTarget:self action:@selector(addExistingUserButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview: self.addExistingUserButton];
    
    self.createNewUserButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    self.createNewUserButton.frame= CGRectMake(50, (self.view.frame.size.height/2.0) + 30, 220.0, 35.0);
    self.createNewUserButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
    self.createNewUserButton.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    [self.createNewUserButton setTitle:@"Create New User" forState:UIControlStateNormal];
    [self.createNewUserButton addTarget:self action:@selector(createNewUserButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview: self.createNewUserButton];
    self.navigationItem.title = @"Add User";
    UIBarButtonItem * tempButtonItem = [[ UIBarButtonItem alloc] init];
    tempButtonItem .title = @"Back";
    
    self.navigationItem.backBarButtonItem = tempButtonItem ;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)viewWillAppear:(BOOL)animated {
    self.addExistingUserButton.frame= CGRectMake(50, (self.view.frame.size.height/2.0) - 45, 220.0, 35.0);
    self.createNewUserButton.frame= CGRectMake(50, (self.view.frame.size.height/2.0) + 10, 220.0, 35.0);
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)addExistingUserButtonClicked:(id)sender
{
    ///NSLog(@"Add Existing User clicked\n");
    AddExistingUserViewController *addExistingUserViewController = [[AddExistingUserViewController alloc] init];
    //    logInViewController.root = self.delegate;
	[self.navigationController pushViewController: addExistingUserViewController animated:NO];
}

-(void)createNewUserButtonClicked:(id)sender
{
    ///NSLog(@"Create New User clicked\n");
    CreateNewUserViewController *createNewUserViewController = [[CreateNewUserViewController alloc] init];
    //    signUpViewController.root = self.delegate;
    [self.navigationController pushViewController:createNewUserViewController animated:NO];
}
@end

