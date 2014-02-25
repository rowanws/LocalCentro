//
//  SSDevelopmentAreasViewController.m
//  CENTRO
//
//  Created by Centro Community Partners.
//  Copyright (c) 2013 Centro Community Partners. All rights reserved.
//

#import "SSDevelopmentAreasViewController.h"
#import "SSUser.h"
#import "Responsibility.h"
#import "EmployeeResponsibility.h"
#import "Employee.h"

@interface SSDevelopmentAreasViewController ()

@property (strong, nonatomic) NSManagedObjectContext *context;
@property (strong, nonatomic) NSArray *responsibilityIDs;
@property (strong, nonatomic) NSMutableArray *employeeIDs;

@end

@implementation SSDevelopmentAreasViewController

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
    
    self.navigationItem.title = @"Competencies";
    
    self.titleLabel.text = @"Here are some areas that need improvement.";
    
    self.employeeIDs = [[NSMutableArray alloc] init];
    
    NSFetchRequest *fetchRequestEM = [[NSFetchRequest alloc] init];
    
    NSEntityDescription *entityEMP = [NSEntityDescription entityForName:@"Employee"
                                                 inManagedObjectContext:self.context];
    [fetchRequestEM setEntity:entityEMP];
    
    [fetchRequestEM setPredicate:[NSPredicate predicateWithFormat:@"selectedAsEmployee = 1"]];
    
    NSError *errorEM;
    NSArray *fetchedObjectsEM = [self.context executeFetchRequest:fetchRequestEM error:&errorEM];
    if (fetchedObjectsEM.count == 0) {
        
    } else {
        for (Employee *emp in fetchedObjectsEM) {
            [self.employeeIDs addObject:emp.employeeID];
        }
        
    }
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"EmployeeResponsibility"
                                                     inManagedObjectContext:self.context];
    [fetchRequest setEntity:entity];
    
    [fetchRequest setPredicate:[NSPredicate predicateWithFormat:@"rank = 1 AND selectedAsResponsibility = 1 AND employeeID IN %@", self.employeeIDs]];
    
    NSError *error;
    NSArray *fetchedObjects = [self.context executeFetchRequest:fetchRequest error:&error];
    if (fetchedObjects.count == 0) {
        
        [self fillNoDevelopmentAreasTextView];
    } else {
        
        NSMutableArray *duplicateResponsibilityIDs = [[NSMutableArray alloc] init];
        
        for(EmployeeResponsibility *er in fetchedObjects) {
            [duplicateResponsibilityIDs addObject:er.responsibilityID];
        }
        
        self.responsibilityIDs = [[NSSet setWithArray:duplicateResponsibilityIDs] allObjects];
        
        duplicateResponsibilityIDs = nil;
        
        [self fillCoreCompetenciesTextView];
    }
}

-(void) fillNoDevelopmentAreasTextView {
    
    NSString *coreCompetencies = @"You don't have development areas.";
    
    self.coreCompetenciesTextView.text = coreCompetencies;
    
    [self.coreCompetenciesTextView flashScrollIndicators];
}

-(void) fillCoreCompetenciesTextView {
    
    NSString *coreCompetencies = @"";
    
    for (int i = 0; i < self.responsibilityIDs.count; i++) {
        if (![coreCompetencies isEqualToString:@""]) {
            coreCompetencies = [NSString stringWithFormat:@"%@\n%@", coreCompetencies, [self responsibilityDescriptionForResponsibility:self.responsibilityIDs[i]]];
        } else {
            coreCompetencies = [NSString stringWithFormat:@"%@", [self responsibilityDescriptionForResponsibility:self.responsibilityIDs[i]]];
        }
        
    }
    
    self.coreCompetenciesTextView.text = coreCompetencies;
    
    [self.coreCompetenciesTextView flashScrollIndicators];
}

- (IBAction)doneButtonPressed:(id)sender {
    [self.context save:nil];
    
    [[SSUser currentUser] setActivityNumberAsCompleted:@"25" andSyncStatus:NO];
    
    [self.navigationController popToRootViewControllerAnimated:YES];
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

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end