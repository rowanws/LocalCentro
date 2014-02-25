//
//  SSPreSelectCompanyValuesViewController.m
//  CENTRO
//
//  Created by Centro Community Partners.
//  Copyright (c) 2013 Centro Community Partners. All rights reserved.
//

#import "SSPreSelectCompanyValuesViewController.h"
#import "SSUser.h"
#import "Company.h"
#import "Student.h"
#import "Value.h"
#import "Mission.h"
#import "Vision.h"
#import "SSUtils.h"

@interface SSPreSelectCompanyValuesViewController ()

@property (strong, nonatomic) NSManagedObjectContext *context;
@property (strong, nonatomic) NSString *personalValue;
@property (strong, nonatomic) Company *company;
@property (strong, nonatomic) NSArray *studentValuesFetchedObjects;
@property int currentValuePos;
@property int veryMuch;

@end

@implementation SSPreSelectCompanyValuesViewController

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
    
    self.navigationItem.title = @"Shared Values";
    
    self.questionLabel.text = [NSString stringWithFormat:@"Do %@'s mission and vision statements reflect the value:", [SSUtils companyName]];
    
    self.valueLabel.text = @"";
    
    NSFetchRequest *companyFetchRequest = [[NSFetchRequest alloc] init];
    
    NSEntityDescription *companyEntity = [NSEntityDescription entityForName:@"Company"
                                              inManagedObjectContext:self.context];
    [companyFetchRequest setEntity:companyEntity];
    
    [companyFetchRequest setPredicate:[NSPredicate predicateWithFormat:@"companyID = %@", [[SSUser currentUser] companyID]]];
    
    NSError *errorC;
    NSArray *companyFetchedObjects = [self.context executeFetchRequest:companyFetchRequest error:&errorC];
    if (companyFetchedObjects.count == 0) {
        
    } else {
        self.company = (Company *) [companyFetchedObjects objectAtIndex:0];
    }

    
    UIBarButtonItem *nextScreenBackButton = [[UIBarButtonItem alloc] initWithTitle:@"Try Again" style:UIBarButtonItemStyleBordered target:self action:nil];
    self.navigationItem.backBarButtonItem = nextScreenBackButton;

    NSString *visionString = self.company.vision.vision;

    NSString *missionString = self.company.mission.mission;
    
    self.visionMissionTextView.text = [NSString stringWithFormat:@"Vision: \n%@\n\nMission:\n%@", visionString, missionString];
    
}

-(void) viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    if(![[SSUser currentUser] isLoggedIn]) {
        [self.navigationController popToRootViewControllerAnimated:YES];
    }
}

-(void) viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    self.currentValuePos = 0;
    self.veryMuch = 0;
        
    NSFetchRequest *studentValuesFetchRequest = [[NSFetchRequest alloc] init];
    
    NSEntityDescription *studentValuesEntity = [NSEntityDescription entityForName:@"Value"
                                                           inManagedObjectContext:self.context];
    [studentValuesFetchRequest setEntity:studentValuesEntity];
    
    [studentValuesFetchRequest setPredicate:[NSPredicate predicateWithFormat:@"studentID = %@ AND rank > 0", [[SSUser currentUser] studentID]]];
    
    studentValuesFetchRequest.sortDescriptors = [NSArray arrayWithObject:[NSSortDescriptor sortDescriptorWithKey:@"rank" ascending:YES selector:nil]];
    
    NSError *errorSV;
    self.studentValuesFetchedObjects = [self.context executeFetchRequest:studentValuesFetchRequest error:&errorSV];
    
    if (self.studentValuesFetchedObjects.count == 0) {
        
        
        self.veryMuchButton.enabled = NO;
        self.aLittleButton.enabled = NO;
        self.notAtAllButton.enabled = NO;
        
        self.questionLabel.text = @"Please complete Personal Values first!";
        self.valueLabel.text = @"";
    } else {
        for(Value *studentValue in self.studentValuesFetchedObjects) {
            if([studentValue selectedAsCompanyValue]){
                [studentValue setSelectedAsCompanyValue:[NSNumber numberWithBool:NO]];
                [studentValue setCompanyRank:[NSNumber numberWithInt:-100]];
            }
        }
        self.valueLabel.text = [(Value *) [self.studentValuesFetchedObjects objectAtIndex:self.currentValuePos] valueLiteralUS];
        self.veryMuchButton.enabled = YES;
        self.aLittleButton.enabled = YES;
        self.notAtAllButton.enabled = YES;
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

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (IBAction)notAtAllButtonPressed:(id)sender {
    self.currentValuePos++;
    [[self.studentValuesFetchedObjects objectAtIndex:self.currentValuePos-1] setCompanyRank:[NSNumber numberWithInt:-100]];
    [[self.studentValuesFetchedObjects objectAtIndex:self.currentValuePos-1] setSelectedAsCompanyValue:[NSNumber numberWithBool:NO]];
    [self continueAsking];
}

- (IBAction)aLittleButtonPressed:(id)sender {
    self.currentValuePos++;
    [[self.studentValuesFetchedObjects objectAtIndex:self.currentValuePos-1] setCompanyRank:[NSNumber numberWithInt:-100]];
    [[self.studentValuesFetchedObjects objectAtIndex:self.currentValuePos-1] setSelectedAsCompanyValue:[NSNumber numberWithBool:NO]];
    [self continueAsking];
    
}

- (IBAction)veryMuchButtonPressed:(id)sender {
    self.currentValuePos++;
    [self saveAnswerAndContinue];
}

-(void) saveAnswerAndContinue {
    [[self.studentValuesFetchedObjects objectAtIndex:self.currentValuePos-1] setSelectedAsCompanyValue:[NSNumber numberWithBool:YES]];
    self.veryMuch++;
        [[self.studentValuesFetchedObjects objectAtIndex:self.currentValuePos-1] setCompanyRank:[NSNumber numberWithInt:self.veryMuch]];
    [self continueAsking];
}

-(void) continueAsking {
    if(self.currentValuePos < 8 && self.veryMuch < 5) {
        self.valueLabel.text = [(Value *) [self.studentValuesFetchedObjects objectAtIndex:self.currentValuePos] valueLiteralUS];
    } else {
        [self.context save:nil];
        [self performSegueWithIdentifier:@"ConfirmEditCorporateValues" sender:self];
    }
}

-(IBAction)dismissVC{
    [self dismissViewControllerAnimated:YES completion:NULL];
}

@end
