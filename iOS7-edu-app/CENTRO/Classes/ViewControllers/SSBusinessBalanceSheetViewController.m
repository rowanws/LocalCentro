//
//  SSBusinessBalanceSheetViewController.m
//  CENTRO
//
//  Created by Centro Community Partners.
//  Copyright (c) 2013 Centro Community Partners. All rights reserved.
//

#import "SSBusinessBalanceSheetViewController.h"
#import "SSUser.h"
#import "CompanyAsset.h"
#import "CompanyDebt.h"
#import "SSUtils.h"

@interface SSBusinessBalanceSheetViewController ()

@property (strong, nonatomic) NSManagedObjectContext *context;
@property double assetAmount;
@property double liabilitiesAmount;
@property double netWorthAmount;

@end

@implementation SSBusinessBalanceSheetViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {

    }
    return self;
}

- (void) viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    if(![[SSUser currentUser] isLoggedIn]) {
        [self.navigationController popToRootViewControllerAnimated:YES];
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
    
    self.assetAmount = 0.0;
    self.liabilitiesAmount = 0.0;
    self.netWorthAmount = 0.0;
    
    self.navigationItem.title = @"Bus. Balance Sheet";
    
    self.personalSheetLabel.text = [NSString stringWithFormat:@"Congrats! Here is %@'s balance sheet.", [SSUtils companyName]];
    self.assetsTextView.text = [NSString stringWithFormat:@"Assets:\nUS$ %@", [self calculateAssetsAmount]];
    self.liabilitiesTextView.text = [NSString stringWithFormat:@"Liabilities:\nUS$ %@", [self calculateLiabilitiesAmount]];
    
    NSString *netWorth = [NSString stringWithFormat:@"Net Worth:\nUS$ %@", [self calculateNetWorthAmount]];
    
    NSRange range = [netWorth rangeOfString:@"-"];
    if (range.length > 0){
        [self.netWorthTextView setTextColor:[UIColor redColor]];
        
    }
        
    self.netWorthTextView.text = netWorth;
    
    
    [[SSUser currentUser] setActivityNumberAsCompleted:@"32" andSyncStatus:NO];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

-(NSString *) calculateAssetsAmount {
    
    NSString *amountString = @"";
    
    double amount = 0.0;
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"CompanyAsset"
                                              inManagedObjectContext:self.context];
    [fetchRequest setEntity:entity];
    
    [fetchRequest setPredicate:[NSPredicate predicateWithFormat:@"companyID = %@", [[SSUser currentUser] companyID]]];
        
    NSError *error;
    NSArray *fetchedObjects = [self.context executeFetchRequest:fetchRequest error:&error];
    if (fetchedObjects.count == 0) {
        amountString = @"0.00";
    } else {
        for (CompanyAsset *ca in fetchedObjects) {
            if ([ca.selectedAsAsset isEqualToNumber:[NSNumber numberWithBool:YES]]) {
                amount = amount + [ca.amount doubleValue];
            }
        }
    }
    
    self.assetAmount = amount;
    amountString = [NSString stringWithFormat:@"%.2f", amount];
    
    amountString = [amountString stringByReplacingOccurrencesOfString:@".00" withString:@""];
    
    return amountString;
}

-(NSString *) calculateLiabilitiesAmount {
    
    NSString *amountString = @"";
    
    double amount = 0.0;
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"CompanyDebt"
                                              inManagedObjectContext:self.context];
    [fetchRequest setEntity:entity];
    
    [fetchRequest setPredicate:[NSPredicate predicateWithFormat:@"companyID = %@", [[SSUser currentUser] companyID]]];
    
    NSError *error;
    NSArray *fetchedObjects = [self.context executeFetchRequest:fetchRequest error:&error];
    if (fetchedObjects.count == 0) {
        amountString = @"0.00";
    } else {
        for (CompanyDebt *cd in fetchedObjects) {
            if ([cd.selectedAsDebt isEqualToNumber:[NSNumber numberWithBool:YES]]) {
                amount = amount + [cd.amount doubleValue];
            }
        }
    }
    
    self.liabilitiesAmount = amount;
    amountString = [NSString stringWithFormat:@"%.2f", amount];
    
    amountString = [amountString stringByReplacingOccurrencesOfString:@".00" withString:@""];
    
    return amountString;
}

-(NSString *) calculateNetWorthAmount {

    double amount = self.assetAmount - self.liabilitiesAmount;
    
    self.netWorthAmount = amount;
    
    NSString *amountString = [NSString stringWithFormat:@"%.2f", amount];
    
    amountString = [amountString stringByReplacingOccurrencesOfString:@".00" withString:@""];
    
    return amountString;
}

@end