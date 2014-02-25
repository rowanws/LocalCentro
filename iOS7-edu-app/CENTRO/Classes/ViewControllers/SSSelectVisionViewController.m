//
//  SSSelectVisionViewController.m
//  CENTRO
//
//  Created by Centro Community Partners.
//  Copyright (c) 2013 Centro Community Partners. All rights reserved.
//

#import "SSSelectVisionViewController.h"
#import "SSConfirmEditVisionViewController.h"
#import "Company.h"
#import "Purpose.h"
#import "SSUser.h"
#import "Vision.h"
#import "SSUtils.h"

@interface SSSelectVisionViewController ()

@property (strong, nonatomic) NSString *companyName;
@property (strong, nonatomic) NSManagedObjectContext *context;
@property (strong, nonatomic) Company *company;
@property (strong, nonatomic) Purpose *tempPurpose;
@property (strong, nonatomic) NSString *vision;

@end

@implementation SSSelectVisionViewController

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
    
    self.navigationItem.title = @"Vision";
    
    self.visionQuestionLabel.text = [NSString stringWithFormat:@"Which best fits %@?", [SSUtils companyName]];
    
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

    self.purposeATextView.text = [self findPurposeForKind:@"A"];
    self.purposeBTextView.text = [self findPurposeForKind:@"B"];
    self.purposeCTextView.text = [self findPurposeForKind:@"C"];
}

-(NSString *) findPurposeForKind: (NSString *) kind {
    
    NSString *purpose;
    NSPredicate *predicate;
    
    if([kind isEqualToString:@"A"]) {
        predicate = [NSPredicate predicateWithFormat:@"kind = %@", @"IDEAL_WORLD"];
    } else if([kind isEqualToString:@"B"]) {
        predicate = [NSPredicate predicateWithFormat:@"kind = %@", @"CUSTOMER_LIVES"];
    } else if([kind isEqualToString:@"C"]) {
        predicate = [NSPredicate predicateWithFormat:@"kind = %@", @"WORLD_IMPACT"];
    } else {
        purpose = @"";
    }
    
    NSSet *purposesWithKind = [self.company.purposes filteredSetUsingPredicate:predicate];
    purpose = [(Purpose *)[purposesWithKind anyObject] purpose];

    return purpose;

}


-(void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if([segue.identifier isEqualToString:@"ConfirmEditVision"]) {
        SSConfirmEditVisionViewController *confirmEditVisionViewController = (SSConfirmEditVisionViewController *) segue.destinationViewController;
        [confirmEditVisionViewController setVision:self.vision];
    }
}

-(void) viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    if(![[SSUser currentUser] isLoggedIn]) {
        [self.navigationController popToRootViewControllerAnimated:YES];
    }
}

- (IBAction)purposeAButtonPressed:(id)sender {
    self.vision = [self findPurposeForKind:@"A"];
    [self performSegueWithIdentifier:@"ConfirmEditVision" sender:self];
}
- (IBAction)purposeBButtonPressed:(id)sender {
    self.vision = [self findPurposeForKind:@"B"];
    [self performSegueWithIdentifier:@"ConfirmEditVision" sender:self];
}
- (IBAction)purposeCButtonPressed:(id)sender {
    self.vision = [self findPurposeForKind:@"C"];
    [self performSegueWithIdentifier:@"ConfirmEditVision" sender:self];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end
