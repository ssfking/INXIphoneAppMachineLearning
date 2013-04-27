//
//  SignalStrengthView.h
//  AutoInsurance
//
//  Created by Spencer King on 3/6/13.
//  Copyright (c) 2013 Spencer King. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SignalStrengthView : UIView

//@property (atomic) int signalStrength;
@property (atomic, strong) UILabel *noSignal;

-(void) resetFrame:(CGRect)rect;
+(void) setGlobalSignalStrength:(int) strength;
+(int) getGlobalSignalStrength;
@end
