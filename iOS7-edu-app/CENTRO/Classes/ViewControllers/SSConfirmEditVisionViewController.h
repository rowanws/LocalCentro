//
//  SSConfirmEditVisionViewController.h
//  CENTRO
//
//  Created by Centro Community Partners.
//  Copyright (c) 2013 Centro Community Partners. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SSConfirmEditVisionViewController : UIViewController

@property (weak, nonatomic) IBOutlet UILabel *visionLabel;
@property (weak, nonatomic) IBOutlet UITextView *visionStatementTextView;
@property (weak, nonatomic) IBOutlet UIImageView *backgroundImageView;

@property (strong, nonatomic) NSString *vision;

@end