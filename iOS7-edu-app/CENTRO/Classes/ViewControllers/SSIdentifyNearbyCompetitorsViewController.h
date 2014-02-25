//
//  SSIdentifyNearbyCompetitorsViewController.h
//  CENTRO
//
//  Created by Centro Community Partners.
//  Copyright (c) 2013 Centro Community Partners. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SSIdentifyNearbyCompetitorsViewController : UIViewController

@property (weak, nonatomic) IBOutlet UIImageView *backgroundImageView;
@property (weak, nonatomic) IBOutlet UILabel *questionLabel;
@property (weak, nonatomic) IBOutlet UIButton *lotButton;
@property (weak, nonatomic) IBOutlet UIButton *fewButton;
@property (weak, nonatomic) IBOutlet UIButton *notManyButton;


-(IBAction)dismissVC;

@end