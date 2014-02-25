//
//  SSEmployeeHoursPerActivityViewController.m
//  CENTRO
//
//  Created by Centro Community Partners.
//  Copyright (c) 2013 Centro Community Partners. All rights reserved.
//

#import "SSEmployeeHoursPerActivityViewController.h"
#import "SSUser.h"
#import "Employee.h"
#import "Responsibility.h"
#import "EmployeeResponsibility.h"

@interface SSEmployeeHoursPerActivityViewController ()

@property (strong, nonatomic) NSManagedObjectContext *context;
@property (strong, nonatomic) NSArray *employeeResponsibility;

@property int currentEmployeeResponsibilityPos;

@end

@implementation SSEmployeeHoursPerActivityViewController

- (IBAction)nextButtonPressed:(id)sender {
    if ([self canContinueAfterValidateInputs]) {
        [self saveCurrent];
        self.currentEmployeeResponsibilityPos++;
        if (self.currentEmployeeResponsibilityPos < self.employeeResponsibility.count) {
            [self continueAsking];
        } else {
            [self.context save:nil];
            [self performSegueWithIdentifier:@"CompetencyAssessment" sender:self];
        }
    }
}

- (void)silentNextButtonPressed{
    
    self.currentEmployeeResponsibilityPos++;
    if (self.currentEmployeeResponsibilityPos < self.employeeResponsibility.count) {
        [self continueAsking];
    } else {
        [self.context save:nil];
        [self performSegueWithIdentifier:@"CompetencyAssessment" sender:self];
    }
    
}

- (IBAction)backButtonPressed:(id)sender {
    self.currentEmployeeResponsibilityPos--;
    [self continueAsking];
}

-(void) viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    if(![[SSUser currentUser] isLoggedIn]) {
        [self.navigationController popToRootViewControllerAnimated:YES];
    }
}


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {

    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    //UIImage *bg = [UIImage imageNamed:@"bg.png"];
    //self.backgroundImageView.image = bg;
    //self.backgroundImageView.contentMode = UIViewContentModeCenter;
    
    self.context = [(id)[[UIApplication sharedApplication] delegate] managedObjectContext];
    
    [self.frequencySegmentedControl addTarget:self
                                       action:@selector(frequencyChanged)
                             forControlEvents:UIControlEventValueChanged];
    
    [self.frequencySegmentedControl setTitle:@"Day" forSegmentAtIndex:0];
    [self.frequencySegmentedControl setTitle:@"Week" forSegmentAtIndex:1];
    [self.frequencySegmentedControl setTitle:@"Month" forSegmentAtIndex:2];
    
    
    UIBarButtonItem *nextScreenBackButton = [[UIBarButtonItem alloc] initWithTitle:@"Time" style:UIBarButtonItemStyleBordered target:self action:nil];
    self.navigationItem.backBarButtonItem = nextScreenBackButton;
    
    self.navigationItem.title = @"Activity Time";
    
    self.frequencyLabel.text = @"per";
        
}

-(void) viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    self.currentEmployeeResponsibilityPos = 0;
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"EmployeeResponsibility"
                                              inManagedObjectContext:self.context];
    [fetchRequest setEntity:entity];
    
    [fetchRequest setPredicate:[NSPredicate predicateWithFormat:@"companyID = %@ AND selectedAsResponsibility = 1", [[SSUser currentUser] companyID]]];
    
    fetchRequest.sortDescriptors = [NSArray arrayWithObject:[NSSortDescriptor sortDescriptorWithKey:@"employeeID" ascending:NO selector:nil]];
    
    NSError *error;
    self.employeeResponsibility = [self.context executeFetchRequest:fetchRequest error:&error];
    
    if (self.employeeResponsibility.count == 0) {
        
        [self performSegueWithIdentifier:@"CompetencyAssessment" sender:self];
    } else {
        NSString *employeeName = [self employeeNameForEmployee:[[self.employeeResponsibility[self.currentEmployeeResponsibilityPos] employeeID] stringValue]];
        NSString *activityDesc = [self responsibilityDescriptionForResponsibility:[[self.employeeResponsibility[self.currentEmployeeResponsibilityPos] responsibilityID] stringValue]];
        
        if ([employeeName isEqualToString:@""] || [activityDesc isEqualToString:@""]) {
            [self silentNextButtonPressed];
        } else {
            if ([employeeName isEqualToString:@"You"]) {
                self.questionLabel.text = [NSString stringWithFormat:@"How many hours do you spend %@?", activityDesc];
            } else {
                self.questionLabel.text = [NSString stringWithFormat:@"How many hours does %@ spend %@?", employeeName, activityDesc];
            }
            
            self.amountTextField.text = [[self.employeeResponsibility[self.currentEmployeeResponsibilityPos] hoursNeeded] stringValue];
            
            self.frequencySegmentedControl.selectedSegmentIndex = [[self.employeeResponsibility[self.currentEmployeeResponsibilityPos] frequencyHoursNeeded] intValue] - 1;
            
            self.backButton.hidden = YES;
        }
    }
}

-(NSString *) employeeNameForEmployee:(NSString *) employeeID  {
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Employee"
                                              inManagedObjectContext:self.context];
    [fetchRequest setEntity:entity];
    
    [fetchRequest setPredicate:[NSPredicate predicateWithFormat:@"employeeID = %@", employeeID]];
    
    fetchRequest.sortDescriptors = [NSArray arrayWithObject:[NSSortDescriptor sortDescriptorWithKey:@"employeeID" ascending:NO selector:nil]];
    
    NSError *error;
    NSArray *fetchedObjects = [self.context executeFetchRequest:fetchRequest error:&error];
    
    if (fetchedObjects.count == 0) {
        
        return @"";
    } else {
        return [fetchedObjects[0] name];
    }
}

-(NSString *) responsibilityDescriptionForResponsibility:(NSString *) responsibilityID  {

    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Responsibility"
                                              inManagedObjectContext:self.context];
    [fetchRequest setEntity:entity];
    
    [fetchRequest setPredicate:[NSPredicate predicateWithFormat:@"responsibilityID = %@", responsibilityID]];
    
    fetchRequest.sortDescriptors = [NSArray arrayWithObject:[NSSortDescriptor sortDescriptorWithKey:@"responsibilityID" ascending:NO selector:nil]];
    
    NSError *error;
    NSArray *fetchedObjects = [self.context executeFetchRequest:fetchRequest error:&error];
    
    if (fetchedObjects.count == 0) {
        
        return @"";
    } else {
        return [fetchedObjects[0] responsibilityDescription];
    }
}

-(void) frequencyChanged {
    [self.amountTextField resignFirstResponder];
    
    [self.employeeResponsibility[self.currentEmployeeResponsibilityPos] setFrequencyHoursNeeded:[NSNumber numberWithInt:self.frequencySegmentedControl.selectedSegmentIndex+1]];
}


-(void) saveCurrent {
    [self.employeeResponsibility[self.currentEmployeeResponsibilityPos] setHoursNeeded:[NSNumber numberWithDouble:[self.amountTextField.text intValue]]];
    
    self.amountTextField.text = @"";
}

-(void) continueAsking {

    if (self.currentEmployeeResponsibilityPos > 0) {
        self.backButton.hidden = NO;
    } else if (self.currentEmployeeResponsibilityPos == 0) {
        self.backButton.hidden = YES;
    }
    
    NSString *employeeName = [self employeeNameForEmployee:[[self.employeeResponsibility[self.currentEmployeeResponsibilityPos] employeeID] stringValue]];
    NSString *activityDesc = [self responsibilityDescriptionForResponsibility:[[self.employeeResponsibility[self.currentEmployeeResponsibilityPos] responsibilityID] stringValue]];
    
    if ([employeeName isEqualToString:@""] || [activityDesc isEqualToString:@""]) {
        [self silentNextButtonPressed];
    } else {
        
        if ([employeeName isEqualToString:@"You"]) {
            self.questionLabel.text = [NSString stringWithFormat:@"How many hours do you spend %@?", activityDesc];
        } else {
            self.questionLabel.text = [NSString stringWithFormat:@"How many hours does %@ spend %@?", employeeName, activityDesc];
        }
        
        self.amountTextField.text = [[self.employeeResponsibility[self.currentEmployeeResponsibilityPos] hoursNeeded] stringValue];
        
        self.frequencySegmentedControl.selectedSegmentIndex = [[self.employeeResponsibility[self.currentEmployeeResponsibilityPos] frequencyHoursNeeded] intValue] - 1;
    }
}

-(BOOL) canContinueAfterValidateInputs {
    BOOL continueAfter = NO;
    
    int amount = [self.amountTextField.text intValue];
    
    int frequency = [[(EmployeeResponsibility *) [self.employeeResponsibility objectAtIndex:self.currentEmployeeResponsibilityPos] frequencyHoursNeeded] intValue];
    if (frequency < 1 || frequency > 3) {
        continueAfter = NO;
        [[[UIAlertView alloc] initWithTitle:@"Selection Error"
                                    message:@"You need to select a frequency before continue."
                                   delegate:nil
                          cancelButtonTitle:@"OK"
                          otherButtonTitles:nil] show];
    } else if(frequency == 1 && (amount <= 0 || amount > 24)) {
        [[[UIAlertView alloc] initWithTitle:@"Selection Error"
                                    message:@"Hours per day must be greater than zero and equal or less to 24."
                                   delegate:nil
                          cancelButtonTitle:@"OK"
                          otherButtonTitles:nil] show];
    } else if(frequency == 2 && (amount <= 0 || amount > 168)) {
        [[[UIAlertView alloc] initWithTitle:@"Selection Error"
                                    message:@"Hours per week must be greater than zero and equal or less to 168."
                                   delegate:nil
                          cancelButtonTitle:@"OK"
                          otherButtonTitles:nil] show];
    } else if(frequency == 3 && (amount <= 0 || amount > 744)) {
        [[[UIAlertView alloc] initWithTitle:@"Selection Error"
                                    message:@"Hours per month must be greater than zero and equal or less to 744."
                                   delegate:nil
                          cancelButtonTitle:@"OK"
                          otherButtonTitles:nil] show];
    } else {
        continueAfter = YES;
    }
    
    return continueAfter;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {

    [self.amountTextField resignFirstResponder];
    
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