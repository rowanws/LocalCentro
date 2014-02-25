//
//  SSSelectIndustryTableViewController.m
//  CENTRO
//
//  Created by Centro Community Partners.
//  Copyright (c) 2013 Centro Community Partners. All rights reserved.
//

#import "SSSelectIndustryTableViewController.h"
#import "IndustryAndSegment.h"
#import "SSUser.h"
#import "SSSelectSegmentTableViewController.h"
#import "Industry.h"
#import "SSUtils.h"

@interface SSSelectIndustryTableViewController  () <NSFetchedResultsControllerDelegate> {
    NSFetchedResultsController *_fetchedResultsController;
}
- (void)refetchData;

@property (strong, nonatomic) NSManagedObjectContext *context;
@property (strong, nonatomic) Industry *industry;

@end

@implementation SSSelectIndustryTableViewController

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
    
    //UIImageView *backgroundImageView40 = [[UIImageView alloc] //initWithImage:[UIImage imageNamed:@"bg-568h@2x.png"]];
//    UIImageView *backgroundImageView35R = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"bg@2x.png"]];
    
  //  CGRect screenBounds = [[UIScreen mainScreen] bounds];
    //if (screenBounds.size.height == 568) {
      //  self.tableView.backgroundView = backgroundImageView40;
    //} else {
      //  self.tableView.backgroundView = backgroundImageView35R;
   // }
    //self.tableView.backgroundView.contentMode = UIViewContentModeCenter;
    
    self.tableView.delegate = self;
    
    self.navigationItem.title = @"Industries";
    
    self.context = [(id)[[UIApplication sharedApplication] delegate] managedObjectContext];
}

-(void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if([segue.identifier isEqualToString:@"SelectIndustrySegment"]) {
        
        [self.context save:nil];
    }
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
}

-(void) viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    NSFetchRequest *fetchRequest = [NSFetchRequest fetchRequestWithEntityName:@"IndustryAndSegment"];
    [fetchRequest setPredicate:[NSPredicate predicateWithFormat:@"isSegment = 0"]];
    fetchRequest.sortDescriptors = [NSArray arrayWithObject:[NSSortDescriptor sortDescriptorWithKey:@"industryAndSegmentID" ascending:YES selector:nil]];
    fetchRequest.returnsObjectsAsFaults = NO;
    
    _fetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest managedObjectContext:self.context sectionNameKeyPath:nil cacheName:nil];
    _fetchedResultsController.delegate = self;
    [_fetchedResultsController performFetch:nil];
    
    NSFetchRequest *fetchRequestIND = [[NSFetchRequest alloc] init];
    
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Industry"
                                              inManagedObjectContext:self.context];
    [fetchRequestIND setEntity:entity];
    
    [fetchRequestIND setPredicate:[NSPredicate predicateWithFormat:@"companyID = %@", [[SSUser currentUser] companyID]]];
    
    NSError *error;
    NSArray *fetchedObjects = [self.context executeFetchRequest:fetchRequestIND error:&error];
    if (fetchedObjects.count == 0) {
        
    } else {
        self.industry = (Industry *) [fetchedObjects objectAtIndex:0];
    }
    
    [self.tableView reloadData];
    [self.tableView setEditing:NO animated:YES];

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
    static NSString *CellIdentifier = @"IndustryCell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        [cell setAccessoryType:UITableViewCellAccessoryNone];
        [cell setSelectionStyle:UITableViewCellSelectionStyleBlue];
    }
    
    NSManagedObject *managedObject = [_fetchedResultsController objectAtIndexPath:indexPath];
    
    NSString *industryCode = [managedObject valueForKey:@"industryCode"];
    NSString *industryDescription = [managedObject valueForKey:@"industryLiteralUS"];
    
    if([self.industry.industryCode isEqualToString:industryCode]) {
        cell.textLabel.text = [NSString stringWithFormat:@"☑ %@", industryDescription];
    } else {
       cell.textLabel.text = [NSString stringWithFormat:@"☐ %@", industryDescription];
    }
    
    [cell setAccessoryType:UITableViewCellAccessoryNone];
    
    return cell;
}

- (UIView *) tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    NSString *headerString;

    if (section == 0) {
        headerString = [NSString stringWithFormat:@"   What Industry is %@ in?", [SSUtils companyName]];
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


-(void) viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];

    NSArray *viewControllers = self.navigationController.viewControllers;
    if (viewControllers.count > 1 && [viewControllers objectAtIndex:viewControllers.count-2] == self) {
        [self.context save:nil];
    } else if ([viewControllers indexOfObject:self] == NSNotFound) {
        [self.context reset];
    } else {
        
        [self.context save:nil];
    }
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    IndustryAndSegment *is = (IndustryAndSegment *) [_fetchedResultsController objectAtIndexPath:indexPath];
    
    self.industry.industryCode = is.industryCode;
    
    [self performSegueWithIdentifier:@"SelectIndustrySegment" sender:self];
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath {
    return UITableViewCellEditingStyleNone;
}

#pragma mark - NSFetchedResultsControllerDelegate

- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller {
    [self.tableView reloadData];
}

-(IBAction)dismissVC{
    [self dismissViewControllerAnimated:YES completion:NULL];
}

@end
