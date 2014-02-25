//
//  SSSignUpViewController.m
//  CENTRO
//
//  Created by Centro Community Partners.
//  Copyright (c) 2013 Centro Community Partners. All rights reserved.
//

#import "SSSignUpViewController.h"
#import "MBProgressHUD.h"
#import "CENTROAPIClient.h"
#import "SSUtils.h"

@interface SSSignUpViewController ()

@end

@implementation SSSignUpViewController

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
    
    self.usernameTextField.delegate = self;
    self.passwordTexfield.delegate = self;
    self.confirmPasswordTextField.delegate = self;

}

- (void) viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self.usernameTextField becomeFirstResponder];
}

- (IBAction)signUpButtonPressed:(id)sender {
    [self signUp];
    
}

- (IBAction)closeButtonPressed:(id)sender {
    [self.delegate SSSignUpViewControllerDidCancelSignUp:self];
    
}

#pragma mark - UITextFieldDelegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    if (textField.tag == 4003) {
        [self.passwordTexfield becomeFirstResponder];
    } else if (textField.tag == 4004){
        [self.confirmPasswordTextField becomeFirstResponder];
    } else {
        [self signUp];
    }
    return YES;
}

#pragma mark - Business Methods

-(void) signUp {
    
    NSDictionary *dict = [[NSDictionary alloc] initWithObjectsAndKeys:
                          self.usernameTextField.text, @"username",
                          self.passwordTexfield.text, @"password",
                          self.confirmPasswordTextField.text, @"confirmPassword", nil];
    
    BOOL shouldSignUp = [self.delegate SSSignUpViewController:self shouldBeginSignUp:dict];
    
    if(shouldSignUp) {
        
        [self.usernameTextField resignFirstResponder];
        [self.passwordTexfield resignFirstResponder];
        [self.confirmPasswordTextField resignFirstResponder];
        
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        hud.mode = MBProgressHUDModeIndeterminate;
        hud.labelText = NSLocalizedString(@"HUDLabelTextSignUp", nil);
        
        CENTROAPIClient *client = [CENTROAPIClient sharedClient];
        [[AFNetworkActivityIndicatorManager sharedManager] setEnabled:YES];
        [[AFNetworkActivityIndicatorManager sharedManager] incrementActivityCount];
        
        NSString *path = [NSString stringWithFormat:@"users/sign_up.json/?admin=no&email=%@&password=%@", self.usernameTextField.text, self.passwordTexfield.text];
        NSURLRequest *request = [client requestWithMethod:@"GET" path:path parameters:nil];
        
        AFJSONRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
            [[AFNetworkActivityIndicatorManager sharedManager] decrementActivityCount];
            [hud hide:YES];
            
            [[[UIAlertView alloc] initWithTitle:@"Success"
                                        message:@"A confirmation email has been sent to you. To access your account, open the email and follow the instructions."
                                       delegate:nil
                              cancelButtonTitle:@"OK"
                              otherButtonTitles:nil] show];
            
            [self.delegate SSSignUpViewController:self didSignUpUser:[SSUser currentUser]];
        }failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
            [[AFNetworkActivityIndicatorManager sharedManager] decrementActivityCount];
            [hud hide:YES];

            [self.delegate SSSignUpViewController:self didFailToSignUpWithError:(NSError *)error];
            [self.usernameTextField becomeFirstResponder];
        }];
        
        [operation start];
        [hud show:YES];
    }
}

@end