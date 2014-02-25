//
//  SSSelectMarketAgeViewController.m
//  CENTRO
//
//  Created by Centro Community Partners.
//  Copyright (c) 2013 Centro Community Partners. All rights reserved.
//

#import "SSSelectMarketAgeViewController.h"
#import "Industry.h"
#import "SSUser.h"

@interface SSSelectMarketAgeViewController ()

@property (strong, nonatomic) NSManagedObjectContext *context;
@property (strong, nonatomic) Industry *industry;
@property int age;

@end

@implementation SSSelectMarketAgeViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {

    }
    return self;
}

-(void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    self.industry.marketAge = [NSNumber numberWithInt:self.age];
    
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
    
    self.navigationItem.title = @"Market Age";
    
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
        
        self.age = [self.industry.marketAge intValue];
        
        self.questionLabel.text = @"How old is your market?";
        
        [self.brandNewMarketButton setTitle:@"  ☐ New market (less than 5 years)" forState:UIControlStateNormal];
        [self.recentMarketButton setTitle:@"  ☐ Recent market (5 to 10 years)" forState:UIControlStateNormal];
        [self.establishedMarketButton setTitle: @"  ☐ Established market (10 to 50 years)" forState:UIControlStateNormal];
        [self.traditionalMarketButton setTitle:@"  ☐ Traditional Market (more than 50 years)" forState:UIControlStateNormal];
        
        if(self.age == 1) {
            [self.brandNewMarketButton setTitle:@"  ☑ New market (less than 5 years)" forState:UIControlStateNormal];
        } else if(self.age == 2) {
            [self.recentMarketButton setTitle:@"  ☑ Recent market (5 to 10 years)" forState:UIControlStateNormal];
        } else if(self.age == 3) {
            [self.establishedMarketButton setTitle: @"  ☑ Established market (10 to 50 years)" forState:UIControlStateNormal];
        } else if(self.age == 4) {
            [self.traditionalMarketButton setTitle:@"   ☑ Traditional Market (more than 50 years)" forState:UIControlStateNormal];
        }
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (IBAction)brandNewMarketButtonPressed:(id)sender {
    self.age = 1;
    [self performSegueWithIdentifier:@"SelectMarketRegulations" sender:self];
}
- (IBAction)recentMarketButtonPressed:(id)sender {
    self.age = 2;
    [self performSegueWithIdentifier:@"SelectMarketRegulations" sender:self];
}
- (IBAction)estabilishedMarketButtonPressed:(id)sender {
    self.age = 3;
    [self performSegueWithIdentifier:@"SelectMarketRegulations" sender:self];
}
- (IBAction)traditionalMarketButtonPressed:(id)sender {
    self.age = 4;
    [self performSegueWithIdentifier:@"SelectMarketRegulations" sender:self];
}
@end
