//
//  SSRankBrandAttributePairsViewController.m
//  CENTRO
//
//  Created by Centro Community Partners.
//  Copyright (c) 2013 Centro Community Partners. All rights reserved.
//

#import "SSRankBrandAttributePairsViewController.h"
#import "Company.h"
#import "BrandAttribute.h"
#import "SSUser.h"
#import "SSUtils.h"

@interface SSRankBrandAttributePairsViewController ()

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

@implementation SSRankBrandAttributePairsViewController

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
    
    self.questionLabel.text = [NSString stringWithFormat:@"Which product/service characteristic is more important to %@'s customers?",[SSUtils companyName]];
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"BrandAttribute"
                                              inManagedObjectContext:self.context];
    [fetchRequest setEntity:entity];
    
    [fetchRequest setPredicate:[NSPredicate predicateWithFormat:@"brandValueRank != %@", @"-100"]];
    
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
    
    [self.leftValueButton setTitle:[(BrandAttribute *) [self.fetchedObjects objectAtIndex:self.position] brandValueLiteralUS] forState:UIControlStateNormal];
    [self.rightValueButton setTitle:[(BrandAttribute *) [self.fetchedObjects objectAtIndex:self.position+1] brandValueLiteralUS] forState:UIControlStateNormal];
    
    self.round = 1;
}


- (IBAction) leftButtonPressed:(id)sender {
    [self winningTeamIsHome:YES];
}

- (IBAction) rightButtonPressed:(id)sender {
    [self winningTeamIsHome:NO];
}

- (void) winningTeamIsHome:(BOOL) home {
    
    BrandAttribute *tempWinner;
    BrandAttribute *tempLoser;
    
    if(self.round == 1) {
        
        if(home) {
            tempWinner = (BrandAttribute *) [self.fetchedObjects objectAtIndex:self.position];
            tempLoser = (BrandAttribute *) [self.fetchedObjects objectAtIndex:self.position+1];
        } else {
            tempWinner = (BrandAttribute *) [self.fetchedObjects objectAtIndex:self.position+1];
            tempLoser = (BrandAttribute *) [self.fetchedObjects objectAtIndex:self.position];
        }
        
        tempWinner.brandValueRank = [NSNumber numberWithInt:self.round];
        tempLoser.brandValueRank = [NSNumber numberWithInt:self.round-1];
        tempLoser.selectedOverBrandValue = [tempWinner brandValueCode];
        [self.secondRound addObject:tempWinner];
        
        self.position = self.position + 2;
        if(self.position >=8){
            self.round = 2;
            self.position = 0;
            [self.leftValueButton setTitle:[(BrandAttribute *) [self.secondRound objectAtIndex:self.position] brandValueLiteralUS] forState:UIControlStateNormal];
            [self.rightValueButton setTitle:[(BrandAttribute *) [self.secondRound objectAtIndex:self.position+1] brandValueLiteralUS] forState:UIControlStateNormal];
        }
        else{
            [self.leftValueButton setTitle:[(BrandAttribute *) [self.fetchedObjects objectAtIndex:self.position] brandValueLiteralUS] forState:UIControlStateNormal];
            [self.rightValueButton setTitle:[(BrandAttribute *) [self.fetchedObjects objectAtIndex:self.position+1] brandValueLiteralUS] forState:UIControlStateNormal];
        }
        
    } else if (self.round == 2) {
        if(home) {
            tempWinner = (BrandAttribute *) [self.secondRound objectAtIndex:self.position];
            tempLoser = (BrandAttribute *) [self.secondRound objectAtIndex:self.position+1];
        } else {
            tempWinner = (BrandAttribute *) [self.secondRound objectAtIndex:self.position+1];
            tempLoser = (BrandAttribute *) [self.secondRound objectAtIndex:self.position];
        }
        
        tempWinner.brandValueRank = [NSNumber numberWithInt:self.round];
        tempLoser.brandValueRank = [NSNumber numberWithInt:self.round-1];
        tempLoser.selectedOverBrandValue = [tempWinner brandValueCode];
        [self.thirdRound addObject:tempWinner];
        
        self.position = self.position + 2;
        if(self.position >=4){
            self.round = 3;
            self.position = 0;
            [self.leftValueButton setTitle:[(BrandAttribute *) [self.thirdRound objectAtIndex:self.position] brandValueLiteralUS] forState:UIControlStateNormal];
            [self.rightValueButton setTitle:[(BrandAttribute *) [self.thirdRound objectAtIndex:self.position+1] brandValueLiteralUS] forState:UIControlStateNormal];
        }
        else{
            [self.leftValueButton setTitle:[(BrandAttribute *) [self.secondRound objectAtIndex:self.position] brandValueLiteralUS] forState:UIControlStateNormal];
            [self.rightValueButton setTitle:[(BrandAttribute *) [self.secondRound objectAtIndex:self.position+1] brandValueLiteralUS] forState:UIControlStateNormal];
        }
    } else if (self.round == 3) {
        if(home) {
            tempWinner = (BrandAttribute *) [self.thirdRound objectAtIndex:self.position];
            tempLoser = (BrandAttribute *) [self.thirdRound objectAtIndex:self.position+1];
        } else {
            tempWinner = (BrandAttribute *) [self.thirdRound objectAtIndex:self.position+1];
            tempLoser = (BrandAttribute *) [self.thirdRound objectAtIndex:self.position];
        }
        
        tempWinner.brandValueRank = [NSNumber numberWithInt:self.round];
        tempLoser.brandValueRank = [NSNumber numberWithInt:self.round-1];
        tempLoser.selectedOverBrandValue = [tempWinner brandValueCode];
        [self.winner addObject:tempWinner];
        
        self.position = self.position + 2;
        if(self.position >=2){
            self.round = -1;
            self.position = 0;
            [self generateRank];
        }
        else{
            [self.leftValueButton setTitle:[(BrandAttribute *) [self.thirdRound objectAtIndex:self.position] brandValueLiteralUS] forState:UIControlStateNormal];
            [self.rightValueButton setTitle:[(BrandAttribute *) [self.thirdRound objectAtIndex:self.position+1] brandValueLiteralUS] forState:UIControlStateNormal];
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
    
    
    for(BrandAttribute *v in self.thirdRound) {
        if([[v brandValueRank] isEqualToNumber:[NSNumber numberWithInt: 2]]){
            [self.ranked replaceObjectAtIndex:1 withObject:v];
        }
    }
    
    for(BrandAttribute *v in self.secondRound) {
        if([[v brandValueRank] isEqualToNumber:[NSNumber numberWithInt: 1]] && [[v selectedOverBrandValue] isEqualToString:[[self.ranked objectAtIndex:0] brandValueCode]] ){
            [self.ranked replaceObjectAtIndex:2 withObject:v];
        }
        if([[v brandValueRank] isEqualToNumber:[NSNumber numberWithInt: 1]] && [[v selectedOverBrandValue] isEqualToString:[[self.ranked objectAtIndex:1] brandValueCode]] ){
            [self.ranked replaceObjectAtIndex:3 withObject:v];
        }
    }
    
    for(BrandAttribute *v in self.firstRound) {
        
        if([[v brandValueRank] isEqualToNumber:[NSNumber numberWithInt: 0]] && [[v selectedOverBrandValue] isEqualToString:[[self.ranked objectAtIndex:0] brandValueCode]] ){
            [self.ranked replaceObjectAtIndex:4 withObject:v];
        }
        if([[v brandValueRank] isEqualToNumber:[NSNumber numberWithInt: 0]] && [[v selectedOverBrandValue] isEqualToString:[[self.ranked objectAtIndex:1] brandValueCode]] ){
            [self.ranked replaceObjectAtIndex:5 withObject:v];
        }
        if([[v brandValueRank] isEqualToNumber:[NSNumber numberWithInt: 0]] && [[v selectedOverBrandValue] isEqualToString:[[self.ranked objectAtIndex:2] brandValueCode]] ){
            [self.ranked replaceObjectAtIndex:6 withObject:v];
        }
        if([[v brandValueRank] isEqualToNumber:[NSNumber numberWithInt: 0]] && [[v selectedOverBrandValue] isEqualToString:[[self.ranked objectAtIndex:3] brandValueCode]] ){
            [self.ranked replaceObjectAtIndex:7 withObject:v];
        }
        
    }
    
    for (int i = 0; i < self.ranked.count; i++) {
        BrandAttribute *tempValue = (BrandAttribute *) [self.ranked objectAtIndex:i];
        NSString *code = [tempValue brandValueCode];
        int newRank = i + 1;
        for (int j = 0; j < self.fetchedObjects.count; j++) {
            if ([[(BrandAttribute *)[self.fetchedObjects objectAtIndex:j] brandValueCode] isEqualToString:code]) {
                [(BrandAttribute *)[self.fetchedObjects objectAtIndex:j] setBrandValueRank:[NSNumber numberWithInt:newRank]];
                [(BrandAttribute *)[self.fetchedObjects objectAtIndex:j] setSelectedOverBrandValue:@""];
                break;
            }
        }
    }
    
    NSError *error;
    if (![self.context save:&error]) {

    } else {
        [self performSegueWithIdentifier:@"ConfirmEditBrandAttributes" sender:self];
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