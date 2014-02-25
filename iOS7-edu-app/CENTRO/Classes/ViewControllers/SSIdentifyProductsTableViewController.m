//
//  SSIdentifyProductsTableViewController.m
//  CENTRO
//
//  Created by Centro Community Partners.
//  Copyright (c) 2013 Centro Community Partners. All rights reserved.
//

#import "SSIdentifyProductsTableViewController.h"
#import "Category.h"
#import "Product.h"
#import "SSUser.h"
#import "SSAddDeleteProductViewController.h"

@interface SSIdentifyProductsTableViewController () <NSFetchedResultsControllerDelegate> {
    NSFetchedResultsController *_fetchedResultsController;
}

@property (strong, nonatomic) NSArray *fetchedCategories;
@property (strong, nonatomic) NSArray *fetchedProductsInCategory;
@property (strong, nonatomic) NSManagedObjectContext *context;
@property (strong, nonatomic) NSIndexPath *selectedIndexPath;
@property (strong, nonatomic) NSNumber *categoryID;

@property int numberOfProductsInCategory;
@property int numberOfCategories;
@property int categoryPos;
@property BOOL resetValues;

- (void)refetchData;

@end

@implementation SSIdentifyProductsTableViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {

    }
    return self;
}
- (IBAction)nextButtonPressed:(id)sender {
    
    
    if (self.categoryPos < self.fetchedCategories.count-1) {
        if (self.numberOfProductsInCategory >= 1) {
            self.categoryPos++;
            [self.context save:nil];
            [self updateTableViewForCategory];
        } else {
            [[[UIAlertView alloc] initWithTitle:@"Selection Error"
                                        message:@"You must select at least 1 Product/Service in this Category."
                                       delegate:nil
                              cancelButtonTitle:@"OK"
                              otherButtonTitles:nil] show];
        }
    } else if(self.categoryPos == self.fetchedCategories.count-1) {
        if (self.numberOfProductsInCategory >= 1) {
            [self.context save:nil];
            [self performSegueWithIdentifier:@"ProductList" sender:self];
        }
        else {
            [[[UIAlertView alloc] initWithTitle:@"Selection Error"
                                        message:@"You must select at least 1 Product/Service in this Category."
                                       delegate:nil
                              cancelButtonTitle:@"OK"
                              otherButtonTitles:nil] show];
        }
    }
}

- (void)refetchData {
    _fetchedResultsController.fetchRequest.resultType = NSManagedObjectResultType;
    [_fetchedResultsController performFetch:nil];
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    
    //UIImageView *backgroundImageView40 = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"bg-568h@2x.png"]];
    //UIImageView *backgroundImageView35R = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"bg@2x.png"]];
    
    //CGRect screenBounds = [[UIScreen mainScreen] bounds];
    //if (screenBounds.size.height == 568) {
    //    self.tableView.backgroundView = backgroundImageView40;
    //} else {
    //    self.tableView.backgroundView = backgroundImageView35R;
    //}
    self.tableView.backgroundView.contentMode = UIViewContentModeCenter;
    
    self.tableView.delegate = self;
    
    self.navigationItem.title = @"Products/Services";
    
    self.context = [(id)[[UIApplication sharedApplication] delegate] managedObjectContext];
    
    self.resetValues = YES;
        
}

- (UIView *) tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    NSString *headerString;
    
    if (section == 0) {
        headerString = [NSString stringWithFormat:@"What are the top selling %@ products/services? (add 1, up to 10)", [self.fetchedCategories[self.categoryPos] name]];
    } else {
        return nil;
    }
    
    UILabel *headerLabel = [[UILabel alloc] init];
    
    headerLabel.numberOfLines = 2;
    headerLabel.lineBreakMode = NSLineBreakByWordWrapping;
    
    headerLabel.text = headerString;
    [headerLabel sizeToFit];
    [headerLabel setBackgroundColor:[UIColor clearColor]];
    
    
    
    return headerLabel;
}

-(void) viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    if(![[SSUser currentUser] isLoggedIn]) {
        [self.navigationController popToRootViewControllerAnimated:YES];
    } else {
        
        NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
        
        NSEntityDescription *entity = [NSEntityDescription entityForName:@"Category" inManagedObjectContext:self.context];
        
        [fetchRequest setEntity:entity];
        
        [fetchRequest setPredicate:[NSPredicate predicateWithFormat:@"companyID = %@ AND selectedAsCategory = 1", [[SSUser currentUser] companyID]]];
        
        NSError *error;
        NSArray *fetchedObjects = [self.context executeFetchRequest:fetchRequest error:&error];
        if (fetchedObjects.count == 0) {
            
        } else {
            self.fetchedCategories = fetchedObjects;
            self.numberOfCategories = [self.fetchedCategories count];
            if(self.resetValues) {
                self.categoryPos = 0;
            }
            self.categoryID = [self.fetchedCategories[self.categoryPos] categoryID];

            NSFetchRequest *fetchRequestCompany = [NSFetchRequest fetchRequestWithEntityName:@"Product"];
            fetchRequestCompany.sortDescriptors = [NSArray arrayWithObject:[NSSortDescriptor sortDescriptorWithKey:@"productID" ascending:YES selector:nil]];
            [fetchRequestCompany setPredicate:[NSPredicate predicateWithFormat:@"categoryID = %@", self.categoryID]];
            fetchRequestCompany.returnsObjectsAsFaults = NO;

            _fetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequestCompany managedObjectContext:self.context sectionNameKeyPath:nil cacheName:nil];
            _fetchedResultsController.delegate = self;
            [_fetchedResultsController performFetch:nil];
            
            self.fetchedProductsInCategory = [_fetchedResultsController fetchedObjects];
            
            self.numberOfProductsInCategory = 0;
            
            [self.tableView reloadData];
        }
    }
}

-(void) updateTableViewForCategory {
    
    self.categoryID = [self.fetchedCategories[self.categoryPos] categoryID];
    
    NSFetchRequest *fetchRequestCompany = [NSFetchRequest fetchRequestWithEntityName:@"Product"];
    fetchRequestCompany.sortDescriptors = [NSArray arrayWithObject:[NSSortDescriptor sortDescriptorWithKey:@"productID" ascending:YES selector:nil]];
    [fetchRequestCompany setPredicate:[NSPredicate predicateWithFormat:@"categoryID = %@", self.categoryID]];
    fetchRequestCompany.returnsObjectsAsFaults = NO;
    
    _fetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequestCompany managedObjectContext:self.context sectionNameKeyPath:nil cacheName:nil];
    _fetchedResultsController.delegate = self;
    [_fetchedResultsController performFetch:nil];
    
    self.fetchedProductsInCategory = [_fetchedResultsController fetchedObjects];
    
    self.numberOfProductsInCategory = 0;
    
    [self.tableView reloadData];
}

-(void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if([segue.identifier isEqualToString:@"AddDeleteProduct"]) {
        SSAddDeleteProductViewController *addDeleteProductViewController = (SSAddDeleteProductViewController *) segue.destinationViewController;
        
        Product *p = [_fetchedResultsController objectAtIndexPath:self.selectedIndexPath];
        
        [addDeleteProductViewController setProductID:p.productID];
        [addDeleteProductViewController setCategoryID:self.categoryID];
        if([p.selectedAsItem isEqualToNumber:[NSNumber numberWithBool:NO]]) {
            [addDeleteProductViewController setAdd:YES];
        } else {
            [addDeleteProductViewController setAdd:NO];
        }
        
        self.resetValues = NO;
        
        UIBarButtonItem *nextScreenBackButton = [[UIBarButtonItem alloc] initWithTitle:@"Cancel" style:UIBarButtonItemStyleBordered target:self action:nil];
        self.navigationItem.backBarButtonItem = nextScreenBackButton;
    } else {
        UIBarButtonItem *nextScreenBackButton = [[UIBarButtonItem alloc] initWithTitle:@"Products" style:UIBarButtonItemStyleBordered target:self action:nil];
        self.navigationItem.backBarButtonItem = nextScreenBackButton;
        
        self.resetValues = YES;
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{    
    return [[_fetchedResultsController sections] count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [[[_fetchedResultsController sections] objectAtIndex:section] numberOfObjects];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"ProductCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;

    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        [cell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
        [cell setSelectionStyle:UITableViewCellSelectionStyleGray];
    }
    
    Product *tempProduct = [_fetchedResultsController objectAtIndexPath:indexPath];
    
    if([tempProduct.selectedAsItem isEqualToNumber:[NSNumber numberWithBool:NO]]) {
        cell.textLabel.text = @"Add Product...";
    } else {
        cell.textLabel.text = tempProduct.name;
        self.numberOfProductsInCategory++;
    }
    
    return cell;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    self.selectedIndexPath = indexPath;
    [self performSegueWithIdentifier:@"AddDeleteProduct" sender:self];
}

#pragma mark - NSFetchedResultsControllerDelegate

- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller {
    [self.tableView reloadData];
}

@end