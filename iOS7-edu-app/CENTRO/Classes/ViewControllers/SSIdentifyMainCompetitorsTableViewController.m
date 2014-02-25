//
//  SSIdentifyMainCompetitorsTableViewController.m
//  CENTRO
//
//  Created by Centro Community Partners.
//  Copyright (c) 2013 Centro Community Partners. All rights reserved.
//

#import "SSIdentifyMainCompetitorsTableViewController.h"
#import "CompetitorProfile.h"
#import "SSUser.h"
#import "SSAddDeleteCompetitorViewController.h"
#import "SSUtils.h"

@interface SSIdentifyMainCompetitorsTableViewController () <NSFetchedResultsControllerDelegate> {
    NSFetchedResultsController *_fetchedResultsController;
}

@property (strong, nonatomic) NSArray *fetchedData;
@property (strong, nonatomic) NSManagedObjectContext *context;
@property (strong, nonatomic) NSIndexPath *selectedIndexPath;

@property int numberOfCompetitors;

- (void)refetchData;

@end

@implementation SSIdentifyMainCompetitorsTableViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {

    }
    return self;
}

- (IBAction)nextButtonPressed:(id)sender {
    if (self.numberOfCompetitors == 4) {
        [self.context save:nil];
        [self performSegueWithIdentifier:@"CompetitorsTargetCustomers" sender:self];
    } else {
        [[[UIAlertView alloc] initWithTitle:@"Selection Error"
                                    message:@"You must select 4 Competitors."
                                    //message:@"You must select at least 3 Competitors."
                                   delegate:nil
                          cancelButtonTitle:@"OK"
                          otherButtonTitles:nil] show];
    }
    
}

- (void)refetchData {
    _fetchedResultsController.fetchRequest.resultType = NSManagedObjectResultType;
    [_fetchedResultsController performFetch:nil];
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
   // }
    self.tableView.backgroundView.contentMode = UIViewContentModeCenter;
    
    self.tableView.delegate = self;
    
    self.navigationItem.title = @"Competitors";
    
    self.context = [(id)[[UIApplication sharedApplication] delegate] managedObjectContext];
    
}

- (UIView *) tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    NSString *headerString;
    
    if (section == 0) {
        headerString = [NSString stringWithFormat:@"Who are %@'s main competitors? (add 4)", [SSUtils companyName]];
    } else {
        return nil;
    }
    
    UILabel *headerLabel = [[UILabel alloc] init];
    
    headerLabel.numberOfLines = 0;
    headerLabel.lineBreakMode = NSLineBreakByWordWrapping;
    
    headerLabel.text = headerString;
    [headerLabel sizeToFit];
    [headerLabel setBackgroundColor:[UIColor clearColor]];
    
    
    
    return headerLabel;
}

-(void) viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    if(![[SSUser currentUser] isLoggedIn]) {
        [self.navigationController popToRootViewControllerAnimated:YES];
    } else {
        
        NSFetchRequest *fetchRequest = [NSFetchRequest fetchRequestWithEntityName:@"CompetitorProfile"];
        fetchRequest.sortDescriptors = [NSArray arrayWithObject:[NSSortDescriptor sortDescriptorWithKey:@"competitorProfileID" ascending:YES selector:nil]];
        fetchRequest.returnsObjectsAsFaults = NO;
        
        _fetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest managedObjectContext:self.context sectionNameKeyPath:nil cacheName:nil];
        _fetchedResultsController.delegate = self;
        [_fetchedResultsController performFetch:nil];
        
        self.fetchedData = [_fetchedResultsController fetchedObjects];
        
        self.numberOfCompetitors = 0;
        
        [self.tableView reloadData];
    }
}

-(void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if([segue.identifier isEqualToString:@"AddDeleteCompetitor"]) {
        SSAddDeleteCompetitorViewController *addDeleteCompetitorViewController = (SSAddDeleteCompetitorViewController *) segue.destinationViewController;
        
        CompetitorProfile *cp = [_fetchedResultsController objectAtIndexPath:self.selectedIndexPath];
        
        [addDeleteCompetitorViewController setCompetitorProfileID:cp.competitorProfileID];
        if([cp.name isEqualToString:@""]) {
            [addDeleteCompetitorViewController setAdd:YES];
        } else {
            [addDeleteCompetitorViewController setAdd:NO];
        }
        
        UIBarButtonItem *nextScreenBackButton = [[UIBarButtonItem alloc] initWithTitle:@"Cancel" style:UIBarButtonItemStyleBordered target:self action:nil];
        self.navigationItem.backBarButtonItem = nextScreenBackButton;
    } else {
        UIBarButtonItem *nextScreenBackButton = [[UIBarButtonItem alloc] initWithTitle:@"Competitors" style:UIBarButtonItemStyleBordered target:self action:nil];
        self.navigationItem.backBarButtonItem = nextScreenBackButton;
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
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
    static NSString *CellIdentifier = @"CompetitorCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;

    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        [cell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
        [cell setSelectionStyle:UITableViewCellSelectionStyleGray];
    }
    
    CompetitorProfile *tempCompetitorProfile = [_fetchedResultsController objectAtIndexPath:indexPath];
    
    if([tempCompetitorProfile.name isEqualToString:@""]) {
        cell.textLabel.text = @"Add Competitor...";
    } else {
        cell.textLabel.text = tempCompetitorProfile.name;
        self.numberOfCompetitors++;
    }
    
    return cell;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    self.selectedIndexPath = indexPath;
    [self performSegueWithIdentifier:@"AddDeleteCompetitor" sender:self];
}

#pragma mark - NSFetchedResultsControllerDelegate

- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller {
    [self.tableView reloadData];
}

@end