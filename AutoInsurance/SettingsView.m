//
//  SettingsView.m
//  AutoInsurance
//
//  Created by Spencer King on 3/7/13.
//  Copyright (c) 2013 Spencer King. All rights reserved.
//

#import "SettingsView.h"
#import "AppDelegate.h"

@interface SettingsView ()

- (void) signOutButtonClicked:(id)sender;

@end

@implementation SettingsView

@synthesize username = _username;
@synthesize logOutButton = _logOutButton;
@synthesize usernameLabel = _usernameLabel;


- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.username = [[UILabel alloc] initWithFrame:CGRectMake(10, 280, 320.0f, 30.0f)];
		self.username.text = @"";
		self.username.backgroundColor = [UIColor clearColor];
		self.username.textAlignment = NSTextAlignmentRight;
        [self.username setFont:[UIFont fontWithName:@"Helvetica" size:15.0]];
		[self addSubview:self.username];
        
        self.usernameLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 280, 320.0f, 30.0f)];
		self.usernameLabel.text = @"Username";
		self.usernameLabel.backgroundColor = [UIColor clearColor];
		self.usernameLabel.textAlignment = NSTextAlignmentLeft;
        [self.usernameLabel setFont:[UIFont fontWithName:@"Helvetica-Bold" size:15.0]];
		[self addSubview:self.usernameLabel];
        
        
        UIImage *blueImage = [UIImage imageNamed:@"blueButton.png"];
        UIImage *blueButtonImage = [blueImage stretchableImageWithLeftCapWidth:12 topCapHeight:0];
        //[myButton setBackgroundImage:blueButtonImage forState:UIControlStateHighlighted];
        
        self.logOutButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        self.logOutButton.frame= CGRectMake(60, 300.0, 234.0, 40.0);
        self.logOutButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
        self.logOutButton.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
        [self.logOutButton setTitle:@"Sign out" forState:UIControlStateNormal];
        [self.logOutButton setBackgroundImage:blueButtonImage forState:UIControlStateNormal];
        [self.logOutButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        
        //self.logOutButton.backgroundColor = [UIColor redColor];
        [self.logOutButton addTarget:self action:@selector(signOutButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview: self.logOutButton];
        [self restoreToDefault];
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

-(void) resetFrame:(CGRect)rect {
    self.frame = rect;
    CGFloat mainHeight = self.bounds.size.height;
    CGFloat mainWidth = self.bounds.size.width;
    self.logOutButton.frame = CGRectMake(10, mainHeight - 60, mainWidth - 20, 40);
    
    self.usernameLabel.frame = CGRectMake(40, 40, mainWidth/2.0 - 40, 30);
    self.username.frame = CGRectMake(mainWidth/2+10, 40, mainWidth/2.0 - 50, 30);
    NSLog(@"username: %@ length:%i\n",self.username.text, self.username.text.length);
    if (self.username.text.length <= 0) {
        NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
        NSString * username = [prefs stringForKey:@"username"];
        ///NSLog(@"username is %@", username);
        if (username != nil) {
            self.username.text = username;
        } else {
            self.username.text = @"";
        }
    }

    
}

- (void) signOutButtonClicked:(id)sender {
    AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    [appDelegate logOut];
    
}

-(void) restoreToDefault {
    self.username.text = @"";
}

@end
