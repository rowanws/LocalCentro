//
//  SSPurposesViewController.h
//  CENTRO
//
//  Created by Centro Community Partners.
//  Copyright (c) 2013 Centro Community Partners. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SSPurposesViewController : UIViewController
{
UIButton *backPurposeButton;
UIButton *nextPurposeButton;

}
@property (strong, nonatomic) UIWindow *window;

@property (nonatomic, retain) IBOutlet UIButton *backPurposeButton;
@property (nonatomic, retain) IBOutlet UIButton *nextPurposeButton;

- (IBAction)doBackPurposeButton;
- (IBAction)doNextPurposeButton;

@property (weak, nonatomic) IBOutlet UIImageView *backgroundImageView;
@property (weak, nonatomic) IBOutlet UILabel *purposeQuestionLabel;
@property (weak, nonatomic) IBOutlet UITextView *purposeAnswerTextView;



-(IBAction)dismissVC;

@end