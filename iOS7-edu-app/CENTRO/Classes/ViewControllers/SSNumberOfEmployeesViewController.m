//
//  SSNumberOfEmployeesViewController.m
//  CENTRO
//
//  Created by Centro Community Partners.
//  Copyright (c) 2013 Centro Community Partners. All rights reserved.
//

#import "SSNumberOfEmployeesViewController.h"
#import "SSUser.h"
#import "Company.h"
#import "SSEmployeeNamesTableViewController.h"
#import "Employee.h"
#import "EmployeeResponsibility.h"
#import "SSUtils.h"

@interface SSNumberOfEmployeesViewController ()

@property (nonatomic, strong) NSManagedObjectContext *context;
@property (nonatomic, strong) Company *company;

@end

@implementation SSNumberOfEmployeesViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {

    }
    return self;
}
- (IBAction)nextButtonPressed:(id)sender {
    [self.context save:nil];
    
    if([self.company.numberOfEmployees intValue] > 0) {
        [self performSegueWithIdentifier:@"TeamNames" sender:self];
    } else {
        [[[UIAlertView alloc] initWithTitle:@"Selection Error"
                                    message:@"You must select the number of employees."
                                   delegate:nil
                          cancelButtonTitle:@"OK"
                          otherButtonTitles:nil] show];
    }
}

-(void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if([segue.identifier isEqualToString:@"TeamNames"]) {
        SSEmployeeNamesTableViewController *employeeNamesTableViewController = (SSEmployeeNamesTableViewController *) segue.destinationViewController;
        
        [employeeNamesTableViewController setNumberOfEmployees:[self.company.numberOfEmployees intValue]];

        UIBarButtonItem *nextScreenBackButton = [[UIBarButtonItem alloc] initWithTitle:@"Names" style:UIBarButtonItemStyleBordered target:self action:nil];
        self.navigationItem.backBarButtonItem = nextScreenBackButton;
    } 
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Employee"
                                              inManagedObjectContext:self.context];
    [fetchRequest setEntity:entity];
    
    [fetchRequest setPredicate:[NSPredicate predicateWithFormat:@"companyID = %@", [[SSUser currentUser] companyID]]];
    
    fetchRequest.sortDescriptors = [NSArray arrayWithObject:[NSSortDescriptor sortDescriptorWithKey:@"employeeID" ascending:YES selector:nil]];
    
    NSError *error;
    NSArray *fetchedObjects = [self.context executeFetchRequest:fetchRequest error:&error];
    if (fetchedObjects.count == 0) {
        
    } else {
        for (int i = 0; i < fetchedObjects.count; i++) {
            Employee *temp = (Employee *) fetchedObjects[i];
            temp.selectedAsEmployee = [NSNumber numberWithBool:NO];
        }
        
        for(int j = 0; j < [self.company.numberOfEmployees intValue]; j++) {
            Employee *temp = (Employee *) fetchedObjects[j];
            
            if([temp.myself isEqualToNumber:[NSNumber numberWithBool:YES]]) {
                temp.name = @"You";
            }
            
            temp.selectedAsEmployee = [NSNumber numberWithBool:YES];
        }
        [self markAllResponsibilitiesAsNoSelected];
    }
}

- (void) markAllResponsibilitiesAsNoSelected {
 
    NSFetchRequest *fetchRequestEM = [[NSFetchRequest alloc] init];
    
    NSEntityDescription *entityEM = [NSEntityDescription entityForName:@"EmployeeResponsibility"
                                                inManagedObjectContext:self.context];
    [fetchRequestEM setEntity:entityEM];
    
    [fetchRequestEM setPredicate:[NSPredicate predicateWithFormat:@"companyID = %@", [[SSUser currentUser] companyID]]];
    fetchRequestEM.sortDescriptors = [NSArray arrayWithObject:[NSSortDescriptor sortDescriptorWithKey:@"employeeID" ascending:YES selector:nil]];
    
    NSError *errorEM;
    NSArray *fetchedEMObject = [self.context executeFetchRequest:fetchRequestEM error:&errorEM];
    if (fetchedEMObject.count == 0) {
        
    } else {
        for(EmployeeResponsibility *er in fetchedEMObject) {
            er.selectedAsResponsibility = [NSNumber numberWithBool:NO];
        }
    }
}

- (IBAction)employeeButtonPressed:(id)sender {
    [self showPickerActionSheet];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    //UIImage *bg40 = [UIImage imageNamed:@"bg-568h@2x.png"];
    //UIImage *bg35R = [UIImage imageNamed:@"bg.png"];
    
    //CGRect screenBounds = [[UIScreen mainScreen] bounds];
    //if (screenBounds.size.height == 568) {
    //    self.backgroundImageView.image = bg40;
    //} else {
    //    self.backgroundImageView.image = bg35R;
    //}
    
    self.context = [(id)[[UIApplication sharedApplication] delegate] managedObjectContext];
    
    self.navigationItem.title = @"Team";
    
    
    //[self.titleLabel setLineBreakMode:NSLineBreakByWordWrapping];
    //[self.titleLabel setNumberOfLines:3];
    //[self.titleLabel sizeToFit];
    self.titleLabel.text = [NSString stringWithFormat:@"How many employees does %@ have?", [SSUtils companyName]];
    
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
        [self refreshButton];
    }

}

-(NSString *) employeeButtonTitle {
    
    NSString *employeeNumber = @"";
    
    if([self.company.numberOfEmployees intValue] <= 0) {
        employeeNumber = @"Select";
    } else if([self.company.numberOfEmployees intValue] == 1) {
        employeeNumber = @"Just Me";
    } else if([self.company.numberOfEmployees intValue] == 2) {
        employeeNumber = @"Employees: 1";
    } else if([self.company.numberOfEmployees intValue] == 3) {
        employeeNumber = @"Employees: 2";
    } else if([self.company.numberOfEmployees intValue] == 4) {
        employeeNumber = @"Employees: 3";
    } else if([self.company.numberOfEmployees intValue] == 5) {
        employeeNumber = @"Employees: 4";
    } else if([self.company.numberOfEmployees intValue] == 6) {
        employeeNumber = @"Employees: 5";
    } else if([self.company.numberOfEmployees intValue] == 7) {
        employeeNumber = @"Employees: 6";
    } else if([self.company.numberOfEmployees intValue] == 8) {
        employeeNumber = @"Employees: 7";
    } else if([self.company.numberOfEmployees intValue] == 9) {
        employeeNumber = @"Employees: 8";
    } else if([self.company.numberOfEmployees intValue] == 10) {
        employeeNumber = @"Employees: 9";
    } else if([self.company.numberOfEmployees  intValue]== 11) {
        employeeNumber = @"Employees: 10+";
    }
    
    return employeeNumber;
    
}

-(void) viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    if(![[SSUser currentUser] isLoggedIn]) {
        [self.navigationController popToRootViewControllerAnimated:YES];
    } else {
        [self refreshButton];
    }
}

-(void) showPickerActionSheet {
    
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:@"Select the number of employees" delegate:self cancelButtonTitle:@"Done" destructiveButtonTitle:nil otherButtonTitles:nil];
    
    actionSheet.actionSheetStyle = UIActionSheetStyleAutomatic;
    
    self.employeePickerView = [[UIPickerView alloc] initWithFrame:CGRectMake(0,103, 320, 103)];
    self.employeePickerView.delegate = self;
    self.employeePickerView.showsSelectionIndicator  = YES;

    [actionSheet addSubview:self.employeePickerView];
    
    [actionSheet showInView:self.view];
    
    [actionSheet setBounds:CGRectMake(0,0, 320, 420)];
    
    self.employeePickerView.hidden = NO;
    
    self.company.numberOfEmployees = [NSNumber numberWithInt:1];
    
    [self refreshButton];
}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
	return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
	return 11;
	
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    
    NSString *employeeNumber = @"";
    
    if(row == 0) {
        employeeNumber = @"Just Me";
    } else if(row == 1) {
        employeeNumber = @"1";
    } else if(row == 2) {
        employeeNumber = @"2";
    } else if(row == 3) {
        employeeNumber = @"3";
    } else if(row == 4) {
        employeeNumber = @"4";
    } else if(row == 5) {
        employeeNumber = @"5";
    } else if(row == 6) {
        employeeNumber = @"6";
    } else if(row == 7) {
        employeeNumber = @"7";
    } else if(row == 8) {
        employeeNumber = @"8";
    } else if(row == 9) {
        employeeNumber = @"9";
    } else if(row == 10) {
        employeeNumber = @"10+";
    }

	return employeeNumber;
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    self.company.numberOfEmployees = [NSNumber numberWithInteger:[pickerView selectedRowInComponent:0]+1];
}

# pragma mark UIActionSheet Delegate

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger) buttonIndex {
    [self refreshButton];
}

-(void) refreshButton {
    [self.employeeButton setTitle:[self employeeButtonTitle] forState:UIControlStateNormal];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
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