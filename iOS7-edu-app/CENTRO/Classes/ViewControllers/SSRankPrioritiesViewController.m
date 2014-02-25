//
//  SSRankPrioritiesViewController.m
//  CENTRO
//
//  Created by Centro Community Partners.
//  Copyright (c) 2013 Centro Community Partners. All rights reserved.
//

#import "SSRankPrioritiesViewController.h"
#import "SSUser.h"
#import "CustomerPriority.h"
#import "SSUtils.h"

@interface SSRankPrioritiesViewController ()

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

@implementation SSRankPrioritiesViewController

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
    
    self.context = [(id)[[UIApplication sharedApplication] delegate] managedObjectContext];
    
    [self competitorQuestions];
}

-(void) viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    if(![[SSUser currentUser] isLoggedIn]) {
        [self.navigationController popToRootViewControllerAnimated:YES];
    } else {
        NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
        
        NSEntityDescription *entity = [NSEntityDescription entityForName:@"CustomerPriority"
                                                  inManagedObjectContext:self.context];
        [fetchRequest setEntity:entity];
        
        [fetchRequest setPredicate:[NSPredicate predicateWithFormat:@"customerProfileID = %@", [[SSUser currentUser] companyID]]];
        
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
    
    CustomerPriority *p1 = (CustomerPriority *) [[[[self.rounds objectAtIndex:self.position] objectAtIndex:0] objectAtIndex:self.position] objectAtIndex:0];
    CustomerPriority *p2 = (CustomerPriority *) [[[[self.rounds objectAtIndex:self.position] objectAtIndex:0] objectAtIndex:self.position+1] objectAtIndex:0];
    
    [self.rightButton setTitle:p2.priorityLiteralUS forState:UIControlStateNormal];
    [self.leftButton setTitle:p1.priorityLiteralUS forState:UIControlStateNormal];
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
            
            CustomerPriority *p1 = (CustomerPriority *) [[[[self.rounds objectAtIndex:self.round] objectAtIndex:0] objectAtIndex:self.position] objectAtIndex:0];
            CustomerPriority *p2 = (CustomerPriority *) [[[[self.rounds objectAtIndex:self.round] objectAtIndex:0]  objectAtIndex:self.position+1] objectAtIndex:0];
            
            [self.rightButton setTitle:p2.priorityLiteralUS forState:UIControlStateNormal];
            [self.leftButton setTitle:p1.priorityLiteralUS forState:UIControlStateNormal];
        }
        else{
            int old_pos = self.position;
            self.position = 0;
            self.round = self.round + 1;
            
            [[[self.rounds objectAtIndex:self.round] objectAtIndex:0] addObject:[[[self.rounds objectAtIndex:self.round-1] objectAtIndex:0] objectAtIndex:old_pos] ];
            
            CustomerPriority *p1 = (CustomerPriority *) [[[[self.rounds objectAtIndex:self.round] objectAtIndex:0] objectAtIndex:self.position] objectAtIndex:0];
            CustomerPriority *p2 = (CustomerPriority *) [[[[self.rounds objectAtIndex:self.round] objectAtIndex:0]  objectAtIndex:self.position+1] objectAtIndex:0];
            
            [self.rightButton setTitle:p2.priorityLiteralUS forState:UIControlStateNormal];
            [self.leftButton setTitle:p1.priorityLiteralUS forState:UIControlStateNormal];
            
            
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
                [self saveRank:rank];
                [self.context save:nil];
                [self performSegueWithIdentifier:@"EditConfirmPriorities" sender:self];
            }
        }
        else{
            
    		CustomerPriority *p1 = (CustomerPriority *) [[[[self.rounds objectAtIndex:self.round] objectAtIndex:0] objectAtIndex:self.position] objectAtIndex:0];
        	CustomerPriority *p2 = (CustomerPriority *) [[[[self.rounds objectAtIndex:self.round] objectAtIndex:0]  objectAtIndex:self.position+1] objectAtIndex:0];
            
            [self.rightButton setTitle:p2.priorityLiteralUS forState:UIControlStateNormal];
            [self.leftButton setTitle:p1.priorityLiteralUS forState:UIControlStateNormal];
        }
    }
}

-(void) competitorQuestions {

    self.questions = [NSArray arrayWithObjects:[NSString stringWithFormat:@"Which is more important to %@'s customers?", [SSUtils companyName]], nil];
    
}

-(void) saveRank:(NSMutableArray *) rank {
    for (CustomerPriority *cp in self.fetchedCompetitorData) {
        NSUInteger index = [rank indexOfObject:[[rank filteredArrayUsingPredicate:[NSPredicate predicateWithFormat: @"priorityLiteralUS = %@", [cp priorityLiteralUS]]] objectAtIndex:0]];
        cp.rank = [NSNumber numberWithUnsignedInteger:index+1];
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

@end