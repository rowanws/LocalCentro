//
//  SSIdentifyBusinessAssetsViewController.m
//  CENTRO
//
//  Created by Centro Community Partners.
//  Copyright (c) 2013 Centro Community Partners.
//

#import "SSIdentifyBusinessAssetsViewController.h"
#import "SSUser.h"
#import "CompanyAsset.h"
#import "Company.h"

@interface SSIdentifyBusinessAssetsViewController ()

@property (strong, nonatomic) NSManagedObjectContext *context;
@property (strong, nonatomic) NSArray *assets;

@property int currentAssetPos;
@property int yesCount;

@end

@implementation SSIdentifyBusinessAssetsViewController

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
    
    UIImage *bg = [UIImage imageNamed:@"bg.png"];
    self.backgroundImageView.image = bg;
    self.backgroundImageView.contentMode = UIViewContentModeCenter;
    
    self.context = [(id)[[UIApplication sharedApplication] delegate] managedObjectContext];
    
    NSFetchRequest *companyFetchRequest = [[NSFetchRequest alloc] init];
    
    NSEntityDescription *companyEntity = [NSEntityDescription entityForName:@"Company"
                                                     inManagedObjectContext:self.context];
    [companyFetchRequest setEntity:companyEntity];
    
    [companyFetchRequest setPredicate:[NSPredicate predicateWithFormat:@"companyID = %@", [[SSUser currentUser] companyID]]];
    
    companyFetchRequest.returnsObjectsAsFaults = NO;
    
    NSString *companyName = @"";
    
    NSError *errorC;
    NSArray *companyFetchedObjects = [self.context executeFetchRequest:companyFetchRequest error:&errorC];
    if (companyFetchedObjects == 0) {
        
        companyName = @"Your Company";
    } else {
        Company *tempCompany = (Company *) [companyFetchedObjects objectAtIndex:0];
        if ([tempCompany.name isEqualToString:@""]) {
            companyName = @"Your Company";
        } else {
            companyName = tempCompany.name;
        }
    }
    
    self.questionLabel.text = [NSString stringWithFormat:@"Does %@ own...", companyName];
    
    [self.yesButton setTitle:@"YES" forState:UIControlStateNormal];
    [self.noButton setTitle:@"NO" forState:UIControlStateNormal];
    
    UIBarButtonItem *nextScreenBackButton = [[UIBarButtonItem alloc] initWithTitle:@"Try Again" style:UIBarButtonItemStyleBordered target:self action:nil];
    self.navigationItem.backBarButtonItem = nextScreenBackButton;
    
    self.navigationItem.title = @"Business Assets";
    
    
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
    
    NSFetchRequest *companyAssetFetchRequest = [[NSFetchRequest alloc] init];
    
    NSEntityDescription *companyAssetEntity = [NSEntityDescription entityForName:@"CompanyAsset"
                                                          inManagedObjectContext:self.context];
    [companyAssetFetchRequest setEntity:companyAssetEntity];
    
    [companyAssetFetchRequest setPredicate:[NSPredicate predicateWithFormat:@"companyID = %@", [[SSUser currentUser] companyID]]];
    
    companyAssetFetchRequest.sortDescriptors = [NSArray arrayWithObject:[NSSortDescriptor sortDescriptorWithKey:@"companyAssetID" ascending:YES selector:nil]];
    
    NSError *error;
    self.assets = [self.context executeFetchRequest:companyAssetFetchRequest error:&error];
    
    if (self.assets.count == 0) {
        
        self.assetTypeLabel.text = @"Error!";
    } else {
        for(CompanyAsset *companyAsset in self.assets) {
            if([companyAsset selectedAsAsset]){
                [companyAsset setSelectedAsAsset:[NSNumber numberWithBool:NO]];
            }
        }
        self.assetTypeLabel.text = [(CompanyAsset *) [self.assets objectAtIndex:self.currentAssetPos] companyAssetLiteralUS];
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
        self.assetTypeLabel.text = [(CompanyAsset *) [self.assets objectAtIndex:self.currentAssetPos] companyAssetLiteralUS];
    } else {
        [self.context save:nil];
        [self performSegueWithIdentifier:@"CompanyAssetAmounts" sender:self];
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