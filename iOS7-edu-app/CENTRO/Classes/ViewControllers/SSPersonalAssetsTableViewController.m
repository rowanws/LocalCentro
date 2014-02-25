//
//  SSPersonalAssetsTableViewController.m
//  CENTRO
//
//  Created by Centro Community Partners.
//  Copyright (c) 2013 Centro Community Partners. All rights reserved.
//

#import "SSPersonalAssetsTableViewController.h"
#import "SSAddEditPersonalAssetsViewController.h"
#import "SSUser.h"

@interface SSPersonalAssetsTableViewController () <NSFetchedResultsControllerDelegate> {
    NSFetchedResultsController *_fetchedResultsController;
}
- (void)refetchData;

@property (strong, nonatomic) NSManagedObjectContext *context;
@property (strong, nonatomic) NSIndexPath *addItemIndexPath;

@property BOOL doneButtonPressed;

@end

@implementation SSPersonalAssetsTableViewController

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
    
    self.navigationItem.title = @"Personal Assets";
    
    self.context = [(id)[[UIApplication sharedApplication] delegate] managedObjectContext];
    
    UIBarButtonItem *nextScreenBackButton = [[UIBarButtonItem alloc] initWithTitle:@"Try Again" style:UIBarButtonItemStyleBordered target:self action:nil];
    self.navigationItem.backBarButtonItem = nextScreenBackButton;
    
}
- (IBAction)doneBarButtonPressed:(id)sender {
    
    [self.context save:nil];
    
    self.doneButtonPressed = YES;
    
    [[SSUser currentUser] setActivityNumberAsCompleted:@"9" andSyncStatus:NO];
        
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
    
    
    NSFetchRequest *fetchRequest = [NSFetchRequest fetchRequestWithEntityName:@"StudentAsset"];
    [fetchRequest setPredicate:[NSPredicate predicateWithFormat:@"selectedAsAsset = 1"]];
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
                [[SSUser currentUser] setSegueToPerform:@"9"];
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
    if ([[[_fetchedResultsController sections] objectAtIndex:section] numberOfObjects] == [self totalAssetsCategories]) {
        self.addItemIndexPath = nil;
        return [[[_fetchedResultsController sections] objectAtIndex:section] numberOfObjects];
    } else {
        return [[[_fetchedResultsController sections] objectAtIndex:section] numberOfObjects] + 1;
    }
    
}

- (int) totalAssetsCategories {
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"StudentAsset"
                                              inManagedObjectContext:self.context];
    
    [fetchRequest setEntity:entity];
    
    [fetchRequest setPredicate:[NSPredicate predicateWithFormat:@"studentID = %@", [[SSUser currentUser] studentID]]];
    
    fetchRequest.sortDescriptors = [NSArray arrayWithObject:[NSSortDescriptor sortDescriptorWithKey:@"studentAssetID" ascending:YES selector:nil]];
    
    NSError *error;
    NSArray *fetchedObjects = [self.context executeFetchRequest:fetchRequest error:&error];
    
    return fetchedObjects.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"PersonalAssets";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
        [cell setAccessoryType:UITableViewCellAccessoryNone];
        [cell setSelectionStyle:UITableViewCellSelectionStyleGray];
    }
    
    if(![indexPath isEqual:self.addItemIndexPath]) {
        
        NSManagedObject *managedObject = [_fetchedResultsController objectAtIndexPath:indexPath];
        cell.textLabel.text = [managedObject valueForKey:@"studentAssetLiteralUS"];
        
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
        [self performSegueWithIdentifier:@"EditPersonalAsset" sender:(StudentAsset *) [_fetchedResultsController objectAtIndexPath:indexPath]];
    } else {
        [self performSegueWithIdentifier:@"AddPersonalAsset" sender:self];
    }
    
}

-(void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    UIBarButtonItem *nextScreenBackButton = [[UIBarButtonItem alloc] initWithTitle:@"Back" style:UIBarButtonItemStyleBordered target:self action:nil];
    self.navigationItem.backBarButtonItem = nextScreenBackButton;
    
    if([segue.identifier isEqualToString:@"EditPersonalAsset"]) {
        SSAddEditPersonalAssetsViewController *addEditPersonalAssetViewController = (SSAddEditPersonalAssetsViewController *) segue.destinationViewController;
        [addEditPersonalAssetViewController setStudentAsset:(StudentAsset *) sender];
        [addEditPersonalAssetViewController setEditingExistingAsset:YES];
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