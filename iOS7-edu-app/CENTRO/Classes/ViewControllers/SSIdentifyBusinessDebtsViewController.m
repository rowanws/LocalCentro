//
//  SSIdentifyBusinessDebtsViewController
//  CENTRO
//
//  Created by Centro Community Partners.
//  Copyright (c) 2013 Centro Community Partners.
//

#import "SSIdentifyBusinessDebtsViewController.h"
#import "SSUser.h"
#import "CompanyDebt.h"
#import "Company.h"

@interface SSIdentifyBusinessDebtsViewController ()

@property (strong, nonatomic) NSManagedObjectContext *context;
@property (strong, nonatomic) NSArray *debts;

@property int currentDebtPos;
@property int yesCount;

@end

@implementation SSIdentifyBusinessDebtsViewController

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
    
    NSFetchRequest *companyFetchRequest = [[NSFetchRequest alloc] init];
    
    NSEntityDescription *companyEntity = [NSEntityDescription entityForName:@"Company"
                                                     inManagedObjectContext:self.context];
    [companyFetchRequest setEntity:companyEntity];
    
    [companyFetchRequest setPredicate:[NSPredicate predicateWithFormat:@"companyID = %@", [[SSUser currentUser] companyID]]];
    
    companyFetchRequest.returnsObjectsAsFaults = NO;
    
    NSString *companyName = @"";
    
    NSError *errorC;
    NSArray *companyFetchedObjects = [self.context executeFetchRequest:companyFetchRequest error:&errorC];
    if (companyFetchedObjects == 0) {
        
        companyName = @"Your Company";
    } else {
        Company *tempCompany = (Company *) [companyFetchedObjects objectAtIndex:0];
        if ([tempCompany.name isEqualToString:@""]) {
            companyName = @"Your Company";
        } else {
            companyName = tempCompany.name;
        }
    }
    
    self.questionLabel.text = [NSString stringWithFormat:@"Does %@ have the following?", companyName];
    
    [self.yesButton setTitle:@"YES" forState:UIControlStateNormal];
    [self.noButton setTitle:@"NO" forState:UIControlStateNormal];
    
    UIBarButtonItem *nextScreenBackButton = [[UIBarButtonItem alloc] initWithTitle:@"Try Again" style:UIBarButtonItemStyleBordered target:self action:nil];
    self.navigationItem.backBarButtonItem = nextScreenBackButton;
    
    self.navigationItem.title = @"Business Debts";
    
}

-(void) viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    if(![[SSUser currentUser] isLoggedIn]) {
        [self.navigationController popToRootViewControllerAnimated:YES];
    }
}

-(void) viewDidAppear:(BOOL)animated {
    self.currentDebtPos = 0;
    self.yesCount = 0;
    
    NSFetchRequest *studentDebtFetchRequest = [[NSFetchRequest alloc] init];
    
    NSEntityDescription *studentDebtEntity = [NSEntityDescription entityForName:@"CompanyDebt"
                                                         inManagedObjectContext:self.context];
    [studentDebtFetchRequest setEntity:studentDebtEntity];
    
    [studentDebtFetchRequest setPredicate:[NSPredicate predicateWithFormat:@"companyID = %@", [[SSUser currentUser] companyID]]];
    
    studentDebtFetchRequest.sortDescriptors = [NSArray arrayWithObject:[NSSortDescriptor sortDescriptorWithKey:@"companyDebtID" ascending:YES selector:nil]];
    
    NSError *errorSV;
    self.debts = [self.context executeFetchRequest:studentDebtFetchRequest error:&errorSV];
    
    if (self.debts.count == 0) {
        
        self.debtTypeLabel.text = @"Error!";
    } else {
        for(CompanyDebt *companyDebt in self.debts) {
            if([companyDebt selectedAsDebt]){
                [companyDebt setSelectedAsDebt:[NSNumber numberWithBool:NO]];
            }
        }
        self.debtTypeLabel.text = [(CompanyDebt *) [self.debts objectAtIndex:self.currentDebtPos] companyDebtLiteralUS];
    }
    
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (IBAction)yesButtonPressed:(id)sender {
    self.currentDebtPos++;
    self.yesCount++;
    [self saveAnswerAndContinue];
}

- (IBAction)noButtonPressed:(id)sender {
    self.currentDebtPos++;
    [self continueAsking];
}

-(void) saveAnswerAndContinue {
    [[self.debts objectAtIndex:self.currentDebtPos-1] setSelectedAsDebt:[NSNumber numberWithBool:YES]];
    [self continueAsking];
}

-(void) continueAsking {
    if(self.currentDebtPos < self.debts.count) {
        self.debtTypeLabel.text = [(CompanyDebt *) [self.debts objectAtIndex:self.currentDebtPos] companyDebtLiteralUS];
    } else {
        [self.context save:nil];
        [self performSegueWithIdentifier:@"BusinessDebtsAmounts" sender:self];
    }
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