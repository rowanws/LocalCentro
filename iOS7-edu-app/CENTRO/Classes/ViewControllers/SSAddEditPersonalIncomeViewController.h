//
//  SSAddEditPersonalIncomeViewController.h
//  CENTRO
//
//  Created by Centro Community Partners.
//  Copyright (c) 2013 Centro Community Partners. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "StudentIncome.h"

@interface SSAddEditPersonalIncomeViewController : UIViewController

@property (weak, nonatomic) IBOutlet UIImageView *backgroundImageView;
@property (weak, nonatomic) IBOutlet UILabel *editItemLabel;
@property (weak, nonatomic) IBOutlet UITextField *editAmountTextField;
@property (weak, nonatomic) IBOutlet UILabel *editFrequencyLabel;
@property (weak, nonatomic) IBOutlet UISegmentedControl *editFrequencySegmentedControl;
@property (weak, nonatomic) IBOutlet UIButton *editIsSureButton;

@property BOOL editingExistingIncome;
@property (strong, nonatomic) StudentIncome *studentIncome;

@end