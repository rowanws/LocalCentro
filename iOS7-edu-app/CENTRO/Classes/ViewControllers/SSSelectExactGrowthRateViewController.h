//
//  SSSelectExactGrowthRateViewController.h
//  CENTRO
//
//  Created by Centro Community Partners.
//  Copyright (c) 2013 Centro Community Partners. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SSSelectExactGrowthRateViewController : UIViewController
@property (weak, nonatomic) IBOutlet UIButton *growthButton;
@property (weak, nonatomic) IBOutlet UIButton *shrinkButton;
@property (weak, nonatomic) IBOutlet UILabel *questionLabel;
@property (weak, nonatomic) IBOutlet UILabel *growthLabel;
@property (weak, nonatomic) IBOutlet UITextField *growthAmountTextField;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *nextButton;
@property (weak, nonatomic) IBOutlet UILabel *frequencyLabel;
@property (weak, nonatomic) IBOutlet UIImageView *backgroundImageView;

@end