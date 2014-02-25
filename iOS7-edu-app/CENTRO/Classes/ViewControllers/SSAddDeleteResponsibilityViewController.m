//
//  SSAddDeleteResponsibilityViewController.m
//  CENTRO
//
//  Created by Centro Community Partners.
//  Copyright (c) 2013 Centro Community Partners. All rights reserved.
//

#import "SSAddDeleteResponsibilityViewController.h"
#import "Responsibility.h"

@interface SSAddDeleteResponsibilityViewController ()

@property (strong, nonatomic) NSManagedObjectContext *context;

@end

@implementation SSAddDeleteResponsibilityViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {

    }
    return self;
}

- (IBAction)addDeleteButtonPressed:(id)sender {
    
    [self.nameTextField resignFirstResponder];
    
    if(self.add) {
        if(![self.nameTextField.text isEqualToString:@""]) {
            self.responsibility.responsibilityDescription = self.nameTextField.text;
            self.responsibility.selectedAsResponsibility = [NSNumber numberWithBool:YES];
        }
    } else {
        self.responsibility.responsibilityDescription = @"";
        self.responsibility.selectedAsResponsibility = [NSNumber numberWithBool:NO];
    }
    
    [self.context save:nil];
    
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    //UIImage *bg40 = [UIImage imageNamed:@"bg-568h@2x.png"];
    //UIImage *bg35R = [UIImage imageNamed:@"bg.png"];
    
    //CGRect screenBounds = [[UIScreen mainScreen] bounds];
    //if (screenBounds.size.height == 568) {
    //    self.backgroundImageView.image = bg40;
    //} else {
    //    self.backgroundImageView.image = bg35R;
    //}
    
    self.context = [(id)[[UIApplication sharedApplication] delegate] managedObjectContext];
    
    if(self.add) {
        self.navigationItem.title = @"Add Activity";
        [self.addDeleteButton setTitle:@"Add Activity" forState:UIControlStateNormal];
        self.questionLabel.text = @"Enter the Activity:";
    } else {
        self.navigationItem.title = @"Delete Activity";
        [self.addDeleteButton setTitle:@"Delete Activity" forState:UIControlStateNormal];
        self.questionLabel.text = @"Are you sure you want to delete this Activity?";
        self.nameTextField.enabled = NO;
    }
    
    self.nameTextField.text = self.responsibility.responsibilityDescription;
    [self.nameTextField becomeFirstResponder];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    [self.nameTextField resignFirstResponder];
}

@end