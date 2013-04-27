//
//  OverviewView.h
//  AutoInsurance
//
//  Created by Spencer King on 3/6/13.
//  Copyright (c) 2013 Spencer King. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SignalStrengthView.h"
#import "BeepView.h"
#import "AccelerationCircleView.h"
#import "CoreMotionController.h"

@interface OverviewView : UIView

@property (atomic, strong) UIView *mainView;
//@property (atomic, strong) UILabel *username;

//@property (atomic, strong) UIButton *calibrateButton;
@property (atomic, strong) UILabel *speedLabel;
@property (atomic, strong) UILabel *speed;
@property (atomic, strong) UILabel *speedUnit;
@property (atomic, strong) UILabel *accelerationLabel;
@property (atomic, strong) AccelerationCircleView *accelerationCircleView;
@property (atomic, strong) UILabel *acceleration;
@property (atomic, strong) UILabel *accelerationUnit;
@property (atomic, strong) SignalStrengthView *signalStrengthView;
@property (atomic, strong) BeepView *beepView;
@property (atomic, strong) UILabel *signalStrength;
@property (atomic, strong) CoreMotionController *coreMotionController;
-(void) resetFrame:(CGRect)rect;
-(void) newSpeed: (NSString *) speed;
-(void) newAcceleration: (NSString *) acceleration;
-(void) restoreToDefault;

@end
