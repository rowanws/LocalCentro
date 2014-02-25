//
//  SSAddDeleteCompetitorViewController.h
//  CENTRO
//
//  Created by Centro Community Partners.
//  Copyright (c) 2013 Centro Community Partners. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SSAddDeleteCompetitorViewController : UIViewController <UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UIImageView *backgroundImageView;
@property (weak, nonatomic) IBOutlet UILabel *questionLabel;
@property (weak, nonatomic) IBOutlet UITextField *nameTextField;
@property (weak, nonatomic) IBOutlet UIButton *addDeleteButton;

@property (strong, nonatomic) NSNumber *competitorProfileID;
@property BOOL add;

@end