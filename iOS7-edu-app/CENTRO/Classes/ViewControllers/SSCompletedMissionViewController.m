//
//  SSCompletedMissionViewController.m
//  CENTRO
//
//  Created by Centro Community Partners.
//  Copyright (c) 2013 Centro Community Partners. All rights reserved.
//

#import "SSCompletedMissionViewController.h"
#import "SSUser.h"
#import "Company.h"
#import "Mission.h"
#import "SSUtils.h"

@interface SSCompletedMissionViewController ()

@property (strong, nonatomic) NSManagedObjectContext *context;
@property (strong, nonatomic) Company *company;

@end

@implementation SSCompletedMissionViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {

    }
    return self;
}

- (IBAction)tryAgainButtonPressed:(id)sender {
    [[SSUser currentUser] setActivityNumberAsIncompleted:@"3"];
    
    UIStoryboard *profileStoryBoard = [UIStoryboard storyboardWithName: @"mission" bundle:Nil];
    UIViewController *initProfileView = [profileStoryBoard instantiateInitialViewController];
    initProfileView.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
    //[VC presentViewController:initProfileView animated: animation completion: NULL];
    
    [self.navigationController pushViewController:initProfileView animated:YES];
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
    
    self.context = [(id)[[UIApplication sharedApplication] delegate] managedObjectContext];
    
    self.navigationItem.title = @"Mission";
    
    self.missionLabel.text = [NSString stringWithFormat:@"%@'s Mission:", [SSUtils companyName]];
    
    self.tryAgainButton.title = @"Try Again!";
    
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
        
        self.missionTextView.text = [self.company.mission mission];
        
        [self.missionTextView flashScrollIndicators];
    }

}

-(void) viewWillAppear:(BOOL)animate {
    [super viewWillAppear:animate];
    
    if(![[SSUser currentUser] isLoggedIn]) {
        [self.navigationController popToRootViewControllerAnimated:YES];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end
