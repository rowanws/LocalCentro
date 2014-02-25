//
//  SSHRCostsTableViewController.m
//  CENTRO
//
//  Created by Centro Community Partners.
//  Copyright (c) 2013 Centro Community Partners. All rights reserved.
//

#import "SSHRCostsTableViewController.h"
#import "SSUser.h"
#import "Employee.h"
#import "Company.h"
#import "SSUtils.h"

@interface SSHRCostsTableViewController () <NSFetchedResultsControllerDelegate> {
    NSFetchedResultsController *_fetchedResultsController;
}
- (void)refetchData;

@property (strong, nonatomic) NSManagedObjectContext *context;
@property (strong, nonatomic) NSIndexPath *benefitsIndexPath;
@property (strong, nonatomic) Company *company;

@end

@implementation SSHRCostsTableViewController

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
    
    self.navigationItem.title = @"HR Costs";
    
    self.titleLabel.text = [NSString stringWithFormat:@"Well done! Here are %@'s annual HR costs.", [SSUtils companyName]];
    
    self.context = [(id)[[UIApplication sharedApplication] delegate] managedObjectContext];
    
    UIBarButtonItem *nextScreenBackButton = [[UIBarButtonItem alloc] initWithTitle:@"Try Again" style:UIBarButtonItemStyleBordered target:self action:nil];
    self.navigationItem.backBarButtonItem = nextScreenBackButton;
    
}

- (IBAction)doneBarButtonPressed:(id)sender {
    
    [self.context save:nil];

    [[SSUser currentUser] setActivityNumberAsCompleted:@"22" andSyncStatus:NO];
        
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
    
    
    NSFetchRequest *fetchRequest = [NSFetchRequest fetchRequestWithEntityName:@"Employee"];
    [fetchRequest setPredicate:[NSPredicate predicateWithFormat:@"companyID = %@ AND selectedAsEmployee = 1", [[SSUser currentUser] companyID]]];
    fetchRequest.sortDescriptors = [NSArray arrayWithObject:[NSSortDescriptor sortDescriptorWithKey:@"manager" ascending:NO selector:nil]];
    fetchRequest.returnsObjectsAsFaults = NO;
    
    _fetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest managedObjectContext:self.context sectionNameKeyPath:nil cacheName:nil];
    _fetchedResultsController.delegate = self;
    [_fetchedResultsController performFetch:nil];
    
    int numberOfObjects = [[[_fetchedResultsController sections] objectAtIndex:0] numberOfObjects];
    
    self.benefitsIndexPath = [NSIndexPath indexPathForRow:numberOfObjects inSection:0];
    
    [self.tableView reloadData];
    [self.tableView setEditing:YES animated:YES];
    
    NSFetchRequest *companyFetchRequest = [[NSFetchRequest alloc] init];
    
    NSEntityDescription *companyEntity = [NSEntityDescription entityForName:@"Company"
                                                     inManagedObjectContext:self.context];
    [companyFetchRequest setEntity:companyEntity];
    
    [companyFetchRequest setPredicate:[NSPredicate predicateWithFormat:@"companyID = %@", [[SSUser currentUser] companyID]]];
    
    companyFetchRequest.returnsObjectsAsFaults = NO;
    
    NSError *errorC;
    NSArray *companyFetchedObjects = [self.context executeFetchRequest:companyFetchRequest error:&errorC];
    if (companyFetchedObjects == 0) {
        
    } else {
        self.company = (Company *) [companyFetchedObjects objectAtIndex:0];
    }
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [[_fetchedResultsController sections] count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [[[_fetchedResultsController sections] objectAtIndex:section] numberOfObjects] + 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"HRCostCell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
        [cell setAccessoryType:UITableViewCellAccessoryNone];
        [cell setSelectionStyle:UITableViewCellSelectionStyleGray];
    }
    
    if(![indexPath isEqual:self.benefitsIndexPath]) {
        Employee *emp = (Employee *)[_fetchedResultsController objectAtIndexPath:indexPath];
        
        cell.textLabel.text = [emp name];
        cell.detailTextLabel.text = [self returnYearlyValueForAmount:[emp earning] frequency:[emp earningFrequency] andWorkingWeeks:[emp weeksWork]];
    } else if ([indexPath isEqual:self.benefitsIndexPath]) {
        cell.textLabel.text = @"Employee Benefits";
        cell.detailTextLabel.text = [self returnYearlyValueForAmount:[self.company totalEmployeeBenefitsCosts] frequency:[self.company frequencyEmployeeBenefits] andWorkingWeeks:[NSNumber numberWithInt:0]];
    }

    return cell;
}

-(NSString *) returnYearlyValueForAmount:(NSNumber *) amount frequency:(NSNumber *) frequency andWorkingWeeks:(NSNumber *) weeks{
    NSString *value = @"";
    
    double proratedAmount = 0.0;
    
    if ([frequency isEqualToNumber:[NSNumber numberWithInt:2]]) {
        double numberOfWeeks = [weeks doubleValue];
        double amountPerWeek = [amount doubleValue];
        
        proratedAmount = numberOfWeeks * amountPerWeek;
    } else if([frequency isEqualToNumber:[NSNumber numberWithInt:3]]) {
        double amountPerMonth = [amount doubleValue];
        
        proratedAmount = amountPerMonth * 12.00;
    } else if ([frequency isEqualToNumber:[NSNumber numberWithInt:4]]) {
        proratedAmount = [amount doubleValue];
    }

    value = [NSString stringWithFormat:@"US$ %.2f", proratedAmount];
    value = [value stringByReplacingOccurrencesOfString:@".00" withString:@""];
    
    return value;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath {
    return UITableViewCellEditingStyleNone;
}

#pragma mark - NSFetchedResultsControllerDelegate

- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller {
    [self.tableView reloadData];
}

@end