//
//  SSLogInViewController.h
//  CENTRO
//
//  Created by Centro Community Partners.
//  Copyright (c) 2013 Centro Community Partners. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SSUser.h"

@protocol SSLogInViewControllerDelegate;

@interface SSLogInViewController : UIViewController <UITextFieldDelegate, UIAlertViewDelegate> {
    id <SSLogInViewControllerDelegate> _delegate;
}

@property (strong, nonatomic) id delegate;

@property (weak, nonatomic) IBOutlet UIImageView *backgroundImageView;
@property (weak, nonatomic) IBOutlet UITextField *usernameTextField;
@property (weak, nonatomic) IBOutlet UITextField *passwordTexfield;
@property (weak, nonatomic) IBOutlet UIButton *logInButton;
@property (weak, nonatomic) IBOutlet UIButton *signUpButton;
@property (weak, nonatomic) IBOutlet UIButton *forgotButton;

@end

@protocol SSLogInViewControllerDelegate <NSObject>

@required

- (BOOL)SSLogInViewController:(SSLogInViewController *)logInController shouldBeginLogInWithUsername:(NSString *)username password:(NSString *)password;

- (void)SSLogInViewController:(SSLogInViewController *)logInController didLogInUser:(SSUser *)user;

- (void)SSLogInViewController:(SSLogInViewController *)logInController didFailToLogInWithError:(NSError *)error;

- (void)SSLogInViewControllerDidCancelLogIn:(SSLogInViewController *)logInController;

@end