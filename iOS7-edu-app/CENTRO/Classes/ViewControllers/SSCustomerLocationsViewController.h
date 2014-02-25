//
//  SSCustomerLocationsViewController.h
//  CENTRO
//
//  Created by Centro Community Partners.
//  Copyright (c) 2013 Centro Community Partners. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SSCustomerLocationsViewController : UIViewController
@property (weak, nonatomic) IBOutlet UIImageView *backgroundImageView;
@property (weak, nonatomic) IBOutlet UILabel *questionLabel;
@property (weak, nonatomic) IBOutlet UILabel *walkingLabel;
@property (weak, nonatomic) IBOutlet UIStepper *walkingStepper;
@property (weak, nonatomic) IBOutlet UILabel *shortDriveLabel;
@property (weak, nonatomic) IBOutlet UIStepper *shortDriveStepper;
@property (weak, nonatomic) IBOutlet UILabel *longerDriveLabel;
@property (weak, nonatomic) IBOutlet UIStepper *longerDriveStepper;
@property (weak, nonatomic) IBOutlet UILabel *onlineLabel;
@property (weak, nonatomic) IBOutlet UIStepper *onlineStepper;
@property (weak, nonatomic) IBOutlet UILabel *otherLabel;
@property (weak, nonatomic) IBOutlet UIStepper *otherStepper;
@property (weak, nonatomic) IBOutlet UIButton *sureButton;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *nextButton;
@property (weak, nonatomic) IBOutlet UILabel *availablePercentageLabel;

@end