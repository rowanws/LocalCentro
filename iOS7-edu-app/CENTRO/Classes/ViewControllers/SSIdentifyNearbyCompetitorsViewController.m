//
//  SSIdentifyNearbyCompetitorsViewController.m
//  CENTRO
//
//  Created by Centro Community Partners.
//  Copyright (c) 2013 Centro Community Partners. All rights reserved.
//

#import "SSIdentifyNearbyCompetitorsViewController.h"
#import "NearbyCompetitor.h"
#import "SSUser.h"
#import "SSUtils.h"

@interface SSIdentifyNearbyCompetitorsViewController ()

@property (strong, nonatomic) NSArray *distancesArray;
@property int distanceArrayIndex;

@property (strong, nonatomic) NSManagedObjectContext *context;
@property (strong, nonatomic) NearbyCompetitor *competitor;


@end

@implementation SSIdentifyNearbyCompetitorsViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {

    }
    return self;
}

- (IBAction)lotButtonPressed:(id)sender {
    [self saveAnswer:1 forQuestion:self.distanceArrayIndex];
}
- (IBAction)fewButtonPressed:(id)sender {
    [self saveAnswer:2 forQuestion:self.distanceArrayIndex];
}
- (IBAction)notManyButtonPressed:(id)sender {
    [self saveAnswer:3 forQuestion:self.distanceArrayIndex];
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
    
    self.navigationItem.title = @"Competitors";
    
    self.context = [(id)[[UIApplication sharedApplication] delegate] managedObjectContext];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

-(void) viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    if(![[SSUser currentUser] isLoggedIn]) {
        [self.navigationController popToRootViewControllerAnimated:YES];
    } else {
        
        NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
        
        NSEntityDescription *entity = [NSEntityDescription entityForName:@"NearbyCompetitor"
                                                  inManagedObjectContext:self.context];
        [fetchRequest setEntity:entity];
        
        [fetchRequest setPredicate:[NSPredicate predicateWithFormat:@"companyID = %@", [[SSUser currentUser] companyID]]];
        
        NSError *error;
        NSArray *fetchedObjects = [self.context executeFetchRequest:fetchRequest error:&error];
        
        if (fetchedObjects.count == 0) { 
            
        } else {
            self.competitor = (NearbyCompetitor *) [fetchedObjects objectAtIndex:0];
        }
        
        self.distanceArrayIndex = 0;
    
        self.distancesArray =@[@"within walking distance", @"within a short drive", @"within a long drive", @"online"];
        
        [self.lotButton setTitle:@"A lot (more than 20)" forState:UIControlStateNormal];
        [self.fewButton setTitle:@"Quite a few (5 to 20)" forState:UIControlStateNormal];
        [self.notManyButton setTitle:@"Not many (less than 5)" forState:UIControlStateNormal];
        
        self.questionLabel.text = [NSString stringWithFormat:@"How many competitors are located %@ of %@?", self.distancesArray[self.distanceArrayIndex], [SSUtils companyName]];
    }
}

- (void) saveAnswer:(int) answer forQuestion:(int) question {
  
    self.distanceArrayIndex++;
        
    if(question == 0) {
        self.competitor.walkingDistanceCompetitors = [NSNumber numberWithInt:answer];
    } else if(question == 1) {
        self.competitor.shortDriveCompetitors = [NSNumber numberWithInt:answer];
    } else if(question == 2) {
        self.competitor.longDriveCompetitors = [NSNumber numberWithInt:answer];
    } else if(question == 3) {
        self.competitor.onlineCompetitors = [NSNumber numberWithInt:answer];
    } else {
        
    }
    
    if(self.distanceArrayIndex < 4) {
        if ([self.distancesArray[self.distanceArrayIndex] isEqualToString:@"online"]) {
            self.questionLabel.text = [NSString stringWithFormat:@"How many competitors are located %@?", self.distancesArray[self.distanceArrayIndex]];
        } else {
            self.questionLabel.text = [NSString stringWithFormat:@"How many competitors are located %@ of %@?", self.distancesArray[self.distanceArrayIndex], [SSUtils companyName]];
        }
    } else {
        [self.context save:nil];
        [self performSegueWithIdentifier:@"MainCompetitors" sender:self];
    }
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
