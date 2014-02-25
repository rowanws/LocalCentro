//
//  SSAddEditPersonalCostViewController.m
//  CENTRO
//
//  Created by Centro Community Partners.
//  Copyright (c) 2013 Centro Community Partners. All rights reserved.
//

#import "SSAddEditPersonalIncomeViewController.h"
#import "SSAddPersonalIncomeTableViewController.h"
#import "StudentIncome.h"

@interface SSAddEditPersonalIncomeViewController ()

@property (strong, nonatomic) NSManagedObjectContext *context;
@property BOOL isSureForCurrentIncome;

@end

@implementation SSAddEditPersonalIncomeViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {

    }
    return self;
}
- (IBAction)doneButtonPressed:(id)sender {
    
    if ([self canSaveAfterValidateInputs]) {

        NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
        
        NSEntityDescription *entity = [NSEntityDescription entityForName:@"StudentIncome"
                                                  inManagedObjectContext:self.context];
        [fetchRequest setEntity:entity];
        
        [fetchRequest setPredicate:[NSPredicate predicateWithFormat:@"studentIncomeCode = %@", self.studentIncome.studentIncomeCode]];
        
        StudentIncome *si;
        
        NSError *error;
        NSArray *fetchedObjects = [self.context executeFetchRequest:fetchRequest error:&error];
        if (fetchedObjects.count == 0) {
            
        } else {
            si = (StudentIncome *) [fetchedObjects objectAtIndex:0];
        }
        
        si.studentIncomeCode = self.studentIncome.studentIncomeCode;
        si.amount = [NSNumber numberWithDouble:[self.editAmountTextField.text doubleValue]];
        si.frequency = self.studentIncome.frequency;
        si.isSure = [NSNumber numberWithBool:self.isSureForCurrentIncome];
        si.selectedAsSourceOfIncome = [NSNumber numberWithBool:YES];
        
        double monthlyAmount = 0.0;
        if([si.frequency isEqual:[NSNumber numberWithInt:1]]) {
            monthlyAmount = [self.editAmountTextField.text doubleValue] * 30;
        } else if([si.frequency isEqual:[NSNumber numberWithInt:2]]) {
            monthlyAmount = [self.editAmountTextField.text doubleValue] * 4;
        } else if([si.frequency isEqual:[NSNumber numberWithInt:4]]) {
            monthlyAmount = [self.editAmountTextField.text doubleValue] / 12;
        } else {
            monthlyAmount = [self.editAmountTextField.text doubleValue];
        }
        
        si.monthlyAmount = [NSNumber numberWithDouble:monthlyAmount];
        
        [self.context save:nil];
        
        [self.navigationController popViewControllerAnimated:YES];
    }
    
}

- (IBAction)isSureButtonPressed:(id)sender {    
    self.isSureForCurrentIncome = !self.isSureForCurrentIncome;
    [self drawSureButton];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //UIImage *bg = [UIImage imageNamed:@"bg.png"];
    //self.backgroundImageView.image = bg;
    self.backgroundImageView.contentMode = UIViewContentModeCenter;
    
    [self.editFrequencySegmentedControl addTarget:self
                                           action:@selector(frequencyChanged)
                                 forControlEvents:UIControlEventValueChanged];
    
    self.editFrequencyLabel.text = @"per";
    
    self.navigationItem.title = @"Pers. Income";
    
    self.context = [(id)[[UIApplication sharedApplication] delegate] managedObjectContext];
    
    UIBarButtonItem *nextScreenBackButton = [[UIBarButtonItem alloc] initWithTitle:@"Try Again" style:UIBarButtonItemStyleBordered target:self action:nil];
    self.navigationItem.backBarButtonItem = nextScreenBackButton;

}

-(void) viewDidAppear:(BOOL)animated {
    
    [super viewDidAppear:animated];
    
    if(self.editingExistingIncome) {
        self.editItemLabel.text = [NSString stringWithFormat:@"Editing values for %@.", [(StudentIncome *) self.studentIncome studentIncomeLiteralUS]];
    } else {
        self.editItemLabel.text = [NSString stringWithFormat:@"How much do you make from your %@?", [(StudentIncome *) self.studentIncome studentIncomeLiteralUS]];
    }
    
    self.editAmountTextField.text = [[(StudentIncome *) self.studentIncome amount] stringValue];
    
    self.editFrequencySegmentedControl.selectedSegmentIndex = [[(StudentIncome *) self.studentIncome frequency] intValue] - 1;
    
    self.isSureForCurrentIncome = [[(StudentIncome *) self.studentIncome isSure] boolValue];
    
    [self drawSureButton];
}

-(void) drawSureButton {
    if(!self.isSureForCurrentIncome) {
        [self.self.editIsSureButton setTitle:@"☑ I'm not sure yet" forState:UIControlStateNormal];
    } else {
        [self.self.editIsSureButton setTitle:@"☐ I'm not sure yet" forState:UIControlStateNormal];
    }
}


-(void) frequencyChanged {
    [self.editAmountTextField resignFirstResponder];
    [self.studentIncome setFrequency:[NSNumber numberWithInt:self.editFrequencySegmentedControl.selectedSegmentIndex+1]];
}

-(BOOL) canSaveAfterValidateInputs {
    BOOL continueAfter = NO;
    
    int frequency = self.editFrequencySegmentedControl.selectedSegmentIndex + 1;
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
    
    [self.editAmountTextField resignFirstResponder];
    
}

@end