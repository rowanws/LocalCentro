//
//  SSBusinessIncomeTableViewController.m
//  CENTRO
//
//  Created by Centro Community Partners.
//  Copyright (c) 2013 Centro Community Partners. All rights reserved.
//

#import "SSBusinessIncomeTableViewController.h"
#import "SSAddEditBusinessIncomeViewController.h"
#import "SSUser.h"
#import "Product.h"
#import "Company.h"

@interface SSBusinessIncomeTableViewController () <NSFetchedResultsControllerDelegate> {
    NSFetchedResultsController *_fetchedResultsController;
}
- (void)refetchData;

@property (strong, nonatomic) NSManagedObjectContext *context;
@property (strong, nonatomic) NSIndexPath *addItemIndexPath;
@property (strong, nonatomic) NSIndexPath *otherIndexPath;
@property (strong, nonatomic) Company *company;

@end

@implementation SSBusinessIncomeTableViewController

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
    
    self.navigationItem.title = @"Business Income";
    
    self.context = [(id)[[UIApplication sharedApplication] delegate] managedObjectContext];
    
    UIBarButtonItem *nextScreenBackButton = [[UIBarButtonItem alloc] initWithTitle:@"Try Again" style:UIBarButtonItemStyleBordered target:self action:nil];
    self.navigationItem.backBarButtonItem = nextScreenBackButton;
    
}
- (IBAction)doneBarButtonPressed:(id)sender {
    
    [self.context save:nil];

    [[SSUser currentUser] setActivityNumberAsCompleted:@"28" andSyncStatus:NO];
        
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
    
    
    NSFetchRequest *fetchRequest = [NSFetchRequest fetchRequestWithEntityName:@"Product"];
    [fetchRequest setPredicate:[NSPredicate predicateWithFormat:@"companyID = %@ AND selectedAsProfitableItem = 1 AND name != %@", [[SSUser currentUser] companyID], @""]];
    fetchRequest.sortDescriptors = [NSArray arrayWithObject:[NSSortDescriptor sortDescriptorWithKey:@"monthlyProfitAmount" ascending:NO selector:nil]];
    fetchRequest.returnsObjectsAsFaults = NO;
    
    _fetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest managedObjectContext:self.context sectionNameKeyPath:nil cacheName:nil];
    _fetchedResultsController.delegate = self;
    [_fetchedResultsController performFetch:nil];
    
    int numberOfObjects = [[[_fetchedResultsController sections] objectAtIndex:0] numberOfObjects];
    
    self.otherIndexPath = [NSIndexPath indexPathForRow:numberOfObjects inSection:0];
    self.addItemIndexPath = [NSIndexPath indexPathForRow:numberOfObjects+1 inSection:0];
    
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
    if ([[[_fetchedResultsController sections] objectAtIndex:section] numberOfObjects] == [self totalItems]) {
        self.addItemIndexPath = nil;
        return [[[_fetchedResultsController sections] objectAtIndex:section] numberOfObjects] + 1;
    } else {
        return [[[_fetchedResultsController sections] objectAtIndex:section] numberOfObjects] + 2;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"BusinessIncomeCell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
        [cell setAccessoryType:UITableViewCellAccessoryNone];
        [cell setSelectionStyle:UITableViewCellSelectionStyleGray];
    }
    
    if(![indexPath isEqual:self.addItemIndexPath] && ![indexPath isEqual:self.otherIndexPath]) {
        
        NSManagedObject *managedObject = [_fetchedResultsController objectAtIndexPath:indexPath];
        cell.textLabel.text = [managedObject valueForKey:@"name"];
        
        double doubleAmount = [[managedObject valueForKey:@"monthlyProfitAmount"] doubleValue];
        
        NSString *detailAmount = [@"US$ " stringByAppendingString:[NSString stringWithFormat:@"%.2f", doubleAmount]];
        
        cell.detailTextLabel.text = [detailAmount stringByReplacingOccurrencesOfString:@".00" withString:@""];
    } else if ([indexPath isEqual:self.otherIndexPath]) {
        cell.textLabel.text = @"Other";
        
        double monthlyAmount = 0.0;
        
        if([[self.company otherProfitFrequency] isEqual:[NSNumber numberWithInt:1]]) {
            monthlyAmount = [self.company.otherProfitAmount doubleValue] * 30;
        } else if([[self.company otherProfitFrequency] isEqual:[NSNumber numberWithInt:2]]) {
            monthlyAmount = [self.company.otherProfitAmount doubleValue] * 4;
        } else if([[self.company otherProfitFrequency] isEqual:[NSNumber numberWithInt:4]]) {
            monthlyAmount = [self.company.otherProfitAmount doubleValue] / 12;
        } else {
            monthlyAmount = [self.company.otherProfitAmount doubleValue];
        }
        
         NSString *detailAmount = [NSString stringWithFormat:@"US$ %.2f", monthlyAmount];

        cell.detailTextLabel.text = [detailAmount stringByReplacingOccurrencesOfString:@".00" withString:@""];
    } else if ([indexPath isEqual:self.addItemIndexPath]) {
        cell.textLabel.text = @"Add new item...";
        cell.detailTextLabel.text = @"";
    }
    
    
    
    return cell;
    
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(![indexPath isEqual:self.addItemIndexPath] && ![indexPath isEqual:self.otherIndexPath]) {
        [self performSegueWithIdentifier:@"EditBusinessIncome" sender:(Product *) [_fetchedResultsController objectAtIndexPath:indexPath]];
    } else if([indexPath isEqual:self.addItemIndexPath]) {
        [self performSegueWithIdentifier:@"AddBusinessIncome" sender:self];
    } else {
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
        [self.navigationController popViewControllerAnimated:YES];
    }
    
}

-(void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    UIBarButtonItem *nextScreenBackButton = [[UIBarButtonItem alloc] initWithTitle:@"Back" style:UIBarButtonItemStyleBordered target:self action:nil];
    self.navigationItem.backBarButtonItem = nextScreenBackButton;
    
    if([segue.identifier isEqualToString:@"EditBusinessIncome"]) {
        SSAddEditBusinessIncomeViewController *addEditBusinessIncomeViewController = (SSAddEditBusinessIncomeViewController *) segue.destinationViewController;
        [addEditBusinessIncomeViewController setItem:(Product *) sender];
        [addEditBusinessIncomeViewController setEditingExistingIncome:YES];
    }
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath {
    return UITableViewCellEditingStyleNone;
}

#pragma mark - NSFetchedResultsControllerDelegate

- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller {
    [self.tableView reloadData];
}

- (int) totalItems {
    
    int total = 0;
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Product"
                                              inManagedObjectContext:self.context];
    
    [fetchRequest setEntity:entity];
    
    [fetchRequest setPredicate:[NSPredicate predicateWithFormat:@"companyID = %@ AND name != %@ and selectedAsProfitableItem = 1", [[SSUser currentUser] companyID], @""]];
    
    fetchRequest.sortDescriptors = [NSArray arrayWithObject:[NSSortDescriptor sortDescriptorWithKey:@"productID" ascending:YES selector:nil]];
    
    NSError *error;
    NSArray *items = [self.context executeFetchRequest:fetchRequest error:&error];
    
    if (items.count == 0) {
        total = 0;
    } else {
        total = items.count;
    }
    
    return total;
}

@end