//
//  SSCustomerIncomeViewController.m
//  CENTRO
//
//  Created by Centro Community Partners.
//  Copyright (c) 2013 Centro Community Partners. All rights reserved.
//

#import "SSCustomerIncomeViewController.h"
#import "CustomerProfile.h"
#import "SSUser.h"
#import "SSUtils.h"

@interface SSCustomerIncomeViewController ()

@property (strong, nonatomic) NSManagedObjectContext *context;
@property (strong, nonatomic) CustomerProfile *profile;
@property BOOL isSure;

@end

@implementation SSCustomerIncomeViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {

    }
    return self;
}

- (IBAction)nextButtonPressed:(id)sender {
    
    double fromIncome = [self.fromTextField.text doubleValue];
    double toIncome = [self.toTextField.text doubleValue];
    
    if(fromIncome < toIncome && fromIncome >= 1.00 && toIncome >= 1.00) {
        
        self.profile.fromIncome = [NSNumber numberWithDouble:fromIncome];
        self.profile.toIncome = [NSNumber numberWithDouble:toIncome];
        self.profile.isIncomeSure = [NSNumber numberWithBool:self.isSure];
        
        [self.context save:nil];
        [self performSegueWithIdentifier:@"SelectCustomerBuyerEducation" sender:self];
    } else {
        [[[UIAlertView alloc] initWithTitle:@"Selection Error"
                                    message:@"From Income must be less than To Income and both greater than 1."
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
    
    self.questionLabel.text = [NSString stringWithFormat:@"How much do %@'s customers make per year?", [SSUtils companyName]];
    self.fromLabel.text = @"From: ";
    self.toLabel.text = @"To: ";
    
    self.navigationItem.title = @"Income";
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
        
        self.fromTextField.text = [self.profile.fromIncome stringValue];
        self.toTextField.text = [self.profile.toIncome stringValue];
        
        self.isSure = [self.profile.isIncomeSure boolValue];
        [self drawSureButton];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    
    [self.fromTextField resignFirstResponder];
    [self.toTextField resignFirstResponder];
    
}

-(void) drawSureButton {
    if(!self.isSure) {
        [self.isSureButton setTitle:@"☑ I'm not sure yet" forState:UIControlStateNormal];
    } else {
        [self.isSureButton setTitle:@"☐ I'm not sure yet" forState:UIControlStateNormal];
    }
}

@end