//
//  SSCustomerProfileSamplesViewController.m
//  CENTRO
//
//  Created by Centro Community Partners.
//  Copyright (c) 2013 Centro Community Partners. All rights reserved.
//

#import "SSCustomerProfileSamplesViewController.h"
#import "SSUser.h"
#import "CustomerProfile.h"
#import "CustomerProfileSample.h"
#import "SSUtils.h"

@interface SSCustomerProfileSamplesViewController ()

@property (strong, nonatomic) NSManagedObjectContext *context;
@property (strong, nonatomic) CustomerProfile *profile;
@property int profilesGenerated;
@property int profilesAccepted;
@property BOOL looksGoodPressed;

@property (strong, nonatomic) NSMutableSet *boyNames;
@property (strong, nonatomic) NSMutableSet *girlNames;

@property (strong, nonatomic) NSString *name;
@property (strong, nonatomic) NSNumber *age;
@property (strong, nonatomic) NSNumber *income;
@property (strong, nonatomic) NSString *education;
@property (strong, nonatomic) NSString *occupation;
@property (strong, nonatomic) NSString *interest;
@property (strong, nonatomic) NSString *location;

@property (strong, nonatomic) NSMutableSet *occupations;
@property BOOL shouldRemoveOccupation;
@property (strong, nonatomic) NSArray* fetchedObjectsCO;

@property BOOL tryAgain;

@property (strong, nonatomic) NSString *allProfiles;

@property (strong, nonatomic) CustomerProfileSample *sample1;
@property (strong, nonatomic) CustomerProfileSample *sample2;
@property (strong, nonatomic) CustomerProfileSample *sample3;

@end

@implementation SSCustomerProfileSamplesViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {

    }
    return self;
}

- (IBAction)wrongButtonPressed:(id)sender {
    if(self.profilesGenerated < 20 && self.profilesAccepted < 3) {
        self.customerProfileTextView.text = [self generateCustomerProfile];
    } else {
        self.customerProfileTextView.text = @"";
        self.tryAgain = NO;
        [[SSUser currentUser] setSegueToPerform:@"13"];
        [self.navigationController popToRootViewControllerAnimated:NO];
        [self.navigationController.navigationBar popNavigationItemAnimated:NO];
    }
}

- (IBAction)rightButtonPressed:(id)sender {
    if(self.profilesAccepted < 3 && self.profilesGenerated < 20) {
        self.profilesAccepted++;
        [self storeProfile];
        
        if(self.shouldRemoveOccupation) {
            [self.occupations removeObject:self.occupation];
        }
        
        if(self.profilesAccepted == 1) {
            self.allProfiles = [NSString stringWithFormat:@"%@\n", self.customerProfileTextView.text];
        } else {
            self.allProfiles = [NSString stringWithFormat:@"%@%@\n", self.allProfiles, self.customerProfileTextView.text];
        }
        if(self.profilesAccepted < 3) {
            self.customerProfileTextView.text = [self generateCustomerProfile];
        }
    }
}
- (IBAction)looksGoodButtonPressed:(id)sender {
    self.looksGoodPressed = YES;
    
    [self.context save:nil];
    [[SSUser currentUser] setActivityNumberAsCompleted:@"13" andSyncStatus:NO];
    [self.navigationController popToRootViewControllerAnimated:YES];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    UIImage *bg40 = [UIImage imageNamed:@"bg-568h@2x.png"];
    UIImage *bg35R = [UIImage imageNamed:@"bg.png"];
    
    CGRect screenBounds = [[UIScreen mainScreen] bounds];
    if (screenBounds.size.height == 568) {
        self.backgroundImageView.image = bg40;
    } else {
        self.backgroundImageView.image = bg35R;
    }
    
    self.context = [(id)[[UIApplication sharedApplication] delegate] managedObjectContext];
    
    self.questionLabel.text = [NSString stringWithFormat:@"Does this look sound like one of %@'s customers?", [SSUtils companyName]];
    [self.rightButton setTitle:@"This Sounds Right!" forState:UIControlStateNormal];
    [self.wrongButton setTitle:@"Something's Wrong Here" forState:UIControlStateNormal];
    [self.looksGoodButton setTitle:@"Looks Good To Me" forState:UIControlStateNormal];
    self.looksGoodButton.hidden = YES;
    
    self.navigationItem.title = @"Customer Profiles";
    
}

-(void)viewWillAppear:(BOOL)animated{
    self.questionLabel.lineBreakMode = NSLineBreakByWordWrapping;
    self.questionLabel.numberOfLines = 3;
}

-(void) viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    if(![[SSUser currentUser] isLoggedIn]) {
        //[self.navigationController popToRootViewControllerAnimated:YES];
    } else {
        
        NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
        
        NSEntityDescription *entity = [NSEntityDescription entityForName:@"CustomerProfile"
                                                  inManagedObjectContext:self.context];
        [fetchRequest setEntity:entity];
        
        [fetchRequest setPredicate:[NSPredicate predicateWithFormat:@"companyID = %@", [[SSUser currentUser] companyID]]];
        
        NSError *error;
        NSArray *fetchedObjects = [self.context executeFetchRequest:fetchRequest error:&error];
        
        if (fetchedObjects.count == 0) { 
            
        } else {
            self.profile = (CustomerProfile *) [fetchedObjects objectAtIndex:0];
        }
        
        self.profilesGenerated = 0;
        self.profilesAccepted = 0;
        self.looksGoodPressed = NO;

        self.boyNames = [NSMutableSet setWithObjects:@"Bob", @"David", @"Carlos", @"Robert", @"Louis", @"Frank", @"Vito", @"Mike", @"Tom", @"Fredo", @"Alex", @"Adam", @"Juan", @"James", @"Max", @"Jack", @"Blake", @"Ryan", @"Benjamin", @"Tristan", nil];
        self.girlNames = [NSMutableSet setWithObjects:@"Theresa", @"Sara", @"Linda", @"Sandra", @"Jennifer", @"Abby", @"Kay", @"Mary", @"Aylin", @"Beatriz", @"Kylie", @"Emily", @"Gabriella", @"Alyssa", @"Stella", @"Lucy", @"Ashley", @"Sophie", @"Trinity", @"Victoria", nil];
        
        NSFetchRequest *fetchRequestCO = [[NSFetchRequest alloc] init];
        
        NSEntityDescription *entityCO = [NSEntityDescription entityForName:@"CustomerOccupation"
                                                  inManagedObjectContext:self.context];
        [fetchRequestCO setEntity:entityCO];
        
        [fetchRequestCO setPredicate:[NSPredicate predicateWithFormat:@"customerProfileID = %@ AND selectedAsCustomerOccupation = 1", [[SSUser currentUser] companyID]]];
        
        NSError *errorCO;
        self.fetchedObjectsCO = [self.context executeFetchRequest:fetchRequestCO error:&errorCO];
        
        if (self.fetchedObjectsCO.count == 0) {
            
        } else {
            
            self.occupations = [[NSMutableSet alloc] init];
            
            for (int i = 0; i < self.fetchedObjectsCO.count; i++) {
                [self.occupations addObject:[[self.fetchedObjectsCO objectAtIndex:i] valueForKey:@"occupationCode"]];
            }
            
            if(self.fetchedObjectsCO.count >= 3) {
                self.shouldRemoveOccupation = YES;
            } else {
                self.shouldRemoveOccupation = NO;
            }
            
        }
        
        self.tryAgain = YES;
        self.customerProfileTextView.text = [self generateCustomerProfile];
    }
}

-(NSString *) generateCustomerProfile {
    
    self.profilesGenerated++;
    
    NSString *customerProfileSample = @"";
    NSString *customerAge = @"";
    NSString *customerGender = @"";
    NSString *customerIncome = @"";
    NSString *customerEducation = @"";
    NSString *customerOccupation = @"";
    NSString *customerInterest = @"";
    NSString *customerLocation = @"";
    
    
    if(YES/*[self.profile.isGenderSure intValue] == 1*/) {
        
        int gender = [self randomValueBetween:0 and:100];

        if ([self.profile.womenPercentage intValue] > [self.profile.menPercentage intValue]) {
            if (gender <= [self.profile.menPercentage intValue]) {
                customerGender = [self.boyNames anyObject];
                [self.boyNames removeObject:customerGender];
            } else {
                customerGender = [self.girlNames anyObject];
                [self.girlNames removeObject:customerGender];
            }
        } else if([self.profile.womenPercentage intValue] < [self.profile.menPercentage intValue]) {
            if (gender <= [self.profile.womenPercentage intValue]) {
                customerGender = [self.girlNames anyObject];
                [self.girlNames removeObject:customerGender];
            } else {
                customerGender = [self.boyNames anyObject];
                [self.boyNames removeObject:customerGender];
            }
        } else {
            if (gender >= 50) {
                customerGender = [self.girlNames anyObject];
                [self.girlNames removeObject:customerGender];
            } else {
                customerGender = [self.boyNames anyObject];
                [self.boyNames removeObject:customerGender];
            }
        }
        
        customerGender = [NSString stringWithFormat:@"%@\n", customerGender];
        self.name = customerGender;
    }
    if(YES/*[self.profile.isAgeSure intValue] == 1*/) {

        int age = [self randomValueBetween:[self.profile.fromAge intValue] and:[self.profile.toAge intValue]];
        customerAge = [NSString stringWithFormat:@"%d years old\n", age];
        self.age = [NSNumber numberWithInt:age];
    }
    if(YES/*[self.profile.isIncomeSure intValue] == 1*/) {

        int income = [self randomValueBetween:[self.profile.fromIncome intValue] and:[self.profile.toIncome intValue]];
        
        if (income < 1000) {
            income = 100 * round(income/100);
        } else {
            income = 1000 * round(income/1000);
        }
        
        if (income == 0) {
            income = 100;
        }
    
        NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
        [formatter setNumberStyle:NSNumberFormatterCurrencyStyle];
        NSString *incomeString = [formatter stringFromNumber:[NSNumber numberWithInt:income]];
        incomeString = [incomeString stringByReplacingOccurrencesOfString:@".00" withString:@""];
        customerIncome = [NSString stringWithFormat:@"Makes %@ per year\n", incomeString];
        
        self.income = [NSNumber numberWithInt:income];
        
    }
    if(YES/*[self.profile.isEducationSure intValue] == 1*/) {
        NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
        
        NSEntityDescription *entity = [NSEntityDescription entityForName:@"CustomerEducation"
                                                  inManagedObjectContext:self.context];
        [fetchRequest setEntity:entity];
        
        [fetchRequest setPredicate:[NSPredicate predicateWithFormat:@"customerProfileID = %@ AND selectedAsCustomerEducation = 1", [[SSUser currentUser] companyID]]];
        
        NSError *error;
        NSArray *fetchedObjects = [self.context executeFetchRequest:fetchRequest error:&error];
        
        if (fetchedObjects.count == 0) { 
            
        } else {
            NSUInteger randomIndex = [self randomValueBetween:0 and:[fetchedObjects count]];
            customerEducation = [NSString stringWithFormat:@"%@\n", [[fetchedObjects objectAtIndex:randomIndex] valueForKey:@"educationLiteralUS"]];
            self.education = [[fetchedObjects objectAtIndex:randomIndex] valueForKey:@"educationCode"];
        }
    }
    if(YES/*[self.profile.isOccupationSure intValue] == 1*/) {
        
        NSArray *ocAr = [self.occupations allObjects];
        NSUInteger randomIndex = [self randomValueBetween:0 and:[ocAr count]];
        
        self.occupation = [ocAr objectAtIndex:randomIndex];
        customerOccupation = [NSString stringWithFormat:@"%@\n", [self literalForOccupationCode:self.occupation locale:@"US"]];
    }
    if(YES/*[self.profile.isInterestSure intValue] == 1*/) {
        NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
        
        NSEntityDescription *entity = [NSEntityDescription entityForName:@"CustomerInterest"
                                                  inManagedObjectContext:self.context];
        [fetchRequest setEntity:entity];
        
        [fetchRequest setPredicate:[NSPredicate predicateWithFormat:@"customerProfileID = %@ AND selectedAsCustomerInterest = 1", [[SSUser currentUser] companyID]]];
        
        NSError *error;
        NSArray *fetchedObjects = [self.context executeFetchRequest:fetchRequest error:&error];
        
        if (fetchedObjects.count == 0) { 
            
        } else {
            NSUInteger randomIndex = [self randomValueBetween:0 and:[fetchedObjects count]];
            customerInterest = [NSString stringWithFormat:@"Enjoys %@\n", [[fetchedObjects objectAtIndex:randomIndex] valueForKey:@"interestLiteralUS"]];
            self.interest = [[fetchedObjects objectAtIndex:randomIndex] valueForKey:@"interestCode"];
        }
    }
    if (YES/*[self.profile.isLocationSure intValue] == 1*/) {
        NSMutableArray *locations = [[NSMutableArray alloc] init];
        NSMutableArray *locationCodes = [[NSMutableArray alloc] init];
        
        if ([self.profile.locationWalk doubleValue] > 0.0) {
            [locations addObject:@"Lives a walking distance from your business\n"];
            [locationCodes addObject:@"WALK"];
        } if ([self.profile.locationShortDrive doubleValue] > 0.0) {
            [locations addObject:@"Lives a short drive from your business\n"];
            [locationCodes addObject:@"SHORT_DRIVE"];
        } if ([self.profile.locationLongDrive doubleValue] > 0.0) {
            [locations addObject:@"Lives a long drive from your business\n"];
            [locationCodes addObject:@"LONG_DRIVE"];
        } if ([self.profile.locationOnline doubleValue] > 0.0) {
            [locations addObject:@"Buy your products/services online\n"];
            [locationCodes addObject:@"ONLINE"];
        } if ([self.profile.locationOther doubleValue] > 0.0) {
            [locations addObject:@"Lives elsewhere\n"];
            [locationCodes addObject:@"OTHER"];
        }

        int position;
        if (locations.count > 1) {
            position = [self randomValueBetween:0 and:locations.count];
            customerLocation = [locations objectAtIndex:position];
            self.location = [locationCodes objectAtIndex:position];
        } else {
            customerLocation = [locations objectAtIndex:0];
            self.location = [locationCodes objectAtIndex:0];
        }
        
    }
    
    customerProfileSample = [NSString stringWithFormat:@"%@%@%@%@%@%@%@", customerGender, customerAge, customerOccupation, customerEducation, customerIncome, customerLocation, customerInterest];
    
    return customerProfileSample;
    
}

-(NSString *) literalForOccupationCode:(NSString *) occupationCode locale:(NSString *) locale {
    
    NSString *literal = @"";
    
    if ([locale isEqualToString:@"US"]) {
        for(int i = 0; i < self.fetchedObjectsCO.count; i++) {
            if ([[self.fetchedObjectsCO[i] valueForKey:@"occupationCode"] isEqualToString:occupationCode]) {
                literal = [self.fetchedObjectsCO[i] valueForKey:@"occupationLiteralUS"];
                break;
            }
        }
    }

    return literal;
}

-(void) storeProfile {
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"CustomerProfileSample"
                                              inManagedObjectContext:self.context];
    [fetchRequest setEntity:entity];
    
    [fetchRequest setPredicate:[NSPredicate predicateWithFormat:@"companyID = %@", [[SSUser currentUser] companyID]]];
    
    NSError *error;
    NSArray *fetchedObjects = [self.context executeFetchRequest:fetchRequest error:&error];
    
    if (fetchedObjects.count == 0) { 
        
    } else {
        CustomerProfileSample *temp = [fetchedObjects objectAtIndex:self.profilesAccepted-1];
        
        temp.companyID = temp.companyID;
        temp.customerProfileSampleID = temp.customerProfileSampleID;
        temp.company = temp.company;
        
        temp.name = self.name;
        temp.age = self.age;
        temp.income = self.income;
        temp.educationLevel = self.education;
        temp.profession = self.occupation;
        temp.interest = self.interest;
        temp.location = self.location;
        
        if(self.profilesAccepted == 1) {
            self.sample1 = temp;
        }
        
        if(self.profilesAccepted == 2) {
            self.sample2 = temp;
        }
        
        if(self.profilesAccepted == 3) {
            self.sample3 = temp;
            self.looksGoodButton.hidden = NO;
            self.rightButton.hidden = YES;
            self.wrongButton.hidden = YES;
            
            self.questionLabel.text = [NSString stringWithFormat:@"Congrats! Here are %@'s sample customer profiles.", [SSUtils companyName]];
            
            self.customerProfileTextView.text = self.allProfiles = [NSString stringWithFormat:@"%@%@\n", self.allProfiles, self.customerProfileTextView.text];
            
            [self.customerProfileTextView flashScrollIndicators];
        }
        
        [self.context save:nil];
    }
    
}

- (NSInteger)randomValueBetween:(NSInteger)min and:(NSInteger)max {
    return (NSInteger) min + arc4random() % (max - min);
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end