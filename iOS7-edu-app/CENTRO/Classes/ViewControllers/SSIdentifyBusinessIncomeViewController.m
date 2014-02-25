//
//  SSIdentifyBusinessIncomeViewController.m
//  CENTRO
//
//  Created by Centro Community Partners.
//  Copyright (c) 2013 Centro Community Partners.
//

#import "SSIdentifyBusinessIncomeViewController.h"
#import "SSUser.h"
#import "Product.h"
#import "Company.h"

@interface SSIdentifyBusinessIncomeViewController ()

@property (strong, nonatomic) NSManagedObjectContext *context;
@property (strong, nonatomic) NSArray *items;

@property int currentItemPos;
@property int yesCount;

@end

@implementation SSIdentifyBusinessIncomeViewController

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
    
    self.questionLabel.text = [NSString stringWithFormat:@"Does %@ have earnings from sales of:", companyName];
    
    [self.yesButton setTitle:@"YES" forState:UIControlStateNormal];
    [self.noButton setTitle:@"NO" forState:UIControlStateNormal];
    
    UIBarButtonItem *nextScreenBackButton = [[UIBarButtonItem alloc] initWithTitle:@"Try Again" style:UIBarButtonItemStyleBordered target:self action:nil];
    self.navigationItem.backBarButtonItem = nextScreenBackButton;
    
    self.navigationItem.title = @"Business Income";
    
    
}

-(void) viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    if(![[SSUser currentUser] isLoggedIn]) {
        [self.navigationController popToRootViewControllerAnimated:YES];
    }
}

-(void) viewDidAppear:(BOOL)animated {
    self.currentItemPos = 0;
    self.yesCount = 0;
    
    NSFetchRequest *studentIncomeFetchRequest = [[NSFetchRequest alloc] init];
    
    NSEntityDescription *studentIncomeEntity = [NSEntityDescription entityForName:@"Product"
                                                           inManagedObjectContext:self.context];
    [studentIncomeFetchRequest setEntity:studentIncomeEntity];
    
    [studentIncomeFetchRequest setPredicate:[NSPredicate predicateWithFormat:@"companyID = %@ and selectedAsItem = 1", [[SSUser currentUser] companyID]]];
    
    studentIncomeFetchRequest.sortDescriptors = [NSArray arrayWithObject:[NSSortDescriptor sortDescriptorWithKey:@"productID" ascending:YES selector:nil]];
    
    NSError *errorSV;
    self.items = [self.context executeFetchRequest:studentIncomeFetchRequest error:&errorSV];
    
    if (self.items.count == 0) {
        
        self.incomeTypeLabel.text = @"Error!";
    } else {
        for(Product *product in self.items) {
            if([product selectedAsProfitableItem]){
                [product setSelectedAsProfitableItem:[NSNumber numberWithBool:NO]];
            }
        }
        self.incomeTypeLabel.text = [(Product *) [self.items objectAtIndex:self.currentItemPos] name];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (IBAction)yesButtonPressed:(id)sender {
    self.currentItemPos++;
    self.yesCount++;
    [self saveAnswerAndContinue];
}

- (IBAction)noButtonPressed:(id)sender {
    self.currentItemPos++;
    [self continueAsking];
}

-(void) saveAnswerAndContinue {
    [[self.items objectAtIndex:self.currentItemPos-1] setSelectedAsProfitableItem:[NSNumber numberWithBool:YES]];
    [self continueAsking];
}

-(void) continueAsking {
    if(self.currentItemPos < self.items.count) {
        self.incomeTypeLabel.text = [(Product *) [self.items objectAtIndex:self.currentItemPos] name];
    } else {
        [self.context save:nil];
        [self performSegueWithIdentifier:@"BusinessIncomeAmounts" sender:self];
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