//
//  SettingsViewController.h
//  AutoInsurance
//
//  Created by Spencer King on 3/7/13.
//  Copyright (c) 2013 Spencer King. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SettingsView.h"

@interface SettingsViewController : UIViewController

@property (atomic, strong) SettingsView *settingsView;

-(void) restoreToDefault;

@end
