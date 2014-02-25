//
//  SSEmployeeResponsibilityTableViewController.m
//  CENTRO
//
//  Created by Centro Community Partners.
//  Copyright (c) 2013 Centro Community Partners. All rights reserved.
//

#import "SSEmployeeResponsibilityTableViewController.h"
#import "SSUser.h"
#import "Company.h"
#import "Employee.h"
#import "Responsibility.h"
#import "EmployeeResponsibility.h"

@interface SSEmployeeResponsibilityTableViewController () <NSFetchedResultsControllerDelegate> {
    NSFetchedResultsController *_fetchedResultsController;
}

@property (strong, nonatomic) NSManagedObjectContext *context;
@property (strong, nonatomic) Company *company;
@property (strong, nonatomic) NSArray *fetchedResponsibilityData;
@property (strong, nonatomic) NSArray *fetchedActivityData;
@property (strong, nonatomic) EmployeeResponsibility *currentResponsibilityForMe;
@property (strong, nonatomic) EmployeeResponsibility *currentResponsibilityForOther;

@property int selectionEmployeeCount;
@property int activityPos;
@property int numberOfEmployees;

@property BOOL onlyMe;

- (void)refetchData;

@end

@implementation SSEmployeeResponsibilityTableViewController

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
    
    if(self.activityPos == self.fetchedActivityData.count-1)    {
        if (self.selectionEmployeeCount > 0) {
            [self.context save:nil];
            [self performSegueWithIdentifier:@"TeamActivities" sender:self];
        } else {
            [[[UIAlertView alloc] initWithTitle:@"Selection Error"
                                        message:@"You must select a responsible for this activity."
                                       delegate:nil
                              cancelButtonTitle:@"OK"
                              otherButtonTitles:nil] show];
        }
    } else {
        if (self.selectionEmployeeCount > 0) {
            self.activityPos++;
            self.selectionEmployeeCount = 0;
            
            self.titleLabel.text = [NSString stringWithFormat:@"Who is responsible for the activity: %@?", [self.fetchedActivityData[self.activityPos] responsibilityDescription]];
            [self fetchedResultsControllerForResponsibilityID:[[self.fetchedActivityData[self.activityPos] responsibilityID] stringValue]];
            [self.tableView reloadData];
        } else {
            [[[UIAlertView alloc] initWithTitle:@"Selection Error"
                                        message:@"You must select a responsible for this activity."
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
    
    self.navigationItem.title = @"Activity";
    
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
        if([self.company.numberOfEmployees intValue] == 1) {
            self.numberOfEmployees = [self.company.numberOfEmployees intValue];
            self.onlyMe = YES;
        } else {
            self.numberOfEmployees = [self.company.numberOfEmployees intValue]-1;
            self.onlyMe = NO;
        }
    }
    [self clearNonEmployeeResponsibilities];
}

-(void) clearNonEmployeeResponsibilities {
    
    NSMutableArray *nonEmployeeIDs = [[NSMutableArray alloc] initWithCapacity:10];
    
    NSFetchRequest *fetchRequestE = [[NSFetchRequest alloc] init];
    
    NSEntityDescription *entityE = [NSEntityDescription entityForName:@"Employee"
                                               inManagedObjectContext:self.context];
    [fetchRequestE setEntity:entityE];
    
    [fetchRequestE setPredicate:[NSPredicate predicateWithFormat:@"companyID = %@ AND selectedAsEmployee = 0", [[SSUser currentUser] companyID]]];
    NSLog(@"Company ID: %@", [[SSUser currentUser] companyID]);
    fetchRequestE.sortDescriptors = [NSArray arrayWithObject:[NSSortDescriptor sortDescriptorWithKey:@"employeeID" ascending:YES selector:nil]];
    
    NSError *errorE;
    NSArray *fetchedEmployeeObjects = [self.context executeFetchRequest:fetchRequestE error:&errorE];
    if (!fetchedEmployeeObjects.count == 0) {
        
        for (Employee *emp in fetchedEmployeeObjects) {
            [nonEmployeeIDs addObject:emp.employeeID];
        }
        
        NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
        
        NSEntityDescription *entity = [NSEntityDescription entityForName:@"EmployeeResponsibility"
                                                  inManagedObjectContext:self.context];
        [fetchRequest setEntity:entity];
        
        [fetchRequest setPredicate:[NSPredicate predicateWithFormat:@"employeeID IN %@", nonEmployeeIDs]];
        
        NSError *error;
        NSArray *fetchedObjects = [self.context executeFetchRequest:fetchRequest error:&error];
        if (!fetchedObjects.count == 0) {
            for(EmployeeResponsibility *empRes in fetchedObjects) {
                empRes.rank = [NSNumber numberWithInt:-1];
                empRes.selectedAsResponsibility = [NSNumber numberWithBool:NO];
            }
        }
        [self.context save:nil];
    }
}

-(NSString *) meName {
    
    NSString *name = @"";
    
    NSFetchRequest *fetchRequestE = [[NSFetchRequest alloc] init];
    
    NSEntityDescription *entityE = [NSEntityDescription entityForName:@"Employee"
                                               inManagedObjectContext:self.context];
    [fetchRequestE setEntity:entityE];
    
    [fetchRequestE setPredicate:[NSPredicate predicateWithFormat:@"companyID = %@ AND selectedAsEmployee = 1 AND myself = 1", [[SSUser currentUser] companyID]]];
    fetchRequestE.sortDescriptors = [NSArray arrayWithObject:[NSSortDescriptor sortDescriptorWithKey:@"employeeID" ascending:YES selector:nil]];
    
    NSError *errorE;
    NSArray *fetchedEmployeeObjects = [self.context executeFetchRequest:fetchRequestE error:&errorE];
    if (fetchedEmployeeObjects.count == 0) {
        
    } else {
        Employee *emp = fetchedEmployeeObjects[0];
        name = [emp name];
    }
    
    return name;
}

-(void) viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    if(![[SSUser currentUser] isLoggedIn]) {
        [self.navigationController popToRootViewControllerAnimated:YES];
    } else {
        
        [self activitiesForCompany];
        self.activityPos = 0;
        self.selectionEmployeeCount = 0;
        
        self.titleLabel.text = [NSString stringWithFormat:@"Who is responsible for the activity: %@?", [self.fetchedActivityData[self.activityPos] responsibilityDescription]];

        [self fetchedResultsControllerForResponsibilityID:[[self.fetchedActivityData[self.activityPos] responsibilityID] stringValue]];
        
        [self.tableView reloadData];
    }
}


-(void) activitiesForCompany {
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Responsibility"
                                              inManagedObjectContext:self.context];
    [fetchRequest setEntity:entity];
    
    [fetchRequest setPredicate:[NSPredicate predicateWithFormat:@"companyID = %@ AND selectedAsResponsibility == 1", [[SSUser currentUser] companyID]]];
    fetchRequest.sortDescriptors = [NSArray arrayWithObject:[NSSortDescriptor sortDescriptorWithKey:@"responsibilityID" ascending:YES selector:nil]];
    
    NSError *error;
    self.fetchedActivityData = [self.context executeFetchRequest:fetchRequest error:&error];
    
}

-(void) fetchedResultsControllerForResponsibilityID:(NSString *) responsibilityID {
    
    NSMutableArray *employeeIDs = [[NSMutableArray alloc] initWithCapacity:10];
    
    //fetch de selected as employee en employee
    NSFetchRequest *fetchRequestE = [[NSFetchRequest alloc] init];
    
    NSEntityDescription *entityE = [NSEntityDescription entityForName:@"Employee"
                                              inManagedObjectContext:self.context];
    [fetchRequestE setEntity:entityE];
    
    [fetchRequestE setPredicate:[NSPredicate predicateWithFormat:@"companyID = %@ AND selectedAsEmployee = 1 AND myself = 0", [[SSUser currentUser] companyID]]];
    fetchRequestE.sortDescriptors = [NSArray arrayWithObject:[NSSortDescriptor sortDescriptorWithKey:@"employeeID" ascending:YES selector:nil]];
    
    NSError *errorE;
    NSArray *fetchedEmployeeObjects = [self.context executeFetchRequest:fetchRequestE error:&errorE];
    if (fetchedEmployeeObjects.count == 0) {
        
    } else {
        for(Employee *emp in fetchedEmployeeObjects) {
            [employeeIDs addObject:[emp.employeeID stringValue]];
        }
    }
    
    NSFetchRequest *fetchRequestEM = [[NSFetchRequest alloc] init];
    
    NSEntityDescription *entityEM = [NSEntityDescription entityForName:@"EmployeeResponsibility"
                                              inManagedObjectContext:self.context];
    [fetchRequestEM setEntity:entityEM];
    
    [fetchRequestEM setPredicate:[NSPredicate predicateWithFormat:@"companyID = %@ AND isMyResponsibility = 1 AND responsibilityID = %@", [[SSUser currentUser] companyID], responsibilityID]];
    fetchRequestEM.sortDescriptors = [NSArray arrayWithObject:[NSSortDescriptor sortDescriptorWithKey:@"employeeID" ascending:YES selector:nil]];
    
    NSError *errorEM;
    NSArray *fetchedEMObject = [self.context executeFetchRequest:fetchRequestEM error:&errorEM];
    if (fetchedEMObject.count == 0) {
        
    } else {
        self.currentResponsibilityForMe = fetchedEMObject[0];
    }
    
    NSFetchRequest *fetchRequestOT = [[NSFetchRequest alloc] init];
    
    NSEntityDescription *entityOT = [NSEntityDescription entityForName:@"EmployeeResponsibility"
                                                inManagedObjectContext:self.context];
    [fetchRequestOT setEntity:entityOT];
    
    [fetchRequestOT setPredicate:[NSPredicate predicateWithFormat:@"companyID = %@ AND isOtherResponsibility = 1 AND responsibilityID = %@", [[SSUser currentUser] companyID], responsibilityID]];
    
    fetchRequestOT.sortDescriptors = [NSArray arrayWithObject:[NSSortDescriptor sortDescriptorWithKey:@"employeeID" ascending:YES selector:nil]];
    
    NSError *errorOT;
    NSArray *fetchedOTObject = [self.context executeFetchRequest:fetchRequestOT error:&errorOT];
    if (fetchedOTObject.count == 0) {
        
    } else {
        self.currentResponsibilityForOther = fetchedOTObject[0];
    }

    
    if(self.onlyMe) {
        if([self.currentResponsibilityForMe.selectedAsResponsibility isEqualToNumber:[NSNumber numberWithBool:YES]]) {
            self.selectionEmployeeCount++;
        }
        if([self.currentResponsibilityForOther.selectedAsResponsibility isEqualToNumber:[NSNumber numberWithBool:YES]]) {
            self.selectionEmployeeCount++;
        }
    } else {
        NSFetchRequest *fetchRequest = [NSFetchRequest fetchRequestWithEntityName:@"EmployeeResponsibility"];
        [fetchRequest setPredicate:[NSPredicate predicateWithFormat:@"responsibilityID = %@ AND ANY %K in %@", responsibilityID, @"employeeID", employeeIDs]];
        fetchRequest.sortDescriptors = [NSArray arrayWithObject:[NSSortDescriptor sortDescriptorWithKey:@"employeeID" ascending:YES selector:nil]];
        
        fetchRequest.returnsObjectsAsFaults = NO;
        
        _fetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest managedObjectContext:self.context sectionNameKeyPath:nil cacheName:nil];
        _fetchedResultsController.delegate = self;
        [_fetchedResultsController performFetch:nil];
        
        self.fetchedResponsibilityData = [_fetchedResultsController fetchedObjects];
        
        for (int i = 0; i < self.fetchedResponsibilityData.count; i++) {
            EmployeeResponsibility *temp = (EmployeeResponsibility *) [self.fetchedResponsibilityData objectAtIndex:i];
            if([temp.selectedAsResponsibility intValue] == 1 || [temp.isMyResponsibility intValue] == 1 || [temp.isOtherResponsibility intValue] == 1) {
                self.selectionEmployeeCount++;
            }
        }
        if([self.currentResponsibilityForMe.selectedAsResponsibility isEqualToNumber:[NSNumber numberWithBool:YES]]) {
            self.selectionEmployeeCount++;
        }
        if([self.currentResponsibilityForOther.selectedAsResponsibility isEqualToNumber:[NSNumber numberWithBool:YES]]) {
            self.selectionEmployeeCount++;
        }
    }
}

-(NSString *) nameForEmployeeID:(NSString *) employeeID {
    
    NSString *name;
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Employee"
                                              inManagedObjectContext:self.context];
    [fetchRequest setEntity:entity];
    
    [fetchRequest setPredicate:[NSPredicate predicateWithFormat:@"companyID = %@ AND employeeID = %@", [[SSUser currentUser] companyID], employeeID]];
    
    NSError *error;
    NSArray *fetchedEmployeeObjects = [self.context executeFetchRequest:fetchRequest error:&error];
    if (fetchedEmployeeObjects.count == 0) {
        
    } else {
        name = [[fetchedEmployeeObjects objectAtIndex:0] name];
    }
    return name;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    
    if(self.onlyMe) {
        return 1;
    } else {
        return [[_fetchedResultsController sections] count];
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if(self.onlyMe) {
        return 2;
    } else {
        return [[[_fetchedResultsController sections] objectAtIndex:section] numberOfObjects] + 2;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSIndexPath *empIP = [NSIndexPath indexPathForItem:indexPath.row-1 inSection:indexPath.section];
    
    static NSString *CellIdentifier = @"EmployeeResponsibilityCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    cell.accessoryType = UITableViewCellAccessoryNone;
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        [cell setAccessoryType:UITableViewCellAccessoryNone];
        [cell setSelectionStyle:UITableViewCellSelectionStyleGray];
    }
    
    if(self.onlyMe) {
        if(indexPath.row == 0) {
            cell.textLabel.text = [self meName];
            if([self.currentResponsibilityForMe.selectedAsResponsibility isEqualToNumber:[NSNumber numberWithBool:NO]]) {
                [cell setAccessoryType:UITableViewCellAccessoryNone];
            } else {
                [cell setAccessoryType:UITableViewCellAccessoryCheckmark];
            }
        } else if(indexPath.row == 1) {
            cell.textLabel.text = @"Someone outside my business";
            if([self.currentResponsibilityForOther.selectedAsResponsibility isEqualToNumber:[NSNumber numberWithBool:NO]]) {
                [cell setAccessoryType:UITableViewCellAccessoryNone];
            } else {
                [cell setAccessoryType:UITableViewCellAccessoryCheckmark];
            }
        }
    } else {
        
        
        if(indexPath.row == 0) {
            cell.textLabel.text = [self meName];
            if([self.currentResponsibilityForMe.selectedAsResponsibility isEqualToNumber:[NSNumber numberWithBool:NO]]) {
                [cell setAccessoryType:UITableViewCellAccessoryNone];
            } else {
                [cell setAccessoryType:UITableViewCellAccessoryCheckmark];
            }
        } else if(indexPath.row == self.numberOfEmployees+1) {
            cell.textLabel.text = @"Someone outside my business";
            if([self.currentResponsibilityForOther.selectedAsResponsibility isEqualToNumber:[NSNumber numberWithBool:NO]]) {
                [cell setAccessoryType:UITableViewCellAccessoryNone];
            } else {
                [cell setAccessoryType:UITableViewCellAccessoryCheckmark];
            }
        } else {
            EmployeeResponsibility *tempRes = [_fetchedResultsController objectAtIndexPath:empIP];
            cell.textLabel.text = [self nameForEmployeeID:[tempRes.employeeID stringValue]];

            if([tempRes.selectedAsResponsibility isEqualToNumber:[NSNumber numberWithBool:NO]]) {
                [cell setAccessoryType:UITableViewCellAccessoryNone];
            } else {
                [cell setAccessoryType:UITableViewCellAccessoryCheckmark];
            }
        }
    }
    return cell;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSIndexPath *empIP = [NSIndexPath indexPathForItem:indexPath.row-1 inSection:indexPath.section];
    
    if(self.onlyMe) {
        if(indexPath.row == 0) {
            if([self.currentResponsibilityForMe.selectedAsResponsibility isEqualToNumber:[NSNumber numberWithBool:NO]]) {
                self.currentResponsibilityForMe.selectedAsResponsibility = [NSNumber numberWithBool:YES];
                self.selectionEmployeeCount++;
            } else {
                self.currentResponsibilityForMe.selectedAsResponsibility = [NSNumber numberWithBool:NO];
                self.selectionEmployeeCount--;
            }
        } else if(indexPath.row == 1) {
            if([self.currentResponsibilityForOther.selectedAsResponsibility isEqualToNumber:[NSNumber numberWithBool:NO]]) {
                self.currentResponsibilityForOther.selectedAsResponsibility = [NSNumber numberWithBool:YES];
                self.selectionEmployeeCount++;
            } else {
                self.currentResponsibilityForOther.selectedAsResponsibility = [NSNumber numberWithBool:NO];
                self.selectionEmployeeCount--;
            }
        }
    } else {
        if(indexPath.row == 0) {
            if([self.currentResponsibilityForMe.selectedAsResponsibility isEqualToNumber:[NSNumber numberWithBool:NO]]) {
                self.currentResponsibilityForMe.selectedAsResponsibility = [NSNumber numberWithBool:YES];
                self.selectionEmployeeCount++;
            } else {
                self.currentResponsibilityForMe.selectedAsResponsibility = [NSNumber numberWithBool:NO];
                self.selectionEmployeeCount--;
            }
        } else if(indexPath.row == self.numberOfEmployees+1) {
            if([self.currentResponsibilityForOther.selectedAsResponsibility isEqualToNumber:[NSNumber numberWithBool:NO]]) {
                self.currentResponsibilityForOther.selectedAsResponsibility = [NSNumber numberWithBool:YES];
                self.selectionEmployeeCount++;
            } else {
                self.currentResponsibilityForOther.selectedAsResponsibility = [NSNumber numberWithBool:NO];
                self.selectionEmployeeCount--;
            }
        } else {
            EmployeeResponsibility *tempRes = [_fetchedResultsController objectAtIndexPath:empIP];            
            if([tempRes.selectedAsResponsibility isEqualToNumber:[NSNumber numberWithBool:NO]]) {
                tempRes.selectedAsResponsibility = [NSNumber numberWithBool:YES];
                self.selectionEmployeeCount++;
            } else {
                tempRes.selectedAsResponsibility = [NSNumber numberWithBool:NO];
                self.selectionEmployeeCount--;
            }
        }
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
