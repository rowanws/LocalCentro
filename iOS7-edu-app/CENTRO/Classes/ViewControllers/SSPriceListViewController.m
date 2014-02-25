//
//  SSPriceListViewController.m
//  CENTRO
//
//  Created by Centro Community Partners.
//  Copyright (c) 2013 Centro Community Partners. All rights reserved.
//

#import "SSPriceListViewController.h"
#import "SSUser.h"
#import "Product.h"
#import "SSUtils.h"

@interface SSPriceListViewController ()

@property (strong, nonatomic) NSManagedObjectContext *context;
@property (strong, nonatomic) NSArray *products;

@property BOOL isSureForCurrentPrice;
@property int currentPricePos;

@end

@implementation SSPriceListViewController


- (IBAction)nextButtonPressed:(id)sender {
    if (self.isSureForCurrentPrice && [self.amountTextField.text intValue] <= 0) {
        [[[UIAlertView alloc] initWithTitle:@"Selection Error"
                                    message:@"Please enter an amount greater than zero."
                                   delegate:nil
                          cancelButtonTitle:@"OK"
                          otherButtonTitles:nil] show];
    } else {
        [self saveCurrent];
        self.currentPricePos++;
        if (self.currentPricePos < self.products.count) {
            [self continueAsking];
        } else {
            [self.context save:nil];
            [self performSegueWithIdentifier:@"PriceList" sender:self];
        }
    }
}

- (IBAction)backButtonPressed:(id)sender {
    [self saveCurrent];
    self.currentPricePos--;
    [self continueAsking];
}

- (IBAction)sureButtonPressed:(id)sender {
    self.isSureForCurrentPrice = !self.isSureForCurrentPrice;
    [self drawSureButton];

}

-(void) viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    if(![[SSUser currentUser] isLoggedIn]) {
        [self.navigationController popToRootViewControllerAnimated:YES];
    }
}


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
    
    //UIImage *bg = [UIImage imageNamed:@"bg.png"];
    //self.backgroundImageView.image = bg;
    self.backgroundImageView.contentMode = UIViewContentModeCenter;
    
    self.context = [(id)[[UIApplication sharedApplication] delegate] managedObjectContext];
    
    self.navigationItem.title = @"Product Prices";
    
    UIBarButtonItem *nextScreenBackButton = [[UIBarButtonItem alloc] initWithTitle:@"Try Again" style:UIBarButtonItemStyleBordered target:self action:nil];
    self.navigationItem.backBarButtonItem = nextScreenBackButton;

}

-(void) viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    self.currentPricePos = 0;
    
    NSFetchRequest *productFetchRequest = [[NSFetchRequest alloc] init];
    
    NSEntityDescription *productEntity = [NSEntityDescription entityForName:@"Product"
                                                         inManagedObjectContext:self.context];
    [productFetchRequest setEntity:productEntity];
    
    [productFetchRequest setPredicate:[NSPredicate predicateWithFormat:@"companyID = %@ AND selectedAsItem = 1", [[SSUser currentUser] companyID]]];
    
    productFetchRequest.sortDescriptors = [NSArray arrayWithObject:[NSSortDescriptor sortDescriptorWithKey:@"productID" ascending:YES selector:nil]];
    
    NSError *errorSV;
    self.products = [self.context executeFetchRequest:productFetchRequest error:&errorSV];
    
    if (self.products.count == 0) {
        
    } else {
        
        self.amountTextField.text = [[(Product *) [self.products objectAtIndex:self.currentPricePos] price] stringValue];
        self.questionLabel.text = [NSString stringWithFormat:@"How much does %@ charge for %@?", [SSUtils companyName], [(Product *) [self.products objectAtIndex:self.currentPricePos] name]];
        self.isSureForCurrentPrice = [[(Product *) [self.products objectAtIndex:self.currentPricePos] isPriceSure] boolValue];
        [self drawSureButton];
        self.backButton.hidden = YES;
    }

}


-(void) drawSureButton {
    if(!self.isSureForCurrentPrice) {
        [self.sureButton setTitle:@"☑ I'm not sure yet" forState:UIControlStateNormal];
    } else {
        [self.sureButton setTitle:@"☐ I'm not sure yet" forState:UIControlStateNormal];
    }
}




-(void) saveCurrent {

    [(Product *) [self.products objectAtIndex:self.currentPricePos] setPrice:[NSNumber numberWithDouble:[self.amountTextField.text doubleValue]]];
    [(Product *) [self.products objectAtIndex:self.currentPricePos] setIsPriceSure:[NSNumber numberWithBool:self.isSureForCurrentPrice]];
    self.amountTextField.text = @"";
}

-(void) continueAsking {
    
    if (self.currentPricePos > 0) {
        self.backButton.hidden = NO;
    } else if (self.currentPricePos == 0) {
        self.backButton.hidden = YES;
    }
    
    self.amountTextField.text = [[(Product *) [self.products objectAtIndex:self.currentPricePos] price] stringValue];
    self.questionLabel.text = [NSString stringWithFormat:@"How much does %@ charge for %@?", [SSUtils companyName], [(Product *) [self.products objectAtIndex:self.currentPricePos] name]];
    self.isSureForCurrentPrice = [[(Product *) [self.products objectAtIndex:self.currentPricePos] isPriceSure] boolValue];
    [self drawSureButton];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {

    [self.amountTextField resignFirstResponder];
    
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