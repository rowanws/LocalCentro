//
//  SSIndustryAnalysisTableViewController.m
//  CENTRO
//
//  Created by Centro Community Partners.
//  Copyright (c) 2013 Centro Community Partners. All rights reserved.
//

#import "SSIndustryAnalysisTableViewController.h"
#import "SSUser.h"
#import "Industry.h"
#import "IndustryAndSegment.h"

@interface SSIndustryAnalysisTableViewController ()

@property (strong, nonatomic) NSManagedObjectContext *context;
@property (strong, nonatomic) Industry *industry;
@property BOOL looksGoodPressed;

@end

@implementation SSIndustryAnalysisTableViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {

    }
    return self;
}

- (IBAction)doneButtonPressed:(id)sender {
    self.looksGoodPressed = YES;
    [[SSUser currentUser] setActivityNumberAsCompleted:@"12" andSyncStatus:NO];
    [self.navigationController popToRootViewControllerAnimated:YES];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    NSArray *viewControllers = self.navigationController.viewControllers;
    if (viewControllers.count > 1 && [viewControllers objectAtIndex:viewControllers.count-2] == self) {

    } else if ([viewControllers indexOfObject:self] == NSNotFound && !self.looksGoodPressed) {
        @try {
            [[SSUser currentUser] setSegueToPerform:@"12"];
            [self.navigationController popToRootViewControllerAnimated:NO];
            [self.navigationController.navigationBar popNavigationItemAnimated:NO];
        }
        @catch (NSException *exception) {
            
        }
        @finally {
            
        }
    } else {
        
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    //UIImageView *backgroundImageView40 = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"bg-568h@2x.png"]];
    //UIImageView *backgroundImageView35R = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"bg@2x.png"]];
    
    //CGRect screenBounds = [[UIScreen mainScreen] bounds];
    //if (screenBounds.size.height == 568) {
    //    self.tableView.backgroundView = backgroundImageView40;
    //} else {
    //    self.tableView.backgroundView = backgroundImageView35R;
    //}
    self.tableView.backgroundView.contentMode = UIViewContentModeCenter;
    
    self.tableView.delegate = self;
    
    self.navigationItem.title = @"Market Analysis";
    
    self.context = [(id)[[UIApplication sharedApplication] delegate] managedObjectContext];
    
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
    
    self.looksGoodPressed = NO;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

-(void) viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    if(![[SSUser currentUser] isLoggedIn]) {
        [self.navigationController popToRootViewControllerAnimated:YES];
    }
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 6;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"IndustryAnalysisCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
        [cell setAccessoryType:UITableViewCellAccessoryNone];
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    }
    
    if(indexPath.row == 0) {
        cell.textLabel.text = @"Industry";
        
        NSFetchRequest *fetchRequestIND = [[NSFetchRequest alloc] init];
        
        NSEntityDescription *entity = [NSEntityDescription entityForName:@"IndustryAndSegment"
                                                  inManagedObjectContext:self.context];
        [fetchRequestIND setEntity:entity];
        
        [fetchRequestIND setPredicate:[NSPredicate predicateWithFormat:[NSString stringWithFormat:@"isSegment = 0 AND industryCode = '%@'", self.industry.industryCode]]];
        
        NSError *error;
        NSArray *fetchedObjects = [self.context executeFetchRequest:fetchRequestIND error:&error];

        if (fetchedObjects.count == 0) {
            
            cell.detailTextLabel.text = @"";
        } else {
            IndustryAndSegment *ias = (IndustryAndSegment *) [fetchedObjects objectAtIndex:0];
            cell.detailTextLabel.text = ias.industryLiteralUS;
        }
    } else if(indexPath.row == 1) {
        cell.textLabel.text = @"Segment";
        NSFetchRequest *fetchRequestIND = [[NSFetchRequest alloc] init];
        
        NSEntityDescription *entity = [NSEntityDescription entityForName:@"IndustryAndSegment"
                                                  inManagedObjectContext:self.context];
        [fetchRequestIND setEntity:entity];
        
        [fetchRequestIND setPredicate:[NSPredicate predicateWithFormat:[NSString stringWithFormat:@"isSegment = 1 AND segmentCode = '%@'", self.industry.industrySegmentCode]]];
        
        NSError *error;
        NSArray *fetchedObjects = [self.context executeFetchRequest:fetchRequestIND error:&error];
        
        if (fetchedObjects.count == 0) {
            
            cell.detailTextLabel.text = @"";
        } else {
            IndustryAndSegment *ias = (IndustryAndSegment *) [fetchedObjects objectAtIndex:0];
            cell.detailTextLabel.text = ias.segmentLiteralUS;
        }
    } else if(indexPath.row == 2) {
        cell.textLabel.text = @"Growth";
        
        NSString *growth = @"";
        
        if([self.industry.growth intValue] == 1) {
            growth = @"High";
        } else if([self.industry.growth intValue] == 2) {
            growth = @"Medium";
        } else if([self.industry.growth intValue] == 3) {
            growth = @"None";
        } else if([self.industry.growth intValue] == 4) {
            growth = @"Shrinking";
        } else {
            growth = [NSString stringWithFormat:@"%@%%", [self.industry.growthRate stringValue] ];
        }
        
        cell.detailTextLabel.text = growth;
    } else if(indexPath.row == 3) {
        cell.textLabel.text = @"Age";
        
        NSString *age = @"";
        
        if([self.industry.marketAge intValue] == 1) {
            age = @"New";
        } else if([self.industry.marketAge intValue] == 2) {
            age = @"Recent";
        } else if([self.industry.marketAge intValue] == 3) {
            age = @"Established";
        } else if([self.industry.marketAge intValue] == 4) {
            age = @"Traditional";
        }
        
        cell.detailTextLabel.text = age;
    } else if(indexPath.row == 4) {
        cell.textLabel.text = @"Regulations";
        
        NSString *regulations = @"";
        
        if([self.industry.regulations intValue] == 1) {
            regulations = @"High";
        } else if([self.industry.regulations intValue] == 2) {
            regulations = @"Medium";
        } else if([self.industry.regulations intValue] == 3) {
            regulations = @"Low";
        } else if([self.industry.regulations intValue] == 4) {
            regulations = @"None";
        }
        
        cell.detailTextLabel.text = regulations;
    } else if(indexPath.row == 5) {
        cell.textLabel.text = @"Volatility";
        
        NSString *volatility = @"";
        
        if([self.industry.volatility intValue] == 1) {
            volatility = @"High";
        } else if([self.industry.volatility intValue] == 2) {
            volatility = @"Medium";
        } else if([self.industry.volatility intValue] == 3) {
            volatility = @"Low";
        }
        
        cell.detailTextLabel.text = volatility;
    }
    
    return cell;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{

}

@end