//
//  SSCompetitorsRankTableViewController.h
//  CENTRO
//
//  Created by Centro Community Partners.
//  Copyright (c) 2013 Centro Community Partners. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SSCompetitorRankCell.h"

@interface SSCompetitorsRankTableViewController : UITableViewController <SSCompetitorRankCellDelegate>

@property (weak, nonatomic) IBOutlet UIBarButtonItem *doneButton;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

@end