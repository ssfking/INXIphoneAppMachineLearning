//
//  CreateNewUserViewController.h
//  AutoInsurance
//
//  Created by Spencer King on 3/4/13.
//  Copyright (c) 2013 Spencer King. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CreateNewUserViewController : UIViewController <UITextFieldDelegate, UIAlertViewDelegate>

@property (atomic, strong) UITextField * username;
@property (atomic, strong) UITextField * password;
@property (atomic, strong) UIButton * createNewUserButton;
@property (atomic, strong) UILabel * feedback;
@property (atomic, strong) UIAlertView *createUserMessageView;
@property (atomic, strong) UIActivityIndicatorView *activityIndicator;
@end
