//
//  SSSelectMarketAgeViewController.h
//  CENTRO
//
//  Created by Centro Community Partners.
//  Copyright (c) 2013 Centro Community Partners. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SSSelectMarketAgeViewController : UIViewController

@property (weak, nonatomic) IBOutlet UIImageView *backgroundImageView;
@property (weak, nonatomic) IBOutlet UILabel *questionLabel;
@property (weak, nonatomic) IBOutlet UIButton *brandNewMarketButton;
@property (weak, nonatomic) IBOutlet UIButton *recentMarketButton;
@property (weak, nonatomic) IBOutlet UIButton *establishedMarketButton;
@property (weak, nonatomic) IBOutlet UIButton *traditionalMarketButton;

@end