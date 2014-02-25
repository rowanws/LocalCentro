//
//  SSLogInViewController.m
//  CENTRO
//
//  Created by Centro Community Partners.
//  Copyright (c) 2013 Centro Community Partners. All rights reserved.
//

#import "SSLogInViewController.h"
#import "CENTROAPIClient.h"
#import "SSUser.h"
#import "SSUtils.h"
#import "MBProgressHUD.h"
#import "SSSignUpViewController.h"
#import "Student.h"

@interface SSLogInViewController ()

@property (strong, readwrite) UIAlertView *forgotAlertView;
@property (strong, readwrite) NSString *emailForgot;
@property (strong, nonatomic) NSManagedObjectContext *context;
@property (strong, nonatomic) Student *student;

@end

@implementation SSLogInViewController

#pragma mark - View Events

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    CGRect screenBounds = [[UIScreen mainScreen] bounds];
    if (screenBounds.size.height == 568) {
        self.backgroundImageView.image = [UIImage imageNamed:@"bgLoginSignUp-568h@2x.png"];
    } else {
        self.backgroundImageView.image = [UIImage imageNamed:@"bgLoginSignUp@2x.png"];
    }
    
    self.context = [(id)[[UIApplication sharedApplication] delegate] managedObjectContext];
    
    self.usernameTextField.delegate = self;
    self.passwordTexfield.delegate = self;
}

- (void) viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self.usernameTextField becomeFirstResponder];
}

-(void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if([segue.identifier isEqualToString:@"ModalSignUp"]) {
        SSSignUpViewController *signUpViewController = (SSSignUpViewController*) segue.destinationViewController;
        [signUpViewController setDelegate:[(SSLogInViewController *) sender delegate]];
    }
}

- (IBAction)logInButtonPressed:(id)sender {
    [self logIn];
}


- (IBAction)signUpButtonPressed:(id)sender {
    [self.usernameTextField resignFirstResponder];
    [self.passwordTexfield resignFirstResponder];
    [self performSegueWithIdentifier:@"ModalSignUp" sender:self];
}

- (IBAction)closeButtonPressed:(id)sender {
    [self.delegate SSLogInViewControllerDidCancelLogIn:self];
}

- (IBAction)forgotButtonPressed:(id)sender {
    
    self.forgotAlertView = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"ForgotPasswordAlertViewTitle", nil)
                                                      message:NSLocalizedString(@"ForgotPasswordAlertViewMessage", nil)
                                                     delegate:nil
                                            cancelButtonTitle:NSLocalizedString(@"ForgotPasswordAlertViewCancelButtonTitle", nil)
                                            otherButtonTitles:nil];
    
    self.forgotAlertView.delegate = self;
    
    self.forgotAlertView.alertViewStyle = UIAlertViewStylePlainTextInput;
    [self.forgotAlertView textFieldAtIndex:0].delegate = self;
    [self.forgotAlertView textFieldAtIndex:0].keyboardType = UIKeyboardTypeEmailAddress;
    [self.forgotAlertView textFieldAtIndex:0].keyboardAppearance = UIKeyboardAppearanceDefault;
    [self.forgotAlertView textFieldAtIndex:0].returnKeyType = UIReturnKeyGo;
    [self.forgotAlertView textFieldAtIndex:0].tag = 4003;
    [self.forgotAlertView show];
    
}

#pragma mark - UIAlertViewDelegate

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    self.emailForgot = [self.forgotAlertView textFieldAtIndex:0].text;
    if(![self.emailForgot isEqualToString:@""]) {
        [self recoverPasswordForEmail:self.emailForgot];
    } else {
        [self.usernameTextField becomeFirstResponder];
    }
}

#pragma mark - UITextFieldDelegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    if (textField.tag == 4002) {
        [self logIn];
    } else if (textField.tag == 4001) {
        [self.passwordTexfield becomeFirstResponder];
    } else if (textField.tag == 4003) {
        [self.forgotAlertView dismissWithClickedButtonIndex: 0 animated:YES];
        self.emailForgot = [self.forgotAlertView textFieldAtIndex:0].text;
        
        if(![self.emailForgot isEqualToString:@""]) {
            [self recoverPasswordForEmail:self.emailForgot];
        }
    } else {
        
    }
    return YES;
}

#pragma mark - Business Methods

-(void) logIn {
        
    BOOL logIn = [self.delegate SSLogInViewController:self shouldBeginLogInWithUsername:self.usernameTextField.text password:self.passwordTexfield.text];

    if (logIn) {
        
        [self.usernameTextField resignFirstResponder];
        [self.passwordTexfield resignFirstResponder];
        
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        hud.mode = MBProgressHUDModeIndeterminate;
        hud.labelText = NSLocalizedString(@"HUDLabelTextLogIn", nil);
        
        CENTROAPIClient *client = [CENTROAPIClient sharedClient];
        [[AFNetworkActivityIndicatorManager sharedManager] setEnabled:YES];
        [[AFNetworkActivityIndicatorManager sharedManager] incrementActivityCount];
        
        NSDictionary *params = @{@"email": self.usernameTextField.text, @"password": self.passwordTexfield.text};
        NSString *path = @"users/sign_in.json";
        NSURLRequest *request = [client requestWithMethod:@"POST" path:path parameters:params];
        
        AFJSONRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
            [[AFNetworkActivityIndicatorManager sharedManager] decrementActivityCount];
            
            NSDictionary *student = [(NSDictionary *) JSON valueForKey:@"student"];
                        
            NSString *email = [student valueForKey:@"email"];
            NSString *authToken = [JSON valueForKey:@"auth_token"];
            NSString *studentID = [student valueForKey:@"id"];
            NSString *companyID = [JSON valueForKey:@"company_id"];

            [[SSUser currentUser] registerUser:email withAuthToken:authToken ID:studentID andCompanyID:companyID];
            
            self.student = [NSEntityDescription insertNewObjectForEntityForName:@"Student"
                                                         inManagedObjectContext:self.context];
            
            NSDate *dateOfBirth;
            if([student valueForKey:@"date_of_birth"] == [NSNull null]) {
                dateOfBirth = nil;
            } else {
                NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
                [dateFormatter setDateFormat:@"yyyy-MM-dd"];
                dateOfBirth = [dateFormatter dateFromString:[student valueForKey:@"date_of_birth"]];
            }
            self.student.dateOfBirth = dateOfBirth;
                        
            NSString *firstName;
            if ([student valueForKey:@"first_name"] == [NSNull null]) {
                firstName = @"";
            } else {
                firstName = [student valueForKey:@"first_name"];
            }
            self.student.firstName = firstName;
            
            NSString *lastName;
            if ([student valueForKey:@"last_name"] == [NSNull null]) {
                lastName = @"";
            } else {
                lastName = [student valueForKey:@"last_name"];
            }
            self.student.lastName = lastName;
            
            NSString *phoneNumber;
            if ([student valueForKey:@"phone_number"] == [NSNull null]) {
                phoneNumber = @"";
            } else {
                phoneNumber = [student valueForKey:@"phone_number"];
            }
            self.student.phoneNumber = phoneNumber;
            
            NSString *phoneType;
            if ([student valueForKey:@"phone_type"] == [NSNull null]) {
                phoneType = @"";
            } else {
                phoneType = [student valueForKey:@"phone_type"];
            }
            self.student.phoneType = phoneType;
            
            NSString *preferredName;
            if ([student valueForKey:@"preferred_name"] == [NSNull null]) {
                preferredName = @"";
            } else {
                preferredName = [student valueForKey:@"preferred_name"];
            }
            self.student.preferredName = preferredName;
            
            NSString *gender;
            if ([student valueForKey:@"gender"] == [NSNull null]) {
                gender = @"";
            } else {
                gender = [student valueForKey:@"gender"];
            }
            self.student.gender = gender;
            
            self.student.email = email;
            self.student.studentID = [NSNumber numberWithInt:[studentID intValue]];
        
            NSError *error;
            if (![self.context save:&error]) {
                NSLog(@"Whoops, couldn't save: %@", [error localizedDescription]);
                [[SSUser currentUser] logOutAndPresentHUDInViewController:nil];
            } else {
                [self.delegate SSLogInViewController:self didLogInUser:[SSUser currentUser]];
            }
            
            [hud hide:YES];
        } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
            [[AFNetworkActivityIndicatorManager sharedManager] decrementActivityCount];
            [hud hide:YES];
            
            [self.delegate SSLogInViewController:self didFailToLogInWithError:(NSError *)error];
            [self.usernameTextField becomeFirstResponder];
        }];
        
        [operation start];
        [hud show:YES];
    }
}

- (void) recoverPasswordForEmail:(NSString *) email {
    
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.mode = MBProgressHUDModeIndeterminate;
    hud.labelText = NSLocalizedString(@"HUDLabelTextForgotPasswd", nil);
    
    CENTROAPIClient *client = [CENTROAPIClient sharedClient];
    [[AFNetworkActivityIndicatorManager sharedManager] setEnabled:YES];
    [[AFNetworkActivityIndicatorManager sharedManager] incrementActivityCount];
    
    NSDictionary *params = @{@"email": email};
    NSString *path = @"users/password.json";
    NSURLRequest *request = [client requestWithMethod:@"POST" path:path parameters:params];
    
    AFJSONRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
        [[AFNetworkActivityIndicatorManager sharedManager] decrementActivityCount];
        [hud hide:YES];
        [self.usernameTextField becomeFirstResponder];
        [[[UIAlertView alloc] initWithTitle:@"Success"
                                    message:@"Check your email for instructions on how to reset your password."
                                   delegate:nil
                          cancelButtonTitle:@"OK"
                          otherButtonTitles:nil] show];
    } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
        [[AFNetworkActivityIndicatorManager sharedManager] decrementActivityCount];
        [hud hide:YES];
        [self.usernameTextField becomeFirstResponder];
        [[[UIAlertView alloc] initWithTitle:@"Error"
                                    message:@"An unknown error has occurred. Try again later."
                                   delegate:nil
                          cancelButtonTitle:@"OK"
                          otherButtonTitles:nil] show];
    }];
    
    [operation start];
    [hud show:YES];

}

@end