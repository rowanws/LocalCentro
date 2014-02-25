//
//  SSCustomerLocationsViewController.m
//  CENTRO
//
//  Created by Centro Community Partners.
//  Copyright (c) 2013 Centro Community Partners. All rights reserved.
//

#import "SSCustomerLocationsViewController.h"
#import "SSUser.h"
#import "CustomerProfile.h"
#import "SSUtils.h"

@interface SSCustomerLocationsViewController ()

@property (strong, nonatomic) NSManagedObjectContext *context;
@property (strong, nonatomic) CustomerProfile *profile;

@property int walkingPercentage;
@property int shortDrivePercentage;
@property int longDrivePercentage;
@property int onlinePercentage;
@property int otherPercentage;
@property BOOL isSure;

@end

@implementation SSCustomerLocationsViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {

    }
    return self;
}
- (IBAction)nextButtonPressed:(id)sender {
    
    if ([self totalPercentage] == 100) {
        self.profile.isLocationSure = [NSNumber numberWithBool:self.isSure];
        self.profile.locationWalk = [NSNumber numberWithFloat:self.walkingPercentage];
        self.profile.locationShortDrive = [NSNumber numberWithFloat:self.shortDrivePercentage];
        self.profile.locationLongDrive = [NSNumber numberWithFloat:self.longDrivePercentage];
        self.profile.locationOnline = [NSNumber numberWithFloat:self.onlinePercentage];
        self.profile.locationOther = [NSNumber numberWithFloat:self.otherPercentage];
        [self.context save:nil];
        
        [self performSegueWithIdentifier:@"SelectCustomerBuyerSampleProfiles" sender:self];
    } else {
        [[[UIAlertView alloc] initWithTitle:@"Selection Error"
                                    message:@"The sum of all percentages should equal 100%."
                                   delegate:nil
                          cancelButtonTitle:@"OK"
                          otherButtonTitles:nil] show];
    }
}

- (IBAction)isSureButtonPressed:(id)sender {
    self.isSure = !self.isSure;
    [self drawSureButton];
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
    
    [self.walkingStepper addTarget:self action:@selector(walkingStepperValueChanged:) forControlEvents:UIControlEventAllEvents];
    [self.walkingStepper setStepValue:5];
    [self.shortDriveStepper addTarget:self action:@selector(shortDriveStepperValueChanged:) forControlEvents:UIControlEventAllEvents];
    [self.shortDriveStepper setStepValue:5];
    [self.longerDriveStepper addTarget:self action:@selector(longerDriveStepperValueChanged:) forControlEvents:UIControlEventAllEvents];
    [self.longerDriveStepper setStepValue:5];
    [self.onlineStepper addTarget:self action:@selector(onlineStepperValueChanged:) forControlEvents:UIControlEventAllEvents];
    [self.onlineStepper setStepValue:5];
    [self.otherStepper addTarget:self action:@selector(otherStepperValueChanged:) forControlEvents:UIControlEventAllEvents];
    [self.otherStepper setStepValue:5];
    
    //UIBarButtonItem *nextScreenBackButton = [[UIBarButtonItem alloc] initWithTitle:@"Try Again" style:UIBarButtonItemStyleBordered target:self action:nil];
    //self.navigationItem.backBarButtonItem = nextScreenBackButton;
    
    self.navigationItem.title = @"Location";
    
}


-(void) viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    if(![[SSUser currentUser] isLoggedIn]) {
        [self.navigationController popToRootViewControllerAnimated:YES];
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
        
        self.walkingPercentage = [self.profile.locationWalk intValue];
        self.shortDrivePercentage = [self.profile.locationShortDrive intValue];
        self.longDrivePercentage = [self.profile.locationLongDrive intValue];
        self.onlinePercentage = [self.profile.locationOnline intValue];
        self.otherPercentage = [self.profile.locationOther intValue];
        
        self.questionLabel.text = [NSString stringWithFormat:@"Where are most of %@'s customers?", [SSUtils companyName]];
        self.walkingLabel.text = [NSString stringWithFormat:@"Walking dist. (%d%%): ", self.walkingPercentage];
        [self.walkingStepper setValue:self.walkingPercentage];
        self.shortDriveLabel.text = [NSString stringWithFormat:@"Short drive (%d%%): ", self.shortDrivePercentage];
        [self.shortDriveStepper setValue:self.shortDrivePercentage];
        self.longerDriveLabel.text = [NSString stringWithFormat:@"Longer drive (%d%%): ", self.longDrivePercentage];
        [self.longerDriveStepper setValue:self.longDrivePercentage];
        self.onlineLabel.text = [NSString stringWithFormat:@"Online (%d%%): ", self.onlinePercentage];
        [self.onlineStepper setValue:self.onlinePercentage];
        self.otherLabel.text = [NSString stringWithFormat:@"Other (%d%%): ", self.otherPercentage];
        [self.otherStepper setValue:self.otherPercentage];
        
        self.isSure = [self.profile.isLocationSure boolValue];
        [self drawSureButton];
        [self updateRemainingPercentage];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

-(void) walkingStepperValueChanged:(UIStepper *)sender
{
    self.walkingPercentage = sender.value;
    self.walkingLabel.text = [NSString stringWithFormat:@"Walking dist. (%d%%): ", self.walkingPercentage];
    [self updateRemainingPercentage];
}

-(void) shortDriveStepperValueChanged:(UIStepper *)sender
{
    self.shortDrivePercentage = sender.value;
    self.shortDriveLabel.text = [NSString stringWithFormat:@"Short drive (%d%%): ", self.shortDrivePercentage];
    [self updateRemainingPercentage];
}

-(void) longerDriveStepperValueChanged:(UIStepper *)sender
{
    self.longDrivePercentage = sender.value;
    self.longerDriveLabel.text = [NSString stringWithFormat:@"Longer drive (%d%%): ", self.longDrivePercentage];
    [self updateRemainingPercentage];
}

-(void) onlineStepperValueChanged:(UIStepper *)sender
{
    self.onlinePercentage = sender.value;
    self.onlineLabel.text = [NSString stringWithFormat:@"Online (%d%%): ", self.onlinePercentage];
    [self updateRemainingPercentage];
}

-(void) otherStepperValueChanged:(UIStepper *)sender
{
    self.otherPercentage = sender.value;
    self.otherLabel.text = [NSString stringWithFormat:@"Other (%d%%): ", self.otherPercentage];
    [self updateRemainingPercentage];
}
-(int) totalPercentage {
    return self.walkingPercentage + self.shortDrivePercentage + self.longDrivePercentage + self.onlinePercentage + self.otherPercentage;
}

-(void) updateRemainingPercentage {
    
    int remainingPercentage = 100 - [self totalPercentage];
    
    if (remainingPercentage == 0) {
        [self.availablePercentageLabel setTextColor:[[UIColor alloc] initWithRed:24.0/255.0 green:150.0/255.0 blue:31.0/255.0 alpha:1.0]];
    } else if(remainingPercentage > 0) {
        [self.availablePercentageLabel setTextColor:[UIColor blackColor]];
    } else {
        [self.availablePercentageLabel setTextColor:[UIColor redColor]];
    }
    
    self.availablePercentageLabel.text = [NSString stringWithFormat:@"Remaining Percentage: %d%%.", remainingPercentage];
}

-(void) drawSureButton {
    if(!self.isSure) {
        [self.sureButton setTitle:@"☑ I'm not sure yet" forState:UIControlStateNormal];
    } else {
        [self.sureButton setTitle:@"☐ I'm not sure yet" forState:UIControlStateNormal];
    }
}

@end