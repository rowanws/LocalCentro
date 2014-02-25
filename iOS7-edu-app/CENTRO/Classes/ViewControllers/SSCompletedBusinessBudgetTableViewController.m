//
//  SSCompletedBusinessBudgetTableViewController.m
//  CENTRO
//
//  Created by Centro Community Partners.
//  Copyright (c) 2013 Centro Community Partners. All rights reserved.
//

#import "SSCompletedBusinessBudgetTableViewController.h"
#import "SSUser.h"

@interface SSCompletedBusinessBudgetTableViewController () <NSFetchedResultsControllerDelegate> {
    NSFetchedResultsController *_fetchedResultsController;
}
- (void)refetchData;

@property (strong, nonatomic) NSManagedObjectContext *context;

@end

@implementation SSCompletedBusinessBudgetTableViewController

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

- (IBAction)tryAgainButtonPressed:(id)sender {
    [[SSUser currentUser] setActivityNumberAsIncompleted:@"27"];
    
    UIStoryboard *profileStoryBoard = [UIStoryboard storyboardWithName: @"business" bundle:Nil];
    UIViewController *initProfileView = [profileStoryBoard instantiateInitialViewController];
    initProfileView.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
    //[VC presentViewController:initProfileView animated: animation completion: NULL];
    
    [self.navigationController pushViewController:initProfileView animated:YES];
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
    
    self.tryAgainButton.title = @"Try Again!";
    
    self.navigationItem.title = @"Bus. Costs";
        
    self.context = [(id)[[UIApplication sharedApplication] delegate] managedObjectContext];
    
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
    
    
    NSFetchRequest *fetchRequest = [NSFetchRequest fetchRequestWithEntityName:@"CompanyCost"];
    [fetchRequest setPredicate:[NSPredicate predicateWithFormat:@"selectedAsIncurredCost = 1"]];
    fetchRequest.sortDescriptors = [NSArray arrayWithObject:[NSSortDescriptor sortDescriptorWithKey:@"monthlyAmount" ascending:NO selector:nil]];
    fetchRequest.returnsObjectsAsFaults = NO;
    
    _fetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest managedObjectContext:self.context sectionNameKeyPath:nil cacheName:nil];
    _fetchedResultsController.delegate = self;
    [_fetchedResultsController performFetch:nil];
    
    
    [self.tableView reloadData];
    [self.tableView setEditing:YES animated:YES];
    
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [[_fetchedResultsController sections] count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [[[_fetchedResultsController sections] objectAtIndex:section] numberOfObjects];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"CompletedCompanyCosts";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
        [cell setAccessoryType:UITableViewCellAccessoryNone];
        [cell setSelectionStyle:UITableViewCellSelectionStyleGray];
    }
    
    NSManagedObject *managedObject = [_fetchedResultsController objectAtIndexPath:indexPath];
    cell.textLabel.text = [managedObject valueForKey:@"companyCostLiteralUS"];
    
    double doubleAmount = [self monthlyAmountWithFrequency:[managedObject valueForKey:@"frequency"] andAmount:[managedObject valueForKey:@"amount"]];
    
    NSString *detailAmount = [@"US$ " stringByAppendingString:[NSString stringWithFormat:@"%.2f", doubleAmount]];
    
    cell.detailTextLabel.text = [detailAmount stringByReplacingOccurrencesOfString:@".00" withString:@""];
    
    return cell;
    
}

-(double) monthlyAmountWithFrequency:(NSNumber *) frequency andAmount:(NSNumber *) amount {
    double monthlyAmount = 0.0;
    if([frequency isEqual:[NSNumber numberWithInt:1]]) {
        monthlyAmount = [amount doubleValue] * 30;
    } else if([frequency isEqual:[NSNumber numberWithInt:2]]) {
        monthlyAmount = [amount doubleValue] * 4;
    } else if([frequency isEqual:[NSNumber numberWithInt:4]]) {
        monthlyAmount = [amount doubleValue] / 12;
    } else {
        monthlyAmount = [amount doubleValue];
    }
    
    return monthlyAmount;
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