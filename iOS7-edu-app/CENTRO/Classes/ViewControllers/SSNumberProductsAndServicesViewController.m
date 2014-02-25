//
//  SSNumberProductsAndServicesViewController.m
//  CENTRO
//
//  Created by Centro Community Partners.
//  Copyright (c) 2013 Centro Community Partners. All rights reserved.
//

#import "SSNumberProductsAndServicesViewController.h"
#import "Company.h"
#import "SSUser.h"
#import "SSUtils.h"

@interface SSNumberProductsAndServicesViewController ()

@property (strong, nonatomic) NSManagedObjectContext *context;
@property (strong, nonatomic) Company *company;
@property (strong, nonatomic) NSArray *questionsArray;
@property (strong, nonatomic) NSArray *questionsCategory;

@property int arrayPos;
@property BOOL isSure;

@end

@implementation SSNumberProductsAndServicesViewController

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
    
    if ([self.amountTextField.text intValue] > 0) {
        [self saveQuestions];
        self.arrayPos++;
        if(self.arrayPos >= 0 && self.arrayPos < self.questionsArray.count) {
            [self refreshQuestions];
            self.backButton.hidden = NO;
        } else {
            if(self.questionsArray.count == self.questionsArray.count) {
                [self performSegueWithIdentifier:@"IdentifyCategories" sender:self];
            }
        }
    } else {
        [[[UIAlertView alloc] initWithTitle:@"Selection Error"
                                    message:@"Please enter an amount greater than zero."
                                   delegate:nil
                          cancelButtonTitle:@"OK"
                          otherButtonTitles:nil] show];
    }
}

- (IBAction)backButtonPressed:(id)sender {
    [self saveQuestions];
    if(self.arrayPos >= 0 && self.arrayPos < self.questionsArray.count) {
        self.arrayPos--;
        if(self.arrayPos == 0) {
            self.backButton.hidden = YES;
        }
        [self refreshQuestions];
    }
}

-(void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"IdentifyCategories"]) {
        [self.context save:nil];
    }
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
    
    self.navigationItem.title = @"Sell";
    
    self.context = [(id)[[UIApplication sharedApplication] delegate] managedObjectContext];
    
    self.backButton.hidden = YES;
    
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

    [self.nextButton setTitle:@"Next" forState:UIControlStateNormal];
    [self.backButton setTitle:@"Back" forState:UIControlStateNormal];
    
    [self questions];
  
}

- (void) viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    if(![[SSUser currentUser] isLoggedIn]) {
        [self.navigationController popToRootViewControllerAnimated:YES];
    } else {
        self.arrayPos = 0;
        [self refreshQuestions];
    }
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (void) touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    [self.amountTextField resignFirstResponder];
}

- (void) questions {
    if (self.company.productsAndServicesEstimate == [NSNumber numberWithInt:1]) {
        self.questionsArray = [NSArray arrayWithObjects:[NSString stringWithFormat:@"How many products does %@ sell?", [SSUtils companyName]], nil];
        self.questionsCategory = [NSArray arrayWithObjects:@"products", nil];
        self.company.servicesQty = [NSNumber numberWithInt:0];
    } else if (self.company.productsAndServicesEstimate == [NSNumber numberWithInt:5]) {
        self.questionsArray = [NSArray arrayWithObjects:[NSString stringWithFormat:@"How many services does %@ sell?", [SSUtils companyName]], nil];
        self.questionsCategory = [NSArray arrayWithObjects:@"services", nil];
        self.company.productsQty = [NSNumber numberWithInt:0];
    } else {
        self.questionsArray = [NSArray arrayWithObjects:[NSString stringWithFormat:@"How many products and services does %@ sell?", [SSUtils companyName]], [NSString stringWithFormat:@"How many services does %@ sell?", [SSUtils companyName]], nil];
        self.questionsCategory = [NSArray arrayWithObjects:@"products", @"services", nil];
    }
}

-(void) drawSureButton {
    if(!self.isSure) {
        [self.self.isSureButton setTitle:@"☑ I'm not sure yet" forState:UIControlStateNormal];
    } else {
        [self.self.isSureButton setTitle:@"☐ I'm not sure yet" forState:UIControlStateNormal];
    }
}

-(void) refreshQuestions {
    self.questionLabel.text = self.questionsArray[self.arrayPos];
    
    if ([self.questionsCategory[self.arrayPos] isEqualToString:@"products"]) {
        self.amountTextField.text = [self.company.productsQty stringValue];
        self.isSure = [self.company.isProductsSure boolValue];
    } else {
        self.amountTextField.text = [self.company.servicesQty stringValue];
        self.isSure = [self.company.isServicesSure boolValue];
    }
    
    [self drawSureButton];
}

-(void) saveQuestions {
    if ([self.questionsCategory[self.arrayPos] isEqualToString:@"products"]) {
        self.company.productsQty = [NSNumber numberWithInt:[self.amountTextField.text intValue]];
        self.company.isProductsSure = [NSNumber numberWithBool:self.isSure];
    } else {
        self.company.servicesQty = [NSNumber numberWithInt:[self.amountTextField.text intValue]];
        self.company.isServicesSure = [NSNumber numberWithBool:self.isSure];
    }
}

@end