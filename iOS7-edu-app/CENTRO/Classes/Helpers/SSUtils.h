//
//  SSUtils.h
//  CENTRO
//
//  Created by Centro Community Partners.
//  Copyright (c) 2013 Centro Community Partners. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SSUtils : NSObject

+ (NSMutableAttributedString *) attributedStringForHeaderInTableView: (NSString *) text;

+ (NSMutableAttributedString *) attributedStringForCellTextOnlyTitle: (NSString *) text;

+ (NSMutableAttributedString *) attributedStringForTitleCellTextGreen: (NSString *) text;

+ (NSMutableAttributedString *) attributedStringForSubTitleCellTextGray: (NSString *) text;


+ (NSMutableAttributedString *) attributedStringForTitleCellTextGray: (NSString *) text;

+ (NSMutableAttributedString *) attributedStringForDetailCellTextGray: (NSString *) text;

+ (void) showAlertViewBasedOnNetworkError: (NSError *) error;

+ (void) setTableViewBackground:(UITableView *) tableView;

+ (NSString *) companyName;

@end