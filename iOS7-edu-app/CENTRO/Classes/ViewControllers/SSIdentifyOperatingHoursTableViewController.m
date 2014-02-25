//
//  SSIdentifyOperatingHoursTableViewController.m
//  CENTRO
//
//  Created by Centro Community Partners.
//  Copyright (c) 2013 Centro Community Partners. All rights reserved.
//

#import "SSIdentifyOperatingHoursTableViewController.h"
#import "OperatingHour.h"
#import "SSUser.h"
#import "SSAddDeleteOperatingHourViewController.h"
#import "SSUtils.h"

@interface SSIdentifyOperatingHoursTableViewController () <NSFetchedResultsControllerDelegate> {
    NSFetchedResultsController *_fetchedResultsController;
}
- (void)refetchData;

@property (strong, nonatomic) NSManagedObjectContext *context;

@property int workingHoursCount;

@end

@implementation SSIdentifyOperatingHoursTableViewController

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

- (IBAction)nextButtonPressed:(id)sender {
    
    if(self.workingHoursCount == 0) {
        [[[UIAlertView alloc] initWithTitle:@"Selection Error"
                                    message:@"You need to select at least one Operating Hour."
                                   delegate:nil
                          cancelButtonTitle:@"OK"
                          otherButtonTitles:nil] show];
    } else {
        [self.context save:nil];
        [self performSegueWithIdentifier:@"BusinessHours" sender:self];
    }
    
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
    
    self.navigationItem.title = @"Operating Hours";
    
    self.context = [(id)[[UIApplication sharedApplication] delegate] managedObjectContext];
    
    self.titleQuestionLabel.text = [NSString stringWithFormat:@"When is %@ open?", [SSUtils companyName]];
}

-(void) viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    if(![[SSUser currentUser] isLoggedIn]) {
        [self.navigationController popToRootViewControllerAnimated:YES];
    }
    
    self.workingHoursCount = 0;
    
    
    NSFetchRequest *fetchRequest = [NSFetchRequest fetchRequestWithEntityName:@"OperatingHour"];
    [fetchRequest setPredicate:[NSPredicate predicateWithFormat:@"companyID = %@", [[SSUser currentUser] companyID]]];
    fetchRequest.sortDescriptors = [NSArray arrayWithObject:[NSSortDescriptor sortDescriptorWithKey:@"dayOfWeekID" ascending:YES selector:nil]];
    fetchRequest.returnsObjectsAsFaults = NO;
    
    _fetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest managedObjectContext:self.context sectionNameKeyPath:nil cacheName:nil];
    _fetchedResultsController.delegate = self;
    [_fetchedResultsController performFetch:nil];
    
    
    [self.tableView reloadData];
    
    for (OperatingHour *oh in _fetchedResultsController.fetchedObjects) {
        if ([oh.selectedAsWorkingDay isEqualToNumber:[NSNumber numberWithBool:YES]]) {
            self.workingHoursCount++;
        }
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
    static NSString *CellIdentifier = @"HourCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
        [cell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
        [cell setSelectionStyle:UITableViewCellSelectionStyleGray];
    }
    
    NSString *cellText = @"";
    NSDateFormatter *timeFormat = [[NSDateFormatter alloc] init];
    [timeFormat setDateFormat:@"hh:mm a"];
    
    if ([[[_fetchedResultsController objectAtIndexPath:indexPath] selectedAsWorkingDay] isEqualToNumber:[NSNumber numberWithBool:YES]]) {
        NSString *day = [self dayLiteralForID:[[[_fetchedResultsController objectAtIndexPath:indexPath] dayOfWeekID] stringValue]];
        NSString *from = [timeFormat stringFromDate:[[_fetchedResultsController objectAtIndexPath:indexPath] from]];
        NSString *to = [timeFormat stringFromDate:[[_fetchedResultsController objectAtIndexPath:indexPath] to]];
        cellText = [NSString stringWithFormat:@"%@ %@ - %@", day, from, to];
    } else {
        NSString *day = [self dayLiteralForID:[[[_fetchedResultsController objectAtIndexPath:indexPath] dayOfWeekID] stringValue]];
        cellText = [NSString stringWithFormat:@"%@ (tap to add)", day];
    }
    
    cell.textLabel.text = cellText;
    

    
    return cell;
}

-(NSString *) dayLiteralForID:(NSString *) dayID {
    
    NSString *dayLiteral = @"";
    
    if([dayID isEqualToString:@"1"]) {
        dayLiteral = @"Mon";
    } else if([dayID isEqualToString:@"2"]) {
        dayLiteral = @"Tue";
    } else if([dayID isEqualToString:@"3"]) {
        dayLiteral = @"Wed";
    } else if([dayID isEqualToString:@"4"]) {
        dayLiteral = @"Thu";
    } else if([dayID isEqualToString:@"5"]) {
        dayLiteral = @"Fri";
    } else if([dayID isEqualToString:@"6"]) {
        dayLiteral = @"Sat";
    } else if([dayID isEqualToString:@"7"]) {
        dayLiteral = @"Sun";
    }
    
    return dayLiteral;
    
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self performSegueWithIdentifier:@"AddOperatingHour" sender:(OperatingHour *) [_fetchedResultsController objectAtIndexPath:indexPath]];
    
}

-(void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if([segue.identifier isEqualToString:@"AddOperatingHour"]) {
        SSAddDeleteOperatingHourViewController *addDeleteOperatingHourViewController = (SSAddDeleteOperatingHourViewController*) segue.destinationViewController;
        [addDeleteOperatingHourViewController setOperatingHour:(OperatingHour *) sender];
        
        UIBarButtonItem *nextScreenBackButton = [[UIBarButtonItem alloc] initWithTitle:@"Cancel" style:UIBarButtonItemStyleBordered target:self action:nil];
        self.navigationItem.backBarButtonItem = nextScreenBackButton;
    } else {
        UIBarButtonItem *nextScreenBackButton = [[UIBarButtonItem alloc] initWithTitle:@"Edit" style:UIBarButtonItemStyleBordered target:self action:nil];
        self.navigationItem.backBarButtonItem = nextScreenBackButton;
    }
}

#pragma mark - NSFetchedResultsControllerDelegate

- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller {
    [self.tableView reloadData];
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

-(IBAction)dismissVC{
    [self dismissViewControllerAnimated:YES completion:NULL];
}

@end