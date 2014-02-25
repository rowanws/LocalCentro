//
//  SSIdentifyBusinessCostsViewController.m
//  CENTRO
//
//  Created by Centro Community Partners.
//  Copyright (c) 2013 Centro Community Partners.
//

#import "SSIdentifyBusinessCostsViewController.h"
#import "SSUser.h"
#import "CompanyCost.h"
#import "Company.h"

@interface SSIdentifyBusinessCostsViewController ()

@property (strong, nonatomic) NSManagedObjectContext *context;
@property (strong, nonatomic) NSArray *costs;

@property int currentCostPos;
@property int yesCount;

@end

@implementation SSIdentifyBusinessCostsViewController

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
    
    self.questionLabel.text = [NSString stringWithFormat:@"Does %@ pay for...", companyName];
    
    [self.yesButton setTitle:@"YES" forState:UIControlStateNormal];
    [self.noButton setTitle:@"NO" forState:UIControlStateNormal];
    
    self.navigationItem.title = @"Business Costs";
    
    UIBarButtonItem *nextScreenBackButton = [[UIBarButtonItem alloc] initWithTitle:@"Try Again" style:UIBarButtonItemStyleBordered target:self action:nil];
    self.navigationItem.backBarButtonItem = nextScreenBackButton;
}

-(void) viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    if(![[SSUser currentUser] isLoggedIn]) {
        [self.navigationController popToRootViewControllerAnimated:YES];
    }
}

-(void) viewDidAppear:(BOOL)animated {
    self.currentCostPos = 0;
    self.yesCount = 0;
    
    NSFetchRequest *companyCostFetchRequest = [[NSFetchRequest alloc] init];
    
    NSEntityDescription *companyCostEntity = [NSEntityDescription entityForName:@"CompanyCost"
                                                         inManagedObjectContext:self.context];
    [companyCostFetchRequest setEntity:companyCostEntity];
    
    [companyCostFetchRequest setPredicate:[NSPredicate predicateWithFormat:@"companyID = %@", [[SSUser currentUser] companyID]]];
    
    companyCostFetchRequest.sortDescriptors = [NSArray arrayWithObject:[NSSortDescriptor sortDescriptorWithKey:@"companyCostID" ascending:YES selector:nil]];
    
    NSError *errorSV;
    self.costs = [self.context executeFetchRequest:companyCostFetchRequest error:&errorSV];
    
    if (self.costs.count == 0) {
        
        self.costTypeLabel.text = @"Error!";
    } else {
        for(CompanyCost *companyCost in self.costs) {
            if([companyCost selectedAsIncurredCost]){
                [companyCost setSelectedAsIncurredCost:[NSNumber numberWithBool:NO]];
            }
        }
        self.costTypeLabel.text = [(CompanyCost *) [self.costs objectAtIndex:self.currentCostPos] companyCostLiteralUS];
    }
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (IBAction)yesButtonPressed:(id)sender {
    self.currentCostPos++;
    self.yesCount++;
    [self saveAnswerAndContinue];
}

- (IBAction)noButtonPressed:(id)sender {
    self.currentCostPos++;
    [self continueAsking];
}

-(void) saveAnswerAndContinue {
    [[self.costs objectAtIndex:self.currentCostPos-1] setSelectedAsIncurredCost:[NSNumber numberWithBool:YES]];
    [self continueAsking];
}

-(void) continueAsking {
    if(self.currentCostPos < self.costs.count) {
        self.costTypeLabel.text = [(CompanyCost *) [self.costs objectAtIndex:self.currentCostPos] companyCostLiteralUS];
    } else {
        [self.context save:nil];
        [self performSegueWithIdentifier:@"BusinessCostAmounts" sender:self];
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