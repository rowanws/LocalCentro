//
//  SSCompanySellViewController.m
//  CENTRO
//
//  Created by Centro Community Partners.
//  Copyright (c) 2013 Centro Community Partners. All rights reserved.
//

#import "SSCompanySellViewController.h"
#import "Company.h"
#import "SSUser.h"
#import "SSUtils.h"

@interface SSCompanySellViewController ()

@property (strong, nonatomic) NSManagedObjectContext *context;
@property (strong, nonatomic) Company *company;

@end

@implementation SSCompanySellViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {

    }
    return self;
}

- (IBAction)onlyProductsButtonPressed:(id)sender {

    self.company.productsAndServicesEstimate = [NSNumber numberWithInt:1];
    [self performSegueWithIdentifier:@"NumberProductsServices" sender:self];
}


- (IBAction)equalProductsServicesButtonPressed:(id)sender {
   
    self.company.productsAndServicesEstimate = [NSNumber numberWithInt:3];
    [self performSegueWithIdentifier:@"NumberProductsServices" sender:self];
}


- (IBAction)onlyServicesButtonPressed:(id)sender {
    
    self.company.productsAndServicesEstimate = [NSNumber numberWithInt:5];
    [self performSegueWithIdentifier:@"NumberProductsServices" sender:self];
}

-(void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"NumberProductsServices"]) {
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
    
    self.questionLabel.text = [NSString stringWithFormat:@"What does %@ sell?", [SSUtils companyName]];
    self.questionLabel.textAlignment = NSTextAlignmentCenter;
    
    [self.onlyProductsButton setTitle:@"Only Products" forState:UIControlStateNormal];
    [self.equalProductsServicesButton setTitle:@"Both Products And Services" forState:UIControlStateNormal];
    [self.onlyServicesButton setTitle:@"Only Services" forState:UIControlStateNormal];
    
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
}

-(void) viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    if(![[SSUser currentUser] isLoggedIn]) {
        [self.navigationController popToRootViewControllerAnimated:YES];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
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
