//
//  SSActivitiesViewController.m
//  CENTRO
//
//  Created by Centro Community Partners.
//  Copyright (c) 2013 Centro Community Partners. All rights reserved.
//

#import "SSActivitiesViewController.h"
#import "SSUser.h"
#import "Activity.h"
#import "CENTROAPIClient.h"
#import "SSServerData.h"
#import "UIViewController+storyboard.h"

@interface SSActivitiesViewController () <NSFetchedResultsControllerDelegate> {
    NSFetchedResultsController *_fetchedResultsController;
}

//@property (nonatomic, retain) IBOutlet UINavigationBar *navButtonBar;

@property (strong, nonatomic) SSServerData *serverData;

- (void)refetchData;

@end

@implementation SSActivitiesViewController


- (void)refetchData {
    _fetchedResultsController.fetchRequest.resultType = NSManagedObjectResultType;
    [_fetchedResultsController performFetch:nil];
}

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    //[self setBackground];
    
    
    NSFetchRequest *fetchRequest = [NSFetchRequest fetchRequestWithEntityName:@"Activity"];
    fetchRequest.sortDescriptors = [NSArray arrayWithObject:[NSSortDescriptor sortDescriptorWithKey:@"turn" ascending:YES selector:nil]];
    fetchRequest.returnsObjectsAsFaults = NO;
    
    _fetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest managedObjectContext:[(id)[[UIApplication sharedApplication] delegate] managedObjectContext] sectionNameKeyPath:nil cacheName:nil];
    _fetchedResultsController.delegate = self;
    [_fetchedResultsController performFetch:nil];
    
    
    self.navigationItem.title = @"Activities";
}

- (IBAction)syncButtonPressed:(id)sender {
    
    if([[CENTROAPIClient sharedClient] networkIsReachable]) {
        [self.serverData pushAndShowHUDinViewController:self logOutAfter:NO];
    } else {
        [[[UIAlertView alloc] initWithTitle:@"Connection Error"
                                    message:@"Please check your internet connection and try again."
                                   delegate:nil
                          cancelButtonTitle:@"OK"
                          otherButtonTitles:nil] show];
    }
}




- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

-(void) viewDidAppear:(BOOL)animate {
    [super viewDidAppear:animate];
    [self.tableView reloadData];
    
    if([[CENTROAPIClient sharedClient] networkIsReachable] &&
       [[SSUser currentUser] isLoggedIn]) {
        self.syncButton.enabled = YES;
    } else {
        self.syncButton.enabled = NO;
    }
    
    if([[SSUser currentUser] listOfNotSyncedActivities].count == 0) {
        self.syncButton.enabled = NO;
    } else {
        self.syncButton.enabled = YES;
    }
    
    [self setBackground];
    
    
}

-(void) setBackground {
    if([[SSUser currentUser] isLoggedIn]) {
        UIImageView *backgroundImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"bg.png"]];
        
        self.tableView.backgroundView = backgroundImageView;
        
        self.tableView.backgroundView.contentMode = UIViewContentModeCenter;
    } else {
        UIImageView *backgroundImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"CentroWelcome.png"]];
        
        self.tableView.backgroundView = backgroundImageView;
        
        self.tableView.backgroundView.contentMode = UIViewContentModeCenter;
    }
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return [[_fetchedResultsController sections] count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    if(![[SSUser currentUser] isLoggedIn]) {
        return 0;
    } else {
        return [[[_fetchedResultsController sections] objectAtIndex:section] numberOfObjects];
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"ActivityCell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
        [cell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
        [cell setSelectionStyle:UITableViewCellSelectionStyleGray];
    }
    
    NSManagedObject *managedObject = [_fetchedResultsController objectAtIndexPath:indexPath];
    
    cell.textLabel.text = [managedObject valueForKey:@"name"];
    
    if(indexPath.row == 0) {
        cell.userInteractionEnabled = YES;
        cell.textLabel.enabled = YES;
    } else {
        NSIndexPath *previousIP = [NSIndexPath indexPathForRow:indexPath.row-1 inSection:indexPath.section];
        Activity *previousActivity = [_fetchedResultsController objectAtIndexPath:previousIP];
        if ([previousActivity completed] == nil) {
            cell.userInteractionEnabled = NO;
            cell.textLabel.enabled = NO;
        } else {
            cell.userInteractionEnabled = YES;
            cell.textLabel.enabled = YES;
        }
    }
    
    return cell;
}

#pragma mark - Table view delegate

#define FLIPHOZ 1 // UIModalTransitionStyleFlipHorizontal
#define COVERVERT 0 //UIModalTransitionStyleCoverVertical

//Storyboards
#define PERSONAL 1
#define VISION 2
#define MISSION 3
#define SHARED_VALUES 4
#define PERSONAL_COST 6
#define PERSONAL_INCOME 7
#define PERSONAL_ASSETS 9
#define PERSONAL_DEBTS 10
#define MARKET_ANALYSIS 12
#define CUSTOMER_INFO 13
#define COMPETITIVE_ANALYSIS 14
#define COMPANY_AND_PRODUCTS 15
#define PRICE_LIST 16
#define CUSTOMER_PREF 17
#define VALUE_PROPOSITION 18
#define OPERATING_HOURS 20
#define EMPLOYEES 21
#define EMPLOYEE_SALARY 22
#define RESPONSIBILITIES 23
#define EMPLOYEE_HOURS 24
#define BRAND 26
#define BUSINESS_COST 27
#define BUSINESS_INCOME 28
#define BUSINESS_ASSETS 30
#define BUSINESS_DEBTS 31


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    int segueNumber = indexPath.row + 1;
    NSLog(@"This is the assets segue number: %d ", segueNumber);
    
    
    
    if (segueNumber > 32 || segueNumber < 1) {
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
    } else {
        
        Activity *activityToPresent = [_fetchedResultsController objectAtIndexPath:indexPath];
        
        NSString *segueIdentifier = [NSString stringWithFormat:@"%d", segueNumber];
        NSLog(@"This is the activity showcompletedscreen: %@ ", activityToPresent.showCompletedScreen);
        NSLog(@"This is the activity completed field: %@ ", activityToPresent.completed);
        
        
        //if(activityToPresent.showCompletedScreen) {
        if(activityToPresent.completed) { //if activity shows a date completed, then segue is to a Completed VC on iPhone (main) storyboard
            
            NSString *completedSegueIdentifier;
            NSLog(@"In the first IF statement segue number: %d ", segueNumber);
            NSLog(@"In the first IF statement completed segue identifier: %@ ", completedSegueIdentifier);
            //if not activity summary statement add c to segue indentifier
            
            if (segueNumber == 5 || segueNumber == 8 || segueNumber == 11 || segueNumber == 19 || segueNumber == 25 || segueNumber == 29 || segueNumber == 32) {
                completedSegueIdentifier = segueIdentifier;
                //NSLog(@"This is the assets segue number for individual boards: %@ ", segueIdentifier);
                NSLog(@"In the second IF statement segue number: %d ", segueNumber);
                NSLog(@"In the second IF statement completed segue identifier: %@ ", completedSegueIdentifier);
                
            }
            else {
                completedSegueIdentifier = [NSString stringWithFormat: @"%@c", segueIdentifier];
                
                //NSLog(@"This is the assets segue number for not individual boards: %@ ", completedSegueIdentifier);
            }
            NSLog(@" Back in first IF/ELSE. This is the completed segue identifier: %@ ", completedSegueIdentifier);
            
            UIBarButtonItem *nextScreenBackButton = [[UIBarButtonItem alloc] initWithTitle:@"Activities" style:UIBarButtonItemStyleBordered target:self action:nil];
            self.navigationItem.backBarButtonItem = nextScreenBackButton;
            [self performSegueWithIdentifier:completedSegueIdentifier sender:self];
            
        } else { //else activity does not show a date completed, segue is to a new activity entry screen
            
            UIBarButtonItem *nextScreenBackButton = [[UIBarButtonItem alloc] initWithTitle:@"Activities" style:UIBarButtonItemStyleBordered target:self action:nil];
            self.navigationItem.backBarButtonItem = nextScreenBackButton;
            
            NSLog(@"This is the  segue number right before the case statement: %d ", segueNumber);
            switch (segueNumber) {
                case PERSONAL:
                    [self segueStoryboard:@"personal" fromVC:self Animation:YES Bundle:Nil useTransitionStyle: COVERVERT];
                    break;
                case VISION:
                    [self segueStoryboard:@"vision" fromVC:self Animation:YES Bundle:Nil useTransitionStyle: COVERVERT];
                    break;
                case MISSION:
                    [self segueStoryboard:@"mission" fromVC:self Animation:YES Bundle:Nil useTransitionStyle: COVERVERT];
                    break;
                case SHARED_VALUES:
                    [self segueStoryboard:@"shared_values" fromVC:self Animation:YES Bundle:Nil useTransitionStyle: COVERVERT];
                    break;
                case PERSONAL_COST:
                    [self segueStoryboard:@"personal_cost" fromVC:self Animation:YES Bundle:Nil useTransitionStyle: COVERVERT];
                    break;
                case PERSONAL_INCOME:
                    [self segueStoryboard:@"personal_income" fromVC:self Animation:YES Bundle:Nil useTransitionStyle: COVERVERT];
                    break;
                case PERSONAL_ASSETS:
                    [self segueStoryboard:@"personal_assets" fromVC:self Animation:YES Bundle:Nil useTransitionStyle: COVERVERT];
                    break;
                case PERSONAL_DEBTS:
                    [self segueStoryboard:@"personal_debts" fromVC:self Animation:YES Bundle:Nil useTransitionStyle: COVERVERT];
                    break;
                case MARKET_ANALYSIS:
                    [self segueStoryboard:@"industry" fromVC:self Animation:YES Bundle:Nil useTransitionStyle: COVERVERT];
                    break;
                case CUSTOMER_INFO:
                    [self segueStoryboard:@"customer_info" fromVC:self Animation:YES Bundle:Nil useTransitionStyle: COVERVERT];
                    break;
                case CUSTOMER_PREF:
                    [self segueStoryboard:@"customer_pref" fromVC:self Animation:YES Bundle:Nil useTransitionStyle: COVERVERT];
                    break;
                case COMPETITIVE_ANALYSIS:
                    [self segueStoryboard:@"competitors" fromVC:self Animation:YES Bundle:Nil useTransitionStyle: COVERVERT];
                    break;
                case COMPANY_AND_PRODUCTS:
                    [self segueStoryboard:@"company" fromVC:self Animation:YES Bundle:Nil useTransitionStyle: COVERVERT];
                    break;
                case PRICE_LIST:
                    [self segueStoryboard:@"price_list" fromVC:self Animation:YES Bundle:Nil useTransitionStyle: COVERVERT];
                    break;
                case VALUE_PROPOSITION:
                    [self segueStoryboard:@"value_proposition" fromVC:self Animation:YES Bundle:Nil useTransitionStyle: COVERVERT];
                    break;
                case OPERATING_HOURS:
                    [self segueStoryboard:@"operating_hours" fromVC:self Animation:YES Bundle:Nil useTransitionStyle: COVERVERT];
                    break;
                case EMPLOYEES:
                    [self segueStoryboard:@"employees" fromVC:self Animation:YES Bundle:Nil useTransitionStyle: COVERVERT];
                    break;
                case EMPLOYEE_SALARY:
                    [self segueStoryboard:@"employee_salary" fromVC:self Animation:YES Bundle:Nil useTransitionStyle: COVERVERT];
                    break;
                case RESPONSIBILITIES:
                    [self segueStoryboard:@"responsibilities" fromVC:self Animation:YES Bundle:Nil useTransitionStyle: COVERVERT];
                    break;
                case EMPLOYEE_HOURS:
                    [self segueStoryboard:@"employee_hours" fromVC:self Animation:YES Bundle:Nil useTransitionStyle: COVERVERT];
                    break;
                case BRAND:
                    [self segueStoryboard:@"brand" fromVC:self Animation:YES Bundle:Nil useTransitionStyle: COVERVERT];
                    break;
                case BUSINESS_COST:
                    [self segueStoryboard:@"business" fromVC:self Animation:YES Bundle:Nil useTransitionStyle: COVERVERT];
                    break;
                case BUSINESS_INCOME:
                    [self segueStoryboard:@"business_finance" fromVC:self Animation:YES Bundle:Nil useTransitionStyle: COVERVERT];
                    break;
                case BUSINESS_ASSETS:
                    [self segueStoryboard:@"business_assets" fromVC:self Animation:YES Bundle:Nil useTransitionStyle: COVERVERT];
                    break;
                case BUSINESS_DEBTS:
                    [self segueStoryboard:@"business_debts" fromVC:self Animation:YES Bundle:Nil useTransitionStyle: COVERVERT];
                    break;
                    
                    
                    //load single view storyboards
                default:
                    self.navigationItem.backBarButtonItem = nextScreenBackButton;
                    NSString *segueIdentifier = [NSString stringWithFormat:@"%d", segueNumber];
                    [self performSegueWithIdentifier:segueIdentifier sender:self];
                    break;
            }
        }
        
    }
}

#pragma mark - NSFetchedResultsControllerDelegate

- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller {
    [self.tableView reloadData];
}

#pragma mark - load profile view

-(void)loadProfile{
    
    [self segueStoryboard:@"profile" fromVC:self Animation:YES Bundle:Nil useTransitionStyle: COVERVERT];
    
}

@end
