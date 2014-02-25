//
//  SSActivitiesViewController.h
//  CENTRO
//
//  Created by Centro Community Partners.
//  Copyright (c) 2013 Centro Community Partners. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>

@interface SSActivitiesViewController : UITableViewController

@property (weak, nonatomic) IBOutlet UIBarButtonItem *syncButton;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *loadProfileButton;
@property (weak, nonatomic) IBOutlet NSDate *_completed;
@property (weak, nonatomic) IBOutlet NSNumber *_showCompletedScreen;




-(IBAction)loadProfile;

@end