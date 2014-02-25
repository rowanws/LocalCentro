//
//  SSAddDeleteCategoryViewController.m
//  CENTRO
//
//  Created by Centro Community Partners.
//  Copyright (c) 2013 Centro Community Partners. All rights reserved.
//

#import "SSAddDeleteCategoryViewController.h"
#import "Category.h"
#import "Product.h"

@interface SSAddDeleteCategoryViewController ()

@property (strong, nonatomic) NSManagedObjectContext *context;
@property (strong, nonatomic) Category *category;

@property BOOL edit;

@end

@implementation SSAddDeleteCategoryViewController

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
            self.category.name = self.nameTextField.text;
            self.category.selectedAsCategory = [NSNumber numberWithBool:YES];
        }
    } else {
        if ([self.nameTextField.text isEqualToString:@""]) {
            self.edit = NO;
        }
        if (self.edit) {
            self.category.name = self.nameTextField.text;
        } else {
            self.category.name = @"";
            self.category.selectedAsCategory = [NSNumber numberWithBool:NO];
            
            NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
            
            NSEntityDescription *entity = [NSEntityDescription entityForName:@"Product"
                                                      inManagedObjectContext:self.context];
            [fetchRequest setEntity:entity];
            
            [fetchRequest setPredicate:[NSPredicate predicateWithFormat:@"categoryID = %@", self.categoryID]];
            
            NSError *error;
            NSArray *fetchedObjects = [self.context executeFetchRequest:fetchRequest error:&error];
            
            if (fetchedObjects.count == 0) { 
                
            } else {
                for (Product *p in fetchedObjects) {
                    p.selectedAsItem = [NSNumber numberWithBool:NO];
                    p.name = @"";
                }
            }
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
    
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Category"
                                              inManagedObjectContext:self.context];
    [fetchRequest setEntity:entity];
    
    [fetchRequest setPredicate:[NSPredicate predicateWithFormat:@"categoryID = %@", self.categoryID]];
    
    NSError *error;
    NSArray *fetchedObjects = [self.context executeFetchRequest:fetchRequest error:&error];
    
    if (fetchedObjects.count == 0) { 
        
    } else {
        self.category = (Category *) [fetchedObjects objectAtIndex:0];
        
        if(self.add) {
            self.navigationItem.title = @"Add Category";
            [self.addDeleteButton setTitle:@"Add Category" forState:UIControlStateNormal];
            self.questionLabel.text = @"Enter the name of the Category:";
            [self.nameTextField becomeFirstResponder];
        } else {
            self.navigationItem.title = @"Delete Category";
            [self.addDeleteButton setTitle:@"Delete Category" forState:UIControlStateNormal];
            self.questionLabel.text = @"Are you sure you want to delete this Category?";
        }
        
        self.nameTextField.text = self.category.name;
        self.nameTextField.delegate = self;
    }
}

-(void) textFieldDidBeginEditing:(UITextField *)textField {
    
    if(!self.add) {
        self.navigationItem.title = @"Edit Category";
        [self.addDeleteButton setTitle:@"Edit Category" forState:UIControlStateNormal];
        self.questionLabel.text = @"Are you sure you want to edit this Category?";
        self.edit = YES;
    }
    
}

-(BOOL) textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    
    if ([[textField.text stringByReplacingCharactersInRange:range withString:string] isEqualToString:@""]) {
        self.edit = NO;
        self.navigationItem.title = @"Delete Category";
        [self.addDeleteButton setTitle:@"Delete Category" forState:UIControlStateNormal];
        self.questionLabel.text = @"Are you sure you want to delete this Category?";
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