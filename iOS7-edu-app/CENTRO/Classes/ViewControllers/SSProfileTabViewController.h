//
//  SSProfileTabViewController.h
//  CENTRO
//
//  Created by Centro Community Partners.
//  Copyright (c) 2013 Centro Community Partners. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MessageUI/MessageUI.h>
#import "SSLogInViewController.h"

@interface SSProfileTabViewController : UITableViewController <UITableViewDelegate, UIAlertViewDelegate, MFMailComposeViewControllerDelegate, SSLogInViewControllerDelegate>

@property (weak, nonatomic) IBOutlet UITableViewCell *profileSummaryCell;
@property (weak, nonatomic) IBOutlet UITableViewCell *editProfileCell;
@property (weak, nonatomic) IBOutlet UITableViewCell *logOutCell;
@property (weak, nonatomic) IBOutlet UITableViewCell *aboutCell;
@property (weak, nonatomic) IBOutlet UITableViewCell *feedbackCell;


@end