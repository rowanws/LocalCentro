//
//  SSAddEditBusinessCostViewController.m
//  CENTRO
//
//  Created by Centro Community Partners.
//  Copyright (c) 2013 Centro Community Partners. All rights reserved.
//

#import "SSAddEditBusinessCostViewController.h"
#import "SSAddBusinessCostTableViewController.h"
#import "CompanyCost.h"
#import "SSUtils.h"

@interface SSAddEditBusinessCostViewController ()

@property (strong, nonatomic) NSManagedObjectContext *context;
@property BOOL isSureForCurrentCost;

@end

@implementation SSAddEditBusinessCostViewController

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
        
        NSEntityDescription *entity = [NSEntityDescription entityForName:@"CompanyCost"
                                                  inManagedObjectContext:self.context];
        [fetchRequest setEntity:entity];
        
        [fetchRequest setPredicate:[NSPredicate predicateWithFormat:@"companyCostCode = %@", self.companyCost.companyCostCode]];
        
        CompanyCost *cc;
        
        NSError *error;
        NSArray *fetchedObjects = [self.context executeFetchRequest:fetchRequest error:&error];
        if (fetchedObjects.count == 0) {
            
        } else {
            cc = (CompanyCost *) [fetchedObjects objectAtIndex:0];
        }
        
        cc.companyCostCode = self.companyCost.companyCostCode;
        cc.amount = [NSNumber numberWithDouble:[self.editAmountTextField.text doubleValue]];
        cc.frequency = self.companyCost.frequency;
        cc.isSure = [NSNumber numberWithBool:self.isSureForCurrentCost];
        cc.selectedAsIncurredCost = [NSNumber numberWithBool:YES];
        
        double monthlyAmount = 0.0;
        if([cc.frequency isEqual:[NSNumber numberWithInt:1]]) {
            monthlyAmount = [self.editAmountTextField.text doubleValue] * 30;
        } else if([cc.frequency isEqual:[NSNumber numberWithInt:2]]) {
            monthlyAmount = [self.editAmountTextField.text doubleValue] * 4;
        } else if([cc.frequency isEqual:[NSNumber numberWithInt:4]]) {
            monthlyAmount = [self.editAmountTextField.text doubleValue] / 12;
        } else {
            monthlyAmount = [self.editAmountTextField.text doubleValue];
        }
        
        cc.monthlyAmount = [NSNumber numberWithDouble:monthlyAmount];
        
        [self.context save:nil];
        
        [self.navigationController popViewControllerAnimated:YES];
        
    }
}

- (IBAction)isSureButtonPressed:(id)sender {    
    self.isSureForCurrentCost = !self.isSureForCurrentCost;
    [self drawSureButton];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIImage *bg = [UIImage imageNamed:@"bg.png"];
    self.backgroundImageView.image = bg;
    self.backgroundImageView.contentMode = UIViewContentModeCenter;
    
    self.navigationItem.title = @"Business Costs";
    
    UIBarButtonItem *nextScreenBackButton = [[UIBarButtonItem alloc] initWithTitle:@"Try Again" style:UIBarButtonItemStyleBordered target:self action:nil];
    self.navigationItem.backBarButtonItem = nextScreenBackButton;
    
    [self.editFrequencySegmentedControl addTarget:self
                                           action:@selector(frequencyChanged)
                                 forControlEvents:UIControlEventValueChanged];
    
    self.editFrequencyLabel.text = @"per";
    
    self.context = [(id)[[UIApplication sharedApplication] delegate] managedObjectContext];

}

-(void) viewDidAppear:(BOOL)animated {
    
    [super viewDidAppear:animated];
    
    if(self.editingExistingCost) {
        self.editItemLabel.text = [NSString stringWithFormat:@"Editing values for %@.", [(CompanyCost *) self.companyCost companyCostLiteralUS]];
    } else {
        self.editItemLabel.text = [NSString stringWithFormat:@"How much does %@ spend on %@?", [SSUtils companyName], [(CompanyCost *) self.companyCost companyCostLiteralUS]];
    }
    
    self.editAmountTextField.text = [[(CompanyCost *) self.companyCost amount] stringValue];
    
    self.editFrequencySegmentedControl.selectedSegmentIndex = [[(CompanyCost *) self.companyCost frequency] intValue] - 1;
    
    self.isSureForCurrentCost = [[(CompanyCost *) self.companyCost isSure] boolValue];
    
    [self drawSureButton];
}

-(void) drawSureButton {
    if(!self.isSureForCurrentCost) {
        [self.self.editIsSureButton setTitle:@"☑ I'm not sure yet" forState:UIControlStateNormal];
    } else {
        [self.self.editIsSureButton setTitle:@"☐ I'm not sure yet" forState:UIControlStateNormal];
    }
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

-(void) frequencyChanged {
    [self.editAmountTextField resignFirstResponder];
    [self.companyCost setFrequency:[NSNumber numberWithInt:self.editFrequencySegmentedControl.selectedSegmentIndex+1]];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    
    [self.editAmountTextField resignFirstResponder];
    
}

@end