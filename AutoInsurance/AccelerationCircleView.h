//
//  AccelerationCircleView.h
//  AutoInsurance
//
//  Created by Spencer King on 3/6/13.
//  Copyright (c) 2013 Spencer King. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AccelerationCircleView : UIView

-(void) setNewAccelerationWithX:(double) x Y:(double) y;
-(void) resetFrame:(CGRect)rect;
@end
