//
//  SSPreSelectPersonalValuesViewController.m
//  CENTRO
//
//  Created by Centro Community Partners.
//  Copyright (c) 2013 Centro Community Partners. All rights reserved.
//

#import "SSPreSelectPersonalValuesViewController.h"
#import "SSUtils.h"
#import "Value.h"
#import "SSUser.h"

@interface SSPreSelectPersonalValuesViewController () <NSFetchedResultsControllerDelegate> {
    NSFetchedResultsController *_fetchedResultsController;
}

@property (nonatomic) int selectionCount;
@property (strong, nonatomic) NSArray *fetchedData;
@property (strong, nonatomic) NSManagedObjectContext *context;
- (void)refetchData;

@end

@implementation SSPreSelectPersonalValuesViewController

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
    
    self.navigationItem.title = @"Personal Values";
    
    
    UIBarButtonItem *nextScreenBackButton = [[UIBarButtonItem alloc] initWithTitle:@"Try Again" style:UIBarButtonItemStyleBordered target:self action:nil];
    self.navigationItem.backBarButtonItem = nextScreenBackButton;
    
    self.context = [(id)[[UIApplication sharedApplication] delegate] managedObjectContext];
    
    NSFetchRequest *fetchRequest = [NSFetchRequest fetchRequestWithEntityName:@"Value"];
    fetchRequest.sortDescriptors = [NSArray arrayWithObject:[NSSortDescriptor sortDescriptorWithKey:@"valueLiteralUS" ascending:YES selector:nil]];
    fetchRequest.returnsObjectsAsFaults = NO;
    
    _fetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest managedObjectContext:self.context sectionNameKeyPath:nil cacheName:nil];
    _fetchedResultsController.delegate = self;
    [_fetchedResultsController performFetch:nil];
    
    self.fetchedData = [_fetchedResultsController fetchedObjects];
    
}

-(void) viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    if(![[SSUser currentUser] isLoggedIn]) {
        [self.navigationController popToRootViewControllerAnimated:YES];
    }
    
    self.selectionCount = 0;
    
    for (int i = 0; i < self.fetchedData.count; i++) {
        Value *tempValue = (Value *) [self.fetchedData objectAtIndex:i];
        if([tempValue.rank intValue] >= 0) {
            self.selectionCount++;
        }
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}


- (IBAction)doneButtonPressed:(id)sender {
    
    if(self.selectionCount != MAX_VALUE_SELECTION) {
        NSString *errorString = [NSString stringWithFormat:@"You must select %d values to continue.", MAX_VALUE_SELECTION];
        
        [[[UIAlertView alloc] initWithTitle:@"Selection Error" message:errorString delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
    } else {
        NSError *error;
        if (![self.context save:&error]) {
            
        }
        
        [self performSegueWithIdentifier:@"RankPersonalValues" sender:self];
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
    static NSString *CellIdentifier = @"PreSelectedPersonalValues";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    cell.accessoryType = UITableViewCellAccessoryNone;
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
        [cell setAccessoryType:UITableViewCellAccessoryNone];
        [cell setSelectionStyle:UITableViewCellSelectionStyleGray];
    }
    
    NSManagedObject *managedObject = [_fetchedResultsController objectAtIndexPath:indexPath];
    cell.textLabel.text = [managedObject valueForKey:@"valueLiteralUS"];
    
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    
    Value *tempValue = (Value *) managedObject;
    
    if([tempValue.rank isEqualToNumber:[NSNumber numberWithInt:-100]]) {
        [cell setAccessoryType:UITableViewCellAccessoryNone];
    } else {
        [cell setAccessoryType:UITableViewCellAccessoryCheckmark];
    }
    
    return cell;
}

- (UIView *) tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    NSString *headerString;
    
    if (section == 0) {
        headerString = [NSString stringWithFormat:@" Touch %d values that are important to you.", MAX_VALUE_SELECTION];
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

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    Value *tempValue = [_fetchedResultsController objectAtIndexPath:indexPath];
    
    if(self.selectionCount < MAX_VALUE_SELECTION) {
        if([tempValue.rank isEqualToNumber:[NSNumber numberWithInt:-100]]) {
            self.selectionCount++;
            tempValue.rank = [NSNumber numberWithInt:0];
        } else {
            self.selectionCount--;
            tempValue.rank = [NSNumber numberWithInt:-100];
            tempValue.companyRank = [NSNumber numberWithInt:-100];
            [tempValue setSelectedAsCompanyValue:[NSNumber numberWithBool:NO]];
        }
    } else {
        if([tempValue.rank intValue] >= 0) {
            self.selectionCount--;
            tempValue.rank = [NSNumber numberWithInt:-100];
            tempValue.companyRank = [NSNumber numberWithInt:-100];
            [tempValue setSelectedAsCompanyValue:[NSNumber numberWithBool:NO]];
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

-(void)dismissVC{
    [self dismissViewControllerAnimated:YES completion:NULL];
}

@end
