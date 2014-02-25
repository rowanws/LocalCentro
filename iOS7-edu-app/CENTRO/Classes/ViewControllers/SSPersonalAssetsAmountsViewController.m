//
//  SSPersonalAssetsAmountsViewController.m
//  CENTRO
//
//  Created by Centro Community Partners.
//  Copyright (c) 2013 Centro Community Partners. All rights reserved.
//

#import "SSPersonalAssetsAmountsViewController.h"
#import "SSUser.h"
#import "StudentAsset.h"
#import "SSPersonalAssetsTableViewController.h"

@interface SSPersonalAssetsAmountsViewController ()

@property (strong, nonatomic) NSManagedObjectContext *context;
@property (strong, nonatomic) NSArray *assets;

@property BOOL isSureForCurrentAsset;
@property int currentAssetPos;

@end

@implementation SSPersonalAssetsAmountsViewController


- (IBAction)nextButtonPressed:(id)sender {
    [self saveCurrent];
    self.currentAssetPos++;
    if (self.currentAssetPos < self.assets.count) {
        [self continueAsking];
    } else {
        [self.context save:nil];
        [self performSegueWithIdentifier:@"PersonalAssets" sender:self];
    }
}

- (IBAction)backButtonPressed:(id)sender {
    [self saveCurrent];
    self.currentAssetPos--;
    [self continueAsking];
}

- (IBAction)sureButtonPressed:(id)sender {
    self.isSureForCurrentAsset = !self.isSureForCurrentAsset;
    [self drawSureButton];

}

-(void) viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    if(![[SSUser currentUser] isLoggedIn]) {
        [self.navigationController popToRootViewControllerAnimated:YES];
    }
}

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
    
    //UIImage *bg = [UIImage imageNamed:@"bg.png"];
    //self.backgroundImageView.image = bg;
    self.backgroundImageView.contentMode = UIViewContentModeCenter;
    
    self.context = [(id)[[UIApplication sharedApplication] delegate] managedObjectContext];
    
    self.navigationItem.title = @"Personal Assets";
    
    self.noteLabel.text = @"If you have more than one add their values together.";
    
    UIBarButtonItem *nextScreenBackButton = [[UIBarButtonItem alloc] initWithTitle:@"Try Again" style:UIBarButtonItemStyleBordered target:self action:nil];
    self.navigationItem.backBarButtonItem = nextScreenBackButton;

}

-(void) viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    self.currentAssetPos = 0;
    
    NSFetchRequest *studentAssetFetchRequest = [[NSFetchRequest alloc] init];
    
    NSEntityDescription *studentAssetEntity = [NSEntityDescription entityForName:@"StudentAsset"
                                                         inManagedObjectContext:self.context];
    [studentAssetFetchRequest setEntity:studentAssetEntity];
    
    [studentAssetFetchRequest setPredicate:[NSPredicate predicateWithFormat:@"studentID = %@ AND selectedAsAsset = 1", [[SSUser currentUser] studentID]]];
    
    studentAssetFetchRequest.sortDescriptors = [NSArray arrayWithObject:[NSSortDescriptor sortDescriptorWithKey:@"studentAssetID" ascending:YES selector:nil]];
    
    NSError *errorSV;
    self.assets = [self.context executeFetchRequest:studentAssetFetchRequest error:&errorSV];
    
    if (self.assets.count == 0) {
        [self performSegueWithIdentifier:@"PersonalAssets" sender:self];
    } else {
        
        self.amountTextField.text = [[(StudentAsset *) [self.assets objectAtIndex:self.currentAssetPos] amount] stringValue];
        self.questionLabel.text = [NSString stringWithFormat:@"What is your %@ worth?", [(StudentAsset *) [self.assets objectAtIndex:self.currentAssetPos] studentAssetLiteralUS]];
        self.isSureForCurrentAsset = [[(StudentAsset *) [self.assets objectAtIndex:self.currentAssetPos] isSure] boolValue];
        [self drawSureButton];
        self.backButton.hidden = YES;
    }

}

-(void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if([segue.identifier isEqualToString:@"PersonalAssets"]) {
        SSPersonalAssetsTableViewController *personalAssetsTableViewController = (SSPersonalAssetsTableViewController *) segue.destinationViewController;
        
        if(self.assets.count == 0) {
            personalAssetsTableViewController.popToRoot = YES;
        } else {
            personalAssetsTableViewController.popToRoot = NO;
        }
    }
}


-(void) drawSureButton {
    if(!self.isSureForCurrentAsset) {
        [self.sureButton setTitle:@"☑ I'm not sure yet" forState:UIControlStateNormal];
    } else {
        [self.sureButton setTitle:@"☐ I'm not sure yet" forState:UIControlStateNormal];
    }
}




-(void) saveCurrent {

    [(StudentAsset *) [self.assets objectAtIndex:self.currentAssetPos] setAmount:[NSNumber numberWithDouble:[self.amountTextField.text doubleValue]]];
    [(StudentAsset *) [self.assets objectAtIndex:self.currentAssetPos] setIsSure:[NSNumber numberWithBool:self.isSureForCurrentAsset]];
        
    self.amountTextField.text = @"";
}

-(void) continueAsking {
    
    if (self.currentAssetPos > 0) {
        self.backButton.hidden = NO;
    } else if (self.currentAssetPos == 0) {
        self.backButton.hidden = YES;
    }
    
    self.amountTextField.text = [[(StudentAsset *) [self.assets objectAtIndex:self.currentAssetPos] amount] stringValue];
    self.questionLabel.text = [NSString stringWithFormat:@"What is your %@ worth?", [(StudentAsset *) [self.assets objectAtIndex:self.currentAssetPos] studentAssetLiteralUS]];
    self.isSureForCurrentAsset = [[(StudentAsset *) [self.assets objectAtIndex:self.currentAssetPos] isSure] boolValue];
    [self drawSureButton];
    

    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {

    [self.amountTextField resignFirstResponder];
    
}

@end