//
//  SSBusinessIncomeStatementViewController.h
//  CENTRO
//
//  Created by Centro Community Partners.
//  Copyright (c) 2013 Centro Community Partners. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SSBusinessIncomeStatementViewController : UIViewController

@property (weak, nonatomic) IBOutlet UIImageView *backgroundImageView;
@property (weak, nonatomic) IBOutlet UILabel *personalStatementLabel;
@property (weak, nonatomic) IBOutlet UITextView *totalIncomeTextView;
@property (weak, nonatomic) IBOutlet UITextView *totalExpensesTextView;
@property (weak, nonatomic) IBOutlet UITextView *netIncomeTextView;

@end