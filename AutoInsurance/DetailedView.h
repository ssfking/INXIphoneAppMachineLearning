//
//  DetailedView.h
//  AutoInsurance
//
//  Created by Spencer King on 2/21/13.
//  Copyright (c) 2013 Spencer King. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BeepView.h"
#import "SignalStrengthView.h"

@interface DetailedView : UIView

//@property (atomic, strong) UIView *mainView;
@property (atomic,strong) UILabel *latitude;
@property (atomic,strong) UILabel *longitude;
@property (atomic, strong) UILabel *altitude;
@property (atomic, strong) UILabel *speed;
@property (atomic, strong) UILabel *calculatedSpeed;
@property (atomic, strong) UILabel *horizontalAccuracy;
@property (atomic, strong) UILabel *verticalAccuracy;
@property (atomic, strong) UILabel *accelerationX;
@property (atomic, strong) UILabel *accelerationY;
@property (atomic, strong) UILabel *accelerationSum;

@property (atomic,strong) UILabel *latitudeLabel;
@property (atomic,strong) UILabel *longitudeLabel;
@property (atomic, strong) UILabel *altitudeLabel;
@property (atomic, strong) UILabel *speedLabel;
@property (atomic, strong) UILabel *calculatedSpeedLabel;
@property (atomic, strong) UILabel *horizontalAccuracyLabel;
@property (atomic, strong) UILabel *verticalAccuracyLabel;
@property (atomic, strong) UILabel *accelerationXLabel;
@property (atomic, strong) UILabel *accelerationYLabel;
@property (atomic, strong) UILabel *accelerationSumLabel;

@property (atomic, strong) UILabel *username;
@property (atomic, strong) SignalStrengthView *signalStrengthView;
@property (atomic, strong) BeepView *beepView;
@property (atomic, strong) UILabel *signalStrength;

//-(void)buttonClicked:(id)sender;
-(void) resetFrame:(CGRect)rect;
-(void) restoreToDefault;
@end
