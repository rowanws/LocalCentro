//
//  SSPersonalCostAmountsViewController.m
//  CENTRO
//
//  Created by Centro Community Partners.
//  Copyright (c) 2013 Centro Community Partners. All rights reserved.
//

#import "SSPersonalCostAmountsViewController.h"
#import "SSUser.h"
#import "StudentCost.h"
#import "SSPersonalBudgetTableViewController.h"

@interface SSPersonalCostAmountsViewController ()

@property (strong, nonatomic) NSManagedObjectContext *context;
@property (strong, nonatomic) NSArray *costs;

@property BOOL isSureForCurrentCost;
//@property int currentFrecuency;
//@property int currentAmount;
@property int currentCostPos;

@end

@implementation SSPersonalCostAmountsViewController


- (IBAction)nextButtonPressed:(id)sender {
    if ([self canContinueAfterValidateInputs]) {
        [self saveCurrent];
        self.currentCostPos++;
        if (self.currentCostPos < self.costs.count) {
            [self continueAsking];
        } else {
            [self.context save:nil];
            [self performSegueWithIdentifier:@"PersonalBudget" sender:self];
        }
    }
}
- (IBAction)backButtonPressed:(id)sender {
    self.currentCostPos--;
    [self continueAsking];
}

- (IBAction)sureButtonPressed:(id)sender {
    
    self.isSureForCurrentCost = !self.isSureForCurrentCost;
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
    //self.backgroundImageView.contentMode = UIViewContentModeCenter;
    
    self.context = [(id)[[UIApplication sharedApplication] delegate] managedObjectContext];
    
    self.navigationItem.title = @"Personal Costs";
    
    UIBarButtonItem *nextScreenBackButton = [[UIBarButtonItem alloc] initWithTitle:@"Try Again" style:UIBarButtonItemStyleBordered target:self action:nil];
    self.navigationItem.backBarButtonItem = nextScreenBackButton;
    
    [self.frequencySegmentedControl addTarget:self
                                       action:@selector(frequencyChanged)
                             forControlEvents:UIControlEventValueChanged];
    
    [self.frequencySegmentedControl setTitle:@"Day" forSegmentAtIndex:0];
    [self.frequencySegmentedControl setTitle:@"Week" forSegmentAtIndex:1];
    [self.frequencySegmentedControl setTitle:@"Month" forSegmentAtIndex:2];
    [self.frequencySegmentedControl setTitle:@"Year" forSegmentAtIndex:3];
    
        
}

-(void) viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    self.currentCostPos = 0;
    
    NSFetchRequest *studentCostFetchRequest = [[NSFetchRequest alloc] init];
    
    NSEntityDescription *studentCostEntity = [NSEntityDescription entityForName:@"StudentCost"
                                                         inManagedObjectContext:self.context];
    [studentCostFetchRequest setEntity:studentCostEntity];
    
    [studentCostFetchRequest setPredicate:[NSPredicate predicateWithFormat:@"studentID = %@ AND selectedAsIncurredCost = 1", [[SSUser currentUser] studentID]]];
    
    studentCostFetchRequest.sortDescriptors = [NSArray arrayWithObject:[NSSortDescriptor sortDescriptorWithKey:@"studentCostID" ascending:YES selector:nil]];
    
    NSError *errorSV;
    self.costs = [self.context executeFetchRequest:studentCostFetchRequest error:&errorSV];
    
    if (self.costs.count == 0) {
        [self performSegueWithIdentifier:@"PersonalBudget" sender:self];
    } else {
        
        self.amountTextField.text = [[(StudentCost *) [self.costs objectAtIndex:self.currentCostPos] amount] stringValue];
        self.questionLabel.text = [NSString stringWithFormat:@"How much do you spend on %@?", [(StudentCost *) [self.costs objectAtIndex:self.currentCostPos] studentCostLiteralUS]];
        self.frequencySegmentedControl.selectedSegmentIndex = [[(StudentCost *) [self.costs objectAtIndex:self.currentCostPos] frequency] intValue] - 1;
        self.isSureForCurrentCost = [[(StudentCost *) [self.costs objectAtIndex:self.currentCostPos] isSure] boolValue];
        [self drawSureButton];
        self.backButton.hidden = YES;
    }
    
    self.frequencyLabel.text = @"per";

}

-(void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if([segue.identifier isEqualToString:@"PersonalBudget"]) {
        SSPersonalBudgetTableViewController *personalBudgetTableViewController = (SSPersonalBudgetTableViewController *) segue.destinationViewController;
        
        if(self.costs.count == 0) {
            personalBudgetTableViewController.popToRoot = YES;
        } else {
            personalBudgetTableViewController.popToRoot = NO;
        }
    }
}


-(void) drawSureButton {
    if(!self.isSureForCurrentCost) {
        [self.sureButton setTitle:@"☑ I'm not sure yet" forState:UIControlStateNormal];
    } else {
        [self.sureButton setTitle:@"☐ I'm not sure yet" forState:UIControlStateNormal];
    }
}

-(void) frequencyChanged {
    [self.amountTextField resignFirstResponder];
    
    [(StudentCost *) [self.costs objectAtIndex:self.currentCostPos] setFrequency:[NSNumber numberWithInt:self.frequencySegmentedControl.selectedSegmentIndex+1]];
    
    
}


-(void) saveCurrent {

    [(StudentCost *) [self.costs objectAtIndex:self.currentCostPos] setAmount:[NSNumber numberWithDouble:[self.amountTextField.text doubleValue]]];
    [(StudentCost *) [self.costs objectAtIndex:self.currentCostPos] setIsSure:[NSNumber numberWithBool:self.isSureForCurrentCost]];
    
    double monthlyAmount = 0.0; 
    if([[(StudentCost *) [self.costs objectAtIndex:self.currentCostPos] frequency] isEqual:[NSNumber numberWithInt:1]]) {
        monthlyAmount = [self.amountTextField.text doubleValue] * 30;
    } else if([[(StudentCost *) [self.costs objectAtIndex:self.currentCostPos] frequency] isEqual:[NSNumber numberWithInt:2]]) {
        monthlyAmount = [self.amountTextField.text doubleValue] * 4;
    } else if([[(StudentCost *) [self.costs objectAtIndex:self.currentCostPos] frequency] isEqual:[NSNumber numberWithInt:4]]) {
        monthlyAmount = [self.amountTextField.text doubleValue] / 12;
    } else {
        monthlyAmount = [self.amountTextField.text doubleValue];
    }
    
    [(StudentCost *) [self.costs objectAtIndex:self.currentCostPos] setMonthlyAmount:[NSNumber numberWithDouble:monthlyAmount]];
    
    self.amountTextField.text = @"";
}

-(BOOL) canContinueAfterValidateInputs {
    BOOL continueAfter = NO;
    
    int frequency = [[(StudentCost *) [self.costs objectAtIndex:self.currentCostPos] frequency] intValue];
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

-(void) continueAsking {
    
    if (self.currentCostPos > 0) {
        self.backButton.hidden = NO;
    } else if (self.currentCostPos == 0) {
        self.backButton.hidden = YES;
    }
    
    self.amountTextField.text = [[(StudentCost *) [self.costs objectAtIndex:self.currentCostPos] amount] stringValue];
    self.questionLabel.text = [NSString stringWithFormat:@"How much do you spend on %@?", [(StudentCost *) [self.costs objectAtIndex:self.currentCostPos] studentCostLiteralUS]];
    self.frequencySegmentedControl.selectedSegmentIndex = [[(StudentCost *) [self.costs objectAtIndex:self.currentCostPos] frequency] intValue] - 1;
    self.isSureForCurrentCost = [[(StudentCost *) [self.costs objectAtIndex:self.currentCostPos] isSure] boolValue];
    [self drawSureButton];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {

    [self.amountTextField resignFirstResponder];
    
}

@end