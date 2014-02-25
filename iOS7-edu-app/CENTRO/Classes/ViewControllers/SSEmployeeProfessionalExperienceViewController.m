//
//  SSEmployeeProfessionalExperienceViewController.m
//  CENTRO
//
//  Created by Centro Community Partners.
//  Copyright (c) 2013 Centro Community Partners. All rights reserved.
//

#import "SSEmployeeProfessionalExperienceViewController.h"
#import "SSUser.h"
#import "Employee.h"

@interface SSEmployeeProfessionalExperienceViewController ()

@property (nonatomic, strong) NSManagedObjectContext *context;
@property (nonatomic, strong) NSArray *employees;

@property int employeePos;

@end

@implementation SSEmployeeProfessionalExperienceViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {

    }
    return self;
}
- (IBAction)nextButtonPressed:(id)sender {
    if([self canContinue]) {
        if(self.employeePos == self.employees.count-1)    {
            [self.context save:nil];
            [self performSegueWithIdentifier:@"Team" sender:self];
        } else {
            self.employeePos++;
            
            [self refreshTitle];
            [self refreshButton];
        }
    } else {
        [[[UIAlertView alloc] initWithTitle:@"Selection Error"
                                    message:@"You must select a professional experience."
                                   delegate:nil
                          cancelButtonTitle:@"OK"
                          otherButtonTitles:nil] show];
    }
}

- (IBAction)professionalExperienceButtonPressed:(id)sender {
    [self showPickerActionSheet];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    //UIImage *bg40 = [UIImage imageNamed:@"bg-568h@2x.png"];
    //UIImage *bg35R = [UIImage imageNamed:@"bg.png"];
    
    //CGRect screenBounds = [[UIScreen mainScreen] bounds];
   // if (screenBounds.size.height == 568) {
    //    self.backgroundImageView.image = bg40;
    //} else {
    //    self.backgroundImageView.image = bg35R;
    //}
    
    self.context = [(id)[[UIApplication sharedApplication] delegate] managedObjectContext];
    
    self.navigationItem.title = @"Experience";
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Employee"
                                              inManagedObjectContext:self.context];
    [fetchRequest setEntity:entity];
    
    [fetchRequest setPredicate:[NSPredicate predicateWithFormat:@"companyID = %@ AND selectedAsEmployee == 1", [[SSUser currentUser] companyID]]];
    fetchRequest.sortDescriptors = [NSArray arrayWithObject:[NSSortDescriptor sortDescriptorWithKey:@"employeeID" ascending:YES selector:nil]];
    
    NSError *error;
    NSArray *fetchedObjects = [self.context executeFetchRequest:fetchRequest error:&error];
    if (fetchedObjects.count == 0) {
        
    } else {
        self.employees = fetchedObjects;
    }

}

-(void) viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    if(![[SSUser currentUser] isLoggedIn]) {
        [self.navigationController popToRootViewControllerAnimated:YES];
    } else {
        
        self.employeePos = 0;
        [self refreshTitle];
        [self refreshButton];
    }
}

-(void) refreshTitle {
    NSString *name = [self.employees[self.employeePos] name];
    if ([name isEqualToString:@"You"]) {
        self.titleLabel.text = @"How much professional experience do you have?";
    } else {
        self.titleLabel.text = [NSString stringWithFormat:@"How much professional experience does %@ have?", name];
    }
}

-(void) refreshButton {
    [self.professionalExperienceButton setTitle:[self employeeExperienceButtonTitle] forState:UIControlStateNormal];
}

-(NSString *) employeeExperienceButtonTitle {
    
    Employee *emp = self.employees[self.employeePos];
    
    NSString *employeeExperienceNumber = @"Select";
    
    if([emp.professionalExperience intValue] == 0) {
        employeeExperienceNumber = @"None";
    } else if([emp.professionalExperience intValue] == 1) {
        employeeExperienceNumber = @"Less than 1 year";
    } else if([emp.professionalExperience intValue] == 2) {
        employeeExperienceNumber = @"1 year";
    } else if([emp.professionalExperience intValue] == 3) {
        employeeExperienceNumber = @"2 years";
    } else if([emp.professionalExperience intValue] == 4) {
        employeeExperienceNumber = @"3 years";
    } else if([emp.professionalExperience intValue] == 5) {
        employeeExperienceNumber = @"4 years";
    } else if([emp.professionalExperience intValue] == 6) {
        employeeExperienceNumber = @"5 years";
    } else if([emp.professionalExperience intValue] == 7) {
        employeeExperienceNumber = @"6 years";
    } else if([emp.professionalExperience intValue] == 8) {
        employeeExperienceNumber = @"7 years";
    } else if([emp.professionalExperience intValue] == 9) {
        employeeExperienceNumber = @"8 years";
    } else if([emp.professionalExperience intValue] == 10) {
        employeeExperienceNumber = @"9 years";
    } else if([emp.professionalExperience intValue] == 11) {
        employeeExperienceNumber = @"10+ years";
    } else {
        employeeExperienceNumber = @"Choose";
    }
    
    return employeeExperienceNumber;
    
}

-(void) showPickerActionSheet {
    
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:@"Select the professional experience" delegate:self cancelButtonTitle:@"Done" destructiveButtonTitle:nil otherButtonTitles:nil];
    
    actionSheet.actionSheetStyle = UIActionSheetStyleAutomatic;
    
    self.professionalExperiencePickerView = [[UIPickerView alloc] initWithFrame:CGRectMake(0,103, 320, 103)];
    self.professionalExperiencePickerView.delegate = self;
    self.professionalExperiencePickerView.showsSelectionIndicator  = YES;

    [actionSheet addSubview:self.professionalExperiencePickerView];
    
    [actionSheet showInView:self.view];
    
    [actionSheet setBounds:CGRectMake(0,0, 320, 420)];
    
    self.professionalExperiencePickerView.hidden = NO;
    
    [self.employees[self.employeePos] setProfessionalExperience:[NSNumber numberWithInt:0]];
    
    [self refreshButton];
}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
	return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
	return 12;
	
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{

    NSString *employeeNumber = @"";
    
    if(row == 0) {
        employeeNumber = @"None";
    } else if(row == 1) {
        employeeNumber = @"Less than 1 year";
    } else if(row == 2) {
        employeeNumber = @"1 year";
    } else if(row == 3) {
        employeeNumber = @"2 years";
    } else if(row == 4) {
        employeeNumber = @"3 years";
    } else if(row == 5) {
        employeeNumber = @"4 years";
    } else if(row == 6) {
        employeeNumber = @"5 years";
    } else if(row == 7) {
        employeeNumber = @"6 years";
    } else if(row == 8) {
        employeeNumber = @"7 years";
    } else if(row == 9) {
        employeeNumber = @"8 years";
    } else if(row == 10) {
        employeeNumber = @"9 years";
    } else if(row == 11) {
        employeeNumber = @"10+ years";
    }

	return employeeNumber;
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    [self.employees[self.employeePos] setProfessionalExperience:[NSNumber numberWithInteger:[pickerView selectedRowInComponent:0]]];
}

-(BOOL) canContinue {
    if ([[self.employees[self.employeePos] professionalExperience] intValue] >= 0) {
        return YES;
    } else {
        return NO;
    }
}


# pragma mark UIActionSheet Delegate

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger) buttonIndex {
    [self refreshButton];
}



- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

-(void) viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    [self.context save:nil];
}

@end