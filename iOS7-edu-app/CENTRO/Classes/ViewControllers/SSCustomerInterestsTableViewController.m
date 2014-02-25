//
//  SSCustomerInterestsTableViewController.m
//  CENTRO
//
//  Created by Centro Community Partners.
//  Copyright (c) 2013 Centro Community Partners. All rights reserved.
//

#import "SSCustomerInterestsTableViewController.h"
#import "CustomerProfile.h"
#import "CustomerInterest.h"
#import "SSUser.h"
#import "SSUtils.h"

@interface SSCustomerInterestsTableViewController () <NSFetchedResultsControllerDelegate> {
    NSFetchedResultsController *_fetchedResultsController;
}

@property (nonatomic) int selectionCount;
@property (strong, nonatomic) NSArray *fetchedData;
@property (strong, nonatomic) NSManagedObjectContext *context;
@property (strong, nonatomic) CustomerProfile *profile;
@property BOOL isSure;
- (void)refetchData;

@end

@implementation SSCustomerInterestsTableViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {

    }
    return self;
}

- (void)refetchData {
    _fetchedResultsController.fetchRequest.resultType = NSManagedObjectResultType;
    [_fetchedResultsController performFetch:nil];
}

- (IBAction)nextButtonPressed:(id)sender {
    if (self.selectionCount > 0) {
        self.profile.isInterestSure = [NSNumber numberWithBool:self.isSure];
        [self.context save:nil];
        
        [self performSegueWithIdentifier:@"SelectCustomerBuyerLocations" sender:self];
    } else {
        [[[UIAlertView alloc] initWithTitle:@"Selection Error"
                                    message:@"You must select an interest."
                                   delegate:nil
                          cancelButtonTitle:@"OK"
                          otherButtonTitles:nil] show];
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    UIImageView *backgroundImageView40 = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"bg-568h@2x.png"]];
    UIImageView *backgroundImageView35R = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"bg@2x.png"]];
    
    CGRect screenBounds = [[UIScreen mainScreen] bounds];
    if (screenBounds.size.height == 568) {
        self.tableView.backgroundView = backgroundImageView40;
    } else {
        self.tableView.backgroundView = backgroundImageView35R;
    }
    self.tableView.backgroundView.contentMode = UIViewContentModeCenter;
    
    self.tableView.delegate = self;
    
    self.navigationItem.title = @"Interest";
    
    self.context = [(id)[[UIApplication sharedApplication] delegate] managedObjectContext];
    
    NSString *headerString = [NSString stringWithFormat:@"What do %@'s customers enjoy doing? (Select all that apply)", [SSUtils companyName]];

    UIView *header = [[UIView alloc] initWithFrame:CGRectMake(5, 0, self.tableView.frame.size.width-10, 50)];
    [header setBackgroundColor:[UIColor clearColor]];
    
    UILabel *headerLabel = [[UILabel alloc] initWithFrame:header.frame];
    
    headerLabel.numberOfLines = 4;
    headerLabel.lineBreakMode = NSLineBreakByWordWrapping;
    
    headerLabel.text = headerString;
    [headerLabel sizeToFit];
    [headerLabel setBackgroundColor:[UIColor clearColor]];
    
    [header addSubview:headerLabel];
    
    self.tableView.tableHeaderView = header;
}

-(void) viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    if(![[SSUser currentUser] isLoggedIn]) {
        [self.navigationController popToRootViewControllerAnimated:YES];
    } else {
        
        self.selectionCount = 0;
        
        NSFetchRequest *fetchRequest = [NSFetchRequest fetchRequestWithEntityName:@"CustomerInterest"];
        fetchRequest.sortDescriptors = [NSArray arrayWithObject:[NSSortDescriptor sortDescriptorWithKey:@"interestID" ascending:YES selector:nil]];
        fetchRequest.returnsObjectsAsFaults = NO;
        
        _fetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest managedObjectContext:self.context sectionNameKeyPath:nil cacheName:nil];
        _fetchedResultsController.delegate = self;
        [_fetchedResultsController performFetch:nil];
        
        self.fetchedData = [_fetchedResultsController fetchedObjects];
        
        for (int i = 0; i < self.fetchedData.count; i++) {
            CustomerInterest *temp = (CustomerInterest *) [self.fetchedData objectAtIndex:i];
            if([temp.selectedAsCustomerInterest intValue] == 1) {
                self.selectionCount++;
            }
        }
        
        NSFetchRequest *fetchRequestCP = [[NSFetchRequest alloc] init];
        
        NSEntityDescription *entityCP = [NSEntityDescription entityForName:@"CustomerProfile"
                                                    inManagedObjectContext:self.context];
        [fetchRequestCP setEntity:entityCP];
        
        [fetchRequestCP setPredicate:[NSPredicate predicateWithFormat:@"companyID = %@", [[SSUser currentUser] companyID]]];
        
        NSError *error;
        NSArray *fetchedObjectsCP = [self.context executeFetchRequest:fetchRequestCP error:&error];
        
        if (fetchedObjectsCP.count == 0) { 
            
        } else {
            self.profile = (CustomerProfile *) [fetchedObjectsCP objectAtIndex:0];
        }
        
        self.isSure = [self.profile.isInterestSure boolValue];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if(section == 0) {
        return [[[_fetchedResultsController sections] objectAtIndex:section] numberOfObjects];
    } else {
        return 1;
    }
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"CustomerInterest";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    cell.accessoryType = UITableViewCellAccessoryNone;
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        [cell setAccessoryType:UITableViewCellAccessoryNone];
        [cell setSelectionStyle:UITableViewCellSelectionStyleGray];
    }
    
    if (indexPath.section == 0) {
        CustomerInterest *temp = [_fetchedResultsController objectAtIndexPath:indexPath];
        cell.textLabel.text = temp.interestLiteralUS;
        
        if([temp.selectedAsCustomerInterest isEqualToNumber:[NSNumber numberWithBool:NO]]) {
            [cell setAccessoryType:UITableViewCellAccessoryNone];
        } else {
            [cell setAccessoryType:UITableViewCellAccessoryCheckmark];
        }
        
    } else {
        if(self.isSure) {
            cell.textLabel.text = @"☐ I'm not sure yet";
        } else {
            cell.textLabel.text = @"☑ I'm not sure yet";
        }
    }
    return cell;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        CustomerInterest *temp = [_fetchedResultsController objectAtIndexPath:indexPath];
        
        if([temp.selectedAsCustomerInterest isEqualToNumber:[NSNumber numberWithBool:NO]]) {
            [temp setSelectedAsCustomerInterest:[NSNumber numberWithBool:YES]];
            self.selectionCount++;
        } else {
            [temp setSelectedAsCustomerInterest:[NSNumber numberWithBool:NO]];
            self.selectionCount--;
        }
        
    } else {
        self.isSure = !self.isSure;
    }
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    [self.tableView reloadData];
    
}

#pragma mark - NSFetchedResultsControllerDelegate

- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller {
    [self.tableView reloadData];
}

@end
