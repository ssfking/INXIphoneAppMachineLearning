//
//  UsersViewController.m
//  AutoInsurance
//
//  Created by Spencer King on 3/4/13.
//  Copyright (c) 2013 Spencer King. All rights reserved.
//

#import "UsersViewController.h"
//#import "LogInSignUpViewController.h"
#import "AddUserViewController.h"
#import "UserViewController.h"
#import "AppDelegate.h"
#import "AddExistingUserViewController.h"
#import "CreateNewUserViewController.h"

@interface UsersViewController ()

-(void) addItem: (id) paramSender;
-(NSArray *) getAllRegisteredUsernames;
@end

@implementation UsersViewController

//@synthesize usersTableViewController = _usersTableViewController;
@synthesize usersTableView = _usersTableView;
@synthesize databaseController = _databaseController;
@synthesize content = _content;
@synthesize indices = _indices;
@synthesize noUserLabel = _noUserLabel;
@synthesize addUserActionSheet = _addUserActionSheet;

- (void)loadView {
    
    /*
    self.usersTableViewController = [[UsersTableViewController alloc] init];
    self.usersTableViewController.tableView.frame = CGRectMake(0, 0, 0, 0);
    */
    self.view = [[UIView alloc] init];
    self.usersTableView = [[UITableView alloc] init];
    self.usersTableView.delegate = self;
    self.usersTableView.dataSource = self;
    [self.view addSubview: self.usersTableView];
    
    self.noUserLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 30, 300.0f, 30.0f)];
    self.noUserLabel.text = @"No user registered";
    self.noUserLabel.backgroundColor = [UIColor clearColor];
    self.noUserLabel.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:self.noUserLabel];
    
    //UIBarButtonItem *addButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(addItem:)];
    
    UIBarButtonItem *addButton = [[UIBarButtonItem alloc] initWithTitle:@"Add" style:UIBarButtonItemStylePlain target:self action:@selector(addItem:)];
    
    
    self.addUserActionSheet = [[UIActionSheet alloc] initWithTitle:@"" delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"Add Existing User", @"Create New User", nil];
    
    self.navigationItem.rightBarButtonItems =
    [NSArray arrayWithObjects:addButton, nil];
    
    self.navigationItem.title = @"Users";
    UIBarButtonItem * tempButtonItem = [[ UIBarButtonItem alloc] init];
    tempButtonItem .title = @"Back";
    self.navigationItem.backBarButtonItem = tempButtonItem ;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    /*
    self.content = [self getAllRegisteredUsernames];
    self.indices = [self.content valueForKey:@"headerTitle"];
    */
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewWillAppear:(BOOL)animated {
    self.usersTableView.frame = self.view.bounds;
    //self.noUserLabel.frame = self.view.bounds;
    self.content = [self getAllRegisteredUsernames];
    self.indices = [self.content valueForKey:@"headerTitle"];
    
    if ([self.content count] <= 0 ){
        self.usersTableView.hidden = YES;
        self.noUserLabel.hidden = NO;
    } else {
        self.noUserLabel.hidden = YES;
        [self.usersTableView reloadData];
        self.usersTableView.hidden = NO;
    }
}

-(void) addItem: (id) paramSender {
    //AddUserViewController * nextController = [[AddUserViewController alloc] init];
    [self.addUserActionSheet showFromBarButtonItem:paramSender animated:YES];
    
    //[self.navigationController pushViewController:nextController animated:NO];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return [self.content count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return [[[self.content objectAtIndex:section] objectForKey:@"rowValues"] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    cell.textLabel.text = [[[self.content objectAtIndex:indexPath.section] objectForKey:@"rowValues"] objectAtIndex:indexPath.row];
    
    return cell;
}

- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView {
    return self.indices;
}

- (NSInteger)tableView:(UITableView *)tableView sectionForSectionIndexTitle:(NSString *)title atIndex:(NSInteger)index {
    return [self.indices indexOfObject:title];
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    return [[self.content objectAtIndex:section] objectForKey:@"headerTitle"];
}
/*
 // Override to support conditional editing of the table view.
 - (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
 {
 // Return NO if you do not want the specified item to be editable.
 return YES;
 }
 */

/*
 // Override to support editing the table view.
 - (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
 {
 if (editingStyle == UITableViewCellEditingStyleDelete) {
 // Delete the row from the data source
 [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
 }
 else if (editingStyle == UITableViewCellEditingStyleInsert) {
 // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
 }
 }
 */

/*
 // Override to support rearranging the table view.
 - (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
 {
 }
 */

/*
 // Override to support conditional rearranging of the table view.
 - (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
 {
 // Return NO if you do not want the item to be re-orderable.
 return YES;
 }
 */

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Navigation logic may go here. Create and push another view controller.
    /*
     <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:@"<#Nib name#>" bundle:nil];
     // ...
     // Pass the selected object to the new view controller.
     [self.navigationController pushViewController:detailViewController animated:YES];
     */
    UserViewController *userViewController = [[UserViewController alloc] init];
    userViewController.usernameString =[[[self.content objectAtIndex:indexPath.section] objectForKey:@"rowValues"] objectAtIndex:indexPath.row];
    userViewController.databaseController = self.databaseController;
    [self.navigationController pushViewController:userViewController animated:NO];
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
     NSString *choice = [actionSheet buttonTitleAtIndex:buttonIndex];
    if ([choice isEqualToString:@"Add Existing User"]) {
        AddExistingUserViewController *addExistingUserViewController = [[AddExistingUserViewController alloc] init];
        //    logInViewController.root = self.delegate;
        [self.navigationController pushViewController: addExistingUserViewController animated:NO];
    }
    else if ([choice isEqualToString:@"Create New User"]) {
        CreateNewUserViewController *createNewUserViewController = [[CreateNewUserViewController alloc] init];
        //    signUpViewController.root = self.delegate;
        [self.navigationController pushViewController:createNewUserViewController animated:NO];
    }
}

- (NSArray *) getAllRegisteredUsernames {
    AppDelegate *appdelegate = [[UIApplication sharedApplication] delegate];
    
    NSManagedObjectContext *ctx = [[NSManagedObjectContext alloc] init];
    [ctx setUndoManager:nil];
    [ctx setPersistentStoreCoordinator: [appdelegate persistentStoreCoordinator]];
    NSArray *results = [self.databaseController findRegisteredUsersWithContext:ctx];
    ///NSLog(@"results:%@\n",results);
    NSMutableArray *content = [[NSMutableArray alloc] init];
    
    NSString *lastChar = nil;
    NSMutableDictionary *curDict = nil;
    NSMutableArray *curArr = nil;
    for (NSString *username in results) {
        NSString *prefix = [username substringToIndex:1];
        if (lastChar == nil || [lastChar caseInsensitiveCompare:prefix] != NSOrderedSame) {
            lastChar = [prefix uppercaseString];
            curDict = [[NSMutableDictionary alloc] init];
            [curDict setValue:lastChar forKey:@"headerTitle"];
            curArr = [[NSMutableArray alloc] init];
            [curDict setValue:curArr forKey:@"rowValues"];
            [content addObject:curDict];
        }
        [curArr addObject:username];
    }
    return content;
}



@end
