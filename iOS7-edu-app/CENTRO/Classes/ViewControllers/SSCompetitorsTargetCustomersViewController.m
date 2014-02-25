//
//  SSCompetitorsTargetCustomersViewController.m
//  CENTRO
//
//  Created by Silvio Centro Community Partners.
//  Copyright (c) 2013 Centro Community Partners. All rights reserved.
//

#import "SSCompetitorsTargetCustomersViewController.h"
#import "CompetitorProfile.h"
#import "CustomerProfile.h"
#import "SSUser.h"
#import "CustomerInterest.h"
#import "CustomerOccupation.h"
#import "CustomerEducation.h"

@interface SSCompetitorsTargetCustomersViewController ()

@property (strong, nonatomic) NSManagedObjectContext *context;
@property (strong, nonatomic) NSArray *fetchedCompetitorData;
@property (strong, nonatomic) NSArray *questionsArray;
@property (strong, nonatomic) NSArray *questionsCategoryArray;
@property (strong, nonatomic) CustomerProfile *profile;

@property int competitorIndex;
@property int questionIndex;
@property BOOL stop;

@end

@implementation SSCompetitorsTargetCustomersViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {

    }
    return self;
}

- (IBAction)oftenButtonPressed:(id)sender {
    [self saveAnswer:1 Category:self.questionsCategoryArray[self.questionIndex] Competitor:self.fetchedCompetitorData[self.competitorIndex]];
    [self incrementQuestionAndCompetitor];
    if(!self.stop) {
        [self saveAnswer:1 Category:self.questionsCategoryArray[self.questionIndex] Competitor:self.fetchedCompetitorData[self.competitorIndex]];
        [self ask];
    } else {
        [self performSegueWithIdentifier:@"RankCompetitors" sender:self];
    }
}

- (IBAction)sometimesButtonPressed:(id)sender {
    [self saveAnswer:2 Category:self.questionsCategoryArray[self.questionIndex] Competitor:self.fetchedCompetitorData[self.competitorIndex]];
    [self incrementQuestionAndCompetitor];
    if(!self.stop) {
        [self ask];
    } else {
        [self performSegueWithIdentifier:@"RankCompetitors" sender:self];
    }
}

- (IBAction)rarelyButtonPressed:(id)sender {
    [self saveAnswer:3 Category:self.questionsCategoryArray[self.questionIndex] Competitor:self.fetchedCompetitorData[self.competitorIndex]];
    [self incrementQuestionAndCompetitor];
    if(!self.stop) {
        [self ask];
    } else {
        [self performSegueWithIdentifier:@"RankCompetitors" sender:self];
    }
}

-(void) incrementQuestionAndCompetitor {    
    if(self.questionIndex < self.questionsArray.count-1) {
        self.questionIndex++;
    } else if(self.questionIndex >= self.questionsArray.count-1) {
        self.questionIndex = 0;
        self.competitorIndex++;
        if (self.competitorIndex == self.fetchedCompetitorData.count) {
            self.stop = YES;
        }
    }
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
    
    self.navigationItem.title = @"Competitors";
    
    [self.oftenButton setTitle:@"Often" forState:UIControlStateNormal];
    [self.sometimesButton setTitle:@"Sometimes" forState:UIControlStateNormal];
    [self.rarelyButton setTitle:@"Rarely" forState:UIControlStateNormal];
        
}

-(void) viewDidAppear:(BOOL)animated {
    
    [super viewDidAppear:animated];
    if(![[SSUser currentUser] isLoggedIn]) {
        [self.navigationController popToRootViewControllerAnimated:YES];
    } else {
        
        self.competitorIndex = 0;
        self.questionIndex = 0;
        self.stop = NO;
        
        NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
        
        NSEntityDescription *entity = [NSEntityDescription entityForName:@"CompetitorProfile"
                                                  inManagedObjectContext:self.context];
        [fetchRequest setEntity:entity];
        
        [fetchRequest setPredicate:[NSPredicate predicateWithFormat:@"name != %@", @""]];
        
        NSError *error;
        NSArray *fetchedObjects = [self.context executeFetchRequest:fetchRequest error:&error];
        
        if (fetchedObjects.count == 0) { 
            
        } else {
            self.fetchedCompetitorData = fetchedObjects;
            
            NSFetchRequest *fetchRequest1 = [[NSFetchRequest alloc] init];
            
            NSEntityDescription *entity1 = [NSEntityDescription entityForName:@"CustomerProfile"
                                                       inManagedObjectContext:self.context];
            [fetchRequest1 setEntity:entity1];
            
            [fetchRequest1 setPredicate:[NSPredicate predicateWithFormat:@"companyID = %@", [[SSUser currentUser] companyID]]];
            
            NSError *error1;
            NSArray *fetchedObjects1 = [self.context executeFetchRequest:fetchRequest1 error:&error1];
            
            if (fetchedObjects1.count == 0) { 
                
            } else {
                self.profile = (CustomerProfile *) [fetchedObjects1 objectAtIndex:0];

                [self questions];
                
                if([self.questionsArray count] == 0) {
                    self.stop = YES;
                    self.questionLabel.text = @"";
                    [self performSegueWithIdentifier:@"RankCompetitors" sender:self];
                } else {
                    [self ask];
                }
            }
        }
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (void) questions {
    
    NSMutableArray *questions = [[NSMutableArray alloc] init];
    NSMutableArray *questionsCategoryArray = [[NSMutableArray alloc] init];
    
    if (YES/*[self.profile.isAgeSure intValue] == 1*/) {
        [questions addObject:[NSString stringWithFormat:@"people between %@ and %@ years old", self.profile.fromAge, self.profile.toAge]];
        [questionsCategoryArray addObject:@"age"];
    }
    
    if (YES/*[self.profile.isGenderSure intValue] == 1*/) {
        [questions addObject:[NSString stringWithFormat:@"%@%% women and %@%% men", self.profile.menPercentage, self.profile.womenPercentage]];
        [questionsCategoryArray addObject:@"gender"];
    }
    
    if (YES/*[self.profile.isIncomeSure intValue] == 1*/) {
        [questions addObject:[NSString stringWithFormat:@"people earning between $%@ and $%@ per year", self.profile.fromIncome, self.profile.toIncome]];
        [questionsCategoryArray addObject:@"income"];
    }
    
    if (YES/*[self.profile.isEducationSure intValue] == 1*/) {
        [questions addObject:@"people with these education levels?"];
        [questionsCategoryArray addObject:@"education"];
    }
    
    if (YES/*[self.profile.isOccupationSure intValue] == 1*/) {
        [questions addObject:@"people with these occupations?"];
        [questionsCategoryArray addObject:@"occupation"];
    }
    
    if (YES/*[self.profile.isInterestSure intValue] == 1*/) {
        [questions addObject:@"people with these interests?"];
        [questionsCategoryArray addObject:@"interest"];
    }
    
    self.questionsArray = questions;
    self.questionsCategoryArray = questionsCategoryArray;
}

- (void) ask {
    
    if(self.questionIndex == 3) {
        NSString *educationList = @"";
        
        NSSet *educations = self.profile.educations;
        
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"selectedAsCustomerEducation = 1"];
        NSArray *selectedEducations = [[educations filteredSetUsingPredicate:predicate] allObjects];
        
        for (int i = 0; i < selectedEducations.count; i++) {
            
            CustomerEducation *temp = [selectedEducations objectAtIndex:i];
            if([educationList isEqualToString:@""]) {
                educationList = [temp educationLiteralUS];
            } else {
                educationList = [NSString stringWithFormat:@"%@, %@", educationList, [temp educationLiteralUS]];
            }
        }
        
        educationList = [NSString stringWithFormat:@"%@.",educationList];
        
        self.questionLabel.text = [NSString stringWithFormat:@"Does %@ sell to %@\n\n%@", [self.fetchedCompetitorData[self.competitorIndex] name], self.questionsArray[self.questionIndex], educationList];
    } else if(self.questionIndex == 4) {
        NSString *occupationList = @"";
        
        NSSet *occupations = self.profile.occupations;
        
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"selectedAsCustomerOccupation = 1"];
        NSArray *selectedOccupations = [[occupations filteredSetUsingPredicate:predicate] allObjects];
        
        for (int i = 0; i < selectedOccupations.count; i++) {
            
            CustomerOccupation *temp = [selectedOccupations objectAtIndex:i];
            if([occupationList isEqualToString:@""]) {
                occupationList = [temp occupationLiteralUS];
            } else {
                occupationList = [NSString stringWithFormat:@"%@, %@", occupationList, [temp occupationLiteralUS]];
            }
        }
        
        occupationList = [NSString stringWithFormat:@"%@.",occupationList];
        
        self.questionLabel.text = [NSString stringWithFormat:@"Does %@ sell to %@\n\n%@", [self.fetchedCompetitorData[self.competitorIndex] name], self.questionsArray[self.questionIndex], occupationList];
    } else if(self.questionIndex == 5) {
        
        NSString *interestList = @"";
        
        NSSet *interests = self.profile.interests;
        
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"selectedAsCustomerInterest = 1"];
        NSArray *selectedInterests = [[interests filteredSetUsingPredicate:predicate] allObjects];
        
        for (int i = 0; i < selectedInterests.count; i++) {

            CustomerInterest *temp = [selectedInterests objectAtIndex:i];
            if([interestList isEqualToString:@""]) {
                interestList = [temp interestLiteralUS];
            } else {
                interestList = [NSString stringWithFormat:@"%@, %@", interestList, [temp interestLiteralUS]];
            }
        }
        
        interestList = [NSString stringWithFormat:@"%@.",interestList];
        
        self.questionLabel.text = [NSString stringWithFormat:@"Does %@ sell to %@\n\n%@", [self.fetchedCompetitorData[self.competitorIndex] name], self.questionsArray[self.questionIndex], interestList];
    } else {
        self.questionLabel.text = [NSString stringWithFormat:@"Does %@ sell to %@?", [self.fetchedCompetitorData[self.competitorIndex] name], self.questionsArray[self.questionIndex]];
    }
}

- (void) saveAnswer: (int) answer Category: (NSString *) category Competitor: (CompetitorProfile *) competitor {
    
    if ([category isEqualToString:@"age"]) {
        [(CompetitorProfile *) self.fetchedCompetitorData[self.competitorIndex] setFrequencySellTargetAge:[NSNumber numberWithInt:answer]];
    } else if ([category isEqualToString:@"gender"]) {
        [(CompetitorProfile *) self.fetchedCompetitorData[self.competitorIndex] setFrequencySellTargetGenre:[NSNumber numberWithInt:answer]];
    } else if ([category isEqualToString:@"income"]) {
        [(CompetitorProfile *) self.fetchedCompetitorData[self.competitorIndex] setFrequencySellTargetIncome:[NSNumber numberWithInt:answer]];
    } else if ([category isEqualToString:@"education"]) {
        [(CompetitorProfile *) self.fetchedCompetitorData[self.competitorIndex] setFrequencySellTargetEducation:[NSNumber numberWithInt:answer]];
    } else if ([category isEqualToString:@"occupation"]) {
        [(CompetitorProfile *) self.fetchedCompetitorData[self.competitorIndex] setFrequencySellTargetOccupation:[NSNumber numberWithInt:answer]];
    } else if ([category isEqualToString:@"interest"]) {
        [(CompetitorProfile *) self.fetchedCompetitorData[self.competitorIndex] setFrequencySellTargetInterest:[NSNumber numberWithInt:answer]];
    } else {
        //
    }
    
    [self.context save:nil];
    
}

@end