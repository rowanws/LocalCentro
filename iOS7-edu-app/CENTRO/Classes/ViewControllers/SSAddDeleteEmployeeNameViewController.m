//
//  SSAddDeleteEmployeeNameViewController.m
//  CENTRO
//
//  Created by Centro Community Partners.
//  Copyright (c) 2013 Centro Community Partners. All rights reserved.
//

#import "SSAddDeleteEmployeeNameViewController.h"
#import "Employee.h"

@interface SSAddDeleteEmployeeNameViewController ()

@property (strong, nonatomic) NSManagedObjectContext *context;

@end

@implementation SSAddDeleteEmployeeNameViewController

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
            self.employee.name = self.nameTextField.text;
        }
    } else {
        self.employee.name = @"";
        self.employee.earning = [NSNumber numberWithDouble:0.0];
        self.employee.earningFrequency = [NSNumber numberWithInt:0];
        self.employee.manager = [NSNumber numberWithBool:NO];
        self.employee.professionalExperience = [NSNumber numberWithInt:0];
        self.employee.weeksWork = [NSNumber numberWithInt:0];
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
        self.navigationItem.title = @"Add Employee";
        [self.addDeleteButton setTitle:@"Add Employee" forState:UIControlStateNormal];
        self.questionLabel.text = @"Enter the name of the Employee:";
    } else {
        self.navigationItem.title = @"Delete Employee";
        [self.addDeleteButton setTitle:@"Delete Employee" forState:UIControlStateNormal];
        self.questionLabel.text = @"Are you sure you want to delete this Employee?";
        self.nameTextField.enabled = NO;
    }
    
    self.nameTextField.text = self.employee.name;
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