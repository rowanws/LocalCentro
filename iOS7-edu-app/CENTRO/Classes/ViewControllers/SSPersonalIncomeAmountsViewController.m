//
//  SSPersonalIncomeAmountsViewController.m
//  CENTRO
//
//  Created by Centro Community Partners.
//  Copyright (c) 2013 Centro Community Partners. All rights reserved.
//

#import "SSPersonalIncomeAmountsViewController.h"
#import "SSUser.h"
#import "StudentIncome.h"
#import "SSPersonalIncomeTableViewController.h"

@interface SSPersonalIncomeAmountsViewController ()

@property (strong, nonatomic) NSManagedObjectContext *context;
@property (strong, nonatomic) NSArray *incomes;

@property BOOL isSureForCurrentIncome;
@property int currentIncomePos;

@end

@implementation SSPersonalIncomeAmountsViewController


- (IBAction)nextButtonPressed:(id)sender {
    if ([self canContinueAfterValidateInputs]) {
        [self saveCurrent];
        self.currentIncomePos++;
        if (self.currentIncomePos < self.incomes.count) {
            [self continueAsking];
        } else {
            [self.context save:nil];
            [self performSegueWithIdentifier:@"PersonalIncome" sender:self];
        }
    }
}

- (IBAction)backButtonPressed:(id)sender {
    self.currentIncomePos--;
    [self continueAsking];
}

- (IBAction)sureButtonPressed:(id)sender {
    self.isSureForCurrentIncome = !self.isSureForCurrentIncome;
    [self drawSureButton];
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
    self.backgroundImageView.contentMode = UIViewContentModeCenter;
    
    self.context = [(id)[[UIApplication sharedApplication] delegate] managedObjectContext];
    
    [self.frequencySegmentedControl addTarget:self
                                       action:@selector(frequencyChanged)
                             forControlEvents:UIControlEventValueChanged];
    
    [self.frequencySegmentedControl setTitle:@"Day" forSegmentAtIndex:0];
    [self.frequencySegmentedControl setTitle:@"Week" forSegmentAtIndex:1];
    [self.frequencySegmentedControl setTitle:@"Month" forSegmentAtIndex:2];
    [self.frequencySegmentedControl setTitle:@"Year" forSegmentAtIndex:3];
    
    
    UIBarButtonItem *nextScreenBackButton = [[UIBarButtonItem alloc] initWithTitle:@"Try Again" style:UIBarButtonItemStyleBordered target:self action:nil];
    self.navigationItem.backBarButtonItem = nextScreenBackButton;
    
    self.navigationItem.title = @"Personal Income";
}

-(void) viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    self.currentIncomePos = 0;
    
    NSFetchRequest *studentIncomeFetchRequest = [[NSFetchRequest alloc] init];
    
    NSEntityDescription *studentIncomeEntity = [NSEntityDescription entityForName:@"StudentIncome"
                                                         inManagedObjectContext:self.context];
    [studentIncomeFetchRequest setEntity:studentIncomeEntity];
    
    [studentIncomeFetchRequest setPredicate:[NSPredicate predicateWithFormat:@"studentID = %@ AND selectedAsSourceOfIncome = 1", [[SSUser currentUser] studentID]]];
    
    studentIncomeFetchRequest.sortDescriptors = [NSArray arrayWithObject:[NSSortDescriptor sortDescriptorWithKey:@"studentIncomeID" ascending:YES selector:nil]];
    
    NSError *errorSV;
    self.incomes = [self.context executeFetchRequest:studentIncomeFetchRequest error:&errorSV];
    
    if (self.incomes.count == 0) {
        [self performSegueWithIdentifier:@"PersonalIncome" sender:self];
    } else {
        
        self.amountTextField.text = [[(StudentIncome *) [self.incomes objectAtIndex:self.currentIncomePos] amount] stringValue];
        if([[[self.incomes objectAtIndex:self.currentIncomePos] studentIncomeCode] isEqualToString:@"SIN_HOUS"]) {
            self.questionLabel.text = @"How much total income do other people in your household earn?";
        } else {
            self.questionLabel.text = [NSString stringWithFormat:@"How much do you make from your %@?", [(StudentIncome *) [self.incomes objectAtIndex:self.currentIncomePos] studentIncomeLiteralUS]];
        }
        self.frequencySegmentedControl.selectedSegmentIndex = [[(StudentIncome *) [self.incomes objectAtIndex:self.currentIncomePos] frequency] intValue] - 1;
        self.isSureForCurrentIncome = [[(StudentIncome *) [self.incomes objectAtIndex:self.currentIncomePos] isSure] boolValue];
        [self drawSureButton];
        self.backButton.hidden = YES;
    }
    
    self.frequencyLabel.text = @"per";
}

-(void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if([segue.identifier isEqualToString:@"PersonalIncome"]) {
        SSPersonalIncomeTableViewController *personalIncomeTableViewController = (SSPersonalIncomeTableViewController *) segue.destinationViewController;
        
        if(self.incomes.count == 0) {
            personalIncomeTableViewController.popToRoot = YES;
        } else {
            personalIncomeTableViewController.popToRoot = NO;
        }
    }
}

-(void) drawSureButton {
    if(!self.isSureForCurrentIncome) {
        [self.sureButton setTitle:@"☑ I'm not sure yet" forState:UIControlStateNormal];
    } else {
        [self.sureButton setTitle:@"☐ I'm not sure yet" forState:UIControlStateNormal];
    }
}

-(void) frequencyChanged {
    [self.amountTextField resignFirstResponder];
    
    [(StudentIncome *) [self.incomes objectAtIndex:self.currentIncomePos] setFrequency:[NSNumber numberWithInt:self.frequencySegmentedControl.selectedSegmentIndex+1]];
}


-(void) saveCurrent {

    [(StudentIncome *) [self.incomes objectAtIndex:self.currentIncomePos] setAmount:[NSNumber numberWithDouble:[self.amountTextField.text doubleValue]]];
    [(StudentIncome *) [self.incomes objectAtIndex:self.currentIncomePos] setIsSure:[NSNumber numberWithBool:self.isSureForCurrentIncome]];
    
    double monthlyAmount = 0.0;
    if([[(StudentIncome *) [self.incomes objectAtIndex:self.currentIncomePos] frequency] isEqual:[NSNumber numberWithInt:1]]) {
        if ([[(StudentIncome *) [self.incomes objectAtIndex:self.currentIncomePos] studentIncomeCode] isEqualToString:@"SIN_JOB"] ||
            [[(StudentIncome *) [self.incomes objectAtIndex:self.currentIncomePos] studentIncomeCode] isEqualToString:@"SIN_2JOB"]) {
            monthlyAmount = [self.amountTextField.text doubleValue] * 21;
        } else {
            monthlyAmount = [self.amountTextField.text doubleValue] * 30;
        }
    } else if([[(StudentIncome *) [self.incomes objectAtIndex:self.currentIncomePos] frequency] isEqual:[NSNumber numberWithInt:2]]) {
        monthlyAmount = [self.amountTextField.text doubleValue] * 4;
    } else if([[(StudentIncome *) [self.incomes objectAtIndex:self.currentIncomePos] frequency] isEqual:[NSNumber numberWithInt:4]]) {
        monthlyAmount = [self.amountTextField.text doubleValue] / 12;
    } else {
        monthlyAmount = [self.amountTextField.text doubleValue];
    }
    
    [(StudentIncome *) [self.incomes objectAtIndex:self.currentIncomePos] setMonthlyAmount:[NSNumber numberWithDouble:monthlyAmount]];
    
    
    self.amountTextField.text = @"";
}

-(void) continueAsking {
    
    if (self.currentIncomePos > 0) {
        self.backButton.hidden = NO;
    } else if (self.currentIncomePos == 0) {
        self.backButton.hidden = YES;
    }
    
    if([[[self.incomes objectAtIndex:self.currentIncomePos] studentIncomeCode] isEqualToString:@"SIN_HOUS"]) {
        self.questionLabel.text = @"How much total income do other people in your household earn?";
    } else {
        self.questionLabel.text = [NSString stringWithFormat:@"How much do you make from your %@?", [(StudentIncome *) [self.incomes objectAtIndex:self.currentIncomePos] studentIncomeLiteralUS]];
    }
    
    self.amountTextField.text = [[(StudentIncome *) [self.incomes objectAtIndex:self.currentIncomePos] amount] stringValue];
    self.frequencySegmentedControl.selectedSegmentIndex = [[(StudentIncome *) [self.incomes objectAtIndex:self.currentIncomePos] frequency] intValue] - 1;
    self.isSureForCurrentIncome = [[(StudentIncome *) [self.incomes objectAtIndex:self.currentIncomePos] isSure] boolValue];
    [self drawSureButton];

}

-(BOOL) canContinueAfterValidateInputs {
    BOOL continueAfter = NO;
    
    int frequency = [[(StudentIncome *) [self.incomes objectAtIndex:self.currentIncomePos] frequency] intValue];
    if (frequency < 1 || frequency > 4) {
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

-(IBAction)dismissVC{
    [self dismissViewControllerAnimated:YES completion:NULL];
}

@end