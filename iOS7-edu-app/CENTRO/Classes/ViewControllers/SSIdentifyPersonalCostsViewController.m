//
//  SSIdentifyPersonalCostsViewController.m
//  CENTRO
//
//  Created by Centro Community Partners.
//  Copyright (c) 2013 Centro Community Partners.
//

#import "SSIdentifyPersonalCostsViewController.h"
#import "SSUser.h"
#import "StudentCost.h"

@interface SSIdentifyPersonalCostsViewController ()

@property (strong, nonatomic) NSManagedObjectContext *context;
@property (strong, nonatomic) NSArray *costs;

@property int currentCostPos;
@property int yesCount;

@end

@implementation SSIdentifyPersonalCostsViewController

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
    
    self.questionLabel.text = @"Do you pay for...";
    
    [self.yesButton setTitle:@"YES" forState:UIControlStateNormal];
    [self.noButton setTitle:@"NO" forState:UIControlStateNormal];
    
    self.context = [(id)[[UIApplication sharedApplication] delegate] managedObjectContext];
    
    self.navigationItem.title = @"Personal Costs";
    
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
    
    NSFetchRequest *studentCostFetchRequest = [[NSFetchRequest alloc] init];
    
    NSEntityDescription *studentCostEntity = [NSEntityDescription entityForName:@"StudentCost"
                                                         inManagedObjectContext:self.context];
    [studentCostFetchRequest setEntity:studentCostEntity];
    
    [studentCostFetchRequest setPredicate:[NSPredicate predicateWithFormat:@"studentID = %@", [[SSUser currentUser] studentID]]];
    
    studentCostFetchRequest.sortDescriptors = [NSArray arrayWithObject:[NSSortDescriptor sortDescriptorWithKey:@"studentCostID" ascending:YES selector:nil]];
    
    NSError *errorSV;
    self.costs = [self.context executeFetchRequest:studentCostFetchRequest error:&errorSV];
    
    if (self.costs.count == 0) {
        
        self.costTypeLabel.text = @"Error!";
    } else {
        for(StudentCost *studentCost in self.costs) {
            if([studentCost selectedAsIncurredCost]){
                [studentCost setSelectedAsIncurredCost:[NSNumber numberWithBool:NO]];
            }
        }
        self.costTypeLabel.text = [(StudentCost *) [self.costs objectAtIndex:self.currentCostPos] studentCostLiteralUS];
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
        self.costTypeLabel.text = [(StudentCost *) [self.costs objectAtIndex:self.currentCostPos] studentCostLiteralUS];
    } else {
        [self.context save:nil];
        [self performSegueWithIdentifier:@"PersonalCostAmounts" sender:self];
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