//
//  SSValuePropositionRankViewController.m
//  CENTRO
//
//  Created by Centro Community Partners.
//  Copyright (c) 2013 Centro Community Partners. All rights reserved.
//

#import "SSValuePropositionRankViewController.h"
#import "SSUser.h"
#import "ValueProposition.h"
#import "CompetitorProfile.h"
#import "Company.h"

@interface SSValuePropositionRankViewController ()

@property (strong, nonatomic) NSManagedObjectContext *context;
@property (strong, nonatomic) NSArray *fetchedCompetitorData;
@property (strong, nonatomic) NSString *company;


@property (strong,nonatomic) NSMutableArray *winners;
@property (strong,nonatomic) NSMutableArray *losers;
@property (strong,nonatomic) NSMutableArray *equals;
@property (strong,nonatomic) NSMutableArray *players;

@property (strong, nonatomic) NSArray *questions;

@property int competitorQuestionPos;
@property int position;
@property BOOL orderingDone;

@end

@implementation SSValuePropositionRankViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {

    }
    return self;
}
- (IBAction)leftButtonPressed:(id)sender {
    [self winningTeamIsHome:1];
}
- (IBAction)rightButtonPressed:(id)sender {
    [self winningTeamIsHome:2];
}
- (IBAction)sameButtonPressed:(id)sender {
    [self winningTeamIsHome:0];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    UIImage *bg40 = [UIImage imageNamed:@"bg-568h@2x.png"];
    UIImage *bg35R = [UIImage imageNamed:@"bg.png"];
    
    CGRect screenBounds = [[UIScreen mainScreen] bounds];
    if (screenBounds.size.height == 568) {
        self.backgroundImageView.image = bg40;
    } else {
        self.backgroundImageView.image = bg35R;
    }
    
    self.navigationItem.title = @"Play";
    
    self.questionLabel.text = @"";
    
    [self.sameButton setTitle:@"SAME" forState:UIControlStateNormal];
    
    self.context = [(id)[[UIApplication sharedApplication] delegate] managedObjectContext];
    
    [self competitorQuestions];
}


- (void) prepareData {

    NSFetchRequest *valuePropositionFetchRequest = [[NSFetchRequest alloc] init];
    
    NSEntityDescription *valuePropositionProfileEntity = [NSEntityDescription entityForName:@"ValueProposition"
                                                                     inManagedObjectContext:self.context];
    [valuePropositionFetchRequest setEntity:valuePropositionProfileEntity];
    
    [valuePropositionFetchRequest setPredicate:[NSPredicate predicateWithFormat:@"companyID = %@", [[SSUser currentUser] companyID]]];
    
    
    valuePropositionFetchRequest.returnsObjectsAsFaults = NO;
    NSError *errorVP;
    NSArray *fetchedObjectsVP = [self.context executeFetchRequest:valuePropositionFetchRequest error:&errorVP];
    self.fetchedCompetitorData = fetchedObjectsVP;
    
    if (fetchedObjectsVP.count == 0) {
        
    } else {

        NSFetchRequest *companyFetchRequest = [[NSFetchRequest alloc] init];
        
        NSEntityDescription *companyEntity = [NSEntityDescription entityForName:@"Company"
                                                         inManagedObjectContext:self.context];
        [companyFetchRequest setEntity:companyEntity];
        
        [companyFetchRequest setPredicate:[NSPredicate predicateWithFormat:@"companyID = %@", [[SSUser currentUser] companyID]]];
        
        companyFetchRequest.returnsObjectsAsFaults = NO;
        
        NSError *errorC;
        NSArray *companyFetchedObjects = [self.context executeFetchRequest:companyFetchRequest error:&errorC];
        if (companyFetchedObjects.count == 0) {
            
        } else {
            Company *tempCompany = (Company *) [companyFetchedObjects objectAtIndex:0];
            if ([tempCompany.name isEqualToString:@""]) {
                self.company = @"My Company";
            } else {
                self.company = tempCompany.name;
            }

            NSFetchRequest *competitorProfileFetchRequest = [[NSFetchRequest alloc] init];
            
            NSEntityDescription *competitorProfileEntity = [NSEntityDescription entityForName:@"CompetitorProfile"
                                                                       inManagedObjectContext:self.context];
            [competitorProfileFetchRequest setEntity:competitorProfileEntity];
            
            [competitorProfileFetchRequest setPredicate:[NSPredicate predicateWithFormat:@"name != %@", @""]];
            
            competitorProfileFetchRequest.returnsObjectsAsFaults = NO;
            
            NSError *errorCP;
            NSArray *fetchedObjectsCP = [self.context executeFetchRequest:competitorProfileFetchRequest error:&errorCP];
            
            if (fetchedObjectsCP.count == 0) {
                
            } else {
                [self clearValueProposition];
                for (int i = 0; i < fetchedObjectsCP.count; i++) {
                    NSString *tempName = [(CompetitorProfile *) fetchedObjectsCP[i] name];
                    NSNumber *tempID = [(CompetitorProfile *) fetchedObjectsCP[i] competitorProfileID];
                    NSNumber *tempPriceRank = [(CompetitorProfile *) fetchedObjectsCP[i] priceRank];
                    NSNumber *tempCustomerServiceRank = [(CompetitorProfile *) fetchedObjectsCP[i] customerServiceRank];
                    NSNumber *tempQualityRank = [(CompetitorProfile *) fetchedObjectsCP[i] qualityRank];
                    NSNumber *tempLocationRank = [(CompetitorProfile *) fetchedObjectsCP[i] locationRank];
                    NSNumber *tempSpeedRank = [(CompetitorProfile *) fetchedObjectsCP[i] speedRank];
                    [(ValueProposition *) self.fetchedCompetitorData[i] setName:tempName];
                    [(ValueProposition *) self.fetchedCompetitorData[i] setCompetitorProfileID:tempID];
                    [(ValueProposition *) self.fetchedCompetitorData[i] setIsCompetitor:[NSNumber numberWithBool:YES]];
                    [(ValueProposition *) self.fetchedCompetitorData[i] setPriceRank:tempPriceRank];
                    [(ValueProposition *) self.fetchedCompetitorData[i] setCustomerServiceRank:tempCustomerServiceRank];
                    [(ValueProposition *) self.fetchedCompetitorData[i] setQualityRank:tempQualityRank];
                    [(ValueProposition *) self.fetchedCompetitorData[i] setLocationRank:tempLocationRank];
                    [(ValueProposition *) self.fetchedCompetitorData[i] setSpeedRank:tempSpeedRank];
                }
                
                [self.fetchedCompetitorData[4] setName:self.company];
                [self.fetchedCompetitorData[4] setIsCompetitor:[NSNumber numberWithBool:NO]];
                [self.fetchedCompetitorData[4] setPriceRank:[NSNumber numberWithInt:500]];
                [self.fetchedCompetitorData[4] setCustomerServiceRank:[NSNumber numberWithInt:500]];
                [self.fetchedCompetitorData[4] setQualityRank:[NSNumber numberWithInt:500]];
                [self.fetchedCompetitorData[4] setLocationRank:[NSNumber numberWithInt:500]];
                [self.fetchedCompetitorData[4] setSpeedRank:[NSNumber numberWithInt:500]];
            }
        }
    }
}



-(void) clearValueProposition {
    for (ValueProposition *vp in self.fetchedCompetitorData) {
        vp.name = @"";
        vp.isCompetitor = [NSNumber numberWithBool:YES];
    }
}

-(void) viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    if(![[SSUser currentUser] isLoggedIn]) {
        [self.navigationController popToRootViewControllerAnimated:YES];
    } else {
        self.competitorQuestionPos = 0;
        [self prepareData];
        [self startTournament];
    }
}

- (void) startTournament {
    
    NSSortDescriptor *sort;
    
    if(self.competitorQuestionPos == 0) {
        sort = [[NSSortDescriptor alloc] initWithKey:@"priceRank" ascending:YES];
        self.fetchedCompetitorData = [self.fetchedCompetitorData sortedArrayUsingDescriptors:[NSArray arrayWithObject:sort]];
    } else if(self.competitorQuestionPos == 1) {
        sort = [[NSSortDescriptor alloc] initWithKey:@"customerServiceRank" ascending:YES];
        self.fetchedCompetitorData = [self.fetchedCompetitorData sortedArrayUsingDescriptors:[NSArray arrayWithObject:sort]];
    } else if(self.competitorQuestionPos == 2) {
        sort = [[NSSortDescriptor alloc] initWithKey:@"qualityRank" ascending:YES];
        self.fetchedCompetitorData = [self.fetchedCompetitorData sortedArrayUsingDescriptors:[NSArray arrayWithObject:sort]];
    } else if(self.competitorQuestionPos == 3) {
        sort = [[NSSortDescriptor alloc] initWithKey:@"locationRank" ascending:YES];
        self.fetchedCompetitorData = [self.fetchedCompetitorData sortedArrayUsingDescriptors:[NSArray arrayWithObject:sort]];
    } else if(self.competitorQuestionPos == 4) {
        sort = [[NSSortDescriptor alloc] initWithKey:@"speedRank" ascending:YES];
        self.fetchedCompetitorData = [self.fetchedCompetitorData sortedArrayUsingDescriptors:[NSArray arrayWithObject:sort]];
    }

    
    self.questionLabel.text = [self.questions objectAtIndex:self.competitorQuestionPos];
    
    self.players = [[NSMutableArray alloc] init];
    
    self.losers = [[NSMutableArray alloc] init];
    self.winners = [[NSMutableArray alloc] init];
    self.equals = [[NSMutableArray alloc] init];
    
    for(int i=0; i < [self.fetchedCompetitorData count]; i++ ){
        NSString *tempName = [(ValueProposition *) self.fetchedCompetitorData[i] name];
        NSNumber *tempComp = [(ValueProposition *) self.fetchedCompetitorData[i] isCompetitor];
        
        if (![tempName isEqualToString:@""] && [tempComp isEqualToNumber:[NSNumber numberWithInt:1]]) {
            NSMutableArray *temp = [[NSMutableArray alloc] initWithObjects:[self.fetchedCompetitorData objectAtIndex:i], nil];
            [self.players addObject:temp];
        }
    }
    
    self.position = 0;
    
    ValueProposition *p1 = (ValueProposition *) [[self.players objectAtIndex:self.position] objectAtIndex:self.position];
    
    [self.rightButton setTitle:p1.name forState:UIControlStateNormal];
    [self.leftButton setTitle:[self.fetchedCompetitorData[4] name] forState:UIControlStateNormal];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (void) winningTeamIsHome:(int) home {
    
    NSMutableArray *rank = [[NSMutableArray alloc] init];
    
    if(self.position < [self.players count]){
    
        if(home == 1){
            [rank addObjectsFromArray:self.winners];
            [rank addObject:self.fetchedCompetitorData[4]];
            for(int i=self.position; i < [self.players count]; i++ ){
                [rank addObjectsFromArray:[self.players objectAtIndex:i]];
            }
            self.position = [self.players count] - 1;
            self.orderingDone = YES;
            
        }
        else{
            if(home == 2){
                [self.winners addObjectsFromArray:[self.players objectAtIndex:self.position]];
                self.orderingDone = NO;
            }
            else{
                [rank addObjectsFromArray:self.winners];
                [rank addObject:self.fetchedCompetitorData[4]];
                for(int i=self.position; i < [self.players count]; i++ ){
                    [rank addObjectsFromArray:[self.players objectAtIndex:i]];
                }
                self.position = [self.players count] - 1;
                self.orderingDone = YES;
            }
        }
        
        self.position = self.position + 1;
        
        if(self.position == [self.players count]){
            
            if(!self.orderingDone){
                [rank addObjectsFromArray:self.winners];
                [rank addObject:self.fetchedCompetitorData[4]];
                [rank addObjectsFromArray:self.equals];
                [rank addObjectsFromArray:self.losers];
            }
            
            if(self.competitorQuestionPos == 0) {
                [self saveRank:rank forCategory:@"prices"];
            } else if(self.competitorQuestionPos == 1) {
                [self saveRank:rank forCategory:@"customersat"];
            } else if(self.competitorQuestionPos == 2) {
                [self saveRank:rank forCategory:@"quality"];
            } else if(self.competitorQuestionPos == 3) {
                [self saveRank:rank forCategory:@"location"];
            } else if(self.competitorQuestionPos == 4) {
                [self saveRank:rank forCategory:@"speed"];
            }
            
            if (self.competitorQuestionPos < 4) {
                self.competitorQuestionPos++;
                [self startTournament];
            } else {
                [self.context save:nil];
                [self performSegueWithIdentifier:@"ValuePropositionsRankTable" sender:self];
            }

            
        }
        else{
            
            ValueProposition *p1 = (ValueProposition *) [[self.players objectAtIndex:self.position] objectAtIndex:0];
            
            [self.rightButton setTitle:p1.name forState:UIControlStateNormal];
            [self.leftButton setTitle:[self.fetchedCompetitorData[4] name] forState:UIControlStateNormal];
   
        }
            
    }      

}

-(void) competitorQuestions {

    self.questions = [NSArray arrayWithObjects:@"Which has better Prices?", @"Which has better Customer Service?", @"Which has better Quality?", @"Which has better Location?", @"Which has better Speed?", nil];
    
}

-(void) saveRank:(NSMutableArray *) rank forCategory:(NSString *) category {
    if ([category isEqualToString:@"prices"]) {
        
        for (int i = 0; i < rank.count; i++) {
            for (ValueProposition *vp in self.fetchedCompetitorData) {
                if ([vp.name isEqualToString:[(ValueProposition *) rank[i] name]]) {
                    vp.priceRank = [NSNumber numberWithInt:i+1];
                }
            }
        }
        
    }
    
    if ([category isEqualToString:@"customersat"]) {

        for (int i = 0; i < rank.count; i++) {
            for (ValueProposition *vp in self.fetchedCompetitorData) {
                if ([vp.name isEqualToString:[(ValueProposition *) rank[i] name]]) {
                    vp.customerServiceRank = [NSNumber numberWithInt:i+1];
                }
            }
        }
        
    }
    
    if ([category isEqualToString:@"quality"]) {
        
        for (int i = 0; i < rank.count; i++) {
            for (ValueProposition *vp in self.fetchedCompetitorData) {
                if ([vp.name isEqualToString:[(ValueProposition *) rank[i] name]]) {
                    vp.qualityRank = [NSNumber numberWithInt:i+1];
                }
            }
        }
        
    }
    
    if ([category isEqualToString:@"location"]) {

        for (int i = 0; i < rank.count; i++) {
            for (ValueProposition *vp in self.fetchedCompetitorData) {
                if ([vp.name isEqualToString:[(ValueProposition *) rank[i] name]]) {
                    vp.locationRank = [NSNumber numberWithInt:i+1];
                }
            }
        }
        
    }
    
    if ([category isEqualToString:@"speed"]) {

        for (int i = 0; i < rank.count; i++) {
            for (ValueProposition *vp in self.fetchedCompetitorData) {
                if ([vp.name isEqualToString:[(ValueProposition *) rank[i] name]]) {
                    vp.speedRank = [NSNumber numberWithInt:i+1];
                }
            }
        }
        
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