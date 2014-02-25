//
//  SSPreSelectBrandAttibutesViewController.m
//  CENTRO
//
//  Created by Centro Community Partners.
//  Copyright (c) 2013 Centro Community Partners. All rights reserved.
//

#import "SSPreSelectBrandAttibutesViewController.h"
#import "SSUtils.h"
#import "BrandAttribute.h"
#import "SSUser.h"

@interface SSPreSelectBrandAttibutesViewController () <NSFetchedResultsControllerDelegate> {
    NSFetchedResultsController *_fetchedResultsController;
}

@property (nonatomic) int selectionCount;
@property (strong, nonatomic) NSArray *fetchedData;
@property (strong, nonatomic) NSManagedObjectContext *context;
- (void)refetchData;

@end

@implementation SSPreSelectBrandAttibutesViewController

static const int MAX_VALUE_SELECTION = 8;

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
    
    self.navigationItem.title = @"Brand Attributes";
    
    
    UIBarButtonItem *nextScreenBackButton = [[UIBarButtonItem alloc] initWithTitle:@"Try Again" style:UIBarButtonItemStyleBordered target:self action:nil];
    self.navigationItem.backBarButtonItem = nextScreenBackButton;
    
    self.context = [(id)[[UIApplication sharedApplication] delegate] managedObjectContext];
    
    NSFetchRequest *fetchRequest = [NSFetchRequest fetchRequestWithEntityName:@"BrandAttribute"];
    fetchRequest.sortDescriptors = [NSArray arrayWithObject:[NSSortDescriptor sortDescriptorWithKey:@"brandValueLiteralUS" ascending:YES selector:nil]];
    fetchRequest.returnsObjectsAsFaults = NO;
    
    _fetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest managedObjectContext:self.context sectionNameKeyPath:nil cacheName:nil];
    _fetchedResultsController.delegate = self;
    [_fetchedResultsController performFetch:nil];
    
    self.fetchedData = [_fetchedResultsController fetchedObjects];
    
    self.titleLabel.text = [NSString stringWithFormat:@"Touch %d product/service factors important to %@'s customers.", MAX_VALUE_SELECTION, [SSUtils companyName]];
}

-(void) viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    if(![[SSUser currentUser] isLoggedIn]) {
        [self.navigationController popToRootViewControllerAnimated:YES];
    }

    self.selectionCount = 0;
    
    for (int i = 0; i < self.fetchedData.count; i++) {
        BrandAttribute *tempBrandAttribute = (BrandAttribute *) [self.fetchedData objectAtIndex:i];
        if([tempBrandAttribute.brandValueRank intValue] >= 0) {
            self.selectionCount++;
        }
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (IBAction)nextButtonPressed:(id)sender {
    
    if(self.selectionCount != MAX_VALUE_SELECTION) {
        NSString *errorString = [NSString stringWithFormat:@"You must select %d values to continue.", MAX_VALUE_SELECTION];
        
        [[[UIAlertView alloc] initWithTitle:@"Selection Error" message:errorString delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
    } else {
        NSError *error;
        if (![self.context save:&error]) {

        }
        
        [self performSegueWithIdentifier:@"RankBrandAttributes" sender:self];
    }
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
    static NSString *CellIdentifier = @"PreSelectBrandAttributeCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    cell.accessoryType = UITableViewCellAccessoryNone;
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
        [cell setAccessoryType:UITableViewCellAccessoryNone];
        [cell setSelectionStyle:UITableViewCellSelectionStyleGray];
    }
    
    NSManagedObject *managedObject = [_fetchedResultsController objectAtIndexPath:indexPath];
    cell.textLabel.text = [managedObject valueForKey:@"brandValueLiteralUS"];
    
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    
    BrandAttribute *tempBrandAttribute = (BrandAttribute *) managedObject;
    
    if([tempBrandAttribute.brandValueRank isEqualToNumber:[NSNumber numberWithInt:-100]]) {
        [cell setAccessoryType:UITableViewCellAccessoryNone];
    } else {
        [cell setAccessoryType:UITableViewCellAccessoryCheckmark];
    }

    return cell;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    BrandAttribute *tempBrandAttribute = [_fetchedResultsController objectAtIndexPath:indexPath];
    
    if(self.selectionCount < MAX_VALUE_SELECTION) {
        if([tempBrandAttribute.brandValueRank isEqualToNumber:[NSNumber numberWithInt:-100]]) {
            self.selectionCount++;
            tempBrandAttribute.brandValueRank = [NSNumber numberWithInt:0];
        } else {
            self.selectionCount--;
            tempBrandAttribute.brandValueRank = [NSNumber numberWithInt:-100];
            tempBrandAttribute.brandValuePropositionRank = [NSNumber numberWithInt:-100];
            [tempBrandAttribute setSelectedAsBrandValueProposition:[NSNumber numberWithBool:NO]];
        }
    } else {
        if([tempBrandAttribute.brandValueRank intValue] >= 0) {
            self.selectionCount--;
            tempBrandAttribute.brandValueRank = [NSNumber numberWithInt:-100];
            tempBrandAttribute.brandValuePropositionRank = [NSNumber numberWithInt:-100];
            [tempBrandAttribute setSelectedAsBrandValueProposition:[NSNumber numberWithBool:NO]];
        }
        else{
            NSString *errorString = [NSString stringWithFormat:@"You have selected more than %d values, please deselect one to continue.", MAX_VALUE_SELECTION];
        
            [[[UIAlertView alloc] initWithTitle:@"Selection Limit" message:errorString delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
        }
    }
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
}

#pragma mark - NSFetchedResultsControllerDelegate

- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller {
    [self.tableView reloadData];
}

- (void) dealloc {
    _fetchedResultsController = nil;
    self.fetchedData = nil;
}

-(IBAction)dismissVC{
    [self dismissViewControllerAnimated:YES completion:NULL];
}


@end