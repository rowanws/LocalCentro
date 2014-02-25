//
//  SSMissionViewController.h
//  CENTRO
//
//  Created by Centro Community Partners.
//  Copyright (c) 2013 Centro Community Partners. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SSMissionViewController : UIViewController

@property (weak, nonatomic) IBOutlet UILabel *missionLabel;
@property (weak, nonatomic) IBOutlet UITextView *visionTextView;
@property (weak, nonatomic) IBOutlet UITextView *missionTextView;
@property (weak, nonatomic) IBOutlet UIImageView *backgroundImageView;


-(IBAction)dismissVC;
@end