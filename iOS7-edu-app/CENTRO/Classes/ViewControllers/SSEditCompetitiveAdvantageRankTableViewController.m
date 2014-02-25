//
//  SSEditCompetitiveAdvantageRankTableViewController.m
//  CENTRO
//
//  Created by Centro Community Partners.
//  Copyright (c) 2013 Centro Community Partners. All rights reserved.
//

#import "SSEditCompetitiveAdvantageRankTableViewController.h"
#import "ValueProposition.h"
#import "SSUser.h"

@interface SSEditCompetitiveAdvantageRankTableViewController () <NSFetchedResultsControllerDelegate> {
    NSFetchedResultsController *_fetchedResultsController;
}
- (void)refetchData;

@property (strong, nonatomic) NSManagedObjectContext *context;
@property (strong, nonatomic) NSMutableArray *valuePropositions;
@property BOOL looksGoodPressed;

@end

@implementation SSEditCompetitiveAdvantageRankTableViewController

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
    
    self.doneButton.title = @"Okay!";
    
    self.context = [(id)[[UIApplication sharedApplication] delegate] managedObjectContext];
    
    
    NSFetchRequest *fetchRequest = [NSFetchRequest fetchRequestWithEntityName:@"ValueProposition"];
    [fetchRequest setPredicate:[NSPredicate predicateWithFormat:@"name != %@", @""]];
    
    
    if(self.priority == 1) {
        fetchRequest.sortDescriptors = [NSArray arrayWithObject:[NSSortDescriptor sortDescriptorWithKey:@"priceRank" ascending:YES selector:nil]];
        self.navigationItem.title = @"Price Rank";
    } else if (self.priority == 2) {
        fetchRequest.sortDescriptors = [NSArray arrayWithObject:[NSSortDescriptor sortDescriptorWithKey:@"customerServiceRank" ascending:YES selector:nil]];
        self.navigationItem.title = @"Service Rank";
    } else if (self.priority == 3) {
        fetchRequest.sortDescriptors = [NSArray arrayWithObject:[NSSortDescriptor sortDescriptorWithKey:@"qualityRank" ascending:YES selector:nil]];
        self.navigationItem.title = @"Quality Rank";
    } else if (self.priority == 4) {
        fetchRequest.sortDescriptors = [NSArray arrayWithObject:[NSSortDescriptor sortDescriptorWithKey:@"locationRank" ascending:YES selector:nil]];
        self.navigationItem.title = @"Location Rank";
    } else if (self.priority == 5) {
        fetchRequest.sortDescriptors = [NSArray arrayWithObject:[NSSortDescriptor sortDescriptorWithKey:@"speedRank" ascending:YES selector:nil]];
        self.navigationItem.title = @"Speed Rank";
    }
    
    fetchRequest.returnsObjectsAsFaults = NO;
    
    _fetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest managedObjectContext:self.context sectionNameKeyPath:nil cacheName:nil];
    _fetchedResultsController.delegate = self;
    [_fetchedResultsController performFetch:nil];
    
        
    self.looksGoodPressed = NO;
}

- (IBAction)doneButtonPressed:(id)sender {

    self.looksGoodPressed = YES;
    [self.context save:nil];
    [self.navigationController popViewControllerAnimated:NO];
    [self.navigationController.navigationBar popNavigationItemAnimated:NO];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    NSArray *viewControllers = self.navigationController.viewControllers;
    if (viewControllers.count > 1 && [viewControllers objectAtIndex:viewControllers.count-2] == self) {
        
    } else if ([viewControllers indexOfObject:self] == NSNotFound && !self.looksGoodPressed) {
        [self.context reset];
    } else {
        
    }
}

-(void) viewWillAppear:(BOOL)animate {
    [super viewWillAppear:animate];
    
    if(![[SSUser currentUser] isLoggedIn]) {
        [self.navigationController popViewControllerAnimated:NO];
        [self.navigationController.navigationBar popNavigationItemAnimated:NO];
    } else {
        [self.tableView reloadData];
        [self.tableView setEditing:YES animated:YES];
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
    static NSString *CellIdentifier = @"EditValueProposition";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
        [cell setAccessoryType:UITableViewCellAccessoryNone];
        [cell setSelectionStyle:UITableViewCellSelectionStyleGray];
    }
    
    NSManagedObject *managedObject = [_fetchedResultsController objectAtIndexPath:indexPath];
    
    NSString *pos = @"";
    
    if(self.priority == 1) {
        pos = [managedObject valueForKey:@"priceRank"];
    } else if (self.priority == 2) {
        pos = [managedObject valueForKey:@"customerServiceRank"];
    } else if (self.priority == 3) {
        pos = [managedObject valueForKey:@"qualityRank"];
    } else if (self.priority == 4) {
        pos = [managedObject valueForKey:@"locationRank"];
    } else if (self.priority == 5) {
        pos = [managedObject valueForKey:@"speedRank"];
    }
    
    NSString *value = [managedObject valueForKey:@"name"];
    cell.textLabel.text = [NSString stringWithFormat:@"%@. %@", pos, value];

    return cell;
}


- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{

    return YES;
}


- (void)tableView:(UITableView *)tableView
moveRowAtIndexPath:(NSIndexPath *)sourceIndexPath
      toIndexPath:(NSIndexPath *)destinationIndexPath;
{
    self.valuePropositions = [[_fetchedResultsController fetchedObjects] mutableCopy];
    
    
    NSManagedObject *valueProposition = [_fetchedResultsController objectAtIndexPath:sourceIndexPath];
    
    
    [self.valuePropositions removeObject:valueProposition];
    
    [self.valuePropositions insertObject:valueProposition atIndex:[destinationIndexPath row]];
    
    
    int i = 1;
    for (NSManagedObject *mo in self.valuePropositions)
    {
        if(self.priority == 1) {
            [mo setValue:[NSNumber numberWithInt:i++] forKey:@"priceRank"];
        } else if (self.priority == 2) {
            [mo setValue:[NSNumber numberWithInt:i++] forKey:@"customerServiceRank"];
        } else if (self.priority == 3) {
            [mo setValue:[NSNumber numberWithInt:i++] forKey:@"qualityRank"];
        } else if (self.priority == 4) {
            [mo setValue:[NSNumber numberWithInt:i++] forKey:@"locationRank"];
        } else if (self.priority == 5) {
            [mo setValue:[NSNumber numberWithInt:i++] forKey:@"speedRank"];
        }
    }
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

-(void) dealloc {
    _fetchedResultsController = nil;
    self.context = nil;
    self.valuePropositions = nil;
}

@end