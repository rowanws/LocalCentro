//
//  SSIdentifyPersonalDebtsViewController.m
//  CENTRO
//
//  Created by Centro Community Partners.
//  Copyright (c) 2013 Centro Community Partners.
//

#import "SSIdentifyPersonalDebtsViewController.h"
#import "SSUser.h"
#import "StudentDebt.h"

@interface SSIdentifyPersonalDebtsViewController ()

@property (strong, nonatomic) NSManagedObjectContext *context;
@property (strong, nonatomic) NSArray *debts;

@property int currentDebtPos;
@property int yesCount;

@end

@implementation SSIdentifyPersonalDebtsViewController

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
    
    self.questionLabel.text = @"Do you have the following?";
    
    [self.yesButton setTitle:@"YES" forState:UIControlStateNormal];
    [self.noButton setTitle:@"NO" forState:UIControlStateNormal];
    
    self.context = [(id)[[UIApplication sharedApplication] delegate] managedObjectContext];
    
    UIBarButtonItem *nextScreenBackButton = [[UIBarButtonItem alloc] initWithTitle:@"Try Again" style:UIBarButtonItemStyleBordered target:self action:nil];
    self.navigationItem.backBarButtonItem = nextScreenBackButton;
    
    self.navigationItem.title = @"Personal Debts";
    
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
    
    NSEntityDescription *studentDebtEntity = [NSEntityDescription entityForName:@"StudentDebt"
                                                         inManagedObjectContext:self.context];
    [studentDebtFetchRequest setEntity:studentDebtEntity];
    
    [studentDebtFetchRequest setPredicate:[NSPredicate predicateWithFormat:@"studentID = %@", [[SSUser currentUser] studentID]]];
    
    studentDebtFetchRequest.sortDescriptors = [NSArray arrayWithObject:[NSSortDescriptor sortDescriptorWithKey:@"studentDebtID" ascending:YES selector:nil]];
    
    NSError *errorSV;
    self.debts = [self.context executeFetchRequest:studentDebtFetchRequest error:&errorSV];
    
    if (self.debts.count == 0) {
        
        self.debtTypeLabel.text = @"Error!";
    } else {
        for(StudentDebt *studentDebt in self.debts) {
            if([studentDebt selectedAsDebt]){
                [studentDebt setSelectedAsDebt:[NSNumber numberWithBool:NO]];
            }
        }
        self.debtTypeLabel.text = [(StudentDebt *) [self.debts objectAtIndex:self.currentDebtPos] studentDebtLiteralUS];
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
        self.debtTypeLabel.text = [(StudentDebt *) [self.debts objectAtIndex:self.currentDebtPos] studentDebtLiteralUS];
    } else {
        [self.context save:nil];
        [self performSegueWithIdentifier:@"PersonalDebtsAmounts" sender:self];
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