//
//  SSPurposesViewController.m
//  CENTRO
//
//  Created by Centro Community Partners.
//  Copyright (c) 2013 Centro Community Partners. All rights reserved.
//

#import "SSPurposesViewController.h"
#import "SSSelectVisionViewController.h"
#import "SSUser.h"
#import "Company.h"
#import "Purpose.h"

@interface SSPurposesViewController ()

@property int currentQuestionNumber;
@property (strong, nonatomic) NSString *companyName;
@property (strong, nonatomic) NSManagedObjectContext *context;
@property (strong, nonatomic) Company *company;
@property (strong, nonatomic) Purpose *tempPurpose;

@end

@implementation SSPurposesViewController

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
    
    //UIImage *bg40 = [UIImage imageNamed:@"bg-568h@2x.png"];
    //UIImage *bg35R = [UIImage imageNamed:@"bg.png"];
    
    //CGRect screenBounds = [[UIScreen mainScreen] bounds];
    //if (screenBounds.size.height == 568) {
    //    self.backgroundImageView.image = bg40;
    //} else {
    //    self.backgroundImageView.image = bg35R;
    //}
    
    self.context = [(id)[[UIApplication sharedApplication] delegate] managedObjectContext];
    
    self.navigationItem.title = @"Your Purpose";
    
    self.purposeQuestionLabel.text = @"";
    self.purposeAnswerTextView.text = @"";
    
    UIBarButtonItem *nextScreenBackButton = [[UIBarButtonItem alloc] initWithTitle:@"Try Again" style:UIBarButtonItemStyleBordered target:self action:nil];
    self.navigationItem.backBarButtonItem = nextScreenBackButton;

}

- (void) viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    if(![[SSUser currentUser] isLoggedIn]) {
        [self.navigationController popToRootViewControllerAnimated:YES];
    }
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Company"
                                              inManagedObjectContext:self.context];
    [fetchRequest setEntity:entity];
    
    [fetchRequest setPredicate:[NSPredicate predicateWithFormat:@"companyID = %@", [[SSUser currentUser] companyID]]];
    
    NSError *error;
    NSArray *fetchedObjects = [self.context executeFetchRequest:fetchRequest error:&error];
    if (fetchedObjects.count == 0) {
        
    } else {
        self.company = (Company *) [fetchedObjects objectAtIndex:0];
    }
    
    if (self.company.name.length == 0) {
        self.companyName = @"your company";
    } else {
        self.companyName = self.company.name;
    }
    
    self.currentQuestionNumber = 0;
    self.tempPurpose = (Purpose *) [self findPurposeForKind:@"IDEAL_WORLD"];
    self.purposeQuestionLabel.text = [NSString stringWithFormat:@"In an ideal world, what would %@ stand for?", self.companyName];
    self.purposeAnswerTextView.text = [self.tempPurpose purpose];
}

@synthesize backPurposeButton, nextPurposeButton;

- (IBAction) doBackPurposeButton {
    //self.window.backgroundColor = [UIColor redColor];
    //window.backgroundColor = [UIColor redColor];
}

- (IBAction) doNextPurposeButton {
    // [[UIApplication sharedApplication] keyWindow].backgroundColor = [UIColor greenColor];
    //self.window.backgroundColor = [UIColor greenColor];
    //window.backgroundColor = [UIColor greenColor];
}


- (IBAction)nextButtonPressed:(id)sender {
    
    self.tempPurpose.purpose = self.purposeAnswerTextView.text;
    
    NSError *error;
    if (![self.context save:&error]) {
        NSLog(@"Whoops, couldn't save: %@", [error localizedDescription]);
    } else {
        self.currentQuestionNumber++;
    }    
    [self updateQuestionMovingForward:YES];
}

- (IBAction)backButtonPressed:(id)sender {
    
    self.tempPurpose.purpose = self.purposeAnswerTextView.text;
    
    NSError *error;
    if (![self.context save:&error]) {
        NSLog(@"Whoops, couldn't save: %@", [error localizedDescription]);
    } else {
        self.currentQuestionNumber--;
    }
    [self updateQuestionMovingForward:NO];
}


-(void) updateQuestionMovingForward:(BOOL) forward {
    
    if(self.currentQuestionNumber == 0) {
        self.purposeQuestionLabel.text = [NSString stringWithFormat:@"In an ideal world, what would %@ stand for?", self.companyName];
        self.tempPurpose = (Purpose *) [self findPurposeForKind:@"IDEAL_WORLD"];
        self.purposeAnswerTextView.text = [self.tempPurpose purpose];
    } else if (self.currentQuestionNumber == 1) {
        self.purposeQuestionLabel.text = [NSString stringWithFormat:@"How will %@ improve its customer's lives?", self.companyName];
        self.tempPurpose = (Purpose *) [self findPurposeForKind:@"CUSTOMER_LIVES"];
        self.purposeAnswerTextView.text = [self.tempPurpose purpose];
    } else if(self.currentQuestionNumber == 2) {
        self.purposeQuestionLabel.text = [NSString stringWithFormat:@"How will %@ impact the world?", self.companyName];
        self.tempPurpose = (Purpose *) [self findPurposeForKind:@"WORLD_IMPACT"];
        self.purposeAnswerTextView.text = [self.tempPurpose purpose];
    } else {
        if(forward) {
            
            [self.context save:nil];
            [self performSegueWithIdentifier:@"SelectVision" sender:self];
            
        } else {
            UINavigationController *nav = self.navigationController;
            [nav popViewControllerAnimated:YES];
        }
    }
    
    
}

-(Purpose *) findPurposeForKind: (NSString *) kind {
    NSSet *purposes = (NSSet *) self.company.purposes;
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"kind = %@", kind];
    
    NSSet *purposesWithKind = [purposes filteredSetUsingPredicate:predicate];
  
    return (Purpose *)[purposesWithKind anyObject];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    
    [self.purposeAnswerTextView resignFirstResponder];
}

-(IBAction)dismissVC{
    [self dismissViewControllerAnimated:YES completion:NULL];
}

@end
