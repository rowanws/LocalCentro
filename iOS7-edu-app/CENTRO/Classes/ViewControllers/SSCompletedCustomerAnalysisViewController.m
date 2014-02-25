//
//  SSCompletedCustomerAnalysisViewController.m
//  CENTRO
//
//  Created by Centro Community Partners.
//  Copyright (c) 2013 Centro Community Partners. All rights reserved.
//

#import "SSCompletedCustomerAnalysisViewController.h"
#import "SSUser.h"
#import "CustomerProfileSample.h"
#import "SSUtils.h"

@interface SSCompletedCustomerAnalysisViewController ()

@property (strong, nonatomic) NSManagedObjectContext *context;
@property (strong, nonatomic) NSArray *profileSamples;

@end

@implementation SSCompletedCustomerAnalysisViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {

    }
    return self;
}

- (IBAction)tryAgainButtonPressed:(id)sender {
    [[SSUser currentUser] setActivityNumberAsIncompleted:@"13"];
    
    UIStoryboard *profileStoryBoard = [UIStoryboard storyboardWithName: @"customer_info" bundle:Nil];
    UIViewController *initProfileView = [profileStoryBoard instantiateInitialViewController];
    initProfileView.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
    //[VC presentViewController:initProfileView animated: animation completion: NULL];
    
    [self.navigationController pushViewController:initProfileView animated:YES];
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
   // }
    
    self.context = [(id)[[UIApplication sharedApplication] delegate] managedObjectContext];
    
    self.navigationItem.title = @"Customers";
    
    self.tryAgainButton.title = @"Try Again!";
    
    self.customerProfileLabel.text = [NSString stringWithFormat:@"%@'s Sample Customer Profiles:", [SSUtils companyName]];

}

- (void) viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"CustomerProfileSample"
                                              inManagedObjectContext:self.context];
    [fetchRequest setEntity:entity];
    
    [fetchRequest setPredicate:[NSPredicate predicateWithFormat:@"companyID = %@", [[SSUser currentUser] companyID]]];
    
    NSError *error;
    NSArray *fetchedObjects = [self.context executeFetchRequest:fetchRequest error:&error];
    
    if (fetchedObjects.count == 0) { 
        
    } else {
        self.profileSamples = fetchedObjects;
        
        self.customerProfileTextView.text = [self generateCustomerProfile];
        
        [self.customerProfileTextView flashScrollIndicators];
    }
}

-(NSString *) generateCustomerProfile {
    
    
    NSString *customerProfileSamples = @"";
    NSString *customerName = @"";
    NSString *customerAge = @"";
    NSString *customerIncome = @"";
    NSString *customerEducation = @"";
    NSString *customerOccupation = @"";
    NSString *customerInterest = @"";
    NSString *customerLocation = @"";
    
    
    for (CustomerProfileSample *cps in self.profileSamples) {
        
        customerName = cps.name;

        int age = [cps.age intValue];
        customerAge = [NSString stringWithFormat:@"%d years old\n", age];
        
        customerOccupation = [NSString stringWithFormat:@"%@\n", [self literalForOccupationCode:cps.profession locale:@"US"]];
        
        customerEducation = [NSString stringWithFormat:@"%@\n", [self literalForEducationCode:cps.educationLevel locale:@"US"]];
        
        NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
        [formatter setNumberStyle:NSNumberFormatterCurrencyStyle];
        NSString *incomeString = [formatter stringFromNumber:cps.income];
        incomeString = [incomeString stringByReplacingOccurrencesOfString:@".00" withString:@""];
        customerIncome = [NSString stringWithFormat:@"Makes %@ per year\n", incomeString];
        
        if ([cps.location isEqualToString:@"WALK"]) {
            customerLocation = @"Lives a walking distance from your business\n";
        } else if ([cps.location isEqualToString:@"SHORT_DRIVE"]) {
            customerLocation = @"Lives a short drive from your business\n";
        } else if ([cps.location isEqualToString:@"LONG_DRIVE"]) {
            customerLocation = @"Lives a long drive from your business\n";
        } else if ([cps.location isEqualToString:@"ONLINE"]) {
            customerLocation = @"Buy your products/services online\n";
        } else if ([cps.location isEqualToString:@"OTHER"]) {
            customerLocation = @"Lives elsewhere\n";
        } else {
            customerLocation = @"";
        }

        customerInterest = [NSString stringWithFormat:@"Enjoys %@\n", [self literalForInterestCode:cps.interest locale:@"US"]];
        
        NSString *customerProfileSample = [NSString stringWithFormat:@"%@%@%@%@%@%@%@", customerName, customerAge, customerOccupation, customerEducation, customerIncome, customerLocation, customerInterest];
        
        if ([customerProfileSamples isEqualToString:@""]) {
            customerProfileSamples = customerProfileSample;
        } else {
            customerProfileSamples = [NSString stringWithFormat:@"%@\n%@", customerProfileSamples, customerProfileSample];
        }
    }
    
    return customerProfileSamples;
    
}


-(NSString *) literalForOccupationCode:(NSString *) occupationCode locale:(NSString *) locale {
    
    NSString *literal = @"";
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"CustomerOccupation"
                                                inManagedObjectContext:self.context];
    [fetchRequest setEntity:entity];
    
    [fetchRequest setPredicate:[NSPredicate predicateWithFormat:@"customerProfileID = %@ AND occupationCode = %@", [[SSUser currentUser] companyID], occupationCode]];
    
    NSError *error;
    NSArray *fetchedObjects = [self.context executeFetchRequest:fetchRequest error:&error];
    
    if (!fetchedObjects.count == 0) {
        if ([locale isEqualToString:@"US"]) {
            literal = [fetchedObjects[0] valueForKey:@"occupationLiteralUS"];
        }
    }

    return literal;
}

-(NSString *) literalForEducationCode:(NSString *) educationCode locale:(NSString *) locale {
    
    NSString *literal = @"";
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"CustomerEducation"
                                              inManagedObjectContext:self.context];
    [fetchRequest setEntity:entity];
    
    [fetchRequest setPredicate:[NSPredicate predicateWithFormat:@"customerProfileID = %@ AND educationCode = %@", [[SSUser currentUser] companyID], educationCode]];
    
    NSError *error;
    NSArray *fetchedObjects = [self.context executeFetchRequest:fetchRequest error:&error];
    
    if (!fetchedObjects.count == 0) {
        if ([locale isEqualToString:@"US"]) {
            literal = [fetchedObjects[0] valueForKey:@"educationLiteralUS"];
        }
    }
    
    return literal;
}

-(NSString *) literalForInterestCode:(NSString *) interestCode locale:(NSString *) locale {
    
    NSString *literal = @"";
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"CustomerInterest"
                                              inManagedObjectContext:self.context];
    [fetchRequest setEntity:entity];
    
    [fetchRequest setPredicate:[NSPredicate predicateWithFormat:@"customerProfileID = %@ AND interestCode = %@", [[SSUser currentUser] companyID], interestCode]];
    
    NSError *error;
    NSArray *fetchedObjects = [self.context executeFetchRequest:fetchRequest error:&error];
    
    if (!fetchedObjects.count == 0) {
        if ([locale isEqualToString:@"US"]) {
            literal = [fetchedObjects[0] valueForKey:@"interestLiteralUS"];
        }
    }
    
    return literal;
}

-(void) viewWillAppear:(BOOL)animate {
    [super viewWillAppear:animate];
    
    if(![[SSUser currentUser] isLoggedIn]) {
        [self.navigationController popToRootViewControllerAnimated:YES];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end