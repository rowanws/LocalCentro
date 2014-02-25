//
//  SSBusinessBalanceSheetViewController.h
//  CENTRO
//
//  Created by Centro Community Partners.
//  Copyright (c) 2013 Centro Community Partners. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SSBusinessBalanceSheetViewController : UIViewController

@property (weak, nonatomic) IBOutlet UIImageView *backgroundImageView;
@property (weak, nonatomic) IBOutlet UILabel *personalSheetLabel;
@property (weak, nonatomic) IBOutlet UITextView *assetsTextView;
@property (weak, nonatomic) IBOutlet UITextView *liabilitiesTextView;
@property (weak, nonatomic) IBOutlet UITextView *netWorthTextView;

@end