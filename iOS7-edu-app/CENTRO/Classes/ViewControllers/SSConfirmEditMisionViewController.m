//
//  SSConfirmEditMisionViewController.m
//  CENTRO
//
//  Created by Centro Community Partners.
//  Copyright (c) 2013 Centro Community Partners. All rights reserved.
//

#import "SSConfirmEditMisionViewController.h"
#import "SSUser.h"
#import "Mission.h"
#import "SSUtils.h"

@interface SSConfirmEditMisionViewController ()

@property (strong, nonatomic) NSManagedObjectContext *context;
@property (strong, nonatomic) Mission *tempMission;

@end

@implementation SSConfirmEditMisionViewController

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
    
    self.context = [(id)[[UIApplication sharedApplication] delegate] managedObjectContext];
    
    self.confirmMissionTextView.text = self.mission;
    
    self.confirmMissionLabel.text = [NSString stringWithFormat:@"Well done! Here is %@'s mission statement.", [SSUtils companyName]];
    
}

- (IBAction)editButtonPressed:(id)sender {
    UINavigationController *nav = self.navigationController;
    [nav popViewControllerAnimated:YES];
}

- (IBAction)looksGoodButtonPressed:(id)sender {
    
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Mission"
                                              inManagedObjectContext:self.context];
    [fetchRequest setEntity:entity];
    
    [fetchRequest setPredicate:[NSPredicate predicateWithFormat:@"companyID = %@", [[SSUser currentUser] companyID]]];
    
    NSError *error;
    NSArray *fetchedObjects = [self.context executeFetchRequest:fetchRequest error:&error];
    if (fetchedObjects.count == 0) {
        
    } else {
        self.tempMission = (Mission *) [fetchedObjects objectAtIndex:0];
        self.tempMission.mission = self.mission;
        NSError *error;
        if (![self.context save:&error]) {
            NSLog(@"Whoops, couldn't save: %@", [error localizedDescription]);
        } else {
            UINavigationController *nav = self.navigationController;
            [nav popToRootViewControllerAnimated:YES];
        }
    }
    
    [[SSUser currentUser] setActivityNumberAsCompleted:@"3" andSyncStatus:NO];
    
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

@end