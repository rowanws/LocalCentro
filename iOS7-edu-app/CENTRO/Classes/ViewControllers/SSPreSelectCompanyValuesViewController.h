//
//  SSPreSelectCompanyValuesViewController.h
//  CENTRO
//
//  Created by Centro Community Partners.
//  Copyright (c) 2013 Centro Community Partners. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SSPreSelectCompanyValuesViewController : UIViewController

@property (weak, nonatomic) IBOutlet UIImageView *backgroundImageView;

@property (weak, nonatomic) IBOutlet UITextView *visionMissionTextView;
@property (weak, nonatomic) IBOutlet UILabel *questionLabel;
@property (weak, nonatomic) IBOutlet UILabel *valueLabel;
@property (weak, nonatomic) IBOutlet UIButton *notAtAllButton;
@property (weak, nonatomic) IBOutlet UIButton *aLittleButton;
@property (weak, nonatomic) IBOutlet UIButton *veryMuchButton;

-(IBAction)dismissVC;

@end