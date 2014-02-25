//
//  SSAddEditPersonalCostViewController.m
//  CENTRO
//
//  Created by Centro Community Partners.
//  Copyright (c) 2013 Centro Community Partners. All rights reserved.
//

#import "SSAddEditPersonalCostViewController.h"
#import "SSAddPersonalCostTableViewController.h"
#import "StudentCost.h"

@interface SSAddEditPersonalCostViewController ()

@property (strong, nonatomic) NSManagedObjectContext *context;
@property BOOL isSureForCurrentCost;

@end

@implementation SSAddEditPersonalCostViewController

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
        
        NSEntityDescription *entity = [NSEntityDescription entityForName:@"StudentCost"
                                                  inManagedObjectContext:self.context];
        [fetchRequest setEntity:entity];
        
        [fetchRequest setPredicate:[NSPredicate predicateWithFormat:@"studentCostCode = %@", self.studentCost.studentCostCode]];
        
        StudentCost *sc;
        
        NSError *error;
        NSArray *fetchedObjects = [self.context executeFetchRequest:fetchRequest error:&error];
        if (fetchedObjects.count == 0) {
            
        } else {
            sc = (StudentCost *) [fetchedObjects objectAtIndex:0];
        }
        
        sc.studentCostCode = self.studentCost.studentCostCode;
        sc.amount = [NSNumber numberWithDouble:[self.editAmountTextField.text doubleValue]];
        sc.frequency = self.studentCost.frequency;
        sc.isSure = [NSNumber numberWithBool:self.isSureForCurrentCost];
        sc.selectedAsIncurredCost = [NSNumber numberWithBool:YES];
        
        double monthlyAmount = 0.0;
        if([sc.frequency isEqual:[NSNumber numberWithInt:1]]) {
            monthlyAmount = [self.editAmountTextField.text doubleValue] * 30;
        } else if([sc.frequency isEqual:[NSNumber numberWithInt:2]]) {
            monthlyAmount = [self.editAmountTextField.text doubleValue] * 4;
        } else if([sc.frequency isEqual:[NSNumber numberWithInt:4]]) {
            monthlyAmount = [self.editAmountTextField.text doubleValue] / 12;
        } else {
            monthlyAmount = [self.editAmountTextField.text doubleValue];
        }
        
        sc.monthlyAmount = [NSNumber numberWithDouble:monthlyAmount];
        
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
    
    //UIImage *bg = [UIImage imageNamed:@"bg.png"];
    //self.backgroundImageView.image = bg;
    self.backgroundImageView.contentMode = UIViewContentModeCenter;
    
    self.navigationItem.title = @"Personal Costs";
    
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
        self.editItemLabel.text = [NSString stringWithFormat:@"Editing values for %@.", [(StudentCost *) self.studentCost studentCostLiteralUS]];
    } else {
        self.editItemLabel.text = [NSString stringWithFormat:@"How much do you spend on %@?", [(StudentCost *) self.studentCost studentCostLiteralUS]];
    }
    
    self.editAmountTextField.text = [[(StudentCost *) self.studentCost amount] stringValue];
    
    self.editFrequencySegmentedControl.selectedSegmentIndex = [[(StudentCost *) self.studentCost frequency] intValue] - 1;
    
    self.isSureForCurrentCost = [[(StudentCost *) self.studentCost isSure] boolValue];
    
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
    [self.studentCost setFrequency:[NSNumber numberWithInt:self.editFrequencySegmentedControl.selectedSegmentIndex+1]];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    
    [self.editAmountTextField resignFirstResponder];
    
}

@end