//
//  SSProfileTabViewController.m
//  CENTRO
//
//  Created by Centro Community Partners.
//  Copyright (c) 2013 Centro Community Partners. All rights reserved.
//

#import "SSUtils.h"

#import "SSProfileTabViewController.h"
#import "SSLogInViewController.h"
#import "SSSignUpViewController.h"


#import <QuartzCore/CoreAnimation.h>
#import "SSAppDelegate.h"

#import "SSUser.h"
#import "MBProgressHUD.h"

#import "Student.h"
#import "CENTROAPIClient.h"
#import "SSServerData.h"

@interface SSProfileTabViewController () <NSFetchedResultsControllerDelegate>

@property (strong, nonatomic) SSServerData *serverData;
@property (strong, nonatomic) Student *student;
@property BOOL fetchHasResults;


@end

@implementation SSProfileTabViewController

    //LaZ


#pragma mark - View Events

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [SSUtils setTableViewBackground:self.tableView];
    self.navigationItem.title = NSLocalizedString(@"ProfileNavBarTitle", nil);
    self.serverData = [[SSServerData alloc] init];
}

- (void) viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    [self userLoggedIn];
    [self.tableView reloadData];
}

-(void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    if([segue.identifier isEqualToString:@"ModalLogIn"]) {
        SSLogInViewController *logInViewController = (SSLogInViewController*) segue.destinationViewController;
        [logInViewController setDelegate:sender];
    }
}

#pragma mark - Table View Delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    NSIndexPath *viewProfile3000 = [NSIndexPath indexPathForRow:0 inSection:0];
    
    NSIndexPath *editProfile3000 = [NSIndexPath indexPathForRow:0 inSection:1];
    NSIndexPath *logOut3000 = [NSIndexPath indexPathForRow:1 inSection:1];
    
    NSIndexPath *about3000 = [NSIndexPath indexPathForRow:2 inSection:1];
    NSIndexPath *sendFeedback3000 = [NSIndexPath indexPathForRow:3 inSection:1];
    //NSIndexPath *about3000 = [NSIndexPath indexPathForRow:0 inSection:2];
    //NSIndexPath *sendFeedback3000 = [NSIndexPath indexPathForRow:1 inSection:2];

    
    if([tableView tag] == 3000 && [indexPath isEqual:logOut3000]) {
        UIAlertView *theAlert =[[UIAlertView alloc] initWithTitle:NSLocalizedString(@"LogOutAlertViewTitle", nil)
                                                          message:NSLocalizedString(@"LogOutAlertViewMessage", nil)
                                                         delegate:self
                                                cancelButtonTitle:NSLocalizedString(@"LogOutAlertViewCancelButtonTitle", nil)
                                                otherButtonTitles:nil];
        [theAlert addButtonWithTitle:NSLocalizedString(@"LogOutButtonTitle", nil)];
        theAlert.tag = 3030;
        [tableView cellForRowAtIndexPath:indexPath].selected = NO;
        [theAlert show];
    } else if ([tableView tag] == 3000 && [indexPath isEqual:sendFeedback3000]) {
        if ([MFMailComposeViewController canSendMail])
        {
            
            NSArray *toRecipients = [NSArray arrayWithObjects:@"appdev@centrocommunity.org", nil];
            NSString *subject = [NSString stringWithFormat:NSLocalizedString(@"EmailFeedbackSubject", nil), [[SSUser currentUser] username]];
            
            NSString *emailBody = @"";
            
            MFMailComposeViewController *mailer = [[MFMailComposeViewController alloc] init];
            mailer.mailComposeDelegate = self;
            [mailer setToRecipients:toRecipients];
            [mailer setSubject:subject];

            [mailer setMessageBody:emailBody isHTML:NO];
            [self presentViewController:mailer animated:YES completion:nil];
        }
        else
        {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"MailComposerAlertViewTitle", nil)
                                                            message:NSLocalizedString(@"MailComposerAlertViewMessage", nil)
                                                           delegate:nil
                                                  cancelButtonTitle:NSLocalizedString(@"MailComposerAlertViewCancelButtonTitle", nil)
                                                  otherButtonTitles: nil];
            [alert show];
        }
    } else if ([tableView tag] == 3000 && [indexPath isEqual:viewProfile3000]) {
        [self performSegueWithIdentifier:@"ViewProfile" sender:self];
    } else if ([tableView tag] == 3000 && [indexPath isEqual:editProfile3000]) {
        //UIBarButtonItem *nextScreenBackButton = [[UIBarButtonItem alloc] initWithTitle:@"Cancel" style:UIBarButtonItemStyleBordered target:self action:nil];
        //self.navigationItem.backBarButtonItem = nextScreenBackButton;
        [self performSegueWithIdentifier:@"EditProfile" sender:self];
    } else if ([tableView tag] == 3000 && [indexPath isEqual:about3000]) {
        [self performSegueWithIdentifier:@"AboutCENTRO" sender:self];
    } else {
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
    }
}

- (UIView *) tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UILabel *headerLabel = [[UILabel alloc] init];
 
    NSString *headerString;
 
    if([tableView tag] == 3000) {
        if (section == 0) {
           return nil;
     } else if (section == 1) {
            headerString = NSLocalizedString(@"HeaderStringProfile", nil);
        } else if (section == 2) {
            headerString = NSLocalizedString(@"HeaderStringAbout", nil);
        } else {
           return nil;
        }
    } else {
        return nil;
    }

    headerLabel.attributedText = [SSUtils attributedStringForHeaderInTableView:headerString];
    [headerLabel setBackgroundColor:[UIColor clearColor]];

    return headerLabel;
}

#pragma mark - Table View Data Source

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSIndexPath *profileSummary3000 = [NSIndexPath indexPathForRow:0 inSection:0];
    
    NSIndexPath *editProfile3000 = [NSIndexPath indexPathForRow:0 inSection:1];
    NSIndexPath *logOut3000 = [NSIndexPath indexPathForRow:1 inSection:1];
    
    //NSIndexPath *about3000 = [NSIndexPath indexPathForRow:2 inSection:1];
    //NSIndexPath *feedback3000 = [NSIndexPath indexPathForRow:3 inSection:1];
    NSIndexPath *about3000 = [NSIndexPath indexPathForRow:0 inSection:2];
    NSIndexPath *feedback3000 = [NSIndexPath indexPathForRow:1 inSection:2];
 
    
    NSString *firstName;
    NSString *lastName;
    
    if([tableView tag] == 3000 && [indexPath isEqual:profileSummary3000]) {
        
        if(self.fetchHasResults) {
            firstName = self.student.firstName;
            lastName = self.student.lastName;
        } else {
            firstName = @"";
            lastName = @"";
        }
        
        NSString *fullName = [NSString stringWithFormat:@"%@ %@", firstName, lastName];
        self.profileSummaryCell.textLabel.attributedText = [SSUtils attributedStringForTitleCellTextGreen:fullName];
        self.profileSummaryCell.detailTextLabel.attributedText = [SSUtils attributedStringForSubTitleCellTextGray:[[SSUser currentUser] username]];
        return self.profileSummaryCell;
    } else if([tableView tag] == 3000 && [indexPath isEqual:editProfile3000]) {
        self.editProfileCell.textLabel.attributedText = [SSUtils attributedStringForCellTextOnlyTitle:NSLocalizedString(@"TableViewCellTitleEditProfile", nil)];
        return self.editProfileCell;
    } else if([tableView tag] == 3000 && [indexPath isEqual:logOut3000]) {
        self.logOutCell.textLabel.attributedText = [SSUtils attributedStringForCellTextOnlyTitle:NSLocalizedString(@"TableViewCellTitleLogOut", nil)];
        return self.logOutCell;
    } else if([tableView tag] == 3000 && [indexPath isEqual:about3000]) {
        self.aboutCell.textLabel.attributedText = [SSUtils attributedStringForCellTextOnlyTitle:NSLocalizedString(@"TableViewCellTitleAbout", nil)];
        return self.aboutCell;
    } else if([tableView tag] == 3000 && [indexPath isEqual:feedback3000]) {
        self.feedbackCell.textLabel.attributedText = [SSUtils attributedStringForCellTextOnlyTitle:NSLocalizedString(@"TableViewCellTitleFeedback", nil)];
        return self.feedbackCell;
    } else {
        return nil;
    }
}

#pragma mark - UIAlertViewDelegate

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(alertView.tag == 3030) {
        switch (buttonIndex) {
            case 0:
                break;
            case 1:
                [[SSUser currentUser] logOutAndPresentHUDInViewController:self];
                break;
            default:
                break;
        }
    } else if(alertView.tag == 3020) {
        switch (buttonIndex) {
            case 0:
                break;
            case 1:
                break;
            default:
                break;
        }
    } else {
        
    }
}

#pragma mark - MFMailComposeViewControllerDelegate

- (void)mailComposeController:(MFMailComposeViewController*)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError*)error
{
    switch (result)
    {
        case MFMailComposeResultCancelled:
            break;
        case MFMailComposeResultSaved:
            break;
        case MFMailComposeResultSent:
            break;
        case MFMailComposeResultFailed:
            break;
        default:
            break;
    }

    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - SSLogInViewControllerDelegate

- (BOOL)SSLogInViewController:(SSLogInViewController *)logInController shouldBeginLogInWithUsername:(NSString *)username password:(NSString *)password {
    if (username && password && username.length && password.length) {
        return YES;
    } else {
        [[[UIAlertView alloc] initWithTitle:NSLocalizedString(@"LogInMissingInformationAlertViewTitle", nil)
                                    message:NSLocalizedString(@"LogInMissingInformationAlertViewMessage", nil)
                                   delegate:nil cancelButtonTitle:NSLocalizedString(@"LogInMissingInformationAlertViewCancelButtonTitle", nil)
                          otherButtonTitles:nil] show];
        return NO;
    }
}

- (void)SSLogInViewController:(SSLogInViewController *)logInController didLogInUser:(SSUser *)user {
    [logInController dismissViewControllerAnimated:YES completion:nil];
    logInController = nil;
    
    [self.parentViewController.tabBarController setSelectedIndex:1];
    [self.serverData pullAndShowHUDInViewController:self];
    
    [self.tableView reloadData];    
}

- (void)SSLogInViewController:(SSLogInViewController *)logInController didFailToLogInWithError:(NSError *)error {
    [SSUtils showAlertViewBasedOnNetworkError: error];
}

- (void)SSLogInViewControllerDidCancelLogIn:(SSLogInViewController *)logInController {
    [logInController dismissViewControllerAnimated:YES completion:nil];
    
    logInController = nil;
    [self.tabBarController setSelectedIndex:0];
}


#pragma mark - SSSignUpViewControllerDelegate

- (BOOL)SSSignUpViewController:(SSSignUpViewController *)signUpController shouldBeginSignUp:(NSDictionary *)info {
    BOOL canSignUp = YES;
    for (id key in info) {
        NSString *field = [info objectForKey:key];
        if (!field || field.length == 0) {
            canSignUp = NO;
            break;
        }
    }
    if (!canSignUp) {
        [[[UIAlertView alloc] initWithTitle:NSLocalizedString(@"SignUpMissingInformationAlertViewTitle", nil)
                                    message:NSLocalizedString(@"SignUpMissingInformationAlertViewMessage", nil)
                                   delegate:nil
                          cancelButtonTitle:NSLocalizedString(@"SignUpMissingInformationAlertViewCancelButtonTitle", nil)
                          otherButtonTitles:nil] show];
    } else {
        if(![[(NSString *) info valueForKey:@"password"] isEqualToString:[(NSString *) info valueForKey:@"confirmPassword"]]) {
            canSignUp = NO;
            [[[UIAlertView alloc] initWithTitle:NSLocalizedString(@"SignUpPasswordMismatchAlertViewTitle", nil)
                                        message:NSLocalizedString(@"SignUpPasswordMismatchAlertViewMessage", nil)
                                       delegate:nil
                              cancelButtonTitle:NSLocalizedString(@"SignUpPasswordMismatchAlertViewCancelButtonTitle", nil)
                              otherButtonTitles:nil] show];
        } else {
            NSString *passwd = [(NSString *) info valueForKey:@"password"];
            if(passwd.length < 8) {
                canSignUp = NO;
                [[[UIAlertView alloc] initWithTitle:NSLocalizedString(@"SignUpShortPasswordAlertViewTitle", nil)
                                            message:NSLocalizedString(@"SignUpShortPasswordAlertViewMessage", nil)
                                           delegate:nil
                                  cancelButtonTitle:NSLocalizedString(@"SignUpShortPasswordAlertViewCancelButtonTitle", nil)
                                  otherButtonTitles:nil] show];
            }
        }
    }
    
    return canSignUp;
}

- (void)SSSignUpViewController:(SSSignUpViewController *)signUpController didSignUpUser:(SSUser *)user {
    [signUpController dismissViewControllerAnimated:YES completion:nil];
    signUpController = nil;

    [self.parentViewController.tabBarController setSelectedIndex:1];
}

- (void)SSSignUpViewControllerDidCancelSignUp:(SSSignUpViewController *)signUpController {
    [signUpController dismissViewControllerAnimated:YES completion:nil];
    signUpController = nil;
}

- (void)SSSignUpViewController:(SSSignUpViewController *)signUpController didFailToSignUpWithError:(NSError *)error {
    [SSUtils showAlertViewBasedOnNetworkError: error];
}

#pragma mark - Business Methods

- (void) userLoggedIn {
    if (![[SSUser currentUser] isLoggedIn]) {
        [self performSegueWithIdentifier:@"ModalLogIn" sender:self];
        self.fetchHasResults = NO;
    } else {
        NSManagedObjectContext *context = [(id)[[UIApplication sharedApplication] delegate] managedObjectContext];
        NSEntityDescription *studentEntityDescription = [NSEntityDescription entityForName:@"Student"
                                                                    inManagedObjectContext:context];
        
        NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
        
        [fetchRequest setEntity:studentEntityDescription];
        
        NSError *error;
        NSArray *fetchedObjects = [context executeFetchRequest:fetchRequest error:&error];
        if (fetchedObjects.count == 0) {
            self.fetchHasResults = NO;
        } else {
            self.fetchHasResults = YES;
            self.student = (Student *) [fetchedObjects objectAtIndex:0];
        }
    }
}

#pragma mark - close profile action


@end