//
//  SSBusinessCostAmountsViewController.m
//  CENTRO
//
//  Created by Centro Community Partners.
//  Copyright (c) 2013 Centro Community Partners. All rights reserved.
//

#import "SSBusinessCostAmountsViewController.h"
#import "SSUser.h"
#import "CompanyCost.h"
#import "Company.h"
#import "SSBusinessBudgetTableViewController.h"

@interface SSBusinessCostAmountsViewController ()

@property (strong, nonatomic) NSManagedObjectContext *context;
@property (strong, nonatomic) NSArray *costs;
@property (strong, nonatomic) NSString *companyName;

@property BOOL isSureForCurrentCost;
@property int currentCostPos;

@end

@implementation SSBusinessCostAmountsViewController


- (IBAction)nextButtonPressed:(id)sender {
    if ([self canContinueAfterValidateInputs]) {
        [self saveCurrent];
        self.currentCostPos++;
        if (self.currentCostPos < self.costs.count) {
            [self continueAsking];
        } else {
            [self.context save:nil];
            [self performSegueWithIdentifier:@"BusinessBudget" sender:self];
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
    
    UIImage *bg = [UIImage imageNamed:@"bg.png"];
    self.backgroundImageView.image = bg;
    self.backgroundImageView.contentMode = UIViewContentModeCenter;
    
    self.context = [(id)[[UIApplication sharedApplication] delegate] managedObjectContext];
    
    self.navigationItem.title = @"Business Costs";
    
    UIBarButtonItem *nextScreenBackButton = [[UIBarButtonItem alloc] initWithTitle:@"Try Again" style:UIBarButtonItemStyleBordered target:self action:nil];
    self.navigationItem.backBarButtonItem = nextScreenBackButton;
    
    [self.frequencySegmentedControl addTarget:self
                                       action:@selector(frequencyChanged)
                             forControlEvents:UIControlEventValueChanged];
    
    [self.frequencySegmentedControl setTitle:@"Day" forSegmentAtIndex:0];
    [self.frequencySegmentedControl setTitle:@"Week" forSegmentAtIndex:1];
    [self.frequencySegmentedControl setTitle:@"Month" forSegmentAtIndex:2];
    [self.frequencySegmentedControl setTitle:@"Year" forSegmentAtIndex:3];
    
    NSFetchRequest *companyFetchRequest = [[NSFetchRequest alloc] init];
    
    NSEntityDescription *companyEntity = [NSEntityDescription entityForName:@"Company"
                                                     inManagedObjectContext:self.context];
    [companyFetchRequest setEntity:companyEntity];
    
    [companyFetchRequest setPredicate:[NSPredicate predicateWithFormat:@"companyID = %@", [[SSUser currentUser] companyID]]];
    
    companyFetchRequest.returnsObjectsAsFaults = NO;
    
    NSError *errorC;
    NSArray *companyFetchedObjects = [self.context executeFetchRequest:companyFetchRequest error:&errorC];
    if (companyFetchedObjects == 0) {
        
        self.companyName = @"Your Company";
    } else {
        Company *tempCompany = (Company *) [companyFetchedObjects objectAtIndex:0];
        if ([tempCompany.name isEqualToString:@""]) {
            self.companyName = @"Your Company";
        } else {
            self.companyName = tempCompany.name;
        }
    }
    
        
}

-(void) viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    self.currentCostPos = 0;
    
    NSFetchRequest *companyCostFetchRequest = [[NSFetchRequest alloc] init];
    
    NSEntityDescription *companyCostEntity = [NSEntityDescription entityForName:@"CompanyCost"
                                                         inManagedObjectContext:self.context];
    [companyCostFetchRequest setEntity:companyCostEntity];
    
    [companyCostFetchRequest setPredicate:[NSPredicate predicateWithFormat:@"companyID = %@ AND selectedAsIncurredCost = 1", [[SSUser currentUser] companyID]]];
    
    companyCostFetchRequest.sortDescriptors = [NSArray arrayWithObject:[NSSortDescriptor sortDescriptorWithKey:@"companyCostID" ascending:YES selector:nil]];
    
    NSError *errorSV;
    self.costs = [self.context executeFetchRequest:companyCostFetchRequest error:&errorSV];
    
    if (self.costs.count == 0) {
        [self performSegueWithIdentifier:@"BusinessBudget" sender:self];
    } else {
        
        self.amountTextField.text = [[(CompanyCost *) [self.costs objectAtIndex:self.currentCostPos] amount] stringValue];
        self.questionLabel.text = [NSString stringWithFormat:@"How much does %@ spend on %@?", self.companyName, [(CompanyCost *) [self.costs objectAtIndex:self.currentCostPos] companyCostLiteralUS]];
        self.frequencySegmentedControl.selectedSegmentIndex = [[(CompanyCost *) [self.costs objectAtIndex:self.currentCostPos] frequency] intValue] - 1;
        self.isSureForCurrentCost = [[(CompanyCost *) [self.costs objectAtIndex:self.currentCostPos] isSure] boolValue];
        [self drawSureButton];
        self.backButton.hidden = YES;
    }
    
    self.frequencyLabel.text = @"per";

}

-(void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if([segue.identifier isEqualToString:@"BusinessBudget"]) {
        SSBusinessBudgetTableViewController *businessBudgetTableViewController = (SSBusinessBudgetTableViewController *) segue.destinationViewController;
        
        if(self.costs.count == 0) {
            businessBudgetTableViewController.popToRoot = YES;
        } else {
            businessBudgetTableViewController.popToRoot = NO;
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
    
    [(CompanyCost *) [self.costs objectAtIndex:self.currentCostPos] setFrequency:[NSNumber numberWithInt:self.frequencySegmentedControl.selectedSegmentIndex+1]];
    
    
}


-(void) saveCurrent {

    [(CompanyCost *) [self.costs objectAtIndex:self.currentCostPos] setAmount:[NSNumber numberWithDouble:[self.amountTextField.text doubleValue]]];
    [(CompanyCost *) [self.costs objectAtIndex:self.currentCostPos] setIsSure:[NSNumber numberWithBool:self.isSureForCurrentCost]];
    
    double monthlyAmount = 0.0; 
    if([[(CompanyCost *) [self.costs objectAtIndex:self.currentCostPos] frequency] isEqual:[NSNumber numberWithInt:1]]) {
        monthlyAmount = [self.amountTextField.text doubleValue] * 30;
    } else if([[(CompanyCost *) [self.costs objectAtIndex:self.currentCostPos] frequency] isEqual:[NSNumber numberWithInt:2]]) {
        monthlyAmount = [self.amountTextField.text doubleValue] * 4;
    } else if([[(CompanyCost *) [self.costs objectAtIndex:self.currentCostPos] frequency] isEqual:[NSNumber numberWithInt:4]]) {
        monthlyAmount = [self.amountTextField.text doubleValue] / 12;
    } else {
        monthlyAmount = [self.amountTextField.text doubleValue];
    }
    
    [(CompanyCost *) [self.costs objectAtIndex:self.currentCostPos] setMonthlyAmount:[NSNumber numberWithDouble:monthlyAmount]];
    
    self.amountTextField.text = @"";
}

-(BOOL) canContinueAfterValidateInputs {
    BOOL continueAfter = NO;
    
    int frequency = [[(CompanyCost *) [self.costs objectAtIndex:self.currentCostPos] frequency] intValue];
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
    
    self.amountTextField.text = [[(CompanyCost *) [self.costs objectAtIndex:self.currentCostPos] amount] stringValue];
    self.questionLabel.text = [NSString stringWithFormat:@"How much does %@ spend on %@?", self.companyName, [(CompanyCost *) [self.costs objectAtIndex:self.currentCostPos] companyCostLiteralUS]];
    self.frequencySegmentedControl.selectedSegmentIndex = [[(CompanyCost *) [self.costs objectAtIndex:self.currentCostPos] frequency] intValue] - 1;
    self.isSureForCurrentCost = [[(CompanyCost *) [self.costs objectAtIndex:self.currentCostPos] isSure] boolValue];
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