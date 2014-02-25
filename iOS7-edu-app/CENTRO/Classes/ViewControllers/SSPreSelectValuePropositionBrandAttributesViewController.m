//
//  SSPreSelectValuePropositionBrandAttributesViewController.m
//  CENTRO
//
//  Created by Centro Community Partners.
//  Copyright (c) 2013 Centro Community Partners. All rights reserved.
//

#import "SSPreSelectValuePropositionBrandAttributesViewController.h"
#import "SSUser.h"
#import "Company.h"
#import "BrandAttribute.h"
#import "ValueProposition.h"
#import "CustomerPriority.h"

@interface SSPreSelectValuePropositionBrandAttributesViewController ()

@property (strong, nonatomic) NSManagedObjectContext *context;
@property (strong, nonatomic) NSString *personalValue;
@property (strong, nonatomic) Company *company;
@property (strong, nonatomic) NSArray *brandAttributesFetchedObjects;
@property int currentValuePos;
@property int veryMuch;

@end

@implementation SSPreSelectValuePropositionBrandAttributesViewController

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
    
    UIImage *bg40 = [UIImage imageNamed:@"bg-568h@2x.png"];
    UIImage *bg35R = [UIImage imageNamed:@"bg.png"];
    
    CGRect screenBounds = [[UIScreen mainScreen] bounds];
    if (screenBounds.size.height == 568) {
        self.backgroundImageView.image = bg40;
    } else {
        self.backgroundImageView.image = bg35R;
    }
    
    self.context = [(id)[[UIApplication sharedApplication] delegate] managedObjectContext];
    
    self.navigationItem.title = @"Brand Attributes";
    
    self.questionLabel.text = @"Does your value proposition reflect this brand attribute?";
    
    self.attributeLabel.text = @"";
    
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

    
    UIBarButtonItem *nextScreenBackButton = [[UIBarButtonItem alloc] initWithTitle:@"Try Again" style:UIBarButtonItemStyleBordered target:self action:nil];
    self.navigationItem.backBarButtonItem = nextScreenBackButton;
    
    self.valuePropositionTextView.text = [NSString stringWithFormat:@"Value Proposition:\n\n%@", [self valuePropositionText]];
    
}

-(void) viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    if(![[SSUser currentUser] isLoggedIn]) {
        [self.navigationController popToRootViewControllerAnimated:YES];
    }
}

-(void) viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    self.currentValuePos = 0;
    self.veryMuch = 0;
        
    NSFetchRequest *studentValuesFetchRequest = [[NSFetchRequest alloc] init];
    
    NSEntityDescription *studentValuesEntity = [NSEntityDescription entityForName:@"BrandAttribute"
                                                           inManagedObjectContext:self.context];
    [studentValuesFetchRequest setEntity:studentValuesEntity];
    
    [studentValuesFetchRequest setPredicate:[NSPredicate predicateWithFormat:@"companyID = %@ AND brandValueRank > 0", [[SSUser currentUser] companyID]]];
    
    studentValuesFetchRequest.sortDescriptors = [NSArray arrayWithObject:[NSSortDescriptor sortDescriptorWithKey:@"brandValueRank" ascending:YES selector:nil]];
    
    NSError *errorSV;
    self.brandAttributesFetchedObjects = [self.context executeFetchRequest:studentValuesFetchRequest error:&errorSV];
    
    if (self.brandAttributesFetchedObjects.count == 0) {
        
        
        self.veryMuchButton.enabled = NO;
        self.aLittleButton.enabled = NO;
        self.notAtAllButton.enabled = NO;
        
        self.questionLabel.text = @"Error!";
        self.attributeLabel.text = @"";
    } else {
        for(BrandAttribute *brandAttribute in self.brandAttributesFetchedObjects) {
            if([brandAttribute selectedAsBrandValueProposition]){
                [brandAttribute setSelectedAsBrandValueProposition:[NSNumber numberWithBool:NO]];
                [brandAttribute setBrandValuePropositionRank:[NSNumber numberWithInt:-100]];
            }
        }
        self.attributeLabel.text = [(BrandAttribute *) [self.brandAttributesFetchedObjects objectAtIndex:self.currentValuePos] brandValueLiteralUS];
        self.veryMuchButton.enabled = YES;
        self.aLittleButton.enabled = YES;
        self.notAtAllButton.enabled = YES;
    }
}

-(NSString *) valuePropositionText {
    
    NSString *vpt = @"";
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"ValueProposition"
                                              inManagedObjectContext:self.context];
    [fetchRequest setEntity:entity];
    
    fetchRequest.returnsObjectsAsFaults = NO;
    
    [fetchRequest setPredicate:[NSPredicate predicateWithFormat:@"companyID = %@ AND isCompetitor = 0", [[SSUser currentUser] companyID]]];
    
    NSMutableArray *solidVP = [[NSMutableArray alloc] init];
    NSMutableArray *weakVP = [[NSMutableArray alloc] init];
    
    NSError *error;
    NSArray *fetchedObjects = [self.context executeFetchRequest:fetchRequest error:&error];
    if (fetchedObjects.count == 0) {
        
    } else {
        ValueProposition *valueProposition = (ValueProposition *) [fetchedObjects objectAtIndex:0];
        
        if([[valueProposition priceRank] intValue] == 1) {
            [solidVP addObject:@"Excellent prices."];
        } else if([[valueProposition priceRank] intValue] == 2) {
            [solidVP addObject:@"Good prices."];
        } else {
            
        }
        
        if([[valueProposition customerServiceRank] intValue] == 1) {
            [solidVP addObject:@"Excellent customer service."];
        } else if([[valueProposition customerServiceRank] intValue] == 2) {
            [solidVP addObject:@"Good customer service."];
        } else {
            
        }
        
        if([[valueProposition qualityRank] intValue] == 1) {
            [solidVP addObject:@"Excellent quality."];
        } else if([[valueProposition qualityRank] intValue] == 2) {
            [solidVP addObject:@"Good quality."];
        } else {
            
        }
        
        if([[valueProposition speedRank] intValue] == 1) {
            [solidVP addObject:@"Excellent speed."];
        } else if([[valueProposition speedRank] intValue] == 2) {
            [solidVP addObject:@"Good speed."];
        } else {
            
        }
        
        if([[valueProposition locationRank] intValue] == 1) {
            [solidVP addObject:@"Excellent location."];
        } else if([[valueProposition locationRank] intValue] == 2) {
            [solidVP addObject:@"Good location."];
        } else {
            
        }
        
        if (solidVP.count >= 1) {
            for (NSString *str in solidVP) {
                vpt = [NSString stringWithFormat:@"%@%@\n", vpt, str];
            }
        } else {

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
                        [weakVP addObject:@"Lower prices."];
                    } else if([[fetchedObjectsWVP[i] priorityCode] isEqualToString:@"PRI_CUSE"]) {
                        [weakVP addObject:@"Improve customer service."];
                    } else if([[fetchedObjectsWVP[i] priorityCode] isEqualToString:@"PRI_QUAL"]) {
                        [weakVP addObject:@"Improve quality."];
                    } else if([[fetchedObjectsWVP[i] priorityCode] isEqualToString:@"PRI_SPEE"]) {
                        [weakVP addObject:@"Provide faster service."];
                    } else if([[fetchedObjectsWVP[i] priorityCode] isEqualToString:@"PRI_LOCA"]) {
                        [weakVP addObject:@"Find a better location."];
                    } else {
                        
                    }
                }
            }
            
            for (NSString *str in weakVP) {
                vpt = [NSString stringWithFormat:@"%@%@\n", vpt, str];
            }

        }
    }
    
    return vpt;
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

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (IBAction)notAtAllButtonPressed:(id)sender {
    self.currentValuePos++;
    [[self.brandAttributesFetchedObjects objectAtIndex:self.currentValuePos-1] setBrandValuePropositionRank:[NSNumber numberWithInt:-100]];
    [[self.brandAttributesFetchedObjects objectAtIndex:self.currentValuePos-1] setSelectedAsBrandValueProposition:[NSNumber numberWithBool:NO]];
    [self continueAsking];
}

- (IBAction)aLittleButtonPressed:(id)sender {
    self.currentValuePos++;
    [[self.brandAttributesFetchedObjects objectAtIndex:self.currentValuePos-1] setBrandValuePropositionRank:[NSNumber numberWithInt:-100]];
    [[self.brandAttributesFetchedObjects objectAtIndex:self.currentValuePos-1] setSelectedAsBrandValueProposition:[NSNumber numberWithBool:NO]];
    [self continueAsking];
    
}

- (IBAction)veryMuchButtonPressed:(id)sender {
    self.currentValuePos++;
    [self saveAnswerAndContinue];
}

-(void) saveAnswerAndContinue {
    [[self.brandAttributesFetchedObjects objectAtIndex:self.currentValuePos-1] setSelectedAsBrandValueProposition:[NSNumber numberWithBool:YES]];
    self.veryMuch++;
        [[self.brandAttributesFetchedObjects objectAtIndex:self.currentValuePos-1] setBrandValuePropositionRank:[NSNumber numberWithInt:self.veryMuch]];
    [self continueAsking];
}

-(void) continueAsking {
    if(self.currentValuePos < 8 && self.veryMuch < 5) {
        self.attributeLabel.text = [(BrandAttribute *) [self.brandAttributesFetchedObjects objectAtIndex:self.currentValuePos] brandValueLiteralUS];
    } else {
        [self.context save:nil];
        [self performSegueWithIdentifier:@"ConfirmEditValuePropositionBrandAttributes" sender:self];
    }
}

@end