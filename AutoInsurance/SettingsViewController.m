//
//  SettingsViewController.m
//  AutoInsurance
//
//  Created by Spencer King on 3/7/13.
//  Copyright (c) 2013 Spencer King. All rights reserved.
//

#import "SettingsViewController.h"

@interface SettingsViewController ()

@end

@implementation SettingsViewController

- (void)loadView
{
    
    ///NSLog(@"SettingsViewController LoadView");
    //UIView *contentView = [[HelloView alloc] initWithFrame:[[UIScreen mainScreen] applicationFrame]];
    
	self.settingsView = [[SettingsView alloc] init];
	
	self.view = self.settingsView;
	
    self.navigationItem.title = @"Settings";
    UIBarButtonItem * tempButtonItem = [[ UIBarButtonItem alloc] init];
    tempButtonItem .title = @"Back";
    self.navigationItem.backBarButtonItem = tempButtonItem ;
}

- (void)viewWillAppear:(BOOL)animated {
    ///NSLog(@"SettingsView will appear....\n");
    [self.settingsView resetFrame:self.view.bounds];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void) restoreToDefault {
    [self.settingsView restoreToDefault];
}

@end
