//
//  SSUtils.m
//  CENTRO
//
//  Created by Centro Community Partners.
//  Copyright (c) 2013 Centro Community Partners. All rights reserved.
//

#import "SSUtils.h"
#import "CENTROAPIClient.h"
#import "Company.h"
#import "SSUser.h"

@implementation SSUtils

+ (NSMutableAttributedString *) attributedStringForHeaderInTableView: (NSString *) text
//Profile view section label text color to green
{
    if(text == nil) {
        text = @"";
    }
    
    NSMutableAttributedString *attString = [[NSMutableAttributedString alloc] initWithString:text];
    NSInteger _stringLength = [text length];
    
    UIColor *fontColor = [UIColor colorWithRed:145.0/255.0 green:172.0/255.0 blue:51.0/255.0 alpha:1.00];
    UIFont *font=[UIFont fontWithName:@"Helvetica-Bold" size:18.0f];
    
    [attString addAttribute:NSFontAttributeName value:font range:NSMakeRange(0, _stringLength)];
    [attString addAttribute:NSForegroundColorAttributeName value:fontColor range:NSMakeRange(0, _stringLength)];
    
    return attString;
}

+ (NSMutableAttributedString *) attributedStringForCellTextOnlyTitle: (NSString *) text
{
    if(text == nil) {
        text = @"";
    }
    
    NSMutableAttributedString *attString = [[NSMutableAttributedString alloc] initWithString:text];
    NSInteger _stringLength = [text length];
    
   UIColor *fontColor = [UIColor colorWithRed:70.0/255.0 green:70.0/255.0 blue:70.0/255.0 alpha:1.00];
    UIFont *font=[UIFont fontWithName:@"Helvetica-Bold" size:17.0f];
    
    
    [attString addAttribute:NSFontAttributeName value:font range:NSMakeRange(0, _stringLength)];
    [attString addAttribute:NSForegroundColorAttributeName value:fontColor range:NSMakeRange(0, _stringLength)];
    
    return attString;
}

+ (NSMutableAttributedString *) attributedStringForTitleCellTextGreen: (NSString *) text
{
    if(text == nil) {
        text = @"";
    }
    
    NSMutableAttributedString *attString = [[NSMutableAttributedString alloc] initWithString:text];
    NSInteger _stringLength = [text length];
    
    UIColor *fontColor = [UIColor colorWithRed:145.0/255.0 green:172.0/255.0 blue:51.0/255.0 alpha:1.00];
    UIFont *font=[UIFont fontWithName:@"Helvetica-Bold" size:17.0f];
    
    
    [attString addAttribute:NSFontAttributeName value:font range:NSMakeRange(0, _stringLength)];
    [attString addAttribute:NSForegroundColorAttributeName value:fontColor range:NSMakeRange(0, _stringLength)];
    
    return attString;
}

+ (NSMutableAttributedString *) attributedStringForSubTitleCellTextGray: (NSString *) text
{
    if(text == nil) {
        text = @"";
    }
    
    NSMutableAttributedString *attString = [[NSMutableAttributedString alloc] initWithString:text];
    NSInteger _stringLength = [text length];
    
    UIColor *fontColor = [UIColor colorWithRed:70.0/255.0 green:70.0/255.0 blue:70.0/255.0 alpha:1.00];
    UIFont *font=[UIFont fontWithName:@"Helvetica" size:14.0f];
    
    
    [attString addAttribute:NSFontAttributeName value:font range:NSMakeRange(0, _stringLength)];
    [attString addAttribute:NSForegroundColorAttributeName value:fontColor range:NSMakeRange(0, _stringLength)];
    
    return attString;
}


+ (NSMutableAttributedString *) attributedStringForTitleCellTextGray: (NSString *) text
{
    if(text == nil) {
        text = @"";
    }
    
    NSMutableAttributedString *attString = [[NSMutableAttributedString alloc] initWithString:text];
    NSInteger _stringLength = [text length];
    
    UIColor *fontColor = [UIColor colorWithRed:70.0/255.0 green:70.0/255.0 blue:70.0/255.0 alpha:1.00];
    UIFont *font=[UIFont fontWithName:@"Helvetica-Bold" size:17.0f];
    
    
    [attString addAttribute:NSFontAttributeName value:font range:NSMakeRange(0, _stringLength)];
    [attString addAttribute:NSForegroundColorAttributeName value:fontColor range:NSMakeRange(0, _stringLength)];
    
    return attString;
}

+ (NSMutableAttributedString *) attributedStringForDetailCellTextGray: (NSString *) text
{
    if(text == nil) {
        text = @"";
    }
    
    NSMutableAttributedString *attString = [[NSMutableAttributedString alloc] initWithString:text];
    NSInteger _stringLength = [text length];
    
    UIColor *fontColor = [UIColor colorWithRed:70.0/255.0 green:70.0/255.0 blue:70.0/255.0 alpha:1.00];
    UIFont *font=[UIFont fontWithName:@"Helvetica" size:17.0f];
    
    
    [attString addAttribute:NSFontAttributeName value:font range:NSMakeRange(0, _stringLength)];
    [attString addAttribute:NSForegroundColorAttributeName value:fontColor range:NSMakeRange(0, _stringLength)];
    
    return attString;
}

+ (void) showAlertViewBasedOnNetworkError: (NSError *) error {
    
    int errorCode = [[[error userInfo] objectForKey:AFNetworkingOperationFailingURLResponseErrorKey] statusCode];
    
    if([error.domain isEqualToString:@"NSURLErrorDomain"]) {
        if (error.code == -1009) {
            [[[UIAlertView alloc] initWithTitle:NSLocalizedString(@"NetworkErrorAlertViewTitle", nil)
                                        message:NSLocalizedString(@"NetworkErrorAlertViewMessage", nil)
                                       delegate:nil
                              cancelButtonTitle:NSLocalizedString(@"LogInSignUpErrorAlertViewCancelButtonTitle", nil)
                              otherButtonTitles:nil] show];
        }
    } else {
        if(errorCode == 404) {
            [[[UIAlertView alloc] initWithTitle:NSLocalizedString(@"LogInErrorAlertViewTitle", nil)
                                        message:NSLocalizedString(@"LogInNoEmailErrorAlertViewMessage", nil)
                                       delegate:nil
                              cancelButtonTitle:NSLocalizedString(@"LogInSignUpErrorAlertViewCancelButtonTitle", nil)
                              otherButtonTitles:nil] show];
        } else if(errorCode == 403) {
            [[[UIAlertView alloc] initWithTitle:NSLocalizedString(@"LogInErrorAlertViewTitle", nil)
                                        message:NSLocalizedString(@"LogInOnlyStudentsErrorAlertViewMessage", nil)
                                       delegate:nil
                              cancelButtonTitle:NSLocalizedString(@"LogInSignUpErrorAlertViewCancelButtonTitle", nil)
                              otherButtonTitles:nil] show];
        } else if(errorCode == 401) {
            [[[UIAlertView alloc] initWithTitle:NSLocalizedString(@"LogInErrorAlertViewTitle", nil)
                                        message:NSLocalizedString(@"LogInInvalidPasswordErrorAlertViewMessage", nil)
                                       delegate:nil
                              cancelButtonTitle:NSLocalizedString(@"LogInSignUpErrorAlertViewCancelButtonTitle", nil)
                              otherButtonTitles:nil] show];
        } else if(errorCode == 406) {
            [[[UIAlertView alloc] initWithTitle:NSLocalizedString(@"SignUpErrorAlertViewTitle", nil)
                                        message:NSLocalizedString(@"SignUpEmailTakenErrorAlertViewMessage", nil)
                                       delegate:nil
                              cancelButtonTitle:NSLocalizedString(@"LogInSignUpErrorAlertViewCancelButtonTitle", nil)
                              otherButtonTitles:nil] show];
        } else if(errorCode == 402) {
            [[[UIAlertView alloc] initWithTitle:NSLocalizedString(@"LogInErrorAlertViewTitle", nil)
                                        message:NSLocalizedString(@"LogInNoConfirmErrorAlertViewMessage", nil)
                                       delegate:nil
                              cancelButtonTitle:NSLocalizedString(@"LogInSignUpErrorAlertViewCancelButtonTitle", nil)
                              otherButtonTitles:nil] show];
        } else {
            [[[UIAlertView alloc] initWithTitle:NSLocalizedString(@"UnknownLogInSignUpErrorAlertViewTitle", nil)
                                        message:NSLocalizedString(@"UnknownLogInSignUpErrorAlertViewMessage", nil)
                                       delegate:nil
                              cancelButtonTitle:NSLocalizedString(@"LogInSignUpErrorAlertViewCancelButtonTitle", nil)
                              otherButtonTitles:nil] show];
        }
    }
}

+ (void) setTableViewBackground:(UITableView *) tableView {
    
    //CGRect screenBounds = [[UIScreen mainScreen] bounds];
    //if (screenBounds.size.height == 568) {
    //    tableView.backgroundView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"bg-568h@2x.png"]];
    //} else {
    //    tableView.backgroundView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"bg@2x.png"]];
    //}
    //tableView.backgroundView.contentMode = UIViewContentModeCenter;
    
}

+ (NSString *) companyName {
    
    Company *company;
    
    NSString *companyName = @"";
    
    NSManagedObjectContext *context = [(id)[[UIApplication sharedApplication] delegate] managedObjectContext];
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Company"
                                              inManagedObjectContext:context];
    [fetchRequest setEntity:entity];
    
    [fetchRequest setPredicate:[NSPredicate predicateWithFormat:@"companyID = %@", [[SSUser currentUser] companyID]]];
    
    NSError *error;
    NSArray *fetchedObjects = [context executeFetchRequest:fetchRequest error:&error];
    if (fetchedObjects.count == 0) {
        companyName = @"Your Company";
    } else {
        company = (Company *) [fetchedObjects objectAtIndex:0];
        companyName = company.name;
    }
    
    if (companyName.length == 0 || [companyName isEqualToString:@""]) {
        companyName = @"Your Company";
    }

    return companyName;
}

@end