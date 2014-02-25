//
//  SSSelectMarketRegulationsViewController.m
//  CENTRO
//
//  Created by Centro Community Partners.
//  Copyright (c) 2013 Centro Community Partners. All rights reserved.
//

#import "SSSelectMarketRegulationsViewController.h"
#import "Industry.h"
#import "SSUser.h"

@interface SSSelectMarketRegulationsViewController ()

@property (strong, nonatomic) NSManagedObjectContext *context;
@property (strong, nonatomic) Industry *industry;
@property int regulations;

@end

@implementation SSSelectMarketRegulationsViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {

    }
    return self;
}

-(void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    self.industry.regulations = [NSNumber numberWithInt:self.regulations];
    
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
    
    self.navigationItem.title = @"Regulations";
    
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
        
        self.regulations = [self.industry.regulations intValue];
        
        self.questionLabel.text = @"How regulated is your industry?";
        
        [self.lotRegulationsButton setTitle:@"    ☐ A lot of regulations" forState:UIControlStateNormal];
        [self.someRegulationsButton setTitle:@"    ☐ Some regulations" forState:UIControlStateNormal];
        [self.hardlyAnyRegulationsButton setTitle: @"    ☐ Hardly any regulations" forState:UIControlStateNormal];
        [self.noRegulationsButton setTitle:@"    ☐ No regulations" forState:UIControlStateNormal];
        
        if(self.regulations == 1) {
            [self.lotRegulationsButton setTitle:@"    ☑ A lot of regulations" forState:UIControlStateNormal];
        } else if(self.regulations == 2) {
            [self.someRegulationsButton setTitle:@"    ☑ Some regulations" forState:UIControlStateNormal];
        } else if(self.regulations == 3) {
            [self.hardlyAnyRegulationsButton setTitle: @"    ☑ Hardly any regulations" forState:UIControlStateNormal];
        } else if(self.regulations == 4) {
            [self.noRegulationsButton setTitle:@"    ☑ No regulations" forState:UIControlStateNormal];
        }
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}
- (IBAction)lotRegulationsButtonPressed:(id)sender {
    self.regulations = 1;
    [self performSegueWithIdentifier:@"SelectIndustryVolatility" sender:self];
}
- (IBAction)someRegulationsButtonPressed:(id)sender {
    self.regulations = 2;
    [self performSegueWithIdentifier:@"SelectIndustryVolatility" sender:self];
}
- (IBAction)hardlyAnyRegulationsButtonPressed:(id)sender {
    self.regulations = 3;
    [self performSegueWithIdentifier:@"SelectIndustryVolatility" sender:self];
}
- (IBAction)noRegulationsButtonPressed:(id)sender {
    self.regulations = 4;
    [self performSegueWithIdentifier:@"SelectIndustryVolatility" sender:self];
}

@end