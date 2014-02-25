//
//  SSRankCompetitorsViewController.m
//  CENTRO
//
//  Created by Centro Community Partners.
//  Copyright (c) 2013 Centro Community Partners. All rights reserved.
//

#import "SSRankCompetitorsViewController.h"
#import "SSUser.h"
#import "CompetitorProfile.h"

@interface SSRankCompetitorsViewController ()

@property (strong, nonatomic) NSManagedObjectContext *context;
@property (strong, nonatomic) NSArray *fetchedCompetitorData;


@property (strong,nonatomic) NSMutableArray *winner;
@property (strong,nonatomic) NSMutableArray *loser;
@property (strong,nonatomic) NSMutableArray *losers;
@property (strong,nonatomic) NSMutableArray *rounds;
@property (strong,nonatomic) NSMutableArray *actualRound;

@property (strong, nonatomic) NSArray *questions;

@property int competitorQuestionPos;
@property int position;
@property int round;

@end

@implementation SSRankCompetitorsViewController

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
    
    
    //UIImage *bg40 = [UIImage imageNamed:@"bg-568h@2x.png"];
    //UIImage *bg35R = [UIImage imageNamed:@"bg.png"];
    
    //CGRect screenBounds = [[UIScreen mainScreen] bounds];
    //if (screenBounds.size.height == 568) {
    //    self.backgroundImageView.image = bg40;
    //} else {
    //    self.backgroundImageView.image = bg35R;
    //}
    
    self.navigationItem.title = @"Play";
    
    self.questionLabel.text = @"";
    
    [self.sameButton setTitle:@"SAME" forState:UIControlStateNormal];
    
    self.context = [(id)[[UIApplication sharedApplication] delegate] managedObjectContext];
    
    [self competitorQuestions];
}

-(void) viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    if(![[SSUser currentUser] isLoggedIn]) {
        [self.navigationController popToRootViewControllerAnimated:YES];
    } else {
        NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
        
        NSEntityDescription *entity = [NSEntityDescription entityForName:@"CompetitorProfile"
                                                  inManagedObjectContext:self.context];
        [fetchRequest setEntity:entity];
        
        [fetchRequest setPredicate:[NSPredicate predicateWithFormat:@"name != %@", @""]];
        
        NSError *error;
        NSArray *fetchedObjects = [self.context executeFetchRequest:fetchRequest error:&error];
        
        self.rounds = [[NSMutableArray alloc] init];
        
        if (fetchedObjects.count == 0) { 
            
        } else {
            self.fetchedCompetitorData = fetchedObjects;
            self.competitorQuestionPos = 0;
            
            [self startTournament];
        }
    }
}

- (void) startTournament {
    
    self.questionLabel.text = [self.questions objectAtIndex:self.competitorQuestionPos];
    
    NSMutableArray *firstRound = [[NSMutableArray alloc] init];
    NSMutableArray *players = [[NSMutableArray alloc] init];
    
    self.losers = [[NSMutableArray alloc] init];
    self.winner = [[NSMutableArray alloc] init];
    self.loser = [[NSMutableArray alloc] init];
    self.rounds = [[NSMutableArray alloc] init];
    self.actualRound = [[NSMutableArray alloc] init];
    
    for(int i=0; i < [self.fetchedCompetitorData count]; i++ ){
        NSMutableArray *temp = [[NSMutableArray alloc] initWithObjects:[self.fetchedCompetitorData objectAtIndex:i], nil];
        [players addObject:temp];
    }
    
    [firstRound addObject:players];
    [self.rounds addObject:firstRound];
    
    self.position = 0;
    self.round = 0;
    
    CompetitorProfile *p1 = (CompetitorProfile *) [[[[self.rounds objectAtIndex:self.position] objectAtIndex:0] objectAtIndex:self.position] objectAtIndex:0];
    CompetitorProfile *p2 = (CompetitorProfile *) [[[[self.rounds objectAtIndex:self.position] objectAtIndex:0] objectAtIndex:self.position+1] objectAtIndex:0];
    
    [self.rightButton setTitle:p2.name forState:UIControlStateNormal];
    [self.leftButton setTitle:p1.name forState:UIControlStateNormal];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (void) winningTeamIsHome:(int) home {
    
    NSMutableArray *tempWinner = [[NSMutableArray alloc] init];
    NSMutableArray *tempLoser = [[NSMutableArray alloc] init];
    
    if(self.position == 0){
        NSMutableArray *nextRound = [[NSMutableArray alloc] init];
        NSMutableArray *nextPlayer = [[NSMutableArray alloc] init];
        [nextRound addObject:nextPlayer];
        [self.rounds addObject:nextRound];
    }
    
    if(home == 1){
        tempWinner = [[[self.rounds objectAtIndex:self.round] objectAtIndex:0] objectAtIndex:self.position];
        tempLoser = [[[self.rounds objectAtIndex:self.round] objectAtIndex:0] objectAtIndex: self.position+1];
        [self.losers addObjectsFromArray:tempLoser];
        [[[self.rounds objectAtIndex:self.round+1] objectAtIndex:0] addObject:tempWinner];
    }
    else{
        if(home == 2){
            tempWinner = [[[self.rounds objectAtIndex:self.round] objectAtIndex:0] objectAtIndex: self.position+1];
            tempLoser = [[[self.rounds objectAtIndex:self.round] objectAtIndex:0] objectAtIndex:self.position];
            [self.losers addObjectsFromArray:tempLoser];
            [[[self.rounds objectAtIndex:self.round+1] objectAtIndex:0] addObject:tempWinner];
        }
        else{
            tempWinner = [[[self.rounds objectAtIndex:self.round] objectAtIndex:0] objectAtIndex: self.position+1];
            tempLoser = [[[self.rounds objectAtIndex:self.round] objectAtIndex:0] objectAtIndex: self.position];
            [tempWinner addObjectsFromArray:tempLoser];
            [[[self.rounds objectAtIndex:self.round+1] objectAtIndex:0] addObject:tempWinner];
        }
    }

    self.position = self.position + 2;

    if([[[self.rounds objectAtIndex:self.round] objectAtIndex:0] count ] > self.position){ 

        if([[[self.rounds objectAtIndex:self.round] objectAtIndex:0] count ] > self.position +1){
            
            CompetitorProfile *p1 = (CompetitorProfile *) [[[[self.rounds objectAtIndex:self.round] objectAtIndex:0] objectAtIndex:self.position] objectAtIndex:0];
            CompetitorProfile *p2 = (CompetitorProfile *) [[[[self.rounds objectAtIndex:self.round] objectAtIndex:0]  objectAtIndex:self.position+1] objectAtIndex:0];
            
            [self.rightButton setTitle:p2.name forState:UIControlStateNormal];
            [self.leftButton setTitle:p1.name forState:UIControlStateNormal];
        }
        else{
            int old_pos = self.position;
            self.position = 0;
            self.round = self.round + 1;
            
            [[[self.rounds objectAtIndex:self.round] objectAtIndex:0] addObject:[[[self.rounds objectAtIndex:self.round-1] objectAtIndex:0] objectAtIndex:old_pos] ];
            
            CompetitorProfile *p1 = (CompetitorProfile *) [[[[self.rounds objectAtIndex:self.round] objectAtIndex:0] objectAtIndex:self.position] objectAtIndex:0];
            CompetitorProfile *p2 = (CompetitorProfile *) [[[[self.rounds objectAtIndex:self.round] objectAtIndex:0]  objectAtIndex:self.position+1] objectAtIndex:0];
            
            [self.rightButton setTitle:p2.name forState:UIControlStateNormal];
            [self.leftButton setTitle:p1.name forState:UIControlStateNormal];
            
            
        }
    }
    else{
        self.position = 0;
        self.round = self.round + 1;
        if([[[self.rounds objectAtIndex:self.round] objectAtIndex:0] count ] == 1){

            NSMutableArray *rank = [[NSMutableArray alloc] init];
            
            for (int i = 0; i < self.losers.count; i++) {
                [rank insertObject:self.losers[i] atIndex:0];
            }
            
            for (int i = 0; i < tempWinner.count; i++) {
                [rank insertObject:tempWinner[i] atIndex:0];
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
                [self performSegueWithIdentifier:@"CompetitorsWalkingDistance" sender:self];
            }
            
            
        }
        else{
            
    		CompetitorProfile *p1 = (CompetitorProfile *) [[[[self.rounds objectAtIndex:self.round] objectAtIndex:0] objectAtIndex:self.position] objectAtIndex:0];
        	CompetitorProfile *p2 = (CompetitorProfile *) [[[[self.rounds objectAtIndex:self.round] objectAtIndex:0]  objectAtIndex:self.position+1] objectAtIndex:0];
            
            [self.rightButton setTitle:p2.name forState:UIControlStateNormal];
            [self.leftButton setTitle:p1.name forState:UIControlStateNormal];
        }
    }
}

-(void) competitorQuestions {

    self.questions = [NSArray arrayWithObjects:@"Which competitor has better Prices?", @"Which competitor has better Customer Service?", @"Which competitor has better Quality?", @"Which competitor has better Location?", @"Which competitor has better Speed?", nil];
    
}

-(void) saveRank:(NSMutableArray *) rank forCategory:(NSString *) category {
    if ([category isEqualToString:@"prices"]) {
        for (CompetitorProfile *cp in self.fetchedCompetitorData) {
            NSUInteger index = [rank indexOfObject:[[rank filteredArrayUsingPredicate:[NSPredicate predicateWithFormat: @"name = %@", [cp name]]] objectAtIndex:0]];
            cp.priceRank = [NSNumber numberWithUnsignedInteger:index+1];
        }
    }
    
    if ([category isEqualToString:@"customersat"]) {
        for (CompetitorProfile *cp in self.fetchedCompetitorData) {
            NSUInteger index = [rank indexOfObject:[[rank filteredArrayUsingPredicate:[NSPredicate predicateWithFormat: @"name = %@", [cp name]]] objectAtIndex:0]];
            cp.customerServiceRank = [NSNumber numberWithUnsignedInteger:index+1];
        }
    }
    
    if ([category isEqualToString:@"quality"]) {
        for (CompetitorProfile *cp in self.fetchedCompetitorData) {
            NSUInteger index = [rank indexOfObject:[[rank filteredArrayUsingPredicate:[NSPredicate predicateWithFormat: @"name = %@", [cp name]]] objectAtIndex:0]];
            cp.qualityRank = [NSNumber numberWithUnsignedInteger:index+1];
        }
    }
    
    if ([category isEqualToString:@"location"]) {
        for (CompetitorProfile *cp in self.fetchedCompetitorData) {
            NSUInteger index = [rank indexOfObject:[[rank filteredArrayUsingPredicate:[NSPredicate predicateWithFormat: @"name = %@", [cp name]]] objectAtIndex:0]];
            cp.locationRank = [NSNumber numberWithUnsignedInteger:index+1];
        }
    }
    
    if ([category isEqualToString:@"speed"]) {
        for (CompetitorProfile *cp in self.fetchedCompetitorData) {
            NSUInteger index = [rank indexOfObject:[[rank filteredArrayUsingPredicate:[NSPredicate predicateWithFormat: @"name = %@", [cp name]]] objectAtIndex:0]];
            cp.speedRank = [NSNumber numberWithUnsignedInteger:index+1];
        }
    }
}

@end