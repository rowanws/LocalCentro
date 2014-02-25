//
//  SSIdentifyResponsibilitiesTableViewController.h
//  CENTRO
//
//  Created by Centro Community Partners.
//  Copyright (c) 2013 Centro Community Partners. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SSIdentifyResponsibilitiesTableViewController : UITableViewController

@property (weak, nonatomic) IBOutlet UILabel *questionLabel;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *nextButton;

-(IBAction)dismissVC;

@end