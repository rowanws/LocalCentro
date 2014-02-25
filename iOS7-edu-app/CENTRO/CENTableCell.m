//
//  CENTableCell.m
//  CENTRO
//
//  Created by Rowan on 1/27/14.
//  Copyright (c) 2014 Centro-RWS. All rights reserved.
//

#import "CENTableCell.h"

@implementation CENTableCell

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

@end
