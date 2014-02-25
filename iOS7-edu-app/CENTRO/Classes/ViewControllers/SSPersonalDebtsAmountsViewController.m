//
//  SSPersonalDebtsAmountsViewController.m
//  CENTRO
//
//  Created by Centro Community Partners.
//  Copyright (c) 2013 Centro Community Partners. All rights reserved.
//

#import "SSPersonalDebtsAmountsViewController.h"
#import "SSUser.h"
#import "StudentDebt.h"
#import "SSPersonalDebtsTableViewController.h"

@interface SSPersonalDebtsAmountsViewController ()

@property (strong, nonatomic) NSManagedObjectContext *context;
@property (strong, nonatomic) NSArray *debts;

@property BOOL isSureForCurrentDebt;
@property int currentDebtPos;

@end

@implementation SSPersonalDebtsAmountsViewController


- (IBAction)nextButtonPressed:(id)sender {
    [self saveCurrent];
    self.currentDebtPos++;
    if (self.currentDebtPos < self.debts.count) {
        [self continueAsking];
    } else {
        [self.context save:nil];
        [self performSegueWithIdentifier:@"PersonalDebts" sender:self];
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
    
    UIImage *bg = [UIImage imageNamed:@"bg.png"];
    self.backgroundImageView.image = bg;
    self.backgroundImageView.contentMode = UIViewContentModeCenter;
    
    self.context = [(id)[[UIApplication sharedApplication] delegate] managedObjectContext];
    
    self.navigationItem.title = @"Personal Debts";
    
    self.noteLabel.text = @"If you have more than one add their values together.";
    
    UIBarButtonItem *nextScreenBackButton = [[UIBarButtonItem alloc] initWithTitle:@"Try Again" style:UIBarButtonItemStyleBordered target:self action:nil];
    self.navigationItem.backBarButtonItem = nextScreenBackButton;

}

-(void) viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    self.currentDebtPos = 0;
    
    NSFetchRequest *studentDebtFetchRequest = [[NSFetchRequest alloc] init];
    
    NSEntityDescription *studentDebtEntity = [NSEntityDescription entityForName:@"StudentDebt"
                                                         inManagedObjectContext:self.context];
    [studentDebtFetchRequest setEntity:studentDebtEntity];
    
    [studentDebtFetchRequest setPredicate:[NSPredicate predicateWithFormat:@"studentID = %@ AND selectedAsDebt = 1", [[SSUser currentUser] studentID]]];
    
    studentDebtFetchRequest.sortDescriptors = [NSArray arrayWithObject:[NSSortDescriptor sortDescriptorWithKey:@"studentDebtID" ascending:YES selector:nil]];
    
    NSError *errorSV;
    self.debts = [self.context executeFetchRequest:studentDebtFetchRequest error:&errorSV];
    
    if (self.debts.count == 0) {
        [self performSegueWithIdentifier:@"PersonalDebts" sender:self];
    } else {
        
        self.amountTextField.text = [[(StudentDebt *) [self.debts objectAtIndex:self.currentDebtPos] amount] stringValue];
        self.questionLabel.text = [NSString stringWithFormat:@"How much do you owe for %@?", [(StudentDebt *) [self.debts objectAtIndex:self.currentDebtPos] studentDebtLiteralUS]];
        self.isSureForCurrentDebt = [[(StudentDebt *) [self.debts objectAtIndex:self.currentDebtPos] isSure] boolValue];
        [self drawSureButton];
        self.backButton.hidden = YES;
    }

}

-(void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if([segue.identifier isEqualToString:@"PersonalDebts"]) {
        SSPersonalDebtsTableViewController *personalDebtsTableViewController = (SSPersonalDebtsTableViewController *) segue.destinationViewController;
        
        if(self.debts.count == 0) {
            personalDebtsTableViewController.popToRoot = YES;
        } else {
            personalDebtsTableViewController.popToRoot = NO;
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
    
    [(StudentDebt *) [self.debts objectAtIndex:self.currentDebtPos] setAmount:[NSNumber numberWithDouble:[self.amountTextField.text doubleValue]]];
    [(StudentDebt *) [self.debts objectAtIndex:self.currentDebtPos] setIsSure:[NSNumber numberWithBool:self.isSureForCurrentDebt]];
    self.amountTextField.text = @"";
}

-(void) continueAsking {
    
    if (self.currentDebtPos > 0) {
        self.backButton.hidden = NO;
    } else if (self.currentDebtPos == 0) {
        self.backButton.hidden = YES;
    }
    
    self.amountTextField.text = [[(StudentDebt *) [self.debts objectAtIndex:self.currentDebtPos] amount] stringValue];
    self.questionLabel.text = [NSString stringWithFormat:@"How much do you owe for %@?", [(StudentDebt *) [self.debts objectAtIndex:self.currentDebtPos] studentDebtLiteralUS]];
    self.isSureForCurrentDebt = [[(StudentDebt *) [self.debts objectAtIndex:self.currentDebtPos] isSure] boolValue];
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