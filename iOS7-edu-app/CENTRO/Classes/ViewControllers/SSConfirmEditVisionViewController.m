//
//  SSConfirmEditVisionViewController.m
//  CENTRO
//
//  Created by Centro Community Partners.
//  Copyright (c) 2013 Centro Community Partners. All rights reserved.
//

#import "SSConfirmEditVisionViewController.h"
#import "SSUser.h"
#import "Vision.h"
#import "SSUtils.h"

@interface SSConfirmEditVisionViewController ()

@property (strong, nonatomic) NSManagedObjectContext *context;
@property (strong, nonatomic) Vision *tempVision;

@end

@implementation SSConfirmEditVisionViewController

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
    
    //UIImage *bg40 = [UIImage imageNamed:@"bg-568h@2x.png"];
    //UIImage *bg35R = [UIImage imageNamed:@"bg.png"];
    
    //CGRect screenBounds = [[UIScreen mainScreen] bounds];
    //if (screenBounds.size.height == 568) {
    //    self.backgroundImageView.image = bg40;
    //} else {
    //    self.backgroundImageView.image = bg35R;
    //}
    
    self.visionLabel.text = [NSString stringWithFormat:@"Congrats! Here is %@'s vision statement.", [SSUtils companyName]];
    self.visionStatementTextView.text = self.vision;
    
    self.context = [(id)[[UIApplication sharedApplication] delegate] managedObjectContext];
    

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

- (IBAction)tryAgainButtonPressed:(id)sender {
    
    [[SSUser currentUser] setSegueToPerform:@"2"];
    
    [self.navigationController popToRootViewControllerAnimated:NO];
    [self.navigationController.navigationBar popNavigationItemAnimated:NO];
}

- (IBAction)looksGoodButtonPressed:(id)sender {
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Vision"
                                              inManagedObjectContext:self.context];
    [fetchRequest setEntity:entity];
    
    [fetchRequest setPredicate:[NSPredicate predicateWithFormat:@"companyID = %@", [[SSUser currentUser] companyID]]];
    
    NSError *error;
    NSArray *fetchedObjects = [self.context executeFetchRequest:fetchRequest error:&error];
    if (fetchedObjects.count == 0) {
        
    } else {
        self.tempVision = (Vision *) [fetchedObjects objectAtIndex:0];
        self.tempVision.vision = self.vision;
        NSError *error;
        if (![self.context save:&error]) {
            NSLog(@"Whoops, couldn't save: %@", [error localizedDescription]);
        } else {
            UINavigationController *nav = self.navigationController;
            [nav popToRootViewControllerAnimated:YES];
        }
    }
    
    [[SSUser currentUser] setActivityNumberAsCompleted:@"2" andSyncStatus:NO];
    
}

@end
