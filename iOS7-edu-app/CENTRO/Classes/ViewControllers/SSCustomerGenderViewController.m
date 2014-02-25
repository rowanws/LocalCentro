//
//  SSCustomerGenderViewController.m
//  CENTRO
//
//  Created by Centro Community Partners.
//  Copyright (c) 2013 Centro Community Partners. All rights reserved.
//

#import "SSCustomerGenderViewController.h"
#import "CustomerProfile.h"
#import "SSUser.h"
#import "SSUtils.h"

@interface SSCustomerGenderViewController ()

@property (strong, nonatomic) NSManagedObjectContext *context;
@property (strong, nonatomic) CustomerProfile *profile;
@property BOOL isSure;

@end

@implementation SSCustomerGenderViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {

    }
    return self;
}
- (IBAction)isSureButtonPressed:(id)sender {
    self.isSure = !self.isSure;
    [self drawSureButton];
}

- (IBAction)nextButtonPressed:(id)sender {

    self.profile.isGenderSure = [NSNumber numberWithBool:self.isSure];
    
    [self.context save:nil];
    [self performSegueWithIdentifier:@"SelectCustomerBuyerIncome" sender:self];
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
    
    self.questionLabel.text = [NSString stringWithFormat:@"Are most of %@'s customers men/boys or women/girls?", [SSUtils companyName]];
    
    [self.genderSlider addTarget:self action:@selector(sliderValueChanged:) forControlEvents:UIControlEventValueChanged];
    
    self.navigationItem.title = @"Gender";
    
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
                
        self.menLabel.text = [NSString stringWithFormat:@"Men/Boys:\n%d%%", [self.profile.menPercentage intValue]];
        self.womenLabel.text = [NSString stringWithFormat:@"Women/Girls:\n%d%%", [self.profile.womenPercentage intValue]];
        
        self.genderSlider.value = [self.profile.womenPercentage floatValue]/100.0;
        
        self.isSure = [self.profile.isGenderSure boolValue];
        [self drawSureButton];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

-(void) sliderValueChanged:(UISlider *)sender
{    
    int steps = sender.value / 0.05;
    sender.value = 0.05 * steps;
    
    int womenPercentage = lroundf(sender.value * 100);
    
    self.profile.womenPercentage = [NSNumber numberWithInt:womenPercentage];
    self.profile.menPercentage = [NSNumber numberWithInt:(100 - womenPercentage)];
    
    self.menLabel.text = [NSString stringWithFormat:@"Men/Boys:\n%d%%", [self.profile.menPercentage intValue]];
    self.womenLabel.text = [NSString stringWithFormat:@"Women/Girls:\n%d%%", [self.profile.womenPercentage intValue]];
}

-(void) drawSureButton {
    if(!self.isSure) {
        [self.isSureButton setTitle:@"☑ I'm not sure yet" forState:UIControlStateNormal];
    } else {
        [self.isSureButton setTitle:@"☐ I'm not sure yet" forState:UIControlStateNormal];
    }
}

@end