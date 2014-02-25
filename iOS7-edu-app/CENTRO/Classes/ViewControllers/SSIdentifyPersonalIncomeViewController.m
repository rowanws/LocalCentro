//
//  SSIdentifyPersonalIncomeViewController.m
//  CENTRO
//
//  Created by Centro Community Partners.
//  Copyright (c) 2013 Centro Community Partners.
//

#import "SSIdentifyPersonalIncomeViewController.h"
#import "SSUser.h"
#import "StudentIncome.h"

@interface SSIdentifyPersonalIncomeViewController ()

@property (strong, nonatomic) NSManagedObjectContext *context;
@property (strong, nonatomic) NSArray *incomes;

@property int currentIncomePos;
@property int yesCount;

@end

@implementation SSIdentifyPersonalIncomeViewController

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
    
    self.questionLabel.text = @"Where do you get income from?";
    
    [self.yesButton setTitle:@"YES" forState:UIControlStateNormal];
    [self.noButton setTitle:@"NO" forState:UIControlStateNormal];
    
    self.context = [(id)[[UIApplication sharedApplication] delegate] managedObjectContext];
    
    UIBarButtonItem *nextScreenBackButton = [[UIBarButtonItem alloc] initWithTitle:@"Try Again" style:UIBarButtonItemStyleBordered target:self action:nil];
    self.navigationItem.backBarButtonItem = nextScreenBackButton;
    
    self.navigationItem.title = @"Personal Income";
}

-(void) viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    if(![[SSUser currentUser] isLoggedIn]) {
        [self.navigationController popToRootViewControllerAnimated:YES];
    }
}

-(void) viewDidAppear:(BOOL)animated {
    self.currentIncomePos = 0;
    self.yesCount = 0;
    
    NSFetchRequest *studentIncomeFetchRequest = [[NSFetchRequest alloc] init];
    
    NSEntityDescription *studentIncomeEntity = [NSEntityDescription entityForName:@"StudentIncome"
                                                           inManagedObjectContext:self.context];
    [studentIncomeFetchRequest setEntity:studentIncomeEntity];
    
    [studentIncomeFetchRequest setPredicate:[NSPredicate predicateWithFormat:@"studentID = %@", [[SSUser currentUser] studentID]]];
    
    studentIncomeFetchRequest.sortDescriptors = [NSArray arrayWithObject:[NSSortDescriptor sortDescriptorWithKey:@"studentIncomeID" ascending:YES selector:nil]];
    
    NSError *errorSV;
    self.incomes = [self.context executeFetchRequest:studentIncomeFetchRequest error:&errorSV];
    
    if (self.incomes.count == 0) {
        
        self.incomeTypeLabel.text = @"Error!";
    } else {
        for(StudentIncome *studentIncome in self.incomes) {
            if([studentIncome selectedAsSourceOfIncome]){
                [studentIncome setSelectedAsSourceOfIncome:[NSNumber numberWithBool:NO]];
            }
        }
        self.incomeTypeLabel.text = [(StudentIncome *) [self.incomes objectAtIndex:self.currentIncomePos] studentIncomeLiteralUS];
    }
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (IBAction)yesButtonPressed:(id)sender {
    self.currentIncomePos++;
    self.yesCount++;
    [self saveAnswerAndContinue];
}

- (IBAction)noButtonPressed:(id)sender {
    self.currentIncomePos++;
    [self continueAsking];
}

-(void) saveAnswerAndContinue {
    [[self.incomes objectAtIndex:self.currentIncomePos-1] setSelectedAsSourceOfIncome:[NSNumber numberWithBool:YES]];
    [self continueAsking];
}

-(void) continueAsking {
    if(self.currentIncomePos < self.incomes.count) {
        if([[[self.incomes objectAtIndex:self.currentIncomePos] studentIncomeCode] isEqualToString:@"SIN_HOUS"]) {
            self.questionLabel.text = @"Does anyone else in your household earn income?";
            self.incomeTypeLabel.text = @"";
        } else {
            self.questionLabel.text = @"Where do you get income from?";
            self.incomeTypeLabel.text = [(StudentIncome *) [self.incomes objectAtIndex:self.currentIncomePos] studentIncomeLiteralUS];
        }
    } else {
        [self.context save:nil];
        [self performSegueWithIdentifier:@"PersonalIncomeAmounts" sender:self];
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


@end