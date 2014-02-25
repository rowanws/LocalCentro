//
//  SSIdentifyPersonalAssetsViewController.m
//  CENTRO
//
//  Created by Centro Community Partners.
//  Copyright (c) 2013 Centro Community Partners.
//

#import "SSIdentifyPersonalAssetsViewController.h"
#import "SSUser.h"
#import "StudentAsset.h"

@interface SSIdentifyPersonalAssetsViewController ()

@property (strong, nonatomic) NSManagedObjectContext *context;
@property (strong, nonatomic) NSArray *assets;

@property int currentAssetPos;
@property int yesCount;

@end

@implementation SSIdentifyPersonalAssetsViewController

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
    //self.backgroundImageView.contentMode = UIViewContentModeCenter;
    
    self.questionLabel.text = @"What do you own?";
    
    [self.yesButton setTitle:@"YES" forState:UIControlStateNormal];
    [self.noButton setTitle:@"NO" forState:UIControlStateNormal];
    
    self.context = [(id)[[UIApplication sharedApplication] delegate] managedObjectContext];
    
    UIBarButtonItem *nextScreenBackButton = [[UIBarButtonItem alloc] initWithTitle:@"Try Again" style:UIBarButtonItemStyleBordered target:self action:nil];
    self.navigationItem.backBarButtonItem = nextScreenBackButton;
    
    self.navigationItem.title = @"Personal Assets";

}

-(void) viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    if(![[SSUser currentUser] isLoggedIn]) {
        [self.navigationController popToRootViewControllerAnimated:YES];
    }
}

-(void) viewDidAppear:(BOOL)animated {
    self.currentAssetPos = 0;
    self.yesCount = 0;
    
    NSFetchRequest *studentAssetFetchRequest = [[NSFetchRequest alloc] init];
    
    NSEntityDescription *studentAssetEntity = [NSEntityDescription entityForName:@"StudentAsset"
                                                          inManagedObjectContext:self.context];
    [studentAssetFetchRequest setEntity:studentAssetEntity];
    
    [studentAssetFetchRequest setPredicate:[NSPredicate predicateWithFormat:@"studentID = %@", [[SSUser currentUser] studentID]]];
    
    studentAssetFetchRequest.sortDescriptors = [NSArray arrayWithObject:[NSSortDescriptor sortDescriptorWithKey:@"studentAssetID" ascending:YES selector:nil]];
    
    NSError *errorSV;
    self.assets = [self.context executeFetchRequest:studentAssetFetchRequest error:&errorSV];
    
    if (self.assets.count == 0) {
        
        self.assetTypeLabel.text = @"Error!";
    } else {
        for(StudentAsset *studentAsset in self.assets) {
            if([studentAsset selectedAsAsset]){
                [studentAsset setSelectedAsAsset:[NSNumber numberWithBool:NO]];
            }
        }
        self.assetTypeLabel.text = [(StudentAsset *) [self.assets objectAtIndex:self.currentAssetPos] studentAssetLiteralUS];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (IBAction)yesButtonPressed:(id)sender {
    self.currentAssetPos++;
    self.yesCount++;
    [self saveAnswerAndContinue];
}

- (IBAction)noButtonPressed:(id)sender {
    self.currentAssetPos++;
    [self continueAsking];
}

-(void) saveAnswerAndContinue {
    [[self.assets objectAtIndex:self.currentAssetPos-1] setSelectedAsAsset:[NSNumber numberWithBool:YES]];
    [self continueAsking];
}

-(void) continueAsking {
    if(self.currentAssetPos < self.assets.count) {
        self.assetTypeLabel.text = [(StudentAsset *) [self.assets objectAtIndex:self.currentAssetPos] studentAssetLiteralUS];
    } else {
        [self.context save:nil];
        [self performSegueWithIdentifier:@"PersonalAssetAmounts" sender:self];
    }
}

-(void) viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    NSArray *viewControllers = self.navigationController.viewControllers;
    if (viewControllers.count > 1 && [viewControllers objectAtIndex:viewControllers.count-2] == self) {
        [self.context save:nil];
    } else if ([viewControllers indexOfObject:self] == NSNotFound) {
        [self.context reset];
    } else {
        
        [self.context save:nil];
    }
}

-(IBAction)dismissVC{
    [self dismissViewControllerAnimated:YES completion:NULL];
}

@end