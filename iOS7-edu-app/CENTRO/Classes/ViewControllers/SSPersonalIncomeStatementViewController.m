//
//  SSPersonalIncomeStatementViewController.m
//  CENTRO
//
//  Created by Centro Community Partners.
//  Copyright (c) 2013 Centro Community Partners. All rights reserved.
//

#import "SSPersonalIncomeStatementViewController.h"
#import "SSUser.h"
#import "StudentIncome.h"
#import "StudentCost.h"

@interface SSPersonalIncomeStatementViewController ()

@property (strong, nonatomic) NSManagedObjectContext *context;
@property double incomeAmount;
@property double expensesAmount;
@property double netIncomeAmount;

@end

@implementation SSPersonalIncomeStatementViewController

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
    
    self.incomeAmount = 0.0;
    self.expensesAmount = 0.0;
    self.netIncomeAmount = 0.0;
    
    self.navigationItem.title = @"Per. Income Statement";
    
    self.personalStatementLabel.text = @"Congrats! Here is your personal monthly income statement.";
    self.totalIncomeTextView.text = [NSString stringWithFormat:@"Total Income:\nUS$ %@", [self calculateATotalIncomeAmount]];
    self.totalExpensesTextView.text = [NSString stringWithFormat:@"Total Expenses:\nUS$ %@", [self calculateTotalExpensesAmount]];
    
    NSString *netIncome = [NSString stringWithFormat:@"Net Income:\nUS$ %@", [self calculateNetIncomeAmount]];
    
    NSRange range = [netIncome rangeOfString:@"-"];
    if (range.length > 0){
        [self.netIncomeTextView setTextColor:[UIColor redColor]];
        
    }
        
    self.netIncomeTextView.text = netIncome;
    
    [[SSUser currentUser] setActivityNumberAsCompleted:@"8" andSyncStatus:NO];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

-(NSString *) calculateATotalIncomeAmount {
    
    NSString *amountString = @"";
    
    double amount = 0.0;
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"StudentIncome"
                                              inManagedObjectContext:self.context];
    [fetchRequest setEntity:entity];
    
    [fetchRequest setPredicate:[NSPredicate predicateWithFormat:@"studentID = %@", [[SSUser currentUser] studentID]]];
        
    NSError *error;
    NSArray *fetchedObjects = [self.context executeFetchRequest:fetchRequest error:&error];
    if (fetchedObjects.count == 0) {
        amountString = @"0.00";
    } else {
        for (StudentIncome *si in fetchedObjects) {
            if ([si.selectedAsSourceOfIncome isEqualToNumber:[NSNumber numberWithBool:YES]]) {
                double monthlyAmount = 0.0;
                
                if([[si frequency] isEqual:[NSNumber numberWithInt:1]]) {
                    monthlyAmount = [si.amount doubleValue] * 30;
                } else if([[si frequency] isEqual:[NSNumber numberWithInt:2]]) {
                    monthlyAmount = [si.amount doubleValue] * 4;
                } else if([[si frequency] isEqual:[NSNumber numberWithInt:4]]) {
                    monthlyAmount = [si.amount doubleValue] / 12;
                } else {
                    monthlyAmount = [si.amount doubleValue];
                }
                
                amount = amount + monthlyAmount;
            }
        }
    }
    
    self.incomeAmount = amount;
    amountString = [NSString stringWithFormat:@"%.2f", amount];
    
    amountString = [amountString stringByReplacingOccurrencesOfString:@".00" withString:@""];
    
    return amountString;
}

-(NSString *) calculateTotalExpensesAmount {
    
    NSString *amountString = @"";
    
    double amount = 0.0;
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"StudentCost"
                                              inManagedObjectContext:self.context];
    [fetchRequest setEntity:entity];
    
    [fetchRequest setPredicate:[NSPredicate predicateWithFormat:@"studentID = %@", [[SSUser currentUser] studentID]]];
    
    NSError *error;
    NSArray *fetchedObjects = [self.context executeFetchRequest:fetchRequest error:&error];
    if (fetchedObjects.count == 0) {
        amountString = @"0.00";
    } else {
        for (StudentCost *sc in fetchedObjects) {
            if ([sc.selectedAsIncurredCost isEqualToNumber:[NSNumber numberWithBool:YES]]) {
                double monthlyAmount = 0.0;

                if([[sc frequency] isEqual:[NSNumber numberWithInt:1]]) {
                    monthlyAmount = [sc.amount doubleValue] * 30;
                } else if([[sc frequency] isEqual:[NSNumber numberWithInt:2]]) {
                    monthlyAmount = [sc.amount doubleValue] * 4;
                } else if([[sc frequency] isEqual:[NSNumber numberWithInt:4]]) {
                    monthlyAmount = [sc.amount doubleValue] / 12;
                } else {
                    monthlyAmount = [sc.amount doubleValue];
                }
                
                amount = amount + monthlyAmount;
            }
        }
    }
    
    self.expensesAmount = amount;
    amountString = [NSString stringWithFormat:@"%.2f", amount];
    
    amountString = [amountString stringByReplacingOccurrencesOfString:@".00" withString:@""];
    
    return amountString;
}

-(NSString *) calculateNetIncomeAmount {

    double amount = self.incomeAmount - self.expensesAmount;
    
    self.netIncomeAmount = amount;
    
    NSString *amountString = [NSString stringWithFormat:@"%.2f", amount];
    
    amountString = [amountString stringByReplacingOccurrencesOfString:@".00" withString:@""];
    
    return amountString;
}

@end