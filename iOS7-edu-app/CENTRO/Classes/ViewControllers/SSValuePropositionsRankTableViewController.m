//
//  SSValuePropositionsRankTableViewController.m
//  CENTRO
//
//  Created by Centro Community Partners.
//  Copyright (c) 2013 Centro Community Partners. All rights reserved.
//

#import "SSValuePropositionsRankTableViewController.h"
#import "ValueProposition.h"
#import "SSUser.h"
#import "SSCompetitiveAdvantageRankCell.h"
#import "SSEditCompetitiveAdvantageRankTableViewController.h"
#import "SSUtils.h"

@interface SSValuePropositionsRankTableViewController () <NSFetchedResultsControllerDelegate> {
    NSFetchedResultsController *_fetchedResultsController;
}

@property (strong, nonatomic) NSManagedObjectContext *context;
@property int priorityToEditRank;

- (void)refetchData;

@end

@implementation SSValuePropositionsRankTableViewController

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


- (IBAction)doneButtonPressed:(id)sender {
    [self.context save:nil];
    [[SSUser currentUser] setActivityNumberAsCompleted:@"18" andSyncStatus:NO];
    [self.navigationController popToRootViewControllerAnimated:YES];
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
    
    self.navigationItem.title = @"Rank";
    
    self.titleLabel.text = [NSString stringWithFormat:@"Well done! Here is how %@ ranks compared to its competitors.", [SSUtils companyName]];
    
    self.context = [(id)[[UIApplication sharedApplication] delegate] managedObjectContext];
}

-(void) viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    if(![[SSUser currentUser] isLoggedIn]) {
        [self.navigationController popToRootViewControllerAnimated:YES];
    } else {

        NSFetchRequest *fetchRequest = [NSFetchRequest fetchRequestWithEntityName:@"ValueProposition"];
        [fetchRequest setPredicate:[NSPredicate predicateWithFormat:@"name != %@", @""]];
        fetchRequest.sortDescriptors = [NSArray arrayWithObject:[NSSortDescriptor sortDescriptorWithKey:@"valuePropositionID" ascending:YES selector:nil]];
        fetchRequest.returnsObjectsAsFaults = NO;
        
        _fetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest managedObjectContext:self.context sectionNameKeyPath:nil cacheName:nil];
        _fetchedResultsController.delegate = self;
        [_fetchedResultsController performFetch:nil];
      
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [[[_fetchedResultsController sections] objectAtIndex:section] numberOfObjects];
}

- (SSCompetitiveAdvantageRankCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"ValuePropositionRankCell";
    SSCompetitiveAdvantageRankCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    if (cell == nil) {
        cell = [[SSCompetitiveAdvantageRankCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    [cell setAccessoryType:UITableViewCellAccessoryNone];
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    cell.delegate = self;
    
    ValueProposition *temp = [_fetchedResultsController objectAtIndexPath:indexPath];
    
    cell.competitorNameLabel.text = temp.name;
    
    [cell.priceRankButton setTitle:[temp.priceRank stringValue] forState:UIControlStateNormal];
    [cell.customerServiceButton setTitle:[temp.customerServiceRank stringValue] forState:UIControlStateNormal];
    [cell.qualityRankButton setTitle:[temp.qualityRank stringValue] forState:UIControlStateNormal];
    [cell.locationRankButton setTitle:[temp.locationRank stringValue] forState:UIControlStateNormal];
    [cell.speedButton setTitle:[temp.speedRank stringValue] forState:UIControlStateNormal];
    
    return cell;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
}

#pragma mark - NSFetchedResultsControllerDelegate

- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller {
    [self.tableView reloadData];
}

#pragma mark - SSCompetitorRankCellDelegate

-(void) priceRankEditModeWillBegin {
    self.priorityToEditRank = 1;
    [self performSegueWithIdentifier:@"EditValuePropositionRank" sender:self];
}

-(void) customerServiceRankEditModeWillBegin {
    self.priorityToEditRank = 2;
    [self performSegueWithIdentifier:@"EditValuePropositionRank" sender:self];
}

-(void) qualityRankEditModeWillBegin {
    self.priorityToEditRank = 3;
    [self performSegueWithIdentifier:@"EditValuePropositionRank" sender:self];
}

-(void) locationRankEditModeWillBegin {
    self.priorityToEditRank = 4;
    [self performSegueWithIdentifier:@"EditValuePropositionRank" sender:self];
}

-(void) speedRankEditModeWillBegin {
    self.priorityToEditRank = 5;
    [self performSegueWithIdentifier:@"EditValuePropositionRank" sender:self];
}

-(void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if([segue.identifier isEqualToString:@"EditValuePropositionRank"]) {
        SSEditCompetitiveAdvantageRankTableViewController *editCompetitiveAdvantageRankTableViewController = (SSEditCompetitiveAdvantageRankTableViewController *) segue.destinationViewController;
        
        [editCompetitiveAdvantageRankTableViewController setPriority:self.priorityToEditRank];
        
        UIBarButtonItem *nextScreenBackButton = [[UIBarButtonItem alloc] initWithTitle:@"Cancel" style:UIBarButtonItemStyleBordered target:self action:nil];
        self.navigationItem.backBarButtonItem = nextScreenBackButton;
    }
}

-(IBAction)dismissVC{
    [self dismissViewControllerAnimated:YES completion:NULL];
}

@end