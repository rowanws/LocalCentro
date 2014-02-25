//
//  SSAddDeleteOperatingHourViewController.m
//  CENTRO
//
//  Created by Centro Community Partners.
//  Copyright (c) 2013 Centro Community Partners. All rights reserved.
//

#import "SSAddDeleteOperatingHourViewController.h"

@interface SSAddDeleteOperatingHourViewController ()

@property (strong, nonatomic) NSManagedObjectContext *context;

@end

@implementation SSAddDeleteOperatingHourViewController

#define FROM_ACTIONSHEET_TAG 1000
#define FROM_PICKER_TAG 1100
#define TO_ACTIONSHEET_TAG 2000
#define TO_PICKER_TAG 2100

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {

    }
    return self;
}
- (IBAction)fromButtonPressed:(id)sender {
    [self showTimePickerActionSheet:@"from"];
}

- (IBAction)toButtonPressed:(id)sender {
    [self showTimePickerActionSheet:@"to"];
}

- (IBAction)deleteButtonPressed:(id)sender {
    self.operatingHour.selectedAsWorkingDay = [NSNumber numberWithBool:NO];
    self.operatingHour.from = nil;
    self.operatingHour.to =nil;
    [self.context save:nil];
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)addButtonPressed:(id)sender {
    
    if(self.operatingHour.to != nil && self.operatingHour.from != nil) {
        if([self.operatingHour.to compare:self.operatingHour.from] == NSOrderedDescending) {
            self.operatingHour.selectedAsWorkingDay = [NSNumber numberWithBool:YES];
            self.operatingHour.dayOfWeekUS = [self dayLiteralForID:[self.operatingHour.dayOfWeekID stringValue]];
            [self.context save:nil];
            [self.navigationController popViewControllerAnimated:YES];
        } else {
            [[[UIAlertView alloc] initWithTitle:@"Selection Error"
                                        message:@"To hour must be greater than From hour."
                                       delegate:nil
                              cancelButtonTitle:@"OK"
                              otherButtonTitles:nil] show];
        }
    } else {
        [[[UIAlertView alloc] initWithTitle:@"Selection Error"
                                    message:@"You need to select To and From hours."
                                   delegate:nil
                          cancelButtonTitle:@"OK"
                          otherButtonTitles:nil] show];
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    //UIImage *bg40 = [UIImage imageNamed:@"bg-568h@2x.png"];
    //UIImage *bg35R = [UIImage imageNamed:@"bg.png"];
    
    //CGRect screenBounds = [[UIScreen mainScreen] bounds];
    //if (screenBounds.size.height == 568) {
    //    self.backgroundImageView.image = bg40;
    //} else {
    //    self.backgroundImageView.image = bg35R;
    //}
    
    self.context = [(id)[[UIApplication sharedApplication] delegate] managedObjectContext];
    
    self.navigationItem.title = @"Operating Hours";
    
    [self refreshFromToButtons];
    
    [self.addButton setTitle:@"Save Operating Hour" forState:UIControlStateNormal];
    [self.deleteButton setTitle:@"Delete Operating Hour" forState:UIControlStateNormal];
    
    self.titleLabel.text = [NSString stringWithFormat:@"Select Business Hours for: %@", [self dayLiteralForID:[self.operatingHour.dayOfWeekID stringValue]]];
    
    if([self.operatingHour.selectedAsWorkingDay isEqualToNumber:[NSNumber numberWithBool:NO]]) {
        self.deleteButton.enabled = NO;
        self.deleteButton.hidden = YES;
    }
}

-(NSString *) dayLiteralForID:(NSString *) dayID {
    
    NSString *dayLiteral = @"";
    
    if([dayID isEqualToString:@"1"]) {
        dayLiteral = @"Monday";
    } else if([dayID isEqualToString:@"2"]) {
        dayLiteral = @"Tuesday";
    } else if([dayID isEqualToString:@"3"]) {
        dayLiteral = @"Wednesday";
    } else if([dayID isEqualToString:@"4"]) {
        dayLiteral = @"Thursday";
    } else if([dayID isEqualToString:@"5"]) {
        dayLiteral = @"Friday";
    } else if([dayID isEqualToString:@"6"]) {
        dayLiteral = @"Saturday";
    } else if([dayID isEqualToString:@"7"]) {
        dayLiteral = @"Sunday";
    }
    
    return dayLiteral;
    
}


-(void) refreshFromToButtons {
    if(self.operatingHour.from == nil) {
        [self.startTimeButton setTitle:@"From" forState:UIControlStateNormal];
    } else {
        NSDateFormatter *timeFormat = [[NSDateFormatter alloc] init];
        [timeFormat setDateFormat:@"hh:mm a"];
        NSString *st = [NSString stringWithFormat:@"From: %@", [timeFormat stringFromDate:self.operatingHour.from]];
        
        [self.startTimeButton setTitle:st forState:UIControlStateNormal];
    }
    
    if(self.operatingHour.to == nil) {
        [self.endTimeButton setTitle:@"To" forState:UIControlStateNormal];
    } else {
        NSDateFormatter *timeFormat = [[NSDateFormatter alloc] init];
        [timeFormat setDateFormat:@"hh:mm a"];
        NSString *st = [NSString stringWithFormat:@"To: %@", [timeFormat stringFromDate:self.operatingHour.to]];
        
        [self.endTimeButton setTitle:st forState:UIControlStateNormal];
    }
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

-(void) viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    NSArray *viewControllers = self.navigationController.viewControllers;
    if (viewControllers.count > 1 && [viewControllers objectAtIndex:viewControllers.count-2] == self) {
    } else if ([viewControllers indexOfObject:self] == NSNotFound) {
        [self.context reset];
    } else {
        
    }
}

-(void) showTimePickerActionSheet:(NSString *) timePeriod {
    
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:@"" delegate:self cancelButtonTitle:@"Done" destructiveButtonTitle:nil otherButtonTitles:nil];
    
    actionSheet.actionSheetStyle = UIActionSheetStyleAutomatic;


    self.timePicker = [[UIDatePicker alloc] initWithFrame:CGRectMake(0,100, 320, 100)];
    
    self.timePicker.datePickerMode = UIDatePickerModeTime;
    

    if ([timePeriod isEqualToString:@"from"]) {
        actionSheet.tag = FROM_ACTIONSHEET_TAG;
        self.timePicker.tag = FROM_PICKER_TAG;
        self.timePicker.minuteInterval = 15;
        if(self.operatingHour.from != nil) {
            [self.timePicker setDate: self.operatingHour.from ];
            [self.timePicker setMinuteInterval:15];
        }
        actionSheet.title = @"Select open time";
    } else {
        actionSheet.tag = TO_ACTIONSHEET_TAG;
        self.timePicker.tag = TO_PICKER_TAG;
        self.timePicker.minuteInterval = 15;
        if(self.operatingHour.to != nil) {
            
            [self.timePicker setDate:self.operatingHour.to];
        }
        actionSheet.title = @"Select close time";
    }

    [actionSheet addSubview:self.timePicker];
    
    [actionSheet showInView: self.view];

    [actionSheet setBounds:CGRectMake(0,0, 320, 520)];
        
    self.timePicker.hidden = NO;
}

# pragma mark UIActionSheet Delegate

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger) buttonIndex {
    if (actionSheet.tag == FROM_ACTIONSHEET_TAG) {
        unsigned int flags = NSHourCalendarUnit | NSMinuteCalendarUnit;
        NSCalendar *calendar = [NSCalendar currentCalendar];
        
        NSDateComponents *components = [calendar components:flags fromDate:[self.timePicker date]];
        NSDate* fromTime = [calendar dateFromComponents:components];
        self.operatingHour.from = fromTime;
    } else if (actionSheet.tag == TO_ACTIONSHEET_TAG) {
        unsigned int flags = NSHourCalendarUnit | NSMinuteCalendarUnit;
        NSCalendar *calendar = [NSCalendar currentCalendar];
        
        NSDateComponents *components = [calendar components:flags fromDate:[self.timePicker date]];
        NSDate* toTime = [calendar dateFromComponents:components];
        
        self.operatingHour.to = toTime;
    }
    
    [self refreshFromToButtons];
}

@end