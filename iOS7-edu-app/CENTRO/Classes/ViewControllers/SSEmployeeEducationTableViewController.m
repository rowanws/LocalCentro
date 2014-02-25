//
//  SSEmployeeEducationTableViewController.m
//  CENTRO
//
//  Created by Centro Community Partners.
//  Copyright (c) 2013 Centro Community Partners. All rights reserved.
//

#import "SSEmployeeEducationTableViewController.h"
#import "SSUser.h"
#import "Company.h"
#import "Employee.h"
#import "EmployeeEducation.h"

@interface SSEmployeeEducationTableViewController () <NSFetchedResultsControllerDelegate> {
    NSFetchedResultsController *_fetchedResultsController;
}

@property (strong, nonatomic) NSManagedObjectContext *context;
@property (strong, nonatomic) Company *company;
@property (strong, nonatomic) NSArray *fetchedEducationData;
@property (strong, nonatomic) NSArray *fetchedEmployeeData;

@property int selectionCount;
@property int employeePos;

- (void)refetchData;

@end

@implementation SSEmployeeEducationTableViewController

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

- (IBAction)nextButtonPressed:(id)sender {
    
    
    if(self.employeePos == [self.company.numberOfEmployees intValue]-1)    {
        if (self.selectionCount > 0) {
            [self.context save:nil];
            [self performSegueWithIdentifier:@"EmployeeProfessionalExperience" sender:self];
        } else {
            [[[UIAlertView alloc] initWithTitle:@"Selection Error"
                                        message:@"You must select an Education Level."
                                       delegate:nil
                              cancelButtonTitle:@"OK"
                              otherButtonTitles:nil] show];
        }
    } else {
        if (self.selectionCount > 0) {
            self.employeePos++;
            self.selectionCount = 0;
            
            NSString *name = [(Employee *) self.fetchedEmployeeData[self.employeePos] name];
            NSString *employeeID = [[(Employee *) self.fetchedEmployeeData[self.employeePos] employeeID] stringValue];
            self.titleLabel.text = [NSString stringWithFormat:@"What has %@ completed?", name];
            [self fetchedResultsControllerForEmployeeID:employeeID];
            
            [self.tableView reloadData];
        } else {
            [[[UIAlertView alloc] initWithTitle:@"Selection Error"
                                        message:@"You must select an Education Level."
                                       delegate:nil
                              cancelButtonTitle:@"OK"
                              otherButtonTitles:nil] show];
        }
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
    
    self.navigationItem.title = @"Education";
    
    self.context = [(id)[[UIApplication sharedApplication] delegate] managedObjectContext];
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Company"
                                              inManagedObjectContext:self.context];
    [fetchRequest setEntity:entity];
    
    [fetchRequest setPredicate:[NSPredicate predicateWithFormat:@"companyID = %@", [[SSUser currentUser] companyID]]];
    
    NSError *error;
    NSArray *fetchedObjects = [self.context executeFetchRequest:fetchRequest error:&error];
    if (fetchedObjects.count == 0) {
        
    } else {
        self.company = (Company *) [fetchedObjects objectAtIndex:0];
    }
}

-(void) viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    if(![[SSUser currentUser] isLoggedIn]) {
        [self.navigationController popToRootViewControllerAnimated:YES];
    } else {
        
        [self employeesForCompany];
        
        self.selectionCount = 0;
        self.employeePos = 0;
        
        Employee *tempEmp = (Employee *) self.fetchedEmployeeData[self.employeePos];
        if ([[tempEmp myself] isEqualToNumber:[NSNumber numberWithBool:YES]]) {
            self.titleLabel.text = [NSString stringWithFormat:@"What have you completed?"];
        } else {
            self.titleLabel.text = [NSString stringWithFormat:@"What has %@ completed?", [tempEmp name]];
        }
        
        NSString *employeeID = [[(Employee *) self.fetchedEmployeeData[self.employeePos] employeeID] stringValue];
        [self fetchedResultsControllerForEmployeeID:employeeID];
        
        [self.tableView reloadData];
    }
}


-(void) employeesForCompany {
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Employee"
                                              inManagedObjectContext:self.context];
    [fetchRequest setEntity:entity];
    
    [fetchRequest setPredicate:[NSPredicate predicateWithFormat:@"companyID = %@ AND selectedAsEmployee == 1", [[SSUser currentUser] companyID]]];
    fetchRequest.sortDescriptors = [NSArray arrayWithObject:[NSSortDescriptor sortDescriptorWithKey:@"employeeID" ascending:YES selector:nil]];
    
    NSError *error;
    self.fetchedEmployeeData = [self.context executeFetchRequest:fetchRequest error:&error];
    
}

-(void) fetchedResultsControllerForEmployeeID:(NSString *) employeeID {
    
    NSFetchRequest *fetchRequest = [NSFetchRequest fetchRequestWithEntityName:@"EmployeeEducation"];
    [fetchRequest setPredicate:[NSPredicate predicateWithFormat:@"employeeID = %@", employeeID]];
    fetchRequest.sortDescriptors = [NSArray arrayWithObject:[NSSortDescriptor sortDescriptorWithKey:@"educationID" ascending:YES selector:nil]];
    
    fetchRequest.returnsObjectsAsFaults = NO;
    
    _fetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest managedObjectContext:self.context sectionNameKeyPath:nil cacheName:nil];
    _fetchedResultsController.delegate = self;
    [_fetchedResultsController performFetch:nil];
    
    self.fetchedEducationData = [_fetchedResultsController fetchedObjects];
    
    for (int i = 0; i < self.fetchedEducationData.count; i++) {
        EmployeeEducation *temp = (EmployeeEducation *) [self.fetchedEducationData objectAtIndex:i];
        if([temp.selectedAsEmployeeEducation intValue] == 1) {
            self.selectionCount++;
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
    static NSString *CellIdentifier = @"EmployeeEducationCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    cell.accessoryType = UITableViewCellAccessoryNone;
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        [cell setAccessoryType:UITableViewCellAccessoryNone];
        [cell setSelectionStyle:UITableViewCellSelectionStyleGray];
    }

    EmployeeEducation *tempEdu = [_fetchedResultsController objectAtIndexPath:indexPath];
    cell.textLabel.text = tempEdu.educationLiteralUS;
    
    if([tempEdu.selectedAsEmployeeEducation isEqualToNumber:[NSNumber numberWithBool:NO]]) {
        [cell setAccessoryType:UITableViewCellAccessoryNone];
    } else {
        [cell setAccessoryType:UITableViewCellAccessoryCheckmark];
    }
    
    
    return cell;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    EmployeeEducation *tempEdu = [_fetchedResultsController objectAtIndexPath:indexPath];
    
    if([tempEdu.selectedAsEmployeeEducation isEqualToNumber:[NSNumber numberWithBool:NO]]) {
        [tempEdu setSelectedAsEmployeeEducation:[NSNumber numberWithBool:YES]];
        self.selectionCount++;
    } else {
        [tempEdu setSelectedAsEmployeeEducation:[NSNumber numberWithBool:NO]];
        self.selectionCount--;
    }
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    [self.tableView reloadData];
    
}

#pragma mark - NSFetchedResultsControllerDelegate

- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller {
    [self.context save:nil];
    [self refetchData];
    [self.tableView reloadData];
}

-(void) viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    [self.context save:nil];
}

@end