//
//  SSEmployeeSalaryAmountsViewController.m
//  CENTRO
//
//  Created by Centro Community Partners.
//  Copyright (c) 2013 Centro Community Partners. All rights reserved.
//

#import "SSEmployeeSalaryAmountsViewController.h"
#import "SSUser.h"
#import "Employee.h"

@interface SSEmployeeSalaryAmountsViewController ()

@property (strong, nonatomic) NSManagedObjectContext *context;
@property (strong, nonatomic) NSArray *employees;

@property int currentPos;

@end

@implementation SSEmployeeSalaryAmountsViewController


- (IBAction)nextButtonPressed:(id)sender {
    if ([self canContinueAfterValidateInputs]) {
        [self saveCurrent];
        self.currentPos++;
        if (self.currentPos < self.employees.count) {
            [self continueAsking];
        } else {
            [self.context save:nil];
            [self performSegueWithIdentifier:@"WorkingWeeks" sender:self];
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
    
    UIImage *bg = [UIImage imageNamed:@"bg.png"];
    self.backgroundImageView.image = bg;
    self.backgroundImageView.contentMode = UIViewContentModeCenter;
    
    self.context = [(id)[[UIApplication sharedApplication] delegate] managedObjectContext];
    
    [self.frequencySegmentedControl addTarget:self
                                       action:@selector(frequencyChanged)
                             forControlEvents:UIControlEventValueChanged];
    
    [self.frequencySegmentedControl setTitle:@"Week" forSegmentAtIndex:0];
    [self.frequencySegmentedControl setTitle:@"Month" forSegmentAtIndex:1];
    [self.frequencySegmentedControl setTitle:@"Year" forSegmentAtIndex:2];
    
    
    UIBarButtonItem *nextScreenBackButton = [[UIBarButtonItem alloc] initWithTitle:@"Salary" style:UIBarButtonItemStyleBordered target:self action:nil];
    self.navigationItem.backBarButtonItem = nextScreenBackButton;
    
    self.navigationItem.title = @"Salary";
}

-(void) viewDidAppear:(BOOL)animated {
    
    [super viewDidAppear:animated];
    
    self.currentPos = 0;
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Employee"
                                              inManagedObjectContext:self.context];
    [fetchRequest setEntity:entity];
    
    [fetchRequest setPredicate:[NSPredicate predicateWithFormat:@"companyID = %@ AND selectedAsEmployee = 1", [[SSUser currentUser] companyID]]];
    
    fetchRequest.sortDescriptors = [NSArray arrayWithObject:[NSSortDescriptor sortDescriptorWithKey:@"employeeID" ascending:YES selector:nil]];
    
    NSError *error;
    self.employees = [self.context executeFetchRequest:fetchRequest error:&error];
    
    if (self.employees.count == 0) {
        
        [self performSegueWithIdentifier:@"WorkingWeeks" sender:self];
    } else {
        
        NSString *employeeName = [[self.employees objectAtIndex:self.currentPos]name];
        
        if ([[[self.employees objectAtIndex:self.currentPos] myself] isEqualToNumber:[NSNumber numberWithBool:YES]]) {
            self.questionLabel.text = [NSString stringWithFormat:@"How much do you earn?"];
        } else {
            self.questionLabel.text = [NSString stringWithFormat:@"How much does %@ earn?", employeeName];
        }
        
        self.amountTextField.text = [[(Employee *) [self.employees objectAtIndex:self.currentPos] earning] stringValue];
        
        self.frequencySegmentedControl.selectedSegmentIndex = [[(Employee *) [self.employees objectAtIndex:self.currentPos] earningFrequency] intValue] - 2;
        
        self.backButton.hidden = YES;
    }
    
    self.frequencyLabel.text = @"per";
    
}

-(void) frequencyChanged {
    [self.amountTextField resignFirstResponder];
    
    [(Employee *) [self.employees objectAtIndex:self.currentPos] setEarningFrequency:[NSNumber numberWithInt:self.frequencySegmentedControl.selectedSegmentIndex+2]];
}


-(void) saveCurrent {
    [(Employee *) [self.employees objectAtIndex:self.currentPos] setEarning:[NSNumber numberWithDouble:[self.amountTextField.text doubleValue]]];
    
    self.amountTextField.text = @"";
}

-(void) continueAsking {
    
    if (self.currentPos > 0) {
        self.backButton.hidden = NO;
    } else if (self.currentPos == 0) {
        self.backButton.hidden = YES;
    }
    
    self.amountTextField.text = [[(Employee *) [self.employees objectAtIndex:self.currentPos] earning] stringValue];
    NSString *employeeName = [[self.employees objectAtIndex:self.currentPos]name];
    
    if ([[[self.employees objectAtIndex:self.currentPos] myself] isEqualToNumber:[NSNumber numberWithBool:YES]]) {
        self.questionLabel.text = [NSString stringWithFormat:@"How much do you earn?"];
    } else {
        self.questionLabel.text = [NSString stringWithFormat:@"How much does %@ earn?", employeeName];
    }
    self.frequencySegmentedControl.selectedSegmentIndex = [[(Employee *) [self.employees objectAtIndex:self.currentPos] earningFrequency] intValue] - 2;
}

-(BOOL) canContinueAfterValidateInputs {
    BOOL continueAfter = NO;
    
    int frequency = [[(Employee *) [self.employees objectAtIndex:self.currentPos] earningFrequency] intValue];
    if (frequency < 2 || frequency > 4) {
        continueAfter = NO;
        [[[UIAlertView alloc] initWithTitle:@"Selection Error"
                                    message:@"You need to select a frequency before continue."
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