//
//  SSCompetitorRankCell.h
//  CENTRO
//
//  Created by Centro Community Partners.
//  Copyright (c) 2013 Centro Community Partners. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol SSCompetitorRankCellDelegate;

@interface SSCompetitorRankCell : UITableViewCell {
    id <SSCompetitorRankCellDelegate> _delegate;
}

@property (strong, nonatomic) id delegate;

@property (weak, nonatomic) IBOutlet UILabel *competitorNameLabel;
@property (weak, nonatomic) IBOutlet UIButton *priceRankButton;
@property (weak, nonatomic) IBOutlet UIButton *customerServiceButton;
@property (weak, nonatomic) IBOutlet UIButton *qualityRankButton;
@property (weak, nonatomic) IBOutlet UIButton *locationRankButton;
@property (weak, nonatomic) IBOutlet UIButton *speedButton;

@end

@protocol SSCompetitorRankCellDelegate <NSObject>


@required

-(void) priceRankEditModeWillBegin;
-(void) customerServiceRankEditModeWillBegin;
-(void) qualityRankEditModeWillBegin;
-(void) locationRankEditModeWillBegin;
-(void) speedRankEditModeWillBegin;

@end