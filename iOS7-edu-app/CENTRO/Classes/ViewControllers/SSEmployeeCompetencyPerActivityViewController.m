//
//  SSEmployeeCompetencyPerActivityViewController.m
//  CENTRO
//
//  Created by Silvio Salierno.
//  Copyright (c) 2013 Silvio Salierno. All rights reserved.
//

#import "SSEmployeeCompetencyPerActivityViewController.h"
#import "SSUser.h"
#import "Employee.h"
#import "Responsibility.h"
#import "EmployeeResponsibility.h"

@interface SSEmployeeCompetencyPerActivityViewController ()

@property (strong, nonatomic) NSManagedObjectContext *context;
@property (strong, nonatomic) NSArray *employeeResponsibility;

@property int currentEmployeeResponsibilityPos;

@end

@implementation SSEmployeeCompetencyPerActivityViewController

- (IBAction)nextButtonPressed:(id)sender {
    if ([self canContinueAfterValidateInputs]) {
        [self saveCurrent];
        self.currentEmployeeResponsibilityPos++;
        if (self.currentEmployeeResponsibilityPos < self.employeeResponsibility.count) {
            [self continueAsking];
        } else {
            [self.context save:nil];
            [self performSegueWithIdentifier:@"CoreCompetencies" sender:self];
        }
    }
}

- (void) silentNextButtonPressed {
    self.currentEmployeeResponsibilityPos++;
    if (self.currentEmployeeResponsibilityPos < self.employeeResponsibility.count) {
        [self continueAsking];
    } else {
        [self.context save:nil];
        [self performSegueWithIdentifier:@"CoreCompetencies" sender:self];
    }
}

- (IBAction)backButtonPressed:(id)sender {
    self.currentEmployeeResponsibilityPos--;
    [self continueAsking];
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
    
    UIFont *font = [UIFont boldSystemFontOfSize:11.0f];
    NSDictionary *attributes = [NSDictionary dictionaryWithObject:font forKey:UITextAttributeFont];
    
    [self.frequencySegmentedControl setTitleTextAttributes:attributes forState:UIControlStateNormal];
    
    [self.frequencySegmentedControl setTitle:@"Great" forSegmentAtIndex:2];
    [self.frequencySegmentedControl setTitle:@"Good\nEnough" forSegmentAtIndex:1];
    [self.frequencySegmentedControl setTitle:@"Need\nImprovement" forSegmentAtIndex:0];
    
    CGFloat width1 = 85.0;
    CGFloat width2 = 85.0;
    
    [self.frequencySegmentedControl setWidth:width1 forSegmentAtIndex:1];
    [self.frequencySegmentedControl setWidth:width2 forSegmentAtIndex:2];
    
    
    UIBarButtonItem *nextScreenBackButton = [[UIBarButtonItem alloc] initWithTitle:@"Competency" style:UIBarButtonItemStyleBordered target:self action:nil];
    self.navigationItem.backBarButtonItem = nextScreenBackButton;
    
    self.navigationItem.title = @"Activity Skill";
    
}

-(void) viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    self.currentEmployeeResponsibilityPos = 0;
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"EmployeeResponsibility"
                                              inManagedObjectContext:self.context];
    [fetchRequest setEntity:entity];
    
    [fetchRequest setPredicate:[NSPredicate predicateWithFormat:@"companyID = %@ AND selectedAsResponsibility = 1", [[SSUser currentUser] companyID]]];
    
    fetchRequest.sortDescriptors = [NSArray arrayWithObject:[NSSortDescriptor sortDescriptorWithKey:@"employeeID" ascending:NO selector:nil]];
    
    NSError *error;
    self.employeeResponsibility = [self.context executeFetchRequest:fetchRequest error:&error];
    
    if (self.employeeResponsibility.count == 0) {
        
        [self performSegueWithIdentifier:@"CoreCompetencies" sender:self];
    } else {
        NSString *employeeName = [self employeeNameForEmployee:[[self.employeeResponsibility[self.currentEmployeeResponsibilityPos] employeeID] stringValue]];
        NSString *activityDesc = [self responsibilityDescriptionForResponsibility:[[self.employeeResponsibility[self.currentEmployeeResponsibilityPos] responsibilityID] stringValue]];
        
        if ([employeeName isEqualToString:@""] || [activityDesc isEqualToString:@""]) {
            [self silentNextButtonPressed];
        } else {
            if ([employeeName isEqualToString:@"You"]) {
                self.questionLabel.text = [NSString stringWithFormat:@"How good are you at the following?"];
            } else {
                self.questionLabel.text = [NSString stringWithFormat:@"How good is %@ at the following?", employeeName];
            }
            
            self.activityLabel.text = activityDesc;
            
            self.frequencySegmentedControl.selectedSegmentIndex = [[self.employeeResponsibility[self.currentEmployeeResponsibilityPos] rank] intValue] - 1;
            
            self.backButton.hidden = YES;
        }
    }
}

-(NSString *) employeeNameForEmployee:(NSString *) employeeID  {
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Employee"
                                              inManagedObjectContext:self.context];
    [fetchRequest setEntity:entity];
    
    [fetchRequest setPredicate:[NSPredicate predicateWithFormat:@"employeeID = %@", employeeID]];
    
    fetchRequest.sortDescriptors = [NSArray arrayWithObject:[NSSortDescriptor sortDescriptorWithKey:@"employeeID" ascending:NO selector:nil]];
    
    NSError *error;
    NSArray *fetchedObjects = [self.context executeFetchRequest:fetchRequest error:&error];
    
    if (fetchedObjects.count == 0) {
        return @"";
    } else {
        return [fetchedObjects[0] name];
    }
}

-(NSString *) responsibilityDescriptionForResponsibility:(NSString *) responsibilityID  {
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Responsibility"
                                              inManagedObjectContext:self.context];
    [fetchRequest setEntity:entity];
    
    [fetchRequest setPredicate:[NSPredicate predicateWithFormat:@"responsibilityID = %@", responsibilityID]];
    
    fetchRequest.sortDescriptors = [NSArray arrayWithObject:[NSSortDescriptor sortDescriptorWithKey:@"responsibilityID" ascending:NO selector:nil]];
    
    NSError *error;
    NSArray *fetchedObjects = [self.context executeFetchRequest:fetchRequest error:&error];
    
    if (fetchedObjects.count == 0) {
        
        return @"";
    } else {
        return [fetchedObjects[0] responsibilityDescription];
    }
}

-(void) frequencyChanged {
    [self.employeeResponsibility[self.currentEmployeeResponsibilityPos] setRank:[NSNumber numberWithInt:self.frequencySegmentedControl.selectedSegmentIndex+1]];
}


-(void) saveCurrent {
    
}

-(void) continueAsking {
    
    if (self.currentEmployeeResponsibilityPos > 0) {
        self.backButton.hidden = NO;
    } else if (self.currentEmployeeResponsibilityPos == 0) {
        self.backButton.hidden = YES;
    }
    
    NSString *employeeName = [self employeeNameForEmployee:[[self.employeeResponsibility[self.currentEmployeeResponsibilityPos] employeeID] stringValue]];
    NSString *activityDesc = [self responsibilityDescriptionForResponsibility:[[self.employeeResponsibility[self.currentEmployeeResponsibilityPos] responsibilityID] stringValue]];
    
    if ([employeeName isEqualToString:@""] || [activityDesc isEqualToString:@""]) {
        [self silentNextButtonPressed];
    } else {
        
        if ([employeeName isEqualToString:@"You"]) {
            self.questionLabel.text = [NSString stringWithFormat:@"How good are you at the following?"];
        } else {
            self.questionLabel.text = [NSString stringWithFormat:@"How good is %@ at the following?", employeeName];
        }
        
        self.activityLabel.text = activityDesc;
        
        self.frequencySegmentedControl.selectedSegmentIndex = [[self.employeeResponsibility[self.currentEmployeeResponsibilityPos] rank] intValue] - 1;
    }
}

-(BOOL) canContinueAfterValidateInputs {
    BOOL continueAfter = NO;
    
    int frequency = [[(EmployeeResponsibility *) [self.employeeResponsibility objectAtIndex:self.currentEmployeeResponsibilityPos] rank] intValue];
    if (frequency < 1 || frequency > 3) {
        continueAfter = NO;
        [[[UIAlertView alloc] initWithTitle:@"Selection Error"
                                    message:@"You need to select a competency before continue."
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