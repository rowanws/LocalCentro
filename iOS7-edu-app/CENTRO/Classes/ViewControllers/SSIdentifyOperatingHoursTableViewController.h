//
//  SSIdentifyOperatingHoursTableViewController.h
//  CENTRO
//
//  Created by Centro Community Partners.
//  Copyright (c) 2013 Centro Community Partners. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SSIdentifyOperatingHoursTableViewController : UITableViewController

@property (weak, nonatomic) IBOutlet UIBarButtonItem *nextButton;
@property (weak, nonatomic) IBOutlet UILabel *titleQuestionLabel;


-(IBAction)dismissVC;


@end