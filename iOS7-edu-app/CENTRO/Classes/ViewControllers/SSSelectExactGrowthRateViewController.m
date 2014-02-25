//
//  SSSelectExactGrowthRateViewController.m
//  CENTRO
//
//  Created by Centro Community Partners.
//  Copyright (c) 2013 Centro Community Partners. All rights reserved.
//

#import "SSSelectExactGrowthRateViewController.h"
#import "SSUser.h"
#import "Industry.h"

@interface SSSelectExactGrowthRateViewController ()

@property (strong, nonatomic) NSManagedObjectContext *context;
@property double offSetForKeyboard;
@property BOOL isGrowing;

@property (strong, nonatomic) Industry *industry;

@end

@implementation SSSelectExactGrowthRateViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {

    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
   // UIImage *bg40 = [UIImage imageNamed:@"bg-568h@2x.png"];
   // UIImage *bg35R = [UIImage imageNamed:@"bg.png"];
    
    //CGRect screenBounds = [[UIScreen mainScreen] bounds];
    //if (screenBounds.size.height == 568) {
    //    self.backgroundImageView.image = bg40;
    //} else {
    //    self.backgroundImageView.image = bg35R;
    //}
    
    self.questionLabel.text = @"Your industry is...";
    
    [self.growthButton setTitle:@"Growing" forState:UIControlStateNormal];
    [self.shrinkButton setTitle:@"Shrinking" forState:UIControlStateNormal];
    
    self.growthLabel.text = @"At a rate of:";
    
    self.frequencyLabel.text = @"percent per year.";
    
    self.offSetForKeyboard = 125.0;
    self.context = [(id)[[UIApplication sharedApplication] delegate] managedObjectContext];
}

-(void) viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    if(![[SSUser currentUser] isLoggedIn]) {
        [self.navigationController popToRootViewControllerAnimated:YES];
    } else {
        
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(keyboardWillShow)
                                                     name:UIKeyboardWillShowNotification
                                                   object:nil];
        
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(keyboardWillHide)
                                                     name:UIKeyboardWillHideNotification
                                                   object:nil];
        
        NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
        
        NSEntityDescription *entity = [NSEntityDescription entityForName:@"Industry"
                                                  inManagedObjectContext:self.context];
        [fetchRequest setEntity:entity];
        
        [fetchRequest setPredicate:[NSPredicate predicateWithFormat:@"companyID = %@", [[SSUser currentUser] companyID]]];
        
        NSError *error;
        NSArray *fetchedObjects = [self.context executeFetchRequest:fetchRequest error:&error];
        if (fetchedObjects.count == 0) {
            
        } else {
            self.industry = (Industry *) [fetchedObjects objectAtIndex:0];
        }
        
        NSString *amount = [[self.industry.growthRate stringValue] stringByReplacingOccurrencesOfString:@"-" withString:@""];
        
        self.growthAmountTextField.text = amount;
        
        if([self.industry.growthRate doubleValue] < 0) {
            self.isGrowing = NO;
            [self shrinkButtonPressed:self];
        } else if([self.industry.growthRate doubleValue] > 0) {
            self.isGrowing = YES;
            [self growthButtonPressed:self];
        } else {
            self.isGrowing = YES;
            [self growthButtonPressed:self];
        }
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (IBAction)growthButtonPressed:(id)sender {
    self.growthLabel.text = @"Growing at a rate of:";
    self.isGrowing = YES;
}
- (IBAction)shrinkButtonPressed:(id)sender {
    self.growthLabel.text = @"Shrinking at a rate of:";
    self.isGrowing = NO;
}
- (IBAction)nextButtonPressed:(id)sender {
    [self.growthAmountTextField resignFirstResponder];
    
    
    if(self.isGrowing) {
        self.industry.growthRate = [NSNumber numberWithDouble:[self.growthAmountTextField.text doubleValue]];
    } else {
        self.industry.growthRate = [NSNumber numberWithDouble:[self.growthAmountTextField.text doubleValue] * -1];
    }
    
    if ([self.growthAmountTextField.text doubleValue] == 0 ) {
        [[[UIAlertView alloc] initWithTitle:@"Selection Error"
                                    message:@"You need to enter a growth rate."
                                   delegate:nil
                          cancelButtonTitle:@"OK"
                          otherButtonTitles:nil] show];
    } else {
        [self.context save:nil];
        [self performSegueWithIdentifier:@"SelectMarketAgeFromExactGrowthRate" sender:self];
    }
    
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    
    [self.growthAmountTextField resignFirstResponder];
}

//-(void) keyboardFrame {
//    NSDictionary *d = [[NSNotificationCenter defaultCenter] userInfo];
//    CGRect r = [d[UIKeyboardFrameEndUserInfoKey] CGRectValue];
//
//    NSLog(@"H: %f", r.size.height);
//}

-(void)keyboardWillShow {
    
    if (self.view.frame.origin.y >= 0)
    {
        [self setViewMovedUp:YES];
    }
    else if (self.view.frame.origin.y < 0)
    {
        [self setViewMovedUp:NO];
    }
}

-(void)keyboardWillHide {
    if (self.view.frame.origin.y >= 0)
    {
        [self setViewMovedUp:YES];
    }
    else if (self.view.frame.origin.y < 0)
    {
        [self setViewMovedUp:NO];
    }
}

-(void)textFieldDidBeginEditing:(UITextField *)sender
{
    if ([sender isEqual:self.growthAmountTextField])
    {
        if  (self.view.frame.origin.y >= 0)
        {
            [self setViewMovedUp:YES];
        }
    }
}


-(void)setViewMovedUp:(BOOL)movedUp
{
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.3];
    
    CGRect rect = self.view.frame;
    if (movedUp)
    {
        rect.origin.y -= self.offSetForKeyboard;
        rect.size.height += self.offSetForKeyboard;
    }
    else
    {
        rect.origin.y += self.offSetForKeyboard;
        rect.size.height -= self.offSetForKeyboard;
    }
    self.view.frame = rect;
    
    [UIView commitAnimations];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    NSArray *viewControllers = self.navigationController.viewControllers;
    if (viewControllers.count > 1 && [viewControllers objectAtIndex:viewControllers.count-2] == self) {
        [self.context save:nil];
    } else if ([viewControllers indexOfObject:self] == NSNotFound) {
        [self.context reset];
    } else {
        
        [self.context save:nil];
    }
    
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIKeyboardWillShowNotification
                                                  object:nil];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIKeyboardWillHideNotification
                                                  object:nil];
}

@end