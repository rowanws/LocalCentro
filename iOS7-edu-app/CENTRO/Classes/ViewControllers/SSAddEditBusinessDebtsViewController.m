//
//  SSAddEditBusinessDebtsViewController.m
//  CENTRO
//
//  Created by Centro Community Partners.
//  Copyright (c) 2013 Centro Community Partners. All rights reserved.
//

#import "SSAddEditBusinessDebtsViewController.h"
#import "SSAddBusinessDebtsTableViewController.h"
#import "CompanyDebt.h"
#import "SSUtils.h"

@interface SSAddEditBusinessDebtsViewController ()

@property (strong, nonatomic) NSManagedObjectContext *context;
@property BOOL isSureForCurrentAsset;

@end

@implementation SSAddEditBusinessDebtsViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {

    }
    return self;
}
- (IBAction)doneButtonPressed:(id)sender {
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"CompanyDebt"
                                              inManagedObjectContext:self.context];
    [fetchRequest setEntity:entity];
    
    [fetchRequest setPredicate:[NSPredicate predicateWithFormat:@"companyDebtCode = %@", self.companyDebt.companyDebtCode]];
    
    CompanyDebt *cd;
    
    NSError *error;
    NSArray *fetchedObjects = [self.context executeFetchRequest:fetchRequest error:&error];
    if (fetchedObjects.count == 0) {
        
    } else {
        cd = (CompanyDebt *) [fetchedObjects objectAtIndex:0];
    }
    
    cd.companyDebtCode = self.companyDebt.companyDebtCode;
    cd.amount = [NSNumber numberWithDouble:[self.editAmountTextField.text doubleValue]];
    cd.isSure = [NSNumber numberWithBool:self.isSureForCurrentAsset];
    cd.selectedAsDebt = [NSNumber numberWithBool:YES];
    
    [self.context save:nil];
    
    [self.navigationController popViewControllerAnimated:YES];
    
}



- (IBAction)isSureButtonPressed:(id)sender {    
    self.isSureForCurrentAsset = !self.isSureForCurrentAsset;
    [self drawSureButton];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //UIImage *bg = [UIImage imageNamed:@"bg.png"];
    //self.backgroundImageView.image = bg;
    self.backgroundImageView.contentMode = UIViewContentModeCenter;
    
    self.editNoteLabel.text = @"If you have more than one add their values together.";
    
    self.context = [(id)[[UIApplication sharedApplication] delegate] managedObjectContext];
    
    self.navigationItem.title = @"Bus. Debts";
    
    UIBarButtonItem *nextScreenBackButton = [[UIBarButtonItem alloc] initWithTitle:@"Try Again" style:UIBarButtonItemStyleBordered target:self action:nil];
    self.navigationItem.backBarButtonItem = nextScreenBackButton;

}

-(void) viewDidAppear:(BOOL)animated {
    
    [super viewDidAppear:animated];
    
    if(self.editingExistingDebt) {
        self.editItemLabel.text = [NSString stringWithFormat:@"Editing values for %@.", [(CompanyDebt *) self.companyDebt companyDebtLiteralUS]];
    } else {
        self.editItemLabel.text = [NSString stringWithFormat:@"How much does %@ owe on its %@?", [SSUtils companyName], [(CompanyDebt *) self.companyDebt companyDebtLiteralUS]];
    }
    
    self.editAmountTextField.text = [[(CompanyDebt *) self.companyDebt amount] stringValue];
    
    self.isSureForCurrentAsset = [[(CompanyDebt *) self.companyDebt isSure] boolValue];
    
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