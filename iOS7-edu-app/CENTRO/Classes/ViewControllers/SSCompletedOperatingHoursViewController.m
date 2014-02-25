//
//  SSCompletedOperatingHoursViewController.m
//  CENTRO
//
//  Created by Centro Community Partners.
//  Copyright (c) 2013 Centro Community Partners. All rights reserved.
//

#import "SSCompletedOperatingHoursViewController.h"
#import "SSUser.h"
#import "OperatingHour.h"
#import "SSUtils.h"

@interface SSCompletedOperatingHoursViewController ()

@property (strong, nonatomic) NSManagedObjectContext *context;

@end

@implementation SSCompletedOperatingHoursViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {

    }
    return self;
}

- (IBAction)tryAgainButtonPressed:(id)sender {
    [[SSUser currentUser] setActivityNumberAsIncompleted:@"20"];
    
    UIStoryboard *profileStoryBoard = [UIStoryboard storyboardWithName: @"operating_hours" bundle:Nil];
    UIViewController *initProfileView = [profileStoryBoard instantiateInitialViewController];
    initProfileView.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
    //[VC presentViewController:initProfileView animated: animation completion: NULL];
    
    [self.navigationController pushViewController:initProfileView animated:YES];
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
    
    self.navigationItem.title = @"Hours";
    
    self.tryAgainButton.title = @"Try Again!";
    
    self.titleLabel.text = [NSString stringWithFormat:@"%@'s business hours are:", [SSUtils companyName]];
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"OperatingHour"
                                              inManagedObjectContext:self.context];
    [fetchRequest setEntity:entity];
    
    [fetchRequest setPredicate:[NSPredicate predicateWithFormat:@"companyID = %@ AND selectedAsWorkingDay == %@", [[SSUser currentUser] companyID], [NSNumber numberWithBool:YES]]];
    
    fetchRequest.sortDescriptors = [NSArray arrayWithObject:[NSSortDescriptor sortDescriptorWithKey:@"dayOfWeekID" ascending:YES selector:nil]];
    
    NSError *error;
    NSArray *fetchedObjects = [self.context executeFetchRequest:fetchRequest error:&error];
    if (fetchedObjects.count == 0) {
        
        self.workingHoursTextView.text = @"";
    } else {
        NSString *wh = @"";
        
        NSDateFormatter *timeFormat = [[NSDateFormatter alloc] init];
        [timeFormat setDateFormat:@"hh:mm a"];
        
        for (OperatingHour *oh in fetchedObjects) {
            NSString *day = [self dayLiteralForID:[[oh dayOfWeekID] stringValue]];
            NSString *from = [timeFormat stringFromDate:[oh from]];
            NSString *to = [timeFormat stringFromDate:[oh to]];
            if([wh isEqualToString:@""]) {
                wh = [NSString stringWithFormat:@"%@ %@ - %@", day, from, to];
            } else {
                wh = [NSString stringWithFormat:@"%@\n%@ %@ - %@", wh, day, from, to];
            }
            
        }
        self.workingHoursTextView.text = wh;
    }
}

-(NSString *) dayLiteralForID:(NSString *) dayID {
    
    NSString *dayLiteral = @"";
    
    if([dayID isEqualToString:@"1"]) {
        dayLiteral = @"Mon";
    } else if([dayID isEqualToString:@"2"]) {
        dayLiteral = @"Tue";
    } else if([dayID isEqualToString:@"3"]) {
        dayLiteral = @"Wed";
    } else if([dayID isEqualToString:@"4"]) {
        dayLiteral = @"Thu";
    } else if([dayID isEqualToString:@"5"]) {
        dayLiteral = @"Fri";
    } else if([dayID isEqualToString:@"6"]) {
        dayLiteral = @"Sat";
    } else if([dayID isEqualToString:@"7"]) {
        dayLiteral = @"Sun";
    }
    
    return dayLiteral;
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end