//
//  SSValuePropositionResultsViewController.m
//  CENTRO
//
//  Created by Centro Community Partners.
//  Copyright (c) 2013 Centro Community Partners. All rights reserved.
//

#import "SSValuePropositionResultsViewController.h"
#import "SSUser.h"
#import "ValueProposition.h"
#import "CustomerPriority.h"
#import "SSUtils.h"

@interface SSValuePropositionResultsViewController ()

@property (strong, nonatomic) NSManagedObjectContext *context;
@property (strong, nonatomic) ValueProposition *valueProposition;
@property (strong, nonatomic) NSMutableArray *solidVP;
@property (strong, nonatomic) NSMutableArray *weakVP;

@end

@implementation SSValuePropositionResultsViewController

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
        
    self.solidVP = [[NSMutableArray alloc] init];
    self.weakVP = [[NSMutableArray alloc] init];
    
    self.context = [(id)[[UIApplication sharedApplication] delegate] managedObjectContext];
    
    self.navigationItem.title = @"Value Proposition";
        
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"ValueProposition"
                                              inManagedObjectContext:self.context];
    [fetchRequest setEntity:entity];
    
    fetchRequest.returnsObjectsAsFaults = NO;
    
    [fetchRequest setPredicate:[NSPredicate predicateWithFormat:@"companyID = %@ AND isCompetitor = 0", [[SSUser currentUser] companyID]]];
    
    NSError *error;
    NSArray *fetchedObjects = [self.context executeFetchRequest:fetchRequest error:&error];
    if (fetchedObjects.count == 0) {
        
    } else {
        
        [[SSUser currentUser] setActivityNumberAsCompleted:@"19" andSyncStatus:NO];
        self.valueProposition = (ValueProposition *) [fetchedObjects objectAtIndex:0];
                
        if([[self.valueProposition priceRank] intValue] == 1) {
            [self.solidVP addObject:@"Excellent prices."];
        } else if([[self.valueProposition priceRank] intValue] == 2) {
            [self.solidVP addObject:@"Good prices."];
        } else {
            
        }
        
        if([[self.valueProposition customerServiceRank] intValue] == 1) {
            [self.solidVP addObject:@"Excellent customer service."];
        } else if([[self.valueProposition customerServiceRank] intValue] == 2) {
            [self.solidVP addObject:@"Good customer service."];
        } else {
            
        }
        
        if([[self.valueProposition qualityRank] intValue] == 1) {
            [self.solidVP addObject:@"Excellent quality."];
        } else if([[self.valueProposition qualityRank] intValue] == 2) {
            [self.solidVP addObject:@"Good quality."];
        } else {
            
        }
        
        if([[self.valueProposition speedRank] intValue] == 1) {
            [self.solidVP addObject:@"Excellent speed."];
        } else if([[self.valueProposition speedRank] intValue] == 2) {
            [self.solidVP addObject:@"Good speed."];
        } else {
            
        }
        
        if([[self.valueProposition locationRank] intValue] == 1) {
            [self.solidVP addObject:@"Excellent location."];
        } else if([[self.valueProposition locationRank] intValue] == 2) {
            [self.solidVP addObject:@"Good location."];
        } else {
            
        }
        
        if (self.solidVP.count >= 1) {
            self.valuePropositionLabel.text = [NSString stringWithFormat:@"Congrats! %@ has a solid value proposition.", [SSUtils companyName]];
            NSString *text = @"";
            
            for (NSString *str in self.solidVP) {
                text = [NSString stringWithFormat:@"%@%@\n", text, str];
            }
            
            self.valuePropositionTextView.text = text;
        } else {
            self.valuePropositionLabel.text = [NSString stringWithFormat:@"Uh oh! %@ has a weak value proposition. Consider doing at least one of the following.", [SSUtils companyName]];
            NSString *text = @"";
            
            NSFetchRequest *fetchRequestWVP = [[NSFetchRequest alloc] init];
            
            NSEntityDescription *entityWVP = [NSEntityDescription entityForName:@"CustomerPriority"
                                                         inManagedObjectContext:self.context];
            [fetchRequestWVP setEntity:entityWVP];
            
            fetchRequestWVP.returnsObjectsAsFaults = NO;
            
            fetchRequestWVP.sortDescriptors = [NSArray arrayWithObject:[NSSortDescriptor sortDescriptorWithKey:@"rank" ascending:YES selector:nil]];
            
            NSError *errorWVP;
            NSArray *fetchedObjectsWVP = [self.context executeFetchRequest:fetchRequestWVP error:&errorWVP];
            if (fetchedObjectsWVP.count == 0) {
                
            } else {
                for (int i = 0; i < 2; i++) {
                    if([[fetchedObjectsWVP[i] priorityCode] isEqualToString:@"PRI_PRIC"]) {
                        [self.weakVP addObject:@"Lower prices."];
                    } else if([[fetchedObjectsWVP[i] priorityCode] isEqualToString:@"PRI_CUSE"]) {
                        [self.weakVP addObject:@"Improve customer service."];
                    } else if([[fetchedObjectsWVP[i] priorityCode] isEqualToString:@"PRI_QUAL"]) {
                        [self.weakVP addObject:@"Improve quality."];
                    } else if([[fetchedObjectsWVP[i] priorityCode] isEqualToString:@"PRI_SPEE"]) {
                        [self.weakVP addObject:@"Provide faster service."];
                    } else if([[fetchedObjectsWVP[i] priorityCode] isEqualToString:@"PRI_LOCA"]) {
                        [self.weakVP addObject:@"Find a better location."];
                    } else {
                        
                    }
                }
            }
        
            for (NSString *str in self.weakVP) {
                text = [NSString stringWithFormat:@"%@%@\n", text, str];
            }
        
            self.valuePropositionTextView.text = text;
        }
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end