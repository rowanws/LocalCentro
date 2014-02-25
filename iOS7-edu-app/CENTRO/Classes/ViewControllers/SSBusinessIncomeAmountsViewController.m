//
//  SSBusinessIncomeAmountsViewController.m
//  CENTRO
//
//  Created by Centro Community Partners.
//  Copyright (c) 2013 Centro Community Partners. All rights reserved.
//

#import "SSBusinessIncomeAmountsViewController.h"
#import "SSUser.h"
#import "Product.h"
#import "Company.h"

@interface SSBusinessIncomeAmountsViewController ()

@property (strong, nonatomic) NSManagedObjectContext *context;
@property (strong, nonatomic) NSArray *items;
@property (strong, nonatomic) NSString *companyName;

@property BOOL isSureForCurrentIncome;
@property int currentItemPos;

@end

@implementation SSBusinessIncomeAmountsViewController


- (IBAction)nextButtonPressed:(id)sender {
    if ([self canContinueAfterValidateInputs]) {
        [self saveCurrent];
        self.currentItemPos++;
        if (self.currentItemPos < self.items.count) {
            [self continueAsking];
        } else {
            [self.context save:nil];
            [self performSegueWithIdentifier:@"OtherIncome" sender:self];
        }
    }
}
- (IBAction)backButtonPressed:(id)sender {
    self.currentItemPos--;
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
    
    
    UIBarButtonItem *nextScreenBackButton = [[UIBarButtonItem alloc] initWithTitle:@"Income" style:UIBarButtonItemStyleBordered target:self action:nil];
    self.navigationItem.backBarButtonItem = nextScreenBackButton;
    
    self.navigationItem.title = @"Business Income";
}

-(void) viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    self.currentItemPos = 0;
    
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
    
    NSFetchRequest *studentIncomeFetchRequest = [[NSFetchRequest alloc] init];
    
    NSEntityDescription *studentIncomeEntity = [NSEntityDescription entityForName:@"Product"
                                                         inManagedObjectContext:self.context];
    [studentIncomeFetchRequest setEntity:studentIncomeEntity];
    
    [studentIncomeFetchRequest setPredicate:[NSPredicate predicateWithFormat:@"companyID = %@ AND selectedAsItem = 1 AND name != %@", [[SSUser currentUser] companyID], @""]]; //selectedAsProfitableItem = 1
    
    studentIncomeFetchRequest.sortDescriptors = [NSArray arrayWithObject:[NSSortDescriptor sortDescriptorWithKey:@"productID" ascending:YES selector:nil]];
    
    NSError *errorSV;
    self.items = [self.context executeFetchRequest:studentIncomeFetchRequest error:&errorSV];
    
    if (self.items.count == 0) {
        [self performSegueWithIdentifier:@"OtherIncome" sender:self];
    } else {
        
        for(Product *pro in self.items) {
            pro.selectedAsProfitableItem = [NSNumber numberWithBool:YES];
        }
        
        self.amountTextField.text = [[(Product *) [self.items objectAtIndex:self.currentItemPos] profitAmount] stringValue];
        self.questionLabel.text = [NSString stringWithFormat:@"How much does %@ earn from sales of %@?", self.companyName, [(Product *) [self.items objectAtIndex:self.currentItemPos] name]];
        self.frequencySegmentedControl.selectedSegmentIndex = [[(Product *) [self.items objectAtIndex:self.currentItemPos] profitFrequency] intValue] - 1;
        self.isSureForCurrentIncome = [[(Product *) [self.items objectAtIndex:self.currentItemPos] isProfitAmountSure] boolValue];
        [self drawSureButton];
        self.backButton.hidden = YES;
    }
    
    self.frequencyLabel.text = @"per";

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
    
    [(Product *) [self.items objectAtIndex:self.currentItemPos] setProfitFrequency:[NSNumber numberWithInt:self.frequencySegmentedControl.selectedSegmentIndex+1]];
}


-(void) saveCurrent {
    
    [(Product *) [self.items objectAtIndex:self.currentItemPos] setProfitAmount:[NSNumber numberWithDouble:[self.amountTextField.text doubleValue]]];
    [(Product *) [self.items objectAtIndex:self.currentItemPos] setIsProfitAmountSure:[NSNumber numberWithBool:self.isSureForCurrentIncome]];
    
    double monthlyAmount = 0.0;
    if([[(Product *) [self.items objectAtIndex:self.currentItemPos] profitFrequency] isEqual:[NSNumber numberWithInt:1]]) {
        monthlyAmount = [self.amountTextField.text doubleValue] * 30;
    } else if([[(Product *) [self.items objectAtIndex:self.currentItemPos] profitFrequency] isEqual:[NSNumber numberWithInt:2]]) {
        monthlyAmount = [self.amountTextField.text doubleValue] * 4;
    } else if([[(Product *) [self.items objectAtIndex:self.currentItemPos] profitFrequency] isEqual:[NSNumber numberWithInt:4]]) {
        monthlyAmount = [self.amountTextField.text doubleValue] / 12;
    } else {
        monthlyAmount = [self.amountTextField.text doubleValue];
    }
    
    [(Product *) [self.items objectAtIndex:self.currentItemPos] setMonthlyProfitAmount:[NSNumber numberWithDouble:monthlyAmount]];
    
    
    self.amountTextField.text = @"";
}

-(void) continueAsking {

    if (self.currentItemPos > 0) {
        self.backButton.hidden = NO;
    } else if (self.currentItemPos == 0) {
        self.backButton.hidden = YES;
    }
    
    self.amountTextField.text = [[(Product *) [self.items objectAtIndex:self.currentItemPos] profitAmount] stringValue];
    self.questionLabel.text = [NSString stringWithFormat:@"How much does %@ earn from sales of %@?", self.companyName, [(Product *) [self.items objectAtIndex:self.currentItemPos] name]];
    self.frequencySegmentedControl.selectedSegmentIndex = [[(Product *) [self.items objectAtIndex:self.currentItemPos] profitFrequency] intValue] - 1;
    self.isSureForCurrentIncome = [[(Product *) [self.items objectAtIndex:self.currentItemPos] isProfitAmountSure] boolValue];
    [self drawSureButton];
}

-(BOOL) canContinueAfterValidateInputs {
    BOOL continueAfter = NO;
    
    int frequency = [[(Product *) [self.items objectAtIndex:self.currentItemPos] profitFrequency] intValue];
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

-(IBAction)dismissVC{
    [self dismissViewControllerAnimated:YES completion:NULL];
}


@end