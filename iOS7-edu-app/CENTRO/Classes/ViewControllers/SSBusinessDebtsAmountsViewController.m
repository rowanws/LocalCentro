//
//  SSBusinessDebtsAmountsViewController.m
//  CENTRO
//
//  Created by Centro Community Partners.
//  Copyright (c) 2013 Centro Community Partners. All rights reserved.
//

#import "SSBusinessDebtsAmountsViewController.h"
#import "SSUser.h"
#import "Company.h"
#import "CompanyDebt.h"
#import "SSBusinessDebtsTableViewController.h"

@interface SSBusinessDebtsAmountsViewController ()

@property (strong, nonatomic) NSManagedObjectContext *context;
@property (strong, nonatomic) NSArray *debts;
@property (strong, nonatomic) NSString *companyName;

@property BOOL isSureForCurrentDebt;
@property int currentDebtPos;

@end

@implementation SSBusinessDebtsAmountsViewController


- (IBAction)nextButtonPressed:(id)sender {
    [self saveCurrent];
    self.currentDebtPos++;
    if (self.currentDebtPos < self.debts.count) {
        [self continueAsking];
    } else {
        [self.context save:nil];
        [self performSegueWithIdentifier:@"BusinessDebts" sender:self];
    }
    
    
}
- (IBAction)backButtonPressed:(id)sender {
    [self saveCurrent];
    self.currentDebtPos--;
    [self continueAsking];
}

- (IBAction)sureButtonPressed:(id)sender {
    self.isSureForCurrentDebt = !self.isSureForCurrentDebt;
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
    
    self.navigationItem.title = @"Business Debts";
    
    self.noteLabel.text = @"If you have more than one add their values together.";
    
    UIBarButtonItem *nextScreenBackButton = [[UIBarButtonItem alloc] initWithTitle:@"Try Again" style:UIBarButtonItemStyleBordered target:self action:nil];
    self.navigationItem.backBarButtonItem = nextScreenBackButton;
    
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
    
    self.currentDebtPos = 0;
    
    NSFetchRequest *studentDebtFetchRequest = [[NSFetchRequest alloc] init];
    
    NSEntityDescription *studentDebtEntity = [NSEntityDescription entityForName:@"CompanyDebt"
                                                         inManagedObjectContext:self.context];
    [studentDebtFetchRequest setEntity:studentDebtEntity];
    
    [studentDebtFetchRequest setPredicate:[NSPredicate predicateWithFormat:@"companyID = %@ AND selectedAsDebt = 1", [[SSUser currentUser] companyID]]];
    
    studentDebtFetchRequest.sortDescriptors = [NSArray arrayWithObject:[NSSortDescriptor sortDescriptorWithKey:@"companyDebtID" ascending:YES selector:nil]];
    
    NSError *errorSV;
    self.debts = [self.context executeFetchRequest:studentDebtFetchRequest error:&errorSV];
    
    if (self.debts.count == 0) {
        [self performSegueWithIdentifier:@"BusinessDebts" sender:self];
    } else {
        
        self.amountTextField.text = [[(CompanyDebt *) [self.debts objectAtIndex:self.currentDebtPos] amount] stringValue];
        self.questionLabel.text = [NSString stringWithFormat:@"How much does %@ owe on its %@?", self.companyName, [(CompanyDebt *) [self.debts objectAtIndex:self.currentDebtPos] companyDebtLiteralUS]];
        self.isSureForCurrentDebt = [[(CompanyDebt *) [self.debts objectAtIndex:self.currentDebtPos] isSure] boolValue];
        [self drawSureButton];
        self.backButton.hidden = YES;
    }

}

-(void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if([segue.identifier isEqualToString:@"BusinessDebts"]) {
        SSBusinessDebtsTableViewController *businessDebtsTableViewController = (SSBusinessDebtsTableViewController *) segue.destinationViewController;
        
        if(self.debts.count == 0) {
            businessDebtsTableViewController.popToRoot = YES;
        } else {
            businessDebtsTableViewController.popToRoot = NO;
        }
    }
}


-(void) drawSureButton {
    if(!self.isSureForCurrentDebt) {
        [self.sureButton setTitle:@"☑ I'm not sure yet" forState:UIControlStateNormal];
    } else {
        [self.sureButton setTitle:@"☐ I'm not sure yet" forState:UIControlStateNormal];
    }
}




-(void) saveCurrent {
    
    [(CompanyDebt *) [self.debts objectAtIndex:self.currentDebtPos] setAmount:[NSNumber numberWithDouble:[self.amountTextField.text doubleValue]]];
    [(CompanyDebt *) [self.debts objectAtIndex:self.currentDebtPos] setIsSure:[NSNumber numberWithBool:self.isSureForCurrentDebt]];
    self.amountTextField.text = @"";
}

-(void) continueAsking {
    
    if (self.currentDebtPos > 0) {
        self.backButton.hidden = NO;
    } else if (self.currentDebtPos == 0) {
        self.backButton.hidden = YES;
    }
    
    self.amountTextField.text = [[(CompanyDebt *) [self.debts objectAtIndex:self.currentDebtPos] amount] stringValue];
    self.questionLabel.text = [NSString stringWithFormat:@"How much does %@ owe on its %@?", self.companyName, [(CompanyDebt *) [self.debts objectAtIndex:self.currentDebtPos] companyDebtLiteralUS]];
    self.isSureForCurrentDebt = [[(CompanyDebt *) [self.debts objectAtIndex:self.currentDebtPos] isSure] boolValue];
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