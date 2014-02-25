//
//  SSViewProfileTableViewController.h
//  CENTRO
//
//  Created by Centro Community Partners.
//  Copyright (c) 2013 Centro Community Partners. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SSViewProfileTableViewController : UITableViewController

@property (weak, nonatomic) IBOutlet UITableViewCell *profileSummaryCell;
@property (weak, nonatomic) IBOutlet UITableViewCell *preferredNameCell;
@property (weak, nonatomic) IBOutlet UITableViewCell *genderCell;
@property (weak, nonatomic) IBOutlet UITableViewCell *dateOfBirthCell;
@property (weak, nonatomic) IBOutlet UITableViewCell *phoneTypeAndNumberCell;

@end