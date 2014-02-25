//
//  SSCompletedCompetitiveAdvantageRankCell.h
//  CENTRO
//
//  Created by Centro Community Partners.
//  Copyright (c) 2013 Centro Community Partners. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SSCompletedCompetitiveAdvantageRankCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *competitorLabel;
@property (weak, nonatomic) IBOutlet UILabel *priceRankLabel;
@property (weak, nonatomic) IBOutlet UILabel *customerServiceRankLabel;
@property (weak, nonatomic) IBOutlet UILabel *qualityRankLabel;
@property (weak, nonatomic) IBOutlet UILabel *locationRankLabel;
@property (weak, nonatomic) IBOutlet UILabel *speedRankLabel;

@end