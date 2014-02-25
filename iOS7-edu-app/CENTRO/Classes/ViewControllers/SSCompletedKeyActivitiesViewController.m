//
//  SSCompletedKeyActivitiesViewController.m
//  CENTRO
//
//  Created by Centro Community Partners.
//  Copyright (c) 2013 Centro Community Partners. All rights reserved.
//

#import "SSCompletedKeyActivitiesViewController.h"
#import "SSUser.h"
#import "Company.h"
#import "Employee.h"
#import "Responsibility.h"
#import "EmployeeResponsibility.h"
#import "SSUtils.h"

@interface SSCompletedKeyActivitiesViewController ()

@property (strong, nonatomic) NSManagedObjectContext *context;
@property (strong, nonatomic) NSArray *employees;
@property (strong, nonatomic) Company *company;

@property int employeePos;
@property BOOL onlyMe;
@property int numberOfEmployees;

@end

@implementation SSCompletedKeyActivitiesViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {

    }
    return self;
}

- (IBAction)tryAgainButtonPressed:(id)sender {
    [[SSUser currentUser] setActivityNumberAsIncompleted:@"23"];
    
    UIStoryboard *profileStoryBoard = [UIStoryboard storyboardWithName: @"responsibilities" bundle:Nil];
    UIViewController *initProfileView = [profileStoryBoard instantiateInitialViewController];
    initProfileView.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
    //[VC presentViewController:initProfileView animated: animation completion: NULL];
    
    [self.navigationController pushViewController:initProfileView animated:YES];
}

- (IBAction)backButtonPressed:(id)sender {
    
    self.employeePos--;
    
    if(self.employeePos <= 0){
        self.backButton.hidden = YES;
    } else if (self.employeePos < self.numberOfEmployees){
        self.nextButton.hidden = NO;
    }
    
    [self refreshTextView];
    self.nextButton.hidden = NO;
    
}

- (IBAction)nextButtonPressed:(id)sender {
    
    self.employeePos++;
    
    if(self.employeePos == self.numberOfEmployees-1){
        self.nextButton.hidden = YES;
    } else if (self.employeePos < self.numberOfEmployees){
        self.backButton.hidden = NO;
    }
    
    [self refreshTextView];
    self.backButton.hidden = NO;
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
    
    self.navigationItem.title = @"Activities";
    
    self.tryAgainButton.title = @"Try Again!";
    
    self.titleLabel.text = [NSString stringWithFormat:@"%@'s key activities:", [SSUtils companyName]];
    
    [self.backButton setTitle:@"Back" forState:UIControlStateNormal];
    self.backButton.hidden = YES;
    
    [self.nextButton setTitle:@"Next" forState:UIControlStateNormal];
    self.nextButton.hidden = NO;
    
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
        if([self.company.numberOfEmployees intValue] == 1) {
            self.numberOfEmployees = 2;
            self.onlyMe = YES;
        } else {
            self.numberOfEmployees = [self.company.numberOfEmployees intValue]+1;
            self.onlyMe = NO;
            NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
            
            NSEntityDescription *entity = [NSEntityDescription entityForName:@"Employee"
                                                      inManagedObjectContext:self.context];
            [fetchRequest setEntity:entity];
            
            [fetchRequest setPredicate:[NSPredicate predicateWithFormat:@"companyID = %@ AND selectedAsEmployee = 1 AND myself = 0", [[SSUser currentUser] companyID]]];
            fetchRequest.sortDescriptors = [NSArray arrayWithObject:[NSSortDescriptor sortDescriptorWithKey:@"employeeID" ascending:YES selector:nil]];
            
            NSError *error;
            NSArray *fetchedObjects = [self.context executeFetchRequest:fetchRequest error:&error];
            if (fetchedObjects.count == 0) {
                
                self.nextButton.hidden = YES;
                self.backButton.hidden = YES;
            } else {
                self.employees = fetchedObjects;
            }
        }
    }
    
}

-(NSString *) meName {
    
    NSString *name = @"";
    
    NSFetchRequest *fetchRequestE = [[NSFetchRequest alloc] init];
    
    NSEntityDescription *entityE = [NSEntityDescription entityForName:@"Employee"
                                               inManagedObjectContext:self.context];
    [fetchRequestE setEntity:entityE];
    
    [fetchRequestE setPredicate:[NSPredicate predicateWithFormat:@"companyID = %@ AND selectedAsEmployee = 1 AND myself = 1", [[SSUser currentUser] companyID]]];
    fetchRequestE.sortDescriptors = [NSArray arrayWithObject:[NSSortDescriptor sortDescriptorWithKey:@"employeeID" ascending:YES selector:nil]];
    
    NSError *errorE;
    NSArray *fetchedEmployeeObjects = [self.context executeFetchRequest:fetchRequestE error:&errorE];
    if (fetchedEmployeeObjects.count == 0) {
        
    } else {
        Employee *emp = fetchedEmployeeObjects[0];
        name = [emp name];
    }
    
    return name;
}

-(void) viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    if(![[SSUser currentUser] isLoggedIn]) {
        [self.navigationController popToRootViewControllerAnimated:YES];
    } else {
        
        self.employeePos = 0;
        [self refreshTextView];
    }
}

-(void) refreshTextView {
    
    NSString *name = @"";
    NSString *activities = @"";
    
    if(self.onlyMe) {
        if(self.employeePos == 0) {
            name = [self meName];
            activities = [self allActivitiesForMe];
        } else if(self.employeePos == 1) {
            name = @"People outside my business";
            activities = [self allActivitiesForOther];
        }
    } else {
        if(self.employeePos == 0) {
            name = [self meName];
            activities = [self allActivitiesForMe];
        } else if(self.employeePos == self.numberOfEmployees-1) {
            name = @"People outside my business";
            activities = [self allActivitiesForOther];
        } else {
            name = [self.employees[self.employeePos-1] name];
            activities = [self allActivitiesForEmployeeID:[[self.employees[self.employeePos-1] employeeID] stringValue]];
        }
    }
    
    NSString *employeeText = [NSString stringWithFormat:@"%@\n\nActivities:\n%@", name, activities];
    
    self.employeeTextView.text = employeeText;
}

-(NSString *) allActivitiesForMe {
    
    NSString *activitiesForMe = @"";
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"EmployeeResponsibility"
                                              inManagedObjectContext:self.context];
    [fetchRequest setEntity:entity];
    
    [fetchRequest setPredicate:[NSPredicate predicateWithFormat:@"companyID = %@ AND isMyResponsibility = 1 AND selectedAsResponsibility = 1", [[SSUser currentUser] companyID]]];
    fetchRequest.sortDescriptors = [NSArray arrayWithObject:[NSSortDescriptor sortDescriptorWithKey:@"responsibilityID" ascending:YES selector:nil]];
    
    NSError *error;
    NSArray *fetchedObjects = [self.context executeFetchRequest:fetchRequest error:&error];
    if (fetchedObjects.count == 0) {
        
        activitiesForMe = @"No Activities Assigned.";
    } else {
        for (int i = 0; i < fetchedObjects.count; i++) {
            NSString *act = [self nameForResponsibilityID:[[fetchedObjects[i] responsibilityID] stringValue]];
            if (![act isEqualToString:@""]) {
                activitiesForMe = [NSString stringWithFormat:@"%@\n%@", activitiesForMe, act];
            }
        }
    }
    
    return activitiesForMe;
}

-(NSString *) allActivitiesForOther {
    
    NSString *activitiesForOther = @"";
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"EmployeeResponsibility"
                                              inManagedObjectContext:self.context];
    [fetchRequest setEntity:entity];
    
    [fetchRequest setPredicate:[NSPredicate predicateWithFormat:@"companyID = %@ AND isOtherResponsibility = 1 AND selectedAsResponsibility = 1", [[SSUser currentUser] companyID]]];
    fetchRequest.sortDescriptors = [NSArray arrayWithObject:[NSSortDescriptor sortDescriptorWithKey:@"responsibilityID" ascending:YES selector:nil]];
    
    NSError *error;
    NSArray *fetchedObjects = [self.context executeFetchRequest:fetchRequest error:&error];
    if (fetchedObjects.count == 0) {
        
        activitiesForOther = @"No Activities Assigned.";
    } else {
        for (int i = 0; i < fetchedObjects.count; i++) {
            NSString *act = [self nameForResponsibilityID:[[fetchedObjects[i] responsibilityID] stringValue]];
            if (![act isEqualToString:@""]) {
                activitiesForOther = [NSString stringWithFormat:@"%@\n%@", activitiesForOther, act];
            }
        }
    }
    
    return activitiesForOther;
}

-(NSString *) allActivitiesForEmployeeID:(NSString *) employeeID {
    
    NSString *activities = @"";
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"EmployeeResponsibility"
                                              inManagedObjectContext:self.context];
    [fetchRequest setEntity:entity];
    
    [fetchRequest setPredicate:[NSPredicate predicateWithFormat:@"companyID = %@ AND employeeID = %@ AND selectedAsResponsibility = 1", [[SSUser currentUser] companyID], employeeID]];
    fetchRequest.sortDescriptors = [NSArray arrayWithObject:[NSSortDescriptor sortDescriptorWithKey:@"employeeID" ascending:YES selector:nil]];
    
    NSError *error;
    NSArray *fetchedObjects = [self.context executeFetchRequest:fetchRequest error:&error];
    if (fetchedObjects.count == 0) {
        
        activities = @"No Activities Assigned.";
    } else {
        for (int i = 0; i < fetchedObjects.count; i++) {
            NSString *act = [self nameForResponsibilityID:[[fetchedObjects[i] responsibilityID] stringValue]];
            if (![act isEqualToString:@""]) {
                activities = [NSString stringWithFormat:@"%@\n%@", activities, act];
            }
        }
    }
    return activities;
}

-(NSString *) nameForResponsibilityID:(NSString *) responsibilityID {
    NSString *name = @"";
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Responsibility"
                                              inManagedObjectContext:self.context];
    [fetchRequest setEntity:entity];
    
    [fetchRequest setPredicate:[NSPredicate predicateWithFormat:@"companyID = %@ AND responsibilityID == %@", [[SSUser currentUser] companyID], responsibilityID]];
    fetchRequest.sortDescriptors = [NSArray arrayWithObject:[NSSortDescriptor sortDescriptorWithKey:@"responsibilityID" ascending:YES selector:nil]];
    
    NSError *error;
    NSArray *fetchedObjects = [self.context executeFetchRequest:fetchRequest error:&error];
    if (fetchedObjects.count == 0) {
        
    } else {
        name = [fetchedObjects[0] responsibilityDescription];
    }
    return name;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end