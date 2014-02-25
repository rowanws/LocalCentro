//
//  SSEmployeeBenefitsViewController.m
//  CENTRO
//
//  Created by Centro Community Partners.
//  Copyright (c) 2013 Centro Community Partners. All rights reserved.
//

#import "SSEmployeeBenefitsViewController.h"
#import "SSUser.h"
#import "Company.h"
#import "SSUtils.h"

@interface SSEmployeeBenefitsViewController ()

@property (strong, nonatomic) NSManagedObjectContext *context;
@property (strong, nonatomic) Company *company;

@end

@implementation SSEmployeeBenefitsViewController

- (IBAction)doneButtonPressed:(id)sender {
    if ([self canContinueAfterValidateInputs]) {
        [self saveCurrent];
        [self.context save:nil];
        [self performSegueWithIdentifier:@"HRCosts" sender:self];
    }
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
    
    [self.frequencySegmentedControl setTitle:@"Month" forSegmentAtIndex:0];
    [self.frequencySegmentedControl setTitle:@"Year" forSegmentAtIndex:1];
    
    
    UIBarButtonItem *nextScreenBackButton = [[UIBarButtonItem alloc] initWithTitle:@"Employee Benefits" style:UIBarButtonItemStyleBordered target:self action:nil];
    self.navigationItem.backBarButtonItem = nextScreenBackButton;
    
    self.navigationItem.title = @"Benefits";
    
    self.doneButton.title = @"Next";
    
    self.questionLabel.text = [NSString stringWithFormat:@"How much does %@ spend on employee benefits?", [SSUtils companyName]];
    
    
}

-(void) viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Company"
                                              inManagedObjectContext:self.context];
    [fetchRequest setEntity:entity];
    
    [fetchRequest setPredicate:[NSPredicate predicateWithFormat:@"companyID = %@", [[SSUser currentUser] companyID]]];
    
    fetchRequest.sortDescriptors = [NSArray arrayWithObject:[NSSortDescriptor sortDescriptorWithKey:@"companyID" ascending:YES selector:nil]];
    
    NSError *error;
    NSArray *fetchedObjects = [self.context executeFetchRequest:fetchRequest error:&error];
    
    if (fetchedObjects.count == 0) {
        
    } else {
        
        self.company = (Company *) fetchedObjects[0];
        
        self.amountTextField.text = [[self.company totalEmployeeBenefitsCosts] stringValue];
        
        self.frequencySegmentedControl.selectedSegmentIndex = [[self.company frequencyEmployeeBenefits] intValue] - 3;
        
    }
    
    self.frequencyLabel.text = @"per";
    
}

-(void) frequencyChanged {
    [self.amountTextField resignFirstResponder];
    
    [self.company setFrequencyEmployeeBenefits:[NSNumber numberWithInt:self.frequencySegmentedControl.selectedSegmentIndex+3]];
}


-(void) saveCurrent {
    [self.company setTotalEmployeeBenefitsCosts:[NSNumber numberWithDouble:[self.amountTextField.text doubleValue]]];
}

-(BOOL) canContinueAfterValidateInputs {
    BOOL continueAfter = NO;
    
    int frequency = [[self.company frequencyEmployeeBenefits] intValue];
    if (frequency < 3 || frequency > 4) {
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
    } else if ([viewControllers indexOfObject:self] == NSNotFound) {
        @try {
            if(self.popToRoot) {
                [[SSUser currentUser] setSegueToPerform:@"22"];
                [self.navigationController popToRootViewControllerAnimated:NO];
                [self.navigationController.navigationBar popNavigationItemAnimated:NO];
            }
        }
        @catch (NSException *exception) {

        }
        @finally {

        }
    } else {
        
    }
}

@end