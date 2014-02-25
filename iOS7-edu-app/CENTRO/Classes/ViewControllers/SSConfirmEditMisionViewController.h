//
//  SSConfirmEditMisionViewController.h
//  CENTRO
//
//  Created by Centro Community Partners.
//  Copyright (c) 2013 Centro Community Partners. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SSConfirmEditMisionViewController : UIViewController

@property (strong, nonatomic) NSString *mission;
@property (weak, nonatomic) IBOutlet UIImageView *backgroundImageView;
@property (weak, nonatomic) IBOutlet UILabel *confirmMissionLabel;
@property (weak, nonatomic) IBOutlet UITextView *confirmMissionTextView;

@end