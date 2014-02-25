//
//  SSCustomerAgeViewController.m
//  CENTRO
//
//  Created by Centro Community Partners.
//  Copyright (c) 2013 Centro Community Partners. All rights reserved.
//

#import "SSCustomerAgeViewController.h"
#import "SSUser.h"
#import "CustomerProfile.h"
#import "SSUtils.h"

@interface SSCustomerAgeViewController ()

@property (strong, nonatomic) NSManagedObjectContext *context;
@property (strong, nonatomic) CustomerProfile *profile;
@property BOOL isSure;

@end

@implementation SSCustomerAgeViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {

    }
    return self;
}
- (IBAction)nextButtonPressed:(id)sender {
    
    int fromAge = [self.fromTextField.text intValue];
    int toAge = [self.toTextField.text intValue];
    
    if(fromAge < toAge && fromAge >= 1 && toAge >= 1 && fromAge < 101 && toAge < 101) {
        
        self.profile.fromAge = [NSNumber numberWithInt:fromAge];
        self.profile.toAge = [NSNumber numberWithInt:toAge];
        self.profile.isAgeSure = [NSNumber numberWithBool:self.isSure];
        
        [self.context save:nil];
        [self performSegueWithIdentifier:@"SelectCustomerBuyerGender" sender:self];
    } else {
        [[[UIAlertView alloc] initWithTitle:@"Selection Error"
                                    message:@"From Age must be less than To Age, both greater than 1 and less than 101."
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
    
    self.questionLabel.text = [NSString stringWithFormat:@"How old are most of the people who buy %@'s products or services?", [SSUtils companyName]];
    self.fromLabel.text = @"From: ";
    self.toLabel.text = @"To: ";
    
    self.navigationItem.title = @"Age";
    
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
        
        self.fromTextField.text = [self.profile.fromAge stringValue];
        self.toTextField.text = [self.profile.toAge stringValue];
        
        self.isSure = [self.profile.isAgeSure boolValue];
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

-(IBAction)dismissVC{
    [self dismissViewControllerAnimated:YES completion:NULL];
}

@end