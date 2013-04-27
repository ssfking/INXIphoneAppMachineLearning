//
//  SettingsView.h
//  AutoInsurance
//
//  Created by Spencer King on 3/7/13.
//  Copyright (c) 2013 Spencer King. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SettingsView : UIView

-(void) resetFrame:(CGRect)rect;
@property (atomic, strong) UILabel *username;
@property (atomic, strong) UILabel *usernameLabel;
@property (atomic, strong) UIButton * logOutButton;

-(void) restoreToDefault;
@end
