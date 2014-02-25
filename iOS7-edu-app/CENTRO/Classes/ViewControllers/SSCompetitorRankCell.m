//
//  SSCompetitorRankCell.m
//  CENTRO
//
//  Created by Centro Community Partners.
//  Copyright (c) 2013 Centro Community Partners. All rights reserved.
//

#import "SSCompetitorRankCell.h"

@implementation SSCompetitorRankCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (IBAction)priceButtonPressed:(id)sender {
    [self.delegate priceRankEditModeWillBegin];
}

- (IBAction)customerServiceButtonPressed:(id)sender {
    [self.delegate customerServiceRankEditModeWillBegin];
}

- (IBAction)qualityButtonPressed:(id)sender {
    [self.delegate qualityRankEditModeWillBegin];
}

- (IBAction)locationButtonPressed:(id)sender {
    [self.delegate locationRankEditModeWillBegin];
}

- (IBAction)speedButtonPressed:(id)sender {
    [self.delegate speedRankEditModeWillBegin];
}

@end