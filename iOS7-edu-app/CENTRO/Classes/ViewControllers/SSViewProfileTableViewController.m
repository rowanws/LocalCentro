//
//  SSViewProfileTableViewController.m
//  CENTRO
//
//  Created by Centro Community Partners.
//  Copyright (c) 2013 Centro Community Partners. All rights reserved.
//

#import "SSViewProfileTableViewController.h"
#import "SSUtils.h"
#import "Student.h"
#import "SSUser.h"

@interface SSViewProfileTableViewController ()

@property (strong, nonatomic) NSManagedObjectContext *context;
@property (strong, nonatomic) Student *student;

@end

@implementation SSViewProfileTableViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {

    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    
    [SSUtils setTableViewBackground:self.tableView];
    self.navigationItem.title = NSLocalizedString(@"ViewProfileNavBarTitle", nil);
    
    self.context = [(id)[[UIApplication sharedApplication] delegate] managedObjectContext];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark - Table view data source

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
       
    NSIndexPath *profileSummaryIP = [NSIndexPath indexPathForRow:0 inSection:0];
    NSIndexPath *preferredNameIP = [NSIndexPath indexPathForRow:0 inSection:1];
    NSIndexPath *genderIP = [NSIndexPath indexPathForRow:1 inSection:1];
    NSIndexPath *dateOfBirthIP = [NSIndexPath indexPathForRow:2 inSection:1];
    NSIndexPath *phoneTypeAndNumberIP = [NSIndexPath indexPathForRow:3 inSection:1];
    

    
    
    if ([indexPath isEqual:profileSummaryIP]) {
        NSString *firstName = self.student.firstName;
        NSString *lastName = self.student.lastName;
    
        NSString *fullName = [NSString stringWithFormat:@"%@ %@", firstName, lastName];
        self.profileSummaryCell.textLabel.attributedText = [SSUtils attributedStringForTitleCellTextGreen:fullName];
        self.profileSummaryCell.detailTextLabel.attributedText = [SSUtils attributedStringForSubTitleCellTextGray:[[SSUser currentUser] username]];

        return self.profileSummaryCell;
    } else if ([indexPath isEqual:preferredNameIP]) {
        self.preferredNameCell.textLabel.attributedText = [SSUtils attributedStringForTitleCellTextGray:@"Preferred Name"];
        self.preferredNameCell.detailTextLabel.attributedText = [SSUtils attributedStringForDetailCellTextGray:self.student.preferredName];

        return self.preferredNameCell;
    } else if ([indexPath isEqual:genderIP]) {
        self.genderCell.textLabel.attributedText = [SSUtils attributedStringForTitleCellTextGray:@"Gender"];
       
        if ([self.student.gender isEqualToString:@"F"]) {
            self.genderCell.detailTextLabel.attributedText = [SSUtils attributedStringForDetailCellTextGray:@"Female"];
        } else if([self.student.gender isEqualToString:@"M"]) {
            self.genderCell.detailTextLabel.attributedText = [SSUtils attributedStringForDetailCellTextGray:@"Male"];
        }
        
        return self.genderCell;
    } else if ([indexPath isEqual:dateOfBirthIP]) {
        self.dateOfBirthCell.textLabel.attributedText = [SSUtils attributedStringForTitleCellTextGray:@"Date of Birth"];
        self.dateOfBirthCell.detailTextLabel.attributedText = [SSUtils attributedStringForDetailCellTextGray:[NSDateFormatter localizedStringFromDate:self.student.dateOfBirth dateStyle:NSDateFormatterMediumStyle timeStyle:NSDateFormatterNoStyle]];
        return self.dateOfBirthCell;
    } else if([indexPath isEqual:phoneTypeAndNumberIP]) {
        
        if ([self.student.phoneType isEqualToString:@"H"]) {
            self.phoneTypeAndNumberCell.textLabel.attributedText = [SSUtils attributedStringForTitleCellTextGray:@"Home Phone"];
        } else if([self.student.phoneType isEqualToString:@"O"]) {
            self.phoneTypeAndNumberCell.textLabel.attributedText = [SSUtils attributedStringForTitleCellTextGray:@"Office Phone"];
        } else if([self.student.phoneType isEqualToString:@"M"]) {
            self.phoneTypeAndNumberCell.textLabel.attributedText = [SSUtils attributedStringForTitleCellTextGray:@"Mobile Phone"];
        }
        
        self.phoneTypeAndNumberCell.detailTextLabel.attributedText = [SSUtils attributedStringForDetailCellTextGray:self.student.phoneNumber];
        
        return self.phoneTypeAndNumberCell;
    } else {
        return nil;
    }
}


- (UIView *) tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UILabel *headerLabel = [[UILabel alloc] init];
    
    NSString *headerString;
    
    if (section == 1) {
        headerString = @"   Your Information";
    } else {
        return nil;
    }
    
    headerLabel.attributedText = [SSUtils attributedStringForHeaderInTableView:headerString];
    [headerLabel setBackgroundColor:[UIColor clearColor]];
    
    return headerLabel;
}

-(void) viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    if(![[SSUser currentUser] isLoggedIn]) {
        [self.navigationController popToRootViewControllerAnimated:YES];
    } else {
        NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
        
        NSEntityDescription *entity = [NSEntityDescription entityForName:@"Student"
                                                  inManagedObjectContext:self.context];
        [fetchRequest setEntity:entity];
        
        [fetchRequest setPredicate:[NSPredicate predicateWithFormat:@"studentID = %@", [[SSUser currentUser] studentID]]];
        
        NSError *error;
        NSArray *fetchedObjects = [self.context executeFetchRequest:fetchRequest error:&error];
        if (fetchedObjects.count == 0) {
            //
        } else {
            self.student = fetchedObjects[0];
        }
    }
}

@end