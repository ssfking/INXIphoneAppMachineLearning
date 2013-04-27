//
//  UserViewController.h
//  AutoInsurance
//
//  Created by Spencer King on 3/4/13.
//  Copyright (c) 2013 Spencer King. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DatabaseController.h"

@interface UserViewController : UIViewController <UITextFieldDelegate, UIAlertViewDelegate>

@property (atomic, strong) NSString *usernameString;
@property (atomic, strong) UILabel *username;
@property (atomic, strong) UITextField * password;
@property (atomic, strong) UIButton * logInButton;
//@property (atomic, strong) UIButton * deleteButton;
@property (atomic, strong) UILabel * feedback;
@property (atomic, strong) DatabaseController *databaseController;
//@property (atomic, strong) UIAlertView *confirmDeleteView;
@property (atomic, strong) UIAlertView *loginMessageView;
@property (atomic, strong) UIActivityIndicatorView *activityIndicator;
@end
