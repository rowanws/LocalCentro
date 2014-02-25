//
//  SSSelectGrowthRateViewController.h
//  CENTRO
//
//  Created by Centro Community Partners.
//  Copyright (c) 2013 Centro Community Partners. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SSSelectGrowthRateViewController : UIViewController

@property (strong, nonatomic) NSString *industryCode;
@property (strong, nonatomic) NSString *segmentCode;

@property (weak, nonatomic) IBOutlet UILabel *growthLabel;
@property (weak, nonatomic) IBOutlet UIButton *yesQuickButton;
@property (weak, nonatomic) IBOutlet UIButton *yesSlowButton;
@property (weak, nonatomic) IBOutlet UIButton *noChangeButton;
@property (weak, nonatomic) IBOutlet UIButton *shrinkButton;
@property (weak, nonatomic) IBOutlet UIButton *exactRateButton;
@property (weak, nonatomic) IBOutlet UIImageView *backgroundImageView;

@end