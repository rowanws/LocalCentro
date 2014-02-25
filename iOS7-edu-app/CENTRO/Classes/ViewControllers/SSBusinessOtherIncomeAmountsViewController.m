//
//  SSBusinessOtherIncomeAmountsViewController.m
//  CENTRO
//
//  Created by Centro Community Partners.
//  Copyright (c) 2013 Centro Community Partners. All rights reserved.
//

#import "SSBusinessOtherIncomeAmountsViewController.h"
#import "SSUser.h"
#import "Product.h"
#import "Company.h"

@interface SSBusinessOtherIncomeAmountsViewController ()

@property (strong, nonatomic) NSManagedObjectContext *context;
@property (strong, nonatomic) NSString *companyName;
@property (strong, nonatomic) Company *company;

@property BOOL isSureForOtherIncome;

@end

@implementation SSBusinessOtherIncomeAmountsViewController

- (IBAction)nextButtonPressed:(id)sender {
    if ([self canContinueAfterValidateInputs]) {
        [self saveOther];
        [self.context save:nil];
        [self performSegueWithIdentifier:@"BusinessIncome" sender:self];
    }
}

- (IBAction)sureButtonPressed:(id)sender {
    
    self.isSureForOtherIncome = !self.isSureForOtherIncome;
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
    
    [self.frequencySegmentedControl addTarget:self
                                       action:@selector(frequencyChanged)
                             forControlEvents:UIControlEventValueChanged];
    
    [self.frequencySegmentedControl setTitle:@"Day" forSegmentAtIndex:0];
    [self.frequencySegmentedControl setTitle:@"Week" forSegmentAtIndex:1];
    [self.frequencySegmentedControl setTitle:@"Month" forSegmentAtIndex:2];
    [self.frequencySegmentedControl setTitle:@"Year" forSegmentAtIndex:3];
    
    
    UIBarButtonItem *nextScreenBackButton = [[UIBarButtonItem alloc] initWithTitle:@"Other" style:UIBarButtonItemStyleBordered target:self action:nil];
    self.navigationItem.backBarButtonItem = nextScreenBackButton;
    
    self.navigationItem.title = @"Other Income";
    
        
}

-(void) viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
        
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
        self.company = (Company *) [companyFetchedObjects objectAtIndex:0];
        if ([self.company.name isEqualToString:@""]) {
            self.companyName = @"Your Company";
        } else {
            self.companyName = self.company.name;
        }
        self.amountTextField.text = [self.company.otherProfitAmount stringValue];
        self.questionLabel.text = [NSString stringWithFormat:@"Does %@ have earnings from other sales?", self.companyName];
        self.frequencySegmentedControl.selectedSegmentIndex = [self.company.otherProfitFrequency intValue] - 1;
        self.isSureForOtherIncome = [self.company.isOtherProfitAmountSure boolValue];
        [self drawSureButton];
    }
    
    self.frequencyLabel.text = @"per";
}

-(void) drawSureButton {
    if(!self.isSureForOtherIncome) {
        [self.sureButton setTitle:@"☑ I'm not sure yet" forState:UIControlStateNormal];
    } else {
        [self.sureButton setTitle:@"☐ I'm not sure yet" forState:UIControlStateNormal];
    }
}

-(void) frequencyChanged {
    [self.amountTextField resignFirstResponder];
    
    [self.company setOtherProfitFrequency:[NSNumber numberWithInt:self.frequencySegmentedControl.selectedSegmentIndex+1]];
}

-(void) saveOther {
    [self.company setOtherProfitAmount:[NSNumber numberWithDouble:[self.amountTextField.text doubleValue]]];
    [self.company setIsOtherProfitAmountSure:[NSNumber numberWithBool:self.isSureForOtherIncome]];
}

-(BOOL) canContinueAfterValidateInputs {
    BOOL continueAfter = NO;
    
    int frequency = [self.company.otherProfitFrequency intValue];
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

@end