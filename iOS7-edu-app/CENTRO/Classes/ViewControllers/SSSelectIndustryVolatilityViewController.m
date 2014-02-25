//
//  SSSelectIndustryVolatilityViewController.m
//  CENTRO
//
//  Created by Centro Community Partners.
//  Copyright (c) 2013 Centro Community Partners. All rights reserved.
//

#import "SSSelectIndustryVolatilityViewController.h"
#import "Industry.h"
#import "SSUser.h"

@interface SSSelectIndustryVolatilityViewController ()

@property (strong, nonatomic) NSManagedObjectContext *context;
@property (strong, nonatomic) Industry *industry;
@property int volatility;

@end

@implementation SSSelectIndustryVolatilityViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {

    }
    return self;
}

-(void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    self.industry.volatility = [NSNumber numberWithInt:self.volatility];
    
    [self.context save:nil];
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
    
    self.navigationItem.title = @"Volatility";
    
    self.context = [(id)[[UIApplication sharedApplication] delegate] managedObjectContext];
}

-(void) viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    if(![[SSUser currentUser] isLoggedIn]) {
        [self.navigationController popToRootViewControllerAnimated:YES];
    } else {
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Industry"
                                              inManagedObjectContext:self.context];
    [fetchRequest setEntity:entity];
    
    [fetchRequest setPredicate:[NSPredicate predicateWithFormat:@"companyID = %@", [[SSUser currentUser] companyID]]];
    
    NSError *error;
    NSArray *fetchedObjects = [self.context executeFetchRequest:fetchRequest error:&error];
    if (fetchedObjects.count == 0) {
        
    } else {
        self.industry = (Industry *) [fetchedObjects objectAtIndex:0];
    }
    
    self.volatility = [self.industry.volatility intValue];
    
    self.questionLabel.text = @"Is your industry volatile?";
    
    [self.boomButton setTitle:@"    ☐ Yes, boom or bust!" forState:UIControlStateNormal];
    [self.someButton setTitle:@"    ☐ Some volatility." forState:UIControlStateNormal];
    [self.nothingButton setTitle: @"    ☐ No, nothing changes." forState:UIControlStateNormal];
    
    if(self.volatility == 1) {
        [self.boomButton setTitle:@"    ☑ Yes, boom or bust!" forState:UIControlStateNormal];
    } else if(self.volatility == 2) {
        [self.someButton setTitle:@"    ☑ Some volatility." forState:UIControlStateNormal];
    } else if(self.volatility == 3) {
        [self.nothingButton setTitle: @"    ☑ No, nothing changes." forState:UIControlStateNormal];
    }
    
    UIBarButtonItem *nextScreenBackButton = [[UIBarButtonItem alloc] initWithTitle:@"Try Again" style:UIBarButtonItemStyleBordered target:self action:nil];
    self.navigationItem.backBarButtonItem = nextScreenBackButton;
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (IBAction)boomButtonPressed:(id)sender {
    self.volatility = 1;
    [self performSegueWithIdentifier:@"IndustryAnalysis" sender:self];
}
- (IBAction)someButtonPressed:(id)sender {
    self.volatility = 2;
    [self performSegueWithIdentifier:@"IndustryAnalysis" sender:self];
}
- (IBAction)nothingButtonPressed:(id)sender {
    self.volatility = 3;
    [self performSegueWithIdentifier:@"IndustryAnalysis" sender:self];
}

@end