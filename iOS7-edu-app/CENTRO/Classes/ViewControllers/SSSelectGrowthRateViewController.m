//
//  SSSelectGrowthRateViewController.m
//  CENTRO
//
//  Created by Centro Community Partners.
//  Copyright (c) 2013 Centro Community Partners. All rights reserved.
//

#import "SSSelectGrowthRateViewController.h"
#import "Industry.h"
#import "SSUser.h"
#import "SSUtils.h"

@interface SSSelectGrowthRateViewController ()

@property (strong, nonatomic) NSManagedObjectContext *context;
@property (strong, nonatomic) Industry *industry;
@property int growth;

@end

@implementation SSSelectGrowthRateViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {

    }
    return self;
}

-(void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    self.industry.growth = [NSNumber numberWithInt:self.growth];
    
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
    
    self.navigationItem.title = @"Growth";
    
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
        
        self.growth = [self.industry.growth intValue];
        
        self.growthLabel.text = [NSString stringWithFormat:@"Is %@'s industry growing?", [SSUtils companyName]];
        
        [self.yesQuickButton setTitle:@"   ☐ Yes, very quickly!" forState:UIControlStateNormal];
        [self.yesSlowButton setTitle:@"   ☐ Yes, but slowly!" forState:UIControlStateNormal];
        [self.noChangeButton setTitle: @"   ☐ It's not changing." forState:UIControlStateNormal];
        [self.shrinkButton setTitle:@"   ☐ It's shrinking :-(" forState:UIControlStateNormal];
        [self.exactRateButton setTitle:@"   ☐ Enter an exact growth rate." forState:UIControlStateNormal];
        
        if(self.growth == 1) {
            [self.yesQuickButton setTitle:@"   ☑ Yes, very quickly!" forState:UIControlStateNormal];
        } else if(self.growth == 2) {
            [self.yesSlowButton setTitle:@"   ☑ Yes, but slowly!" forState:UIControlStateNormal];
        } else if(self.growth == 3) {
            [self.noChangeButton setTitle: @"   ☑ It's not changing." forState:UIControlStateNormal];
        } else if(self.growth == 4) {
            [self.shrinkButton setTitle:@"   ☑ It's shrinking :-(" forState:UIControlStateNormal];
        } else if(self.growth == 5) {
            [self.exactRateButton setTitle:@"   ☑ Enter an exact growth rate." forState:UIControlStateNormal];
        }
    }
}
- (IBAction)yesQuickButtonPressed:(id)sender {
    self.growth = 1;
    [self performSegueWithIdentifier:@"SelectMarketAgeFromGrowthRate" sender:self];
}
- (IBAction)yesSlowButtonPressed:(id)sender {
    self.growth = 2;
    [self performSegueWithIdentifier:@"SelectMarketAgeFromGrowthRate" sender:self];
}
- (IBAction)noChangeButtonPressed:(id)sender {
    self.growth = 3;
    [self performSegueWithIdentifier:@"SelectMarketAgeFromGrowthRate" sender:self];
}
- (IBAction)shrinkButtonPressed:(id)sender {
    self.growth = 4;
    [self performSegueWithIdentifier:@"SelectMarketAgeFromGrowthRate" sender:self];
}
- (IBAction)exactRateButtonPressed:(id)sender {
    self.growth = -1;
    [self performSegueWithIdentifier:@"SelectExactGrowthRate" sender:self];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end