//
//  SSEmployeeWorkingWeeksViewController.m
//  CENTRO
//
//  Created by Centro Community Partners.
//  Copyright (c) 2013 Centro Community Partners. All rights reserved.
//

#import "SSEmployeeWorkingWeeksViewController.h"
#import "SSUser.h"
#import "Employee.h"
#import "SSEmployeeBenefitsViewController.h"

@interface SSEmployeeWorkingWeeksViewController ()

@property (strong, nonatomic) NSManagedObjectContext *context;
@property (strong, nonatomic) NSArray *employees;

@property int currentPos;

@property BOOL popToRoot;

@end

@implementation SSEmployeeWorkingWeeksViewController

- (IBAction)nextButtonPressed:(id)sender {
    if ([self canContinueAfterValidateInputs]) {
        [self saveCurrent];
        self.currentPos++;
        if (self.currentPos < self.employees.count) {
            [self continueAsking];
        } else {
            [self.context save:nil];
            [self performSegueWithIdentifier:@"EmployeeBenefits" sender:self];
        }
    }
}
- (IBAction)backButtonPressed:(id)sender {
    self.currentPos--;
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
    
    UIBarButtonItem *nextScreenBackButton = [[UIBarButtonItem alloc] initWithTitle:@"Weeks" style:UIBarButtonItemStyleBordered target:self action:nil];
    self.navigationItem.backBarButtonItem = nextScreenBackButton;
    
    self.navigationItem.title = @"Working Weeks";
}

-(void) viewDidAppear:(BOOL)animated {
    
    [super viewDidAppear:animated];
    
    self.currentPos = 0;
    
    self.popToRoot = NO;
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Employee"
                                              inManagedObjectContext:self.context];
    [fetchRequest setEntity:entity];
    
    [fetchRequest setPredicate:[NSPredicate predicateWithFormat:@"companyID = %@ AND selectedAsEmployee = 1 AND earningFrequency = 2", [[SSUser currentUser] companyID]]];
    
    fetchRequest.sortDescriptors = [NSArray arrayWithObject:[NSSortDescriptor sortDescriptorWithKey:@"employeeID" ascending:YES selector:nil]];
    
    NSError *error;
    self.employees = [self.context executeFetchRequest:fetchRequest error:&error];
    
    if (self.employees.count == 0) {
        
        self.popToRoot = YES;
        [self performSegueWithIdentifier:@"EmployeeBenefits" sender:self];
    } else {
        
        NSString *employeeName = [[self.employees objectAtIndex:self.currentPos]name];
        
        if ([[[self.employees objectAtIndex:self.currentPos] myself] isEqualToNumber:[NSNumber numberWithBool:YES]]) {
            self.questionLabel.text = [NSString stringWithFormat:@"How many weeks do you work per year? (1 year has 52 weeks)"];
        } else {
            self.questionLabel.text = [NSString stringWithFormat:@"How many weeks does %@ work per year? (1 year has 52 weeks)", employeeName];
        }
        
        self.amountTextField.text = [[(Employee *) [self.employees objectAtIndex:self.currentPos] weeksWork] stringValue];
        
        self.backButton.hidden = YES;
    }
}

-(void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if([segue.identifier isEqualToString:@"EmployeeBenefits"]) {
        SSEmployeeBenefitsViewController *employeeBenefitsViewController = (SSEmployeeBenefitsViewController *) segue.destinationViewController;
        
        employeeBenefitsViewController.popToRoot = self.popToRoot;
        
        if (self.popToRoot) {
            UIBarButtonItem *nextScreenBackButton = [[UIBarButtonItem alloc] initWithTitle:@"Salary" style:UIBarButtonItemStyleBordered target:self action:nil];
            self.navigationItem.backBarButtonItem = nextScreenBackButton;
        }
    }
}

-(void) saveCurrent {
    [(Employee *) [self.employees objectAtIndex:self.currentPos] setWeeksWork:[NSNumber numberWithInt:[self.amountTextField.text intValue]]];
    
    self.amountTextField.text = @"";
}

-(void) continueAsking {
    
    if (self.currentPos > 0) {
        self.backButton.hidden = NO;
    } else if (self.currentPos == 0) {
        self.backButton.hidden = YES;
    }
    
    self.amountTextField.text = [[(Employee *) [self.employees objectAtIndex:self.currentPos] weeksWork] stringValue];
    NSString *employeeName = [[self.employees objectAtIndex:self.currentPos]name];
    
    if ([[[self.employees objectAtIndex:self.currentPos] myself] isEqualToNumber:[NSNumber numberWithBool:YES]]) {
        self.questionLabel.text = [NSString stringWithFormat:@"How many weeks do you work per year? (1 year has 52 weeks)"];
    } else {
        self.questionLabel.text = [NSString stringWithFormat:@"How many weeks does %@ work per year? (1 year has 52 weeks)", employeeName];
    }
}

-(BOOL) canContinueAfterValidateInputs {
    BOOL continueAfter = NO;
    
    int workingWeeks = [self.amountTextField.text intValue];
    if (workingWeeks <= 0 || workingWeeks > 52) {
        continueAfter = NO;
        [[[UIAlertView alloc] initWithTitle:@"Selection Error"
                                    message:@"Working weeks must be greater than zero and equal or less than 52."
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

@end