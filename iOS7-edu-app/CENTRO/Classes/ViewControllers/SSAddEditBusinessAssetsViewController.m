//
//  SSAddEditBusinessAssetsViewController.m
//  CENTRO
//
//  Created by Centro Community Partners.
//  Copyright (c) 2013 Centro Community Partners. All rights reserved.
//

#import "SSAddEditBusinessAssetsViewController.h"
#import "SSAddBusinessAssetsTableViewController.h"
#import "CompanyAsset.h"
#import "SSUtils.h"

@interface SSAddEditBusinessAssetsViewController ()

@property (strong, nonatomic) NSManagedObjectContext *context;
@property BOOL isSureForCurrentAsset;

@end

@implementation SSAddEditBusinessAssetsViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {

    }
    return self;
}
- (IBAction)doneButtonPressed:(id)sender {
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"CompanyAsset"
                                              inManagedObjectContext:self.context];
    [fetchRequest setEntity:entity];
    
    [fetchRequest setPredicate:[NSPredicate predicateWithFormat:@"companyAssetCode = %@", self.companyAsset.companyAssetCode]];
    
    CompanyAsset *ca;
    
    NSError *error;
    NSArray *fetchedObjects = [self.context executeFetchRequest:fetchRequest error:&error];
    if (fetchedObjects.count == 0) {
        
    } else {
        ca = (CompanyAsset *) [fetchedObjects objectAtIndex:0];
    }
    
    ca.companyAssetCode = self.companyAsset.companyAssetCode;
    ca.amount = [NSNumber numberWithDouble:[self.editAmountTextField.text doubleValue]];
    ca.isSure = [NSNumber numberWithBool:self.isSureForCurrentAsset];
    ca.selectedAsAsset = [NSNumber numberWithBool:YES];
    
    [self.context save:nil];
    
    [self.navigationController popViewControllerAnimated:YES];
    
}

- (IBAction)isSureButtonPressed:(id)sender {
    self.isSureForCurrentAsset = !self.isSureForCurrentAsset;
    [self drawSureButton];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIImage *bg = [UIImage imageNamed:@"bg.png"];
    self.backgroundImageView.image = bg;
    self.backgroundImageView.contentMode = UIViewContentModeCenter;
    
    self.editNoteLabel.text = @"If you have more than one add their values together.";
    
    self.navigationItem.title = @"Bus. Assets";
    
    self.context = [(id)[[UIApplication sharedApplication] delegate] managedObjectContext];
    
    UIBarButtonItem *nextScreenBackButton = [[UIBarButtonItem alloc] initWithTitle:@"Try Again" style:UIBarButtonItemStyleBordered target:self action:nil];
    self.navigationItem.backBarButtonItem = nextScreenBackButton;

}

-(void) viewDidAppear:(BOOL)animated {
    
    [super viewDidAppear:animated];
    
    if(self.editingExistingAsset) {
        self.editItemLabel.text = [NSString stringWithFormat:@"Editing values for %@.", [(CompanyAsset *) self.companyAsset companyAssetLiteralUS]];
    } else {
        self.editItemLabel.text = [NSString stringWithFormat:@"How much is %@'s %@ worth?", [SSUtils companyName], [(CompanyAsset *) self.companyAsset companyAssetLiteralUS]];
    }
    
    self.editAmountTextField.text = [[(CompanyAsset *) self.companyAsset amount] stringValue];
    
    self.isSureForCurrentAsset = [[(CompanyAsset *) self.companyAsset isSure] boolValue];
    
    [self drawSureButton];
}

-(void) drawSureButton {
    if(!self.isSureForCurrentAsset) {
        [self.self.editIsSureButton setTitle:@"☑ I'm not sure yet" forState:UIControlStateNormal];
    } else {
        [self.self.editIsSureButton setTitle:@"☐ I'm not sure yet" forState:UIControlStateNormal];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    
    [self.editAmountTextField resignFirstResponder];
    
}

@end