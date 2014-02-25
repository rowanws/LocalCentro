//
//  SSEditProfileTableViewController.m
//  CENTRO
//
//  Created by Centro Community Partners.
//  Copyright (c) 2013 Centro Community Partners. All rights reserved.
//

#import "SSEditProfileTableViewController.h"
#import "SSUtils.h"
#import "SSUser.h"
#import "Student.h"
#import "Company.h"
#import "CENTROAPIClient.h"
#import "MBProgressHUD.h"

@interface SSEditProfileTableViewController ()

@property (strong, nonatomic) NSManagedObjectContext *context;

@property (strong, nonatomic) NSIndexPath *firstNameCellIP;
@property (strong, nonatomic) NSIndexPath *lastNameCellIP;
@property (strong, nonatomic) NSIndexPath *preferredNameCellIP;
@property (strong, nonatomic) NSIndexPath *genderCellIP;
@property (strong, nonatomic) NSIndexPath *dateOfBirthCellIP;
@property (strong, nonatomic) NSIndexPath *phoneNumberCellIP;
@property (strong, nonatomic) NSIndexPath *phoneNumberTypeCellIP;
@property (strong, nonatomic) NSIndexPath *companyNameIP;

@property (strong, nonatomic) UITableViewCell *activeCell;

@property (strong, nonatomic) Student *student;
@property (strong, nonatomic) Company *company;

@property (strong, nonatomic) MBProgressHUD *hudForPush;

@end


@implementation SSEditProfileTableViewController

#define PHONE_TYPE_ACTIONSHEET_TAG 3290
#define GENDER_ACTIONSHEET_TAG 3280
#define BIRTHDAY_ACTIONSHEET_TAG 3270
#define BIRTHDAY_PICKER_TAG 3271

#define FNAME_TEXTFIELD_TAG 3251
#define LNAME_TEXTFIELD_TAG 3252
#define PNAME_TEXTFIELD_TAG 3253
#define PNUMBER_TEXTFIELD_TAG 3254
#define CNAME_TEXTFIELD_TAG 3255

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
    self.navigationItem.title = NSLocalizedString(@"EditProfileNavBarTitle", nil);
    
    self.context = [(id)[[UIApplication sharedApplication] delegate] managedObjectContext];
    
    UITapGestureRecognizer *gestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideKeyboard)];
    gestureRecognizer.cancelsTouchesInView = NO;
    [self.tableView addGestureRecognizer:gestureRecognizer];
    

}

-(void) viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    if(![[SSUser currentUser] isLoggedIn]) {
        [self.navigationController popToRootViewControllerAnimated:YES];
    } else {
        
        self.firstNameCellIP = [NSIndexPath indexPathForRow:0 inSection:0];
        self.lastNameCellIP = [NSIndexPath indexPathForRow:1 inSection:0];
        self.preferredNameCellIP = [NSIndexPath indexPathForRow:2 inSection:0];
        self.phoneNumberCellIP = [NSIndexPath indexPathForRow:3 inSection:0];
        self.phoneNumberTypeCellIP = [NSIndexPath indexPathForRow:4 inSection:0];
        self.genderCellIP = [NSIndexPath indexPathForRow:5 inSection:0];
        self.dateOfBirthCellIP = [NSIndexPath indexPathForRow:6 inSection:0];

        self.companyNameIP = [NSIndexPath indexPathForRow:0 inSection:1];
        
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
        
        NSFetchRequest *fetchRequestC = [[NSFetchRequest alloc] init];
        
        NSEntityDescription *entityC = [NSEntityDescription entityForName:@"Company"
                                                  inManagedObjectContext:self.context];
        [fetchRequestC setEntity:entityC];
        
        [fetchRequestC setPredicate:[NSPredicate predicateWithFormat:@"companyID = %@", [[SSUser currentUser] companyID]]];
        
        NSError *errorC;
        NSArray *fetchedObjectsC = [self.context executeFetchRequest:fetchRequestC error:&errorC];
        if (fetchedObjectsC.count == 0) {
            //
        } else {
            self.company = fetchedObjectsC[0];
        }
    }
}

- (void) viewDidAppear:(BOOL)animated {
    
    [super viewDidAppear:animated];
    [self.tableView reloadData];
    
}

- (IBAction)saveButtonPressed:(id)sender {
    
    [self hideKeyboard];
    
    if([[CENTROAPIClient sharedClient] networkIsReachable]) {
        
        self.company.name = [self.company.name stringByTrimmingCharactersInSet: [NSCharacterSet whitespaceCharacterSet]];
        
        [self.context save:nil];
        
        [[UIApplication sharedApplication] beginIgnoringInteractionEvents];
        
        NSOperationQueue *operationQueue = [[NSOperationQueue alloc] init];
        [operationQueue setMaxConcurrentOperationCount:1];
        
        NSMutableArray *operationsArray = [[NSMutableArray alloc] initWithCapacity:2];
        
        
        self.hudForPush = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        self.hudForPush.mode = MBProgressHUDModeIndeterminate;
        self.hudForPush.labelText = NSLocalizedString(@"HUDLabelTextPushProfileData", nil);
        [self.hudForPush show:YES];
        
        [operationsArray addObject:[self studentData]];
        [operationsArray addObject:[self companyData]];
        
        [operationQueue addOperations:operationsArray waitUntilFinished:NO];
    } else {
        [[[UIAlertView alloc] initWithTitle:@"Connection Error"
                                    message:@"Check your Internet Connection. You must be online to update your profile."
                                   delegate:nil
                          cancelButtonTitle:@"OK"
                          otherButtonTitles:nil] show];
    }
}

-(AFJSONRequestOperation *) studentData {
    
    CENTROAPIClient *client = [CENTROAPIClient sharedClient];
    [[AFNetworkActivityIndicatorManager sharedManager] setEnabled:YES];
    
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithCapacity:3];
    [params setObject:[[SSUser currentUser] token] forKey:@"auth_token"];
    
    NSDictionary *studentDict = [NSDictionary dictionaryWithObjectsAndKeys:
                                 self.student.dateOfBirth, @"date_of_birth",
                                 self.student.firstName, @"first_name",
                                 self.student.lastName, @"last_name",
                                 self.student.phoneNumber, @"phone_number",
                                 self.student.phoneType, @"phone_type",
                                 self.student.preferredName, @"preferred_name",
                                 self.student.gender, @"gender",
                                 nil];
    
    [params setObject:studentDict forKey:@"student"];
    
    [[AFNetworkActivityIndicatorManager sharedManager] incrementActivityCount];
    NSString *path = [NSString stringWithFormat:@"students/%@.json", self.company.companyID];
    NSURLRequest *request = [client requestWithMethod:@"PUT" path:path parameters:params];
    
    AFJSONRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
        [[AFNetworkActivityIndicatorManager sharedManager] decrementActivityCount];
    } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
        [[AFNetworkActivityIndicatorManager sharedManager] decrementActivityCount];
    }];
    
    return operation;
}

-(AFJSONRequestOperation *) companyData {
    
    CENTROAPIClient *client = [CENTROAPIClient sharedClient];
    [[AFNetworkActivityIndicatorManager sharedManager] setEnabled:YES];
    
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithCapacity:3];
    [params setObject:[[SSUser currentUser] token] forKey:@"auth_token"];
    
    NSDictionary *companyDict = [NSDictionary dictionaryWithObjectsAndKeys:
                                 self.company.companyID, @"id",
                                 self.company.name, @"name",
                                 self.company.studentID, @"student_id",
                                 self.company.productsQty, @"products_qty",
                                 self.company.productsAndServicesEstimate, @"products_services",
                                 self.company.servicesQty, @"services_qty",
                                 self.company.isProductsSure, @"is_products_sure",
                                 self.company.isServicesSure, @"is_services_sure",
                                 self.company.otherProfitAmount, @"other_profit_amount",
                                 self.company.otherProfitFrequency, @"other_profit_frequency",
                                 self.company.isOtherProfitAmountSure, @"is_other_profit_amount_sure",
                                 self.company.totalEmployeeBenefitsCosts, @"total_employee_benefits_costs",
                                 self.company.frequencyEmployeeBenefits, @"frequency_employee_benefits",
                                 self.company.numberOfEmployees, @"number_employees",
                                 nil];
    
    [params setObject:companyDict forKey:@"company"];
    
    [[AFNetworkActivityIndicatorManager sharedManager] incrementActivityCount];
    NSString *path = [NSString stringWithFormat:@"companies/%@.json", self.company.companyID];
    NSURLRequest *request = [client requestWithMethod:@"PUT" path:path parameters:params];
    
    AFJSONRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
        [[AFNetworkActivityIndicatorManager sharedManager] decrementActivityCount];
        [self.hudForPush hide:YES];
        [[UIApplication sharedApplication] endIgnoringInteractionEvents];
        [self.navigationController popToRootViewControllerAnimated:YES];
    } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
        [[AFNetworkActivityIndicatorManager sharedManager] decrementActivityCount];
        [self.hudForPush hide:YES];
        [[UIApplication sharedApplication] endIgnoringInteractionEvents];
    }];

    return operation;
}

- (UIView *) tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UILabel *headerLabel = [[UILabel alloc] init];
    
    NSString *headerString;

    if (section == 0) {
        headerString = @"    Your Information";
    } else if (section == 1) {
        headerString = @"    Your Company Information";
    } else {
        return nil;
    }
    
    headerLabel.attributedText = [SSUtils attributedStringForHeaderInTableView:headerString];
    [headerLabel setBackgroundColor:[UIColor clearColor]];
    
    return headerLabel;
}

-(UITableViewCell *) addEditableAccessoryViewToCell:(UITableViewCell *) cell withData:(NSString *) data phoneKeyboard:(BOOL) phoneKeyboard andTag:(int) tag{
    
    UITableViewCell *newCell = cell;
    
    CGRect detailTextLabelFrame = newCell.detailTextLabel.frame;
    detailTextLabelFrame.origin.x -= 105.0f;
    detailTextLabelFrame.size.width += 135.0f;
    
    UITextField *textField = [[UITextField alloc] initWithFrame:detailTextLabelFrame];
    textField.attributedText = [SSUtils attributedStringForDetailCellTextGray:data];
    textField.textAlignment = NSTextAlignmentRight;
    textField.delegate = self;
    textField.tag = tag;
    if (phoneKeyboard) {
        [textField setKeyboardType:UIKeyboardTypePhonePad];
    }
    
    newCell.detailTextLabel.hidden = YES;
    newCell.accessoryView = textField;
    
    return newCell;
}

-(void) showGenderActionSheet {
    
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:@"Select your gender" delegate:self cancelButtonTitle:nil destructiveButtonTitle:nil otherButtonTitles:nil];
    
    actionSheet.tag = GENDER_ACTIONSHEET_TAG;
    actionSheet.actionSheetStyle = UIActionSheetStyleAutomatic;
    
    [actionSheet addButtonWithTitle:@"Female"];
    [actionSheet addButtonWithTitle:@"Male"];
    
    [actionSheet showFromTabBar:self.tabBarController.tabBar];
}

-(void) showPhoneTypeActionSheet {
    
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:@"Select your phone type" delegate:self cancelButtonTitle:nil destructiveButtonTitle:nil otherButtonTitles:nil];
    
    actionSheet.tag = PHONE_TYPE_ACTIONSHEET_TAG;
    actionSheet.actionSheetStyle = UIActionSheetStyleAutomatic;
    
    [actionSheet addButtonWithTitle:@"Home"];
    [actionSheet addButtonWithTitle:@"Office"];
    [actionSheet addButtonWithTitle:@"Mobile"];
    
    [actionSheet showFromTabBar:self.tabBarController.tabBar];
}

-(void) showBirthdayActionSheet {
    
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:@"Select your date of birth" delegate:self cancelButtonTitle:@"Done" destructiveButtonTitle:nil otherButtonTitles:nil];
    
    actionSheet.tag = BIRTHDAY_ACTIONSHEET_TAG;
    actionSheet.actionSheetStyle = UIActionSheetStyleAutomatic;
    
    self.birthdayDatePicker = [[UIDatePicker alloc] initWithFrame:CGRectMake(0,100, 320, 100)];
    self.birthdayDatePicker.tag = BIRTHDAY_PICKER_TAG;
    [self.birthdayDatePicker setMaximumDate: [[NSDate alloc] init]];
    self.birthdayDatePicker.datePickerMode = UIDatePickerModeDate;
    
    if(self.student.dateOfBirth != nil) {
        [self.birthdayDatePicker setDate:self.student.dateOfBirth];
    }
    
    [actionSheet addSubview:self.birthdayDatePicker];
    
    [actionSheet showFromTabBar:self.tabBarController.tabBar];

    [actionSheet setBounds:CGRectMake(0,0, 320, 520)];
    
    self.birthdayDatePicker.hidden = NO;
}

-(NSString *) getGenderDescription {
    if([self.student.gender isEqualToString:@"F"]) {
        return @"Female";
    } else if([self.student.gender isEqualToString:@"M"]) {
        return @"Male";
    } else {
        return @"";
    }
}

-(NSString *) getPhoneTypeDescription {
    if([self.student.phoneType isEqualToString:@"H"]) {
        return @"Home";
    } else if([self.student.phoneType isEqualToString:@"O"]) {
        return @"Office";
    } else if([self.student.phoneType isEqualToString:@"M"]) {
        return @"Mobile";
    } else {
        return @"";
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark - Table view data source

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{

    if([indexPath isEqual:self.firstNameCellIP]) {
        self.firstNameCell.textLabel.attributedText = [SSUtils attributedStringForTitleCellTextGray:@"First Name"];
        self.firstNameCell = [self addEditableAccessoryViewToCell:self.firstNameCell withData:self.student.firstName phoneKeyboard:NO andTag:FNAME_TEXTFIELD_TAG];
        return self.firstNameCell;
    } else if([indexPath isEqual:self.lastNameCellIP]) {
        self.lastNameCell.textLabel.attributedText = [SSUtils attributedStringForTitleCellTextGray:@"Last Name"];
        self.lastNameCell = [self addEditableAccessoryViewToCell:self.lastNameCell withData:self.student.lastName phoneKeyboard:NO andTag:LNAME_TEXTFIELD_TAG];
        return self.lastNameCell;
    } else if([indexPath isEqual:self.preferredNameCellIP]) {
        self.preferredNameCell.textLabel.attributedText = [SSUtils attributedStringForTitleCellTextGray:@"Preferred Name"];
        self.preferredNameCell = [self addEditableAccessoryViewToCell:self.preferredNameCell withData:self.student.preferredName phoneKeyboard:NO andTag:PNAME_TEXTFIELD_TAG];
        return self.preferredNameCell;
    } else if([indexPath isEqual:self.genderCellIP]) {
        self.genderCell.textLabel.attributedText = [SSUtils attributedStringForTitleCellTextGray:@"Gender"];
        self.genderCell.detailTextLabel.attributedText = [SSUtils attributedStringForDetailCellTextGray:[self getGenderDescription]];
        return self.genderCell;
    } else if([indexPath isEqual:self.dateOfBirthCellIP]) {
        self.dateOfBirthCell.textLabel.attributedText = [SSUtils attributedStringForTitleCellTextGray:@"Date of Birth"];
        self.dateOfBirthCell.detailTextLabel.attributedText = [SSUtils attributedStringForDetailCellTextGray:[NSDateFormatter localizedStringFromDate:self.student.dateOfBirth dateStyle:NSDateFormatterMediumStyle timeStyle:NSDateFormatterNoStyle]];
        return self.dateOfBirthCell;
    } else if([indexPath isEqual:self.phoneNumberCellIP]) {
        self.phoneNumberCell.textLabel.attributedText = [SSUtils attributedStringForTitleCellTextGray:@"Phone Number"];
        self.phoneNumberCell = [self addEditableAccessoryViewToCell:self.phoneNumberCell withData:self.student.phoneNumber phoneKeyboard:YES andTag:PNUMBER_TEXTFIELD_TAG];
        return self.phoneNumberCell;
    } else if([indexPath isEqual:self.phoneNumberTypeCellIP]) {
        self.phoneNumberTypeCell.textLabel.attributedText = [SSUtils attributedStringForTitleCellTextGray:@"Phone Type"];
        self.phoneNumberTypeCell.detailTextLabel.attributedText = [SSUtils attributedStringForDetailCellTextGray:[self getPhoneTypeDescription]];
        return self.phoneNumberTypeCell;
    } else if([indexPath isEqual:self.companyNameIP]) {
        self.companyNameCell.textLabel.attributedText = [SSUtils attributedStringForTitleCellTextGray:@"Name"];
        self.companyNameCell = [self addEditableAccessoryViewToCell:self.companyNameCell withData:self.company.name phoneKeyboard:NO andTag:CNAME_TEXTFIELD_TAG];
        return self.companyNameCell;
    } else {
        return nil;
    }
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    
    self.activeCell = (UITableViewCell *) [textField superview];
    
    return YES;
}

- (BOOL) textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    
    NSString *s = [textField.text stringByReplacingCharactersInRange:range withString:string];
    
    if([self.activeCell.accessoryView tag] == FNAME_TEXTFIELD_TAG) {
        self.student.firstName = s;
    } else if([self.activeCell.accessoryView tag] == LNAME_TEXTFIELD_TAG) {
        self.student.lastName = s;
    } else if([self.activeCell.accessoryView tag] == PNAME_TEXTFIELD_TAG) {
        self.student.preferredName = s;
    } else if([self.activeCell.accessoryView tag] == PNUMBER_TEXTFIELD_TAG) {
        self.student.phoneNumber = s;
    } else if([self.activeCell.accessoryView tag] == CNAME_TEXTFIELD_TAG) {
        self.company.name = s;
    }
    
    return YES;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{

    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    
    [self hideKeyboard];
    
    if ([indexPath isEqual:self.phoneNumberTypeCellIP]) {
        [self showPhoneTypeActionSheet];
    } else if([indexPath isEqual:self.dateOfBirthCellIP]) {
        [self showBirthdayActionSheet];
    } else if([indexPath isEqual:self.genderCellIP]) {
        [self showGenderActionSheet];
    } else {
        [cell.accessoryView becomeFirstResponder];
        cell.selected = NO;
        self.activeCell = cell;
    }
}

- (void) hideKeyboard {
    [self.activeCell.accessoryView resignFirstResponder];
}

# pragma mark UIActionSheet Delegate

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger) buttonIndex {
    
    if (actionSheet.tag == GENDER_ACTIONSHEET_TAG) {
        if (buttonIndex == 0) {
            self.student.gender = @"F";
        } else if (buttonIndex == 1) {
            self.student.gender = @"M";
        } else {
            self.student.gender = @"";
        }
    } else if (actionSheet.tag == BIRTHDAY_ACTIONSHEET_TAG) {
        self.student.dateOfBirth = [self.birthdayDatePicker date];
    } else if (actionSheet.tag == PHONE_TYPE_ACTIONSHEET_TAG) {
        if (buttonIndex == 0) {
            self.student.phoneType = @"H";
        } else if (buttonIndex == 1) {
            self.student.phoneType = @"O";
        } else {
            self.student.phoneType = @"M";
        }
    }
    [actionSheet dismissWithClickedButtonIndex:buttonIndex animated:YES];
    [self.tableView reloadData];
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

@end