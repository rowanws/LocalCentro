//
//  SSAddDeleteProductViewController.m
//  CENTRO
//
//  Created by Centro Community Partners.
//  Copyright (c) 2013 Centro Community Partners. All rights reserved.
//

#import "SSAddDeleteProductViewController.h"
#import "Product.h"

@interface SSAddDeleteProductViewController ()

@property (strong, nonatomic) NSManagedObjectContext *context;
@property (strong, nonatomic) Product *product;

@property BOOL edit;

@end

@implementation SSAddDeleteProductViewController

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
            self.product.name = self.nameTextField.text;
            self.product.selectedAsItem = [NSNumber numberWithBool:YES];
            self.product.categoryID = self.categoryID;
        }
    } else {
        
        if ([self.nameTextField.text isEqualToString:@""]) {
            self.edit = NO;
        }
        
        if (self.edit) {
            self.product.name = self.nameTextField.text;
        } else {
            self.product.name = @"";
            self.product.selectedAsItem = [NSNumber numberWithBool:NO];
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
    
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Product"
                                              inManagedObjectContext:self.context];
    [fetchRequest setEntity:entity];
    
    [fetchRequest setPredicate:[NSPredicate predicateWithFormat:@"productID = %@", self.productID]];
    
    NSError *error;
    NSArray *fetchedObjects = [self.context executeFetchRequest:fetchRequest error:&error];
    
    if (fetchedObjects.count == 0) { 
        
    } else {
        self.product = (Product *) [fetchedObjects objectAtIndex:0];
        
        if(self.add) {
            self.navigationItem.title = @"Add Product";
            [self.addDeleteButton setTitle:@"Add Product" forState:UIControlStateNormal];
            self.questionLabel.text = @"Enter the name of the Product:";
            [self.nameTextField becomeFirstResponder];
        } else {
            self.navigationItem.title = @"Delete Product";
            [self.addDeleteButton setTitle:@"Delete Product" forState:UIControlStateNormal];
            self.questionLabel.text = @"Are you sure you want to delete this Product?";
        }
        
        self.nameTextField.text = self.product.name;
        self.nameTextField.delegate = self;
    }
}

-(void) textFieldDidBeginEditing:(UITextField *)textField {
    
    if(!self.add) {
        self.navigationItem.title = @"Edit Product";
        [self.addDeleteButton setTitle:@"Edit Product" forState:UIControlStateNormal];
        self.questionLabel.text = @"Are you sure you want to edit this Product?";
        self.edit = YES;
    }
    
}

-(BOOL) textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    
    if ([[textField.text stringByReplacingCharactersInRange:range withString:string] isEqualToString:@""]) {
        self.edit = NO;
        self.navigationItem.title = @"Delete Product";
        [self.addDeleteButton setTitle:@"Delete Product" forState:UIControlStateNormal];
        self.questionLabel.text = @"Are you sure you want to delete this Product?";
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