//
//  SSCompletedBusinessIncomeTableViewController.m
//  CENTRO
//
//  Created by Centro Community Partners.
//  Copyright (c) 2013 Centro Community Partners. All rights reserved.
//

#import "SSCompletedBusinessIncomeTableViewController.h"
#import "SSUser.h"
#import "Product.h"
#import "Company.h"

@interface SSCompletedBusinessIncomeTableViewController () <NSFetchedResultsControllerDelegate> {
    NSFetchedResultsController *_fetchedResultsController;
}
- (void)refetchData;

@property (strong, nonatomic) NSManagedObjectContext *context;
@property (strong, nonatomic) NSIndexPath *otherIndexPath;
@property (strong, nonatomic) Company *company;

@end

@implementation SSCompletedBusinessIncomeTableViewController

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
    [[SSUser currentUser] setActivityNumberAsIncompleted:@"28"];
    
    UIStoryboard *profileStoryBoard = [UIStoryboard storyboardWithName: @"business_finance" bundle:Nil];
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
    
    self.navigationItem.title = @"Bus. Income";
    
    self.context = [(id)[[UIApplication sharedApplication] delegate] managedObjectContext];
    
    self.tryAgainButton.title = @"Try Again!";
    
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
    static NSString *CellIdentifier = @"CompletedBusinessIncomeCell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
        [cell setAccessoryType:UITableViewCellAccessoryNone];
        [cell setSelectionStyle:UITableViewCellSelectionStyleGray];
    }
    
    if(![indexPath isEqual:self.otherIndexPath]) {
        
        NSManagedObject *managedObject = [_fetchedResultsController objectAtIndexPath:indexPath];
        cell.textLabel.text = [managedObject valueForKey:@"name"];
        
        double doubleAmount = [self monthlyAmountWithFrequency:[managedObject valueForKey:@"profitFrequency"] andAmount:[managedObject valueForKey:@"profitAmount"]];
        
        NSString *detailAmount = [@"US$ " stringByAppendingString:[NSString stringWithFormat:@"%.2f", doubleAmount]];
        
        cell.detailTextLabel.text = [detailAmount stringByReplacingOccurrencesOfString:@".00" withString:@""];
    } else if ([indexPath isEqual:self.otherIndexPath]) {
        cell.textLabel.text = @"Other";
        
        double monthlyAmount = [self monthlyAmountWithFrequency:[self.company otherProfitFrequency] andAmount:self.company.otherProfitAmount];
        
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
    }

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