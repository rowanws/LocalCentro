//
//  SSVisionMissionValuesViewController.m
//  CENTRO
//
//  Created by Centro Community Partners.
//  Copyright (c) 2013 Centro Community Partners. All rights reserved.
//

#import "SSVisionMissionValuesViewController.h"
#import "SSUser.h"
#import "Company.h"
#import "Vision.h"
#import "Mission.h"
#import "Value.h"


@interface SSVisionMissionValuesViewController ()

@property (strong, nonatomic) NSManagedObjectContext *context;
@property (strong, nonatomic) Company *company;
@property (strong, nonatomic) NSString *companyName;

@end

@implementation SSVisionMissionValuesViewController

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
    
    self.navigationItem.title = @"Vision, Mission, Values";
        
    NSFetchRequest *companyFetchRequest = [[NSFetchRequest alloc] init];
    
    NSEntityDescription *companyEntity = [NSEntityDescription entityForName:@"Company"
                                                     inManagedObjectContext:self.context];
    [companyFetchRequest setEntity:companyEntity];
    
    [companyFetchRequest setPredicate:[NSPredicate predicateWithFormat:@"companyID = %@", [[SSUser currentUser] companyID]]];
    
    NSError *errorC;
    NSArray *companyFetchedObjects = [self.context executeFetchRequest:companyFetchRequest error:&errorC];
    if (companyFetchedObjects.count == 0) {
        
    } else {
        self.company = (Company *) [companyFetchedObjects objectAtIndex:0];
    }
    
    if (self.company.name.length == 0) {
        self.companyName = @"your company";
    } else {
        self.companyName = self.company.name;
    }
    

    self.titleLabel.text = [NSString stringWithFormat:@"Here are %@'s vision, mission and values!", self.companyName];

    self.visionTextView.text = [NSString stringWithFormat:@"Vision:\n%@", self.company.vision.vision];
    self.missionTextView.text = [NSString stringWithFormat:@"Mission:\n%@", self.company.mission.mission];
    
    NSFetchRequest *studentValuesFetchRequest = [[NSFetchRequest alloc] init];
    
    NSEntityDescription *studentValuesEntity = [NSEntityDescription entityForName:@"Value"
                                                           inManagedObjectContext:self.context];
    [studentValuesFetchRequest setEntity:studentValuesEntity];
    
    [studentValuesFetchRequest setPredicate:[NSPredicate predicateWithFormat:@"studentID = %@ AND selectedAsCompanyValue == %@", [[SSUser currentUser] studentID], [NSNumber numberWithBool:YES]]];
    
    studentValuesFetchRequest.sortDescriptors = [NSArray arrayWithObject:[NSSortDescriptor sortDescriptorWithKey:@"companyRank" ascending:YES selector:nil]];
    
    NSError *errorSV;
    NSArray *studentValuesFetchedObjects = [self.context executeFetchRequest:studentValuesFetchRequest error:&errorSV];
    if (studentValuesFetchedObjects.count == 0) {
        self.valuesTextView.text = @"";
    } else {

        NSString *val = @"";

        for(int i = 0; i< studentValuesFetchedObjects.count; i++) {
            Value *tempSV = [studentValuesFetchedObjects objectAtIndex:i];
            if([val isEqualToString:@""]) {
                val = [tempSV valueLiteralUS];
                val = [val stringByReplacingOccurrencesOfString:@" " withString:@""];
            } else {
                val = [NSString stringWithFormat:@"%@, %@", val, [tempSV valueLiteralUS]];
            }
        }
        
        self.valuesTextView.text = [NSString stringWithFormat:@"Values:\n%@.",val];
    }

    [[SSUser currentUser] setActivityNumberAsCompleted:@"5" andSyncStatus:NO];
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

-(void)dismissVC{
    [self dismissViewControllerAnimated:YES completion:NULL];
}

@end