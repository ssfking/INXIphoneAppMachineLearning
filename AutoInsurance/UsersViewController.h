//
//  UsersViewController.h
//  AutoInsurance
//
//  Created by Spencer King on 3/4/13.
//  Copyright (c) 2013 Spencer King. All rights reserved.
//

#import <UIKit/UIKit.h>
//#import "UsersTableViewController.h"
#import "DatabaseController.h"

@interface UsersViewController : UIViewController <UITableViewDataSource, UITableViewDelegate, UIActionSheetDelegate>

//@property (atomic,strong) UsersTableViewController *usersTableViewController;
@property (atomic, strong) UITableView *usersTableView;
@property (atomic, strong) DatabaseController *databaseController;
@property (atomic, strong) NSArray *content;
@property (atomic, strong) NSArray *indices;
@property (atomic, strong) UILabel *noUserLabel;
@property (atomic, strong) UIActionSheet *addUserActionSheet;
@end
