//
//  SSAddEditPersonalCostViewController.h
//  CENTRO
//
//  Created by Centro Community Partners.
//  Copyright (c) 2013 Centro Community Partners. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "StudentCost.h"

@interface SSAddEditPersonalCostViewController : UIViewController

@property (weak, nonatomic) IBOutlet UIImageView *backgroundImageView;
@property (weak, nonatomic) IBOutlet UILabel *editItemLabel;
@property (weak, nonatomic) IBOutlet UITextField *editAmountTextField;
@property (weak, nonatomic) IBOutlet UILabel *editFrequencyLabel;
@property (weak, nonatomic) IBOutlet UISegmentedControl *editFrequencySegmentedControl;
@property (weak, nonatomic) IBOutlet UIButton *editIsSureButton;

@property BOOL editingExistingCost;
@property (strong, nonatomic) StudentCost *studentCost;

@end