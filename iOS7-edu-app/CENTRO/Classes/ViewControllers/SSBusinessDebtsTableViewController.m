//
//  SSBusinessDebtsTableViewController.m
//  CENTRO
//
//  Created by Centro Community Partners.
//  Copyright (c) 2013 Centro Community Partners. All rights reserved.
//

#import "SSBusinessDebtsTableViewController.h"
#import "SSAddEditBusinessDebtsViewController.h"
#import "SSUser.h"
#import "CompanyDebt.h"

@interface SSBusinessDebtsTableViewController () <NSFetchedResultsControllerDelegate> {
    NSFetchedResultsController *_fetchedResultsController;
}
- (void)refetchData;

@property (strong, nonatomic) NSManagedObjectContext *context;
@property (strong, nonatomic) NSIndexPath *addItemIndexPath;

@property BOOL doneButtonPressed;

@end

@implementation SSBusinessDebtsTableViewController

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

    
    //UIImageView *backgroundImageView40 = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"bg-568h@2x.png"]];
    //UIImageView *backgroundImageView35R = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"bg@2x.png"]];
    
    //CGRect screenBounds = [[UIScreen mainScreen] bounds];
    //if (screenBounds.size.height == 568) {
    //    self.tableView.backgroundView = backgroundImageView40;
    //} else {
    //    self.tableView.backgroundView = backgroundImageView35R;
    //}
    self.tableView.backgroundView.contentMode = UIViewContentModeCenter;
    
    self.tableView.delegate = self;
    
    self.navigationItem.title = @"Business Debts";
    
    self.context = [(id)[[UIApplication sharedApplication] delegate] managedObjectContext];
    
    UIBarButtonItem *nextScreenBackButton = [[UIBarButtonItem alloc] initWithTitle:@"Try Again" style:UIBarButtonItemStyleBordered target:self action:nil];
    self.navigationItem.backBarButtonItem = nextScreenBackButton;
    
}

- (IBAction)doneBarButtonPressed:(id)sender {
    
    [self.context save:nil];
    
    self.doneButtonPressed = YES;
    
    [[SSUser currentUser] setActivityNumberAsCompleted:@"31" andSyncStatus:NO];
        
    [self.navigationController popToRootViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

-(void) viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    if(![[SSUser currentUser] isLoggedIn]) {
        [self.navigationController popToRootViewControllerAnimated:YES];
    }
    
    
    NSFetchRequest *fetchRequest = [NSFetchRequest fetchRequestWithEntityName:@"CompanyDebt"];
    [fetchRequest setPredicate:[NSPredicate predicateWithFormat:@"selectedAsDebt = 1"]];
    fetchRequest.sortDescriptors = [NSArray arrayWithObject:[NSSortDescriptor sortDescriptorWithKey:@"amount" ascending:NO selector:nil]];
    fetchRequest.returnsObjectsAsFaults = NO;
    
    _fetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest managedObjectContext:self.context sectionNameKeyPath:nil cacheName:nil];
    _fetchedResultsController.delegate = self;
    [_fetchedResultsController performFetch:nil];
    
    
    self.addItemIndexPath = [NSIndexPath indexPathForRow:[[[_fetchedResultsController sections] objectAtIndex:0] numberOfObjects] inSection:0];

    [self.tableView reloadData];
    [self.tableView setEditing:YES animated:YES];
    
    self.doneButtonPressed = NO;
    
}

-(void) viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    NSArray *viewControllers = self.navigationController.viewControllers;
    if (viewControllers.count > 1 && [viewControllers objectAtIndex:viewControllers.count-2] == self) {
    } else if ([viewControllers indexOfObject:self] == NSNotFound) {
        @try {
            if(self.popToRoot && !self.doneButtonPressed) {
                [[SSUser currentUser] setSegueToPerform:@"31"];
                [self.navigationController popToRootViewControllerAnimated:NO];
                [self.navigationController.navigationBar popNavigationItemAnimated:NO];
            }
        }
        @catch (NSException *exception) {
            
        }
        @finally {
            
        }
    } else {
        
    }
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [[_fetchedResultsController sections] count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if ([[[_fetchedResultsController sections] objectAtIndex:section] numberOfObjects] == [self totalDebtsCategories]) {
        self.addItemIndexPath = nil;
        return [[[_fetchedResultsController sections] objectAtIndex:section] numberOfObjects];
    } else {
        return [[[_fetchedResultsController sections] objectAtIndex:section] numberOfObjects] + 1;
    }
    
}

- (int) totalDebtsCategories {
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"CompanyDebt"
                                              inManagedObjectContext:self.context];
    
    [fetchRequest setEntity:entity];
    
    [fetchRequest setPredicate:[NSPredicate predicateWithFormat:@"companyID = %@", [[SSUser currentUser] companyID]]];
    
    fetchRequest.sortDescriptors = [NSArray arrayWithObject:[NSSortDescriptor sortDescriptorWithKey:@"companyDebtID" ascending:YES selector:nil]];
    
    NSError *error;
    NSArray *fetchedObjects = [self.context executeFetchRequest:fetchRequest error:&error];
    
    return fetchedObjects.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"BusinessDebts";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
        [cell setAccessoryType:UITableViewCellAccessoryNone];
        [cell setSelectionStyle:UITableViewCellSelectionStyleGray];
    }
    
    if(![indexPath isEqual:self.addItemIndexPath]) {
        
        NSManagedObject *managedObject = [_fetchedResultsController objectAtIndexPath:indexPath];
        cell.textLabel.text = [managedObject valueForKey:@"companyDebtLiteralUS"];
        
        double doubleAmount = [[managedObject valueForKey:@"amount"] doubleValue];
        
        NSString *detailAmount = [@"US$ " stringByAppendingString:[NSString stringWithFormat:@"%.2f", doubleAmount]];
        
        cell.detailTextLabel.text = [detailAmount stringByReplacingOccurrencesOfString:@".00" withString:@""];
    } else {
        cell.textLabel.text = @"Add new item...";
        cell.detailTextLabel.text = @"";
    }
    
    
    
    return cell;
    
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(![indexPath isEqual:self.addItemIndexPath]) {
        [self performSegueWithIdentifier:@"EditBusinessDebt" sender:(CompanyDebt *) [_fetchedResultsController objectAtIndexPath:indexPath]];
    } else {
        [self performSegueWithIdentifier:@"AddBusinessDebt" sender:self];
    }
    
}

-(void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    UIBarButtonItem *nextScreenBackButton = [[UIBarButtonItem alloc] initWithTitle:@"Back" style:UIBarButtonItemStyleBordered target:self action:nil];
    self.navigationItem.backBarButtonItem = nextScreenBackButton;
    
    if([segue.identifier isEqualToString:@"EditBusinessDebt"]) {
        SSAddEditBusinessDebtsViewController *addEditBusinessDebtsViewController = (SSAddEditBusinessDebtsViewController *) segue.destinationViewController;
        [addEditBusinessDebtsViewController setCompanyDebt:(CompanyDebt *) sender];
        [addEditBusinessDebtsViewController setEditingExistingDebt:YES];
    }
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath {
    return UITableViewCellEditingStyleNone;
}

#pragma mark - NSFetchedResultsControllerDelegate

- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller {
    [self.tableView reloadData];
}

@end