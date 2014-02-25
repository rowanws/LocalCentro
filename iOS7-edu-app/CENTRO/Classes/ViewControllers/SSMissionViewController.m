//
//  SSMissionViewController.m
//  CENTRO
//
//  Created by Centro Community Partners.
//  Copyright (c) 2013 Centro Community Partners. All rights reserved.
//

#import "SSMissionViewController.h"
#import "SSUser.h"
#import "Company.h"
#import "Mission.h"
#import "Vision.h"
#import "SSConfirmEditMisionViewController.h"

@interface SSMissionViewController ()

@property (strong, nonatomic) NSManagedObjectContext *context;
@property (strong, nonatomic) NSString *companyName;
@property (strong, nonatomic) Company *company;
@property (strong, nonatomic) Mission *mission;
@property (strong, nonatomic) Vision *vision;
@property (strong, nonatomic) NSString *missionText;
@property double offSetForKeyboard;

@end

@implementation SSMissionViewController

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
    
    //UIImage *bg40 = [UIImage imageNamed:@"bg-568h@2x.png"];
    //UIImage *bg35R = [UIImage imageNamed:@"bg.png"];
    
    //CGRect screenBounds = [[UIScreen mainScreen] bounds];
    //if (screenBounds.size.height == 568) {
    //    self.backgroundImageView.image = bg40;
    //    self.offSetForKeyboard = 0.0;
    //} else {
    //    self.backgroundImageView.image = bg35R;
    //    self.offSetForKeyboard = 80.0;
    //}
    
    self.context = [(id)[[UIApplication sharedApplication] delegate] managedObjectContext];
    
    
        [super viewDidLoad];
        // Do any additional setup after loading the view, typically from a nib.


    
    self.navigationItem.title = @"Mission";
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Company"
                                              inManagedObjectContext:self.context];
    [fetchRequest setEntity:entity];
    
    [fetchRequest setPredicate:[NSPredicate predicateWithFormat:@"companyID = %@", [[SSUser currentUser] companyID]]];
    
    NSError *error;
    NSArray *fetchedObjects = [self.context executeFetchRequest:fetchRequest error:&error];
    if (fetchedObjects.count == 0) {
        
    } else {
        self.company = (Company *) [fetchedObjects objectAtIndex:0];
    }
    
    if (self.company.name.length == 0) {
        self.companyName = @"your company";
    } else {
        self.companyName = self.company.name;
    }
        
    self.mission = self.company.mission;
    
    self.vision = self.company.vision;

    self.visionTextView.text = [NSString stringWithFormat:@"Vision:\n%@", self.vision.vision];
    
    self.missionLabel.text = [NSString stringWithFormat:@"To achieve its vision, %@ needs to...", self.companyName];
    self.missionTextView.text = self.mission.mission;
}

-(void) viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    if(![[SSUser currentUser] isLoggedIn]) {
        [self.navigationController popToRootViewControllerAnimated:YES];
    }
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShow)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillHide)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];
}

- (IBAction)nextButtonPressed:(id)sender {
    
    [self.missionTextView resignFirstResponder];
    
    self.missionText = self.missionTextView.text;
    self.mission.mission = self.missionText;
    
    NSError *error;
    if (![self.context save:&error]) {
        NSLog(@"Whoops, couldn't save: %@", [error localizedDescription]);
    } else {
        [self performSegueWithIdentifier:@"ConfirmEditMission" sender:self];
    }
}


- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if([[segue identifier] isEqualToString:@"ConfirmEditMission"]) {
        SSConfirmEditMisionViewController *destinationVC = [segue destinationViewController];
        [destinationVC setMission:self.missionText];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    
    [self.missionTextView resignFirstResponder];
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
    if ([sender isEqual:self.missionTextView])
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

-(IBAction)dismissVC{
    [self dismissViewControllerAnimated:YES completion:NULL];
}



@end
