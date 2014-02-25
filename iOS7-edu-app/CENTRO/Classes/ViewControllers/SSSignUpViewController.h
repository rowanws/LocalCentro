//
//  SSSignUpViewController.h
//  CENTRO
//
//  Created by Centro Community Partners.
//  Copyright (c) 2013 Centro Community Partners. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SSUser.h"

@protocol SSSignUpViewControllerDelegate;

@interface SSSignUpViewController : UIViewController <UITextFieldDelegate> {
    id <SSSignUpViewControllerDelegate> _delegate;
}

@property (strong, nonatomic) id delegate;

@property (weak, nonatomic) IBOutlet UIImageView *backgroundImageView;
@property (weak, nonatomic) IBOutlet UITextField *usernameTextField;
@property (weak, nonatomic) IBOutlet UITextField *passwordTexfield;
@property (weak, nonatomic) IBOutlet UITextField *confirmPasswordTextField;

@property (weak, nonatomic) IBOutlet UIButton *signUpButton;

@end

@protocol SSSignUpViewControllerDelegate <NSObject>

@required

- (BOOL)SSSignUpViewController:(SSSignUpViewController *)signUpController shouldBeginSignUp:(NSDictionary *)info;

- (void)SSSignUpViewController:(SSSignUpViewController *)signUpController didSignUpUser:(SSUser *)user;

- (void)SSSignUpViewController:(SSSignUpViewController *)signUpController didFailToSignUpWithError:(NSError *)error;

- (void)SSSignUpViewControllerDidCancelSignUp:(SSSignUpViewController *)signUpController;

@end