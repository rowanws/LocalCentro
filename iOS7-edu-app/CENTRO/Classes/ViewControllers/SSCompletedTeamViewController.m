//
//  SSCompletedTeamViewController.m
//  CENTRO
//
//  Created by Centro Community Partners.
//  Copyright (c) 2013 Centro Community Partners. All rights reserved.
//

#import "SSCompletedTeamViewController.h"
#import "SSUser.h"
#import "Employee.h"
#import "EmployeeEducation.h"
#import "SSUtils.h"

@interface SSCompletedTeamViewController ()

@property (strong, nonatomic) NSManagedObjectContext *context;
@property (strong, nonatomic) NSArray *employees;

@property int employeePos;

@end

@implementation SSCompletedTeamViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {

    }
    return self;
}

- (IBAction)tryAgainButtonPressed:(id)sender {
    [[SSUser currentUser] setActivityNumberAsIncompleted:@"21"];
    
    UIStoryboard *profileStoryBoard = [UIStoryboard storyboardWithName: @"employees" bundle:Nil];
    UIViewController *initProfileView = [profileStoryBoard instantiateInitialViewController];
    initProfileView.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
    //[VC presentViewController:initProfileView animated: animation completion: NULL];
    
    [self.navigationController pushViewController:initProfileView animated:YES];
}

- (IBAction)backButtonPressed:(id)sender {
    
    self.employeePos--;
    
    if(self.employeePos <= 0){
        self.backButton.hidden = YES;
    } else if (self.employeePos < self.employees.count){
        self.nextButton.hidden = NO;
    }
    
    [self refreshTextView];
    self.nextButton.hidden = NO;
    
}

- (IBAction)nextButtonPressed:(id)sender {
    
    self.employeePos++;
    
    if(self.employeePos == self.employees.count-1){
        self.nextButton.hidden = YES;
    } else if (self.employeePos < self.employees.count){
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
    
    self.navigationItem.title = @"Team";
    
    self.titleLabel.text = [NSString stringWithFormat:@"%@'s team", [SSUtils companyName]];
    
    [self.backButton setTitle:@"Back" forState:UIControlStateNormal];
    self.backButton.hidden = YES;
    
    [self.nextButton setTitle:@"Next" forState:UIControlStateNormal];
    self.nextButton.hidden = NO;
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Employee"
                                              inManagedObjectContext:self.context];
    [fetchRequest setEntity:entity];
    
    [fetchRequest setPredicate:[NSPredicate predicateWithFormat:@"companyID = %@ AND selectedAsEmployee == 1", [[SSUser currentUser] companyID]]];
    fetchRequest.sortDescriptors = [NSArray arrayWithObject:[NSSortDescriptor sortDescriptorWithKey:@"employeeID" ascending:YES selector:nil]];
    
    NSError *error;
    NSArray *fetchedObjects = [self.context executeFetchRequest:fetchRequest error:&error];
    if (fetchedObjects.count == 0) {
        
    } else {
        self.employees = fetchedObjects;
        
        if (fetchedObjects.count == 1) {
            self.nextButton.hidden = YES;
            self.backButton.hidden = YES;
        }
    }
    
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
    
    Employee *emp = self.employees[self.employeePos];
    
    NSString *name = emp.name;
    
    NSString *manager = @"";
    if([emp.manager isEqualToNumber:[NSNumber numberWithBool:YES]]) {
        manager = @"(Manager)";
    }
    
    NSString *education = @"";
    NSFetchRequest *fetchRequest = [NSFetchRequest fetchRequestWithEntityName:@"EmployeeEducation"];
    [fetchRequest setPredicate:[NSPredicate predicateWithFormat:@"employeeID = %@ AND selectedAsEmployeeEducation == 1", emp.employeeID]];
    fetchRequest.sortDescriptors = [NSArray arrayWithObject:[NSSortDescriptor sortDescriptorWithKey:@"educationID" ascending:YES selector:nil]];
    fetchRequest.returnsObjectsAsFaults = NO;
    
    NSError *error;
    NSArray *educations = [self.context executeFetchRequest:fetchRequest error:&error];
    
    for(EmployeeEducation *empEdu in educations) {
        if ([education isEqualToString:@""]) {
            education = [NSString stringWithFormat:@"%@%@", education, empEdu.educationLiteralUS];
        } else {
            education = [NSString stringWithFormat:@"%@\n%@", education, empEdu.educationLiteralUS];
        }
    }
    
    
    NSString *experience = @"";
    if([emp.professionalExperience intValue] == 0) {
        experience = @"None";
    } else if([emp.professionalExperience intValue] == 1) {
        experience = @"Less than 1 year";
    } else if([emp.professionalExperience intValue] == 2) {
        experience = @"1 year";
    } else if([emp.professionalExperience intValue] == 3) {
        experience = @"2 years";
    } else if([emp.professionalExperience intValue] == 4) {
        experience = @"3 years";
    } else if([emp.professionalExperience intValue] == 5) {
        experience = @"4 years";
    } else if([emp.professionalExperience intValue] == 6) {
        experience = @"5 years";
    } else if([emp.professionalExperience intValue] == 7) {
        experience = @"6 years";
    } else if([emp.professionalExperience intValue] == 8) {
        experience = @"7 years";
    } else if([emp.professionalExperience intValue] == 9) {
        experience = @"8 years";
    } else if([emp.professionalExperience intValue] == 10) {
        experience = @"9 years";
    } else if([emp.professionalExperience intValue] == 11) {
        experience = @"10+ years";
    }
    
    NSString *employeeText = [NSString stringWithFormat:@"%@ %@\n\nEducation:\n%@\n\nExperience: %@", name, manager, education, experience];
    
    self.employeeTextView.text = employeeText;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end