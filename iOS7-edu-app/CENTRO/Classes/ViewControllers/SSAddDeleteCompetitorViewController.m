//
//  SSAddDeleteCompetitorViewController.m
//  CENTRO
//
//  Created by Centro Community Partners.
//  Copyright (c) 2013 Centro Community Partners. All rights reserved.
//

#import "SSAddDeleteCompetitorViewController.h"
#import "CompetitorProfile.h"

@interface SSAddDeleteCompetitorViewController ()

@property (strong, nonatomic) NSManagedObjectContext *context;
@property (strong, nonatomic) CompetitorProfile *competitor;

@property BOOL edit;

@end

@implementation SSAddDeleteCompetitorViewController

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
            self.competitor.name = self.nameTextField.text;
        }
    } else {
        if ([self.nameTextField.text isEqualToString:@""]) {
            self.edit = NO;
        }
        if (self.edit) {
            self.competitor.name = self.nameTextField.text;
        } else {
            self.competitor.name = @"";
        }
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
    
    self.edit = NO;
    
    self.context = [(id)[[UIApplication sharedApplication] delegate] managedObjectContext];
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"CompetitorProfile"
                                              inManagedObjectContext:self.context];
    [fetchRequest setEntity:entity];
    
    [fetchRequest setPredicate:[NSPredicate predicateWithFormat:@"competitorProfileID = %@", self.competitorProfileID]];
    
    NSError *error;
    NSArray *fetchedObjects = [self.context executeFetchRequest:fetchRequest error:&error];
    
    if (fetchedObjects.count == 0) { 
        
    } else {
        self.competitor = (CompetitorProfile *) [fetchedObjects objectAtIndex:0];
        
        if(self.add) {
            self.navigationItem.title = @"Add Competitor";
            [self.addDeleteButton setTitle:@"Add Competitor" forState:UIControlStateNormal];
            self.questionLabel.text = @"Enter the name of the Competitor:";
            [self.nameTextField becomeFirstResponder];
        } else {
            self.navigationItem.title = @"Delete Competitor";
            [self.addDeleteButton setTitle:@"Delete Competitor" forState:UIControlStateNormal];
            self.questionLabel.text = @"Are you sure you want to delete this Competitor?";
            //self.nameTextField.enabled = NO;
        }
        
        self.nameTextField.text = self.competitor.name;
        self.nameTextField.delegate = self;
    }
}

-(void) textFieldDidBeginEditing:(UITextField *)textField {
    
    if(!self.add) {
        self.navigationItem.title = @"Edit Competitor";
        [self.addDeleteButton setTitle:@"Edit Competitor" forState:UIControlStateNormal];
        self.questionLabel.text = @"Are you sure you want to edit this Competitor?";
        self.edit = YES;
    }
    
}

-(BOOL) textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    
    if ([[textField.text stringByReplacingCharactersInRange:range withString:string] isEqualToString:@""]) {
        self.edit = NO;
        self.navigationItem.title = @"Delete Competitor";
        [self.addDeleteButton setTitle:@"Delete Competitor" forState:UIControlStateNormal];
        self.questionLabel.text = @"Are you sure you want to delete this Competitor?";
    }
    
    return YES;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    [self.nameTextField resignFirstResponder];
}

@end