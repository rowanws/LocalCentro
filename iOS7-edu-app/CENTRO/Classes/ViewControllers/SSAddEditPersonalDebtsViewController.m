//
//  SSAddEditPersonalDebtsViewController.m
//  CENTRO
//
//  Created by Centro Community Partners.
//  Copyright (c) 2013 Centro Community Partners. All rights reserved.
//

#import "SSAddEditPersonalDebtsViewController.h"
#import "SSAddPersonalDebtsTableViewController.h"
#import "StudentDebt.h"

@interface SSAddEditPersonalDebtsViewController ()

@property (strong, nonatomic) NSManagedObjectContext *context;
@property BOOL isSureForCurrentAsset;

@end

@implementation SSAddEditPersonalDebtsViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {

    }
    return self;
}
- (IBAction)doneButtonPressed:(id)sender {
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"StudentDebt"
                                              inManagedObjectContext:self.context];
    [fetchRequest setEntity:entity];
    
    [fetchRequest setPredicate:[NSPredicate predicateWithFormat:@"studentDebtCode = %@", self.studentDebt.studentDebtCode]];
    
    StudentDebt *sd;
    
    NSError *error;
    NSArray *fetchedObjects = [self.context executeFetchRequest:fetchRequest error:&error];
    if (fetchedObjects.count == 0) {
        
    } else {
        sd = (StudentDebt *) [fetchedObjects objectAtIndex:0];
    }
    
    sd.studentDebtCode = self.studentDebt.studentDebtCode;
    sd.amount = [NSNumber numberWithDouble:[self.editAmountTextField.text doubleValue]];
    sd.isSure = [NSNumber numberWithBool:self.isSureForCurrentAsset];
    sd.selectedAsDebt = [NSNumber numberWithBool:YES];
    
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
    
    self.context = [(id)[[UIApplication sharedApplication] delegate] managedObjectContext];
    
    self.navigationItem.title = @"Personal Debts";
    
    UIBarButtonItem *nextScreenBackButton = [[UIBarButtonItem alloc] initWithTitle:@"Try Again" style:UIBarButtonItemStyleBordered target:self action:nil];
    self.navigationItem.backBarButtonItem = nextScreenBackButton;

}

-(void) viewDidAppear:(BOOL)animated {
    
    [super viewDidAppear:animated];
    
    if(self.editingExistingDebt) {
        self.editItemLabel.text = [NSString stringWithFormat:@"Editing values for %@.", [(StudentDebt *) self.studentDebt studentDebtLiteralUS]];
    } else {
        self.editItemLabel.text = [NSString stringWithFormat:@"How much do you owe for %@?", [(StudentDebt *) self.studentDebt studentDebtLiteralUS]];
    }
    
    self.editAmountTextField.text = [[(StudentDebt *) self.studentDebt amount] stringValue];
    
    self.isSureForCurrentAsset = [[(StudentDebt *) self.studentDebt isSure] boolValue];
    
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