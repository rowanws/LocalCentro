//
//  SSRankValuePairsViewController.m
//  CENTRO
//
//  Created by Centro Community Partners.
//  Copyright (c) 2013 Centro Community Partners. All rights reserved.
//

#import "SSRankValuePairsViewController.h"
#import "Value.h"
#import "SSUser.h"

@interface SSRankValuePairsViewController ()

@property (strong, nonatomic) NSString *leftValueID;
@property (strong, nonatomic) NSString *rightValueID;
@property (strong, nonatomic) NSManagedObjectContext *context;
@property (strong, nonatomic) NSArray *fetchedObjects;

@property (strong, nonatomic) NSMutableArray *firstRound;
@property (strong, nonatomic) NSMutableArray *secondRound;
@property (strong, nonatomic) NSMutableArray *thirdRound;
@property (strong, nonatomic) NSMutableArray *winner;
@property (strong, nonatomic) NSMutableArray *ranked;


@property int position;
@property int round;

@end

@implementation SSRankValuePairsViewController

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
    
//   UIImage *bg40 = [UIImage imageNamed:@"bg-568h@2x.png"];
//   UIImage *bg35R = [UIImage imageNamed:@"bg.png"];
    
//    CGRect screenBounds = [[UIScreen mainScreen] bounds];
//    if (screenBounds.size.height == 505) {
//        self.backgroundImageView.image = bg40;
//    } else {
//        self.backgroundImageView.image = bg35R;
//    }
    
    self.questionLabel.text = @"Which value is MORE important to you? (choose one)";
    
    self.context = [(id)[[UIApplication sharedApplication] delegate] managedObjectContext];
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Value"
                                              inManagedObjectContext:self.context];
    [fetchRequest setEntity:entity];
    
    [fetchRequest setPredicate:[NSPredicate predicateWithFormat:@"rank != %@", @"-100"]];
    
    NSError *error;
    self.fetchedObjects = [self.context executeFetchRequest:fetchRequest error:&error];
    
    if (self.fetchedObjects.count == 0) {
        
    } else {
        
    }
    
    self.navigationItem.title = @"Play";
    
    UIBarButtonItem *nextScreenBackButton = [[UIBarButtonItem alloc] initWithTitle:@"Try Again" style:UIBarButtonItemStyleBordered target:self action:nil];
    self.navigationItem.backBarButtonItem = nextScreenBackButton;
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}


- (void) viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    if(![[SSUser currentUser] isLoggedIn]) {
        [self.navigationController popToRootViewControllerAnimated:YES];
    }
    
    self.firstRound = [[NSMutableArray alloc] init];
    self.secondRound = [[NSMutableArray alloc] init];
    self.thirdRound = [[NSMutableArray alloc] init];
    self.winner = [[NSMutableArray alloc] init];
    self.ranked = [[NSMutableArray alloc] init];
    
    self.position = 0;
    
    self.firstRound = [self.fetchedObjects mutableCopy];
    
    [self.leftValueButton setTitle:[(Value *) [self.fetchedObjects objectAtIndex:self.position] valueLiteralUS] forState:UIControlStateNormal];
    [self.rightValueButton setTitle:[(Value *) [self.fetchedObjects objectAtIndex:self.position+1] valueLiteralUS] forState:UIControlStateNormal];
    
    self.round = 1;
}


- (IBAction) leftButtonPressed:(id)sender {
    [self winningTeamIsHome:YES];
}

- (IBAction) rightButtonPressed:(id)sender {
    [self winningTeamIsHome:NO];
}

- (void) winningTeamIsHome:(BOOL) home {
    
    Value *tempWinner;
    Value *tempLoser;
    
    if(self.round == 1) {
        
        if(home) {
            tempWinner = (Value *) [self.fetchedObjects objectAtIndex:self.position];
            tempLoser = (Value *) [self.fetchedObjects objectAtIndex:self.position+1];
        } else {
            tempWinner = (Value *) [self.fetchedObjects objectAtIndex:self.position+1];
            tempLoser = (Value *) [self.fetchedObjects objectAtIndex:self.position];
        }
        
        tempWinner.rank = [NSNumber numberWithInt:self.round];
        tempLoser.rank = [NSNumber numberWithInt:self.round-1];
        tempLoser.selectedOver = [tempWinner valueCode];
        [self.secondRound addObject:tempWinner];
        
        self.position = self.position + 2;
        if(self.position >=8){
            self.round = 2;
            self.position = 0;
            [self.leftValueButton setTitle:[(Value *) [self.secondRound objectAtIndex:self.position] valueLiteralUS] forState:UIControlStateNormal];
            [self.rightValueButton setTitle:[(Value *) [self.secondRound objectAtIndex:self.position+1] valueLiteralUS] forState:UIControlStateNormal];
        }
        else{
            [self.leftValueButton setTitle:[(Value *) [self.fetchedObjects objectAtIndex:self.position] valueLiteralUS] forState:UIControlStateNormal];
            [self.rightValueButton setTitle:[(Value *) [self.fetchedObjects objectAtIndex:self.position+1] valueLiteralUS] forState:UIControlStateNormal];
        }
        
    } else if (self.round == 2) {
        if(home) {
            tempWinner = (Value *) [self.secondRound objectAtIndex:self.position];
            tempLoser = (Value *) [self.secondRound objectAtIndex:self.position+1];
        } else {
            tempWinner = (Value *) [self.secondRound objectAtIndex:self.position+1];
            tempLoser = (Value *) [self.secondRound objectAtIndex:self.position];
        }
        
        tempWinner.rank = [NSNumber numberWithInt:self.round];
        tempLoser.rank = [NSNumber numberWithInt:self.round-1];
        tempLoser.selectedOver = [tempWinner valueCode];
        [self.thirdRound addObject:tempWinner];
        
        self.position = self.position + 2;
        if(self.position >=4){
            self.round = 3;
            self.position = 0;
            [self.leftValueButton setTitle:[(Value *) [self.thirdRound objectAtIndex:self.position] valueLiteralUS] forState:UIControlStateNormal];
            [self.rightValueButton setTitle:[(Value *) [self.thirdRound objectAtIndex:self.position+1] valueLiteralUS] forState:UIControlStateNormal];
        }
        else{
            [self.leftValueButton setTitle:[(Value *) [self.secondRound objectAtIndex:self.position] valueLiteralUS] forState:UIControlStateNormal];
            [self.rightValueButton setTitle:[(Value *) [self.secondRound objectAtIndex:self.position+1] valueLiteralUS] forState:UIControlStateNormal];
        }
    } else if (self.round == 3) {
        
        if(home) {
            tempWinner = (Value *) [self.thirdRound objectAtIndex:self.position];
            tempLoser = (Value *) [self.thirdRound objectAtIndex:self.position+1];
        } else {
            tempWinner = (Value *) [self.thirdRound objectAtIndex:self.position+1];
            tempLoser = (Value *) [self.thirdRound objectAtIndex:self.position];
        }
        
        tempWinner.rank = [NSNumber numberWithInt:self.round];
        tempLoser.rank = [NSNumber numberWithInt:self.round-1];
        tempLoser.selectedOver = [tempWinner valueCode];
        [self.winner addObject:tempWinner];
        
        self.position = self.position + 2;
        if(self.position >=2){
            self.round = -1;
            self.position = 0;
            [self generateRank];
        }
        else{
            [self.leftValueButton setTitle:[(Value *) [self.thirdRound objectAtIndex:self.position] valueLiteralUS] forState:UIControlStateNormal];
            [self.rightValueButton setTitle:[(Value *) [self.thirdRound objectAtIndex:self.position+1] valueLiteralUS] forState:UIControlStateNormal];
        }
    }
    else{
        
    }
}

- (void) generateRank {
    
    for (NSInteger i = 0; i < 8; ++i)
    {
        [self.ranked addObject:[NSNull null]];
    }
    
    [self.ranked replaceObjectAtIndex:0 withObject:[self.winner lastObject]];
    
    
    for(Value *v in self.thirdRound) {
        if([[v rank] isEqualToNumber:[NSNumber numberWithInt: 2]]){
            [self.ranked replaceObjectAtIndex:1 withObject:v];
        }
    }
    
    for(Value *v in self.secondRound) {
        if([[v rank] isEqualToNumber:[NSNumber numberWithInt: 1]] && [[v selectedOver] isEqualToString:[[self.ranked objectAtIndex:0] valueCode]] ){
            [self.ranked replaceObjectAtIndex:2 withObject:v];
        }
        if([[v rank] isEqualToNumber:[NSNumber numberWithInt: 1]] && [[v selectedOver] isEqualToString:[[self.ranked objectAtIndex:1] valueCode]] ){
            [self.ranked replaceObjectAtIndex:3 withObject:v];
        }
    }
    
    for(Value *v in self.firstRound) {
        
        if([[v rank] isEqualToNumber:[NSNumber numberWithInt: 0]] && [[v selectedOver] isEqualToString:[[self.ranked objectAtIndex:0] valueCode]] ){
            [self.ranked replaceObjectAtIndex:4 withObject:v];
        }
        if([[v rank] isEqualToNumber:[NSNumber numberWithInt: 0]] && [[v selectedOver] isEqualToString:[[self.ranked objectAtIndex:1] valueCode]] ){
            [self.ranked replaceObjectAtIndex:5 withObject:v];
        }
        if([[v rank] isEqualToNumber:[NSNumber numberWithInt: 0]] && [[v selectedOver] isEqualToString:[[self.ranked objectAtIndex:2] valueCode]] ){
            [self.ranked replaceObjectAtIndex:6 withObject:v];
        }
        if([[v rank] isEqualToNumber:[NSNumber numberWithInt: 0]] && [[v selectedOver] isEqualToString:[[self.ranked objectAtIndex:3] valueCode]] ){
            [self.ranked replaceObjectAtIndex:7 withObject:v];
        }
        
    }
    
    for (int i = 0; i < self.ranked.count; i++) {
        Value *tempValue = (Value *) [self.ranked objectAtIndex:i];
        NSString *code = [tempValue valueCode];
        int newRank = i + 1;
        for (int j = 0; j < self.fetchedObjects.count; j++) {
            if ([[(Value *)[self.fetchedObjects objectAtIndex:j] valueCode] isEqualToString:code]) {
                [(Value *)[self.fetchedObjects objectAtIndex:j] setRank:[NSNumber numberWithInt:newRank]];
                [(Value *)[self.fetchedObjects objectAtIndex:j] setSelectedOver:@""];
                break;
            }
        }
    }
    
    NSError *error;
    if (![self.context save:&error]) {
        
    } else {
        
        [self performSegueWithIdentifier:@"ConfirmEditPersonalValues" sender:self];
    }
}

-(void) dealloc {
    self.leftValueID = nil;
    self.rightValueID = nil;
    self.context = nil;
    self.fetchedObjects = nil;
    
    self.firstRound = nil;
    self.secondRound = nil;
    self.thirdRound = nil;
    self.winner = nil;
    self.ranked = nil;
}


@end
