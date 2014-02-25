//
//  SSBusinessIncomeStatementViewController.m
//  CENTRO
//
//  Created by Centro Community Partners.
//  Copyright (c) 2013 Centro Community Partners. All rights reserved.
//

#import "SSBusinessIncomeStatementViewController.h"
#import "SSUser.h"
#import "Product.h"
#import "CompanyCost.h"
#import "Category.h"
#import "Company.h"
#import "SSUtils.h"

@interface SSBusinessIncomeStatementViewController ()

@property (strong, nonatomic) NSManagedObjectContext *context;
@property double incomeAmount;
@property double expensesAmount;
@property double netIncomeAmount;

@end

@implementation SSBusinessIncomeStatementViewController

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
    
    self.navigationItem.title = @"Bus. Income Statement";
    
    self.personalStatementLabel.text = [NSString stringWithFormat:@"Congrats! Here is %@'s monthly income statement.", [SSUtils companyName]];
    self.totalIncomeTextView.text = [NSString stringWithFormat:@"Income:\n\n%@", [self calculateATotalIncomeAmount]];
    self.totalExpensesTextView.text = [NSString stringWithFormat:@"Total Expenses:\nUS$ %@", [self calculateTotalExpensesAmount]];
    
    NSString *netIncome = [NSString stringWithFormat:@"Net Income:\nUS$ %@", [self calculateNetIncomeAmount]];
    
    NSRange range = [netIncome rangeOfString:@"-"];
    if (range.length > 0){
        [self.netIncomeTextView setTextColor:[UIColor redColor]];
        
    }
        
    self.netIncomeTextView.text = netIncome;
    
    [[SSUser currentUser] setActivityNumberAsCompleted:@"29" andSyncStatus:NO];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

-(NSString *) calculateATotalIncomeAmount {
    
    NSString *amountString = @"";
    
    double amount = 0.0;
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Product"
                                              inManagedObjectContext:self.context];
    [fetchRequest setEntity:entity];
    
    [fetchRequest setPredicate:[NSPredicate predicateWithFormat:@"companyID = %@", [[SSUser currentUser] companyID]]];
    
    NSMutableDictionary *sumPerCategory = [[NSMutableDictionary alloc] initWithCapacity:4];
    
    NSError *error;
    NSArray *fetchedObjects = [self.context executeFetchRequest:fetchRequest error:&error];
    if (fetchedObjects.count == 0) {
        amountString = @"0.00";
    } else {
        for (Product *pro in fetchedObjects) {
            if ([pro.selectedAsProfitableItem isEqualToNumber:[NSNumber numberWithBool:YES]] && ![pro.name isEqualToString:@""]) {
                double monthlyAmount = 0.0;
                
                if([[pro profitFrequency] isEqual:[NSNumber numberWithInt:1]]) {
                    monthlyAmount = [pro.profitAmount doubleValue] * 30;
                } else if([[pro profitFrequency] isEqual:[NSNumber numberWithInt:2]]) {
                    monthlyAmount = [pro.profitAmount doubleValue] * 4;
                } else if([[pro profitFrequency] isEqual:[NSNumber numberWithInt:4]]) {
                    monthlyAmount = [pro.profitAmount doubleValue] / 12;
                } else {
                    monthlyAmount = [pro.profitAmount doubleValue];
                }
                
                amount = amount + monthlyAmount;
                
                if ([sumPerCategory objectForKey:[pro.categoryID stringValue]] == nil) {
                    [sumPerCategory setObject:[NSNumber numberWithDouble:monthlyAmount] forKey:[pro.categoryID stringValue]];
                } else {
                    double amount2 = [[sumPerCategory objectForKey:[pro.categoryID stringValue]] doubleValue];
                    amount2 = amount2 + monthlyAmount;
                    [sumPerCategory setObject:[NSNumber numberWithDouble:amount2] forKey:[pro.categoryID stringValue]];
                }
            }
        }
        
        NSArray *catIDs = [sumPerCategory allKeys];
        
        for(int i = 0; i < catIDs.count; i++) {
            NSString *catDes = [self categoryNameFromID:catIDs[i]];
            
            NSString *catAmount = [NSString stringWithFormat:@"%.2f", [[sumPerCategory objectForKey:catIDs[i]] doubleValue]];
            
            amountString = [NSString stringWithFormat:@"%@%@ US$ %@\n", amountString, catDes, catAmount];
            
        }
        
        Company *company;
        
        NSFetchRequest *companyFetchRequest = [[NSFetchRequest alloc] init];
        
        NSEntityDescription *companyEntity = [NSEntityDescription entityForName:@"Company"
                                                         inManagedObjectContext:self.context];
        [companyFetchRequest setEntity:companyEntity];
        
        [companyFetchRequest setPredicate:[NSPredicate predicateWithFormat:@"companyID = %@", [[SSUser currentUser] companyID]]];
        
        companyFetchRequest.returnsObjectsAsFaults = NO;
        
        NSError *errorC;
        NSArray *companyFetchedObjects = [self.context executeFetchRequest:companyFetchRequest error:&errorC];
        if (companyFetchedObjects == 0) {
            
            company = nil;
        } else {
            company = (Company *) [companyFetchedObjects objectAtIndex:0];
        }
        
        double monthlyAmount = 0.0;
        
        if([[company otherProfitFrequency] isEqual:[NSNumber numberWithInt:1]]) {
            monthlyAmount = [company.otherProfitAmount doubleValue] * 30;
        } else if([[company otherProfitFrequency] isEqual:[NSNumber numberWithInt:2]]) {
            monthlyAmount = [company.otherProfitAmount doubleValue] * 4;
        } else if([[company otherProfitFrequency] isEqual:[NSNumber numberWithInt:4]]) {
            monthlyAmount = [company.otherProfitAmount doubleValue] / 12;
        } else {
            monthlyAmount = [company.otherProfitAmount doubleValue];
        }
        
        NSString *otherAmount = [NSString stringWithFormat:@"US$ %.2f", monthlyAmount];
        
        amountString = [NSString stringWithFormat:@"%@Other US$ %@\n", amountString, otherAmount];
        
        amount = amount + monthlyAmount;
    }
    
    self.incomeAmount = amount;
    
    amountString = [NSString stringWithFormat:@"%@\nTotal: US$ %.2f", amountString, amount];
        
    amountString = [amountString stringByReplacingOccurrencesOfString:@".00" withString:@""];
    
    return amountString;
}

-(NSString *) calculateTotalExpensesAmount {
    
    NSString *amountString = @"";
    
    double amount = 0.0;
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"CompanyCost"
                                              inManagedObjectContext:self.context];
    [fetchRequest setEntity:entity];
    
    [fetchRequest setPredicate:[NSPredicate predicateWithFormat:@"companyID = %@", [[SSUser currentUser] companyID]]];
    
    NSError *error;
    NSArray *fetchedObjects = [self.context executeFetchRequest:fetchRequest error:&error];
    if (fetchedObjects.count == 0) {
        amountString = @"0.00";
    } else {
        for (CompanyCost *cc in fetchedObjects) {
            if ([cc.selectedAsIncurredCost isEqualToNumber:[NSNumber numberWithBool:YES]]) {
                double monthlyAmount = 0.0;

                if([[cc frequency] isEqual:[NSNumber numberWithInt:1]]) {
                    monthlyAmount = [cc.amount doubleValue] * 30;
                } else if([[cc frequency] isEqual:[NSNumber numberWithInt:2]]) {
                    monthlyAmount = [cc.amount doubleValue] * 4;
                } else if([[cc frequency] isEqual:[NSNumber numberWithInt:4]]) {
                    monthlyAmount = [cc.amount doubleValue] / 12;
                } else {
                    monthlyAmount = [cc.amount doubleValue];
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

-(NSString *) categoryNameFromID:(NSString *) identifier {
    
    NSString *catDes = @"";
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Category"
                                              inManagedObjectContext:self.context];
    [fetchRequest setEntity:entity];
    
    [fetchRequest setPredicate:[NSPredicate predicateWithFormat:@"categoryID = %@", identifier]];
    
    NSError *error;
    NSArray *fetchedObjects = [self.context executeFetchRequest:fetchRequest error:&error];
    if (fetchedObjects.count == 0) {
        catDes = @"";
    } else {
        catDes = [(Category *) [fetchedObjects objectAtIndex:0] name];
    }
    
    return catDes;
    
}

@end