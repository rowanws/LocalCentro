//
//  SSAddEditBusinessIncomeViewController.m
//  CENTRO
//
//  Created by Centro Community Partners.
//  Copyright (c) 2013 Centro Community Partners. All rights reserved.
//

#import "SSAddEditBusinessIncomeViewController.h"
#import "SSAddBusinessIncomeTableViewController.h"
#import "Product.h"

@interface SSAddEditBusinessIncomeViewController ()

@property (strong, nonatomic) NSManagedObjectContext *context;
@property BOOL isSureForCurrentIncome;

@end

@implementation SSAddEditBusinessIncomeViewController

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
        
        NSEntityDescription *entity = [NSEntityDescription entityForName:@"Product"
                                                  inManagedObjectContext:self.context];
        [fetchRequest setEntity:entity];
        
        [fetchRequest setPredicate:[NSPredicate predicateWithFormat:@"productID = %@", self.item.productID]];
        
        Product *pro;
        
        NSError *error;
        NSArray *fetchedObjects = [self.context executeFetchRequest:fetchRequest error:&error];
        if (fetchedObjects.count == 0) {
            
        } else {
            pro = (Product *) [fetchedObjects objectAtIndex:0];
        }
        
        pro.productID = self.item.productID;
        pro.profitAmount = [NSNumber numberWithDouble:[self.editAmountTextField.text doubleValue]];
        pro.profitFrequency = self.item.profitFrequency;
        pro.isProfitAmountSure = [NSNumber numberWithBool:self.isSureForCurrentIncome];
        pro.selectedAsProfitableItem = [NSNumber numberWithBool:YES];
        
        double monthlyAmount = 0.0;
        if([pro.profitFrequency isEqual:[NSNumber numberWithInt:1]]) {
            monthlyAmount = [self.editAmountTextField.text doubleValue] * 30;
        } else if([pro.profitFrequency isEqual:[NSNumber numberWithInt:2]]) {
            monthlyAmount = [self.editAmountTextField.text doubleValue] * 4;
        } else if([pro.profitFrequency isEqual:[NSNumber numberWithInt:4]]) {
            monthlyAmount = [self.editAmountTextField.text doubleValue] / 12;
        } else {
            monthlyAmount = [self.editAmountTextField.text doubleValue];
        }
        
        pro.monthlyProfitAmount = [NSNumber numberWithDouble:monthlyAmount];
        
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
    
    UIImage *bg = [UIImage imageNamed:@"bg.png"];
    self.backgroundImageView.image = bg;
    self.backgroundImageView.contentMode = UIViewContentModeCenter;
    
    [self.editFrequencySegmentedControl addTarget:self
                                           action:@selector(frequencyChanged)
                                 forControlEvents:UIControlEventValueChanged];
    
    self.editFrequencyLabel.text = @"per";
    
    self.navigationItem.title = @"Business Income";
    
    self.context = [(id)[[UIApplication sharedApplication] delegate] managedObjectContext];
    
    UIBarButtonItem *nextScreenBackButton = [[UIBarButtonItem alloc] initWithTitle:@"Try Again" style:UIBarButtonItemStyleBordered target:self action:nil];
    self.navigationItem.backBarButtonItem = nextScreenBackButton;

}

-(void) viewDidAppear:(BOOL)animated {
    
    [super viewDidAppear:animated];
    
    if(self.editingExistingIncome) {
        self.editItemLabel.text = [NSString stringWithFormat:@"Editing values for %@.", [(Product *) self.item name]];
    } else {
        self.editItemLabel.text = [NSString stringWithFormat:@"Adding the Personal Income: %@, fill the associated values.", [(Product *) self.item name]];
    }
    
    self.editAmountTextField.text = [[(Product *) self.item profitAmount] stringValue];
    
    self.editFrequencySegmentedControl.selectedSegmentIndex = [[(Product *) self.item profitFrequency] intValue] - 1;
    
    self.isSureForCurrentIncome = [[(Product *) self.item isProfitAmountSure] boolValue];
    
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
    [self.item setProfitFrequency:[NSNumber numberWithInt:self.editFrequencySegmentedControl.selectedSegmentIndex+1]];
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