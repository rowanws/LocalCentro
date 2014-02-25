//
//  SSServerData.m
//  CENTRO
//
//  Created by Centro Community Partners.
//  Copyright (c) 2013 Centro Community Partners. All rights reserved.
//

#import "SSServerData.h"
#import "MBProgressHUD.h"
#import "CENTROAPIClient.h"
#import "SSUser.h"
#import "SSUtils.h"
#import "Student.h"
#import "Activity.h"
#import "Value.h"
#import "Company.h"
#import "Purpose.h"
#import "Mission.h"
#import "Vision.h"
#import "StudentCost.h"
#import "StudentIncome.h"
#import "StudentAsset.h"
#import "StudentDebt.h"
#import "IndustryAndSegment.h"
#import "Industry.h"
#import "CustomerProfile.h"
#import "CustomerEducation.h"
#import "CustomerOccupation.h"
#import "CustomerInterest.h"
#import "CustomerPriority.h"
#import "CustomerProfileSample.h"
#import "NearbyCompetitor.h"
#import "CompetitorProfile.h"
#import "Category.h"
#import "Product.h"
#import "ValueProposition.h"
#import "OperatingHour.h"
#import "Employee.h"
#import "EmployeeEducation.h"
#import "Responsibility.h"
#import "EmployeeResponsibility.h"
#import "BrandAttribute.h"
#import "CompanyCost.h"
#import "CompanyAsset.h"
#import "CompanyDebt.h"
#import "SSActivitiesViewController.h"

@interface SSServerData()

@property (strong, nonatomic) NSManagedObjectContext *context;
@property (strong, nonatomic) Student *student;
@property (strong, nonatomic) MBProgressHUD *hudForDataGathering;
@property (strong, nonatomic) MBProgressHUD *hudForPush;

-(void) setStudentForCurrentUser;

@end

@implementation SSServerData

-(void) pullAndShowHUDInViewController: (UIViewController *) viewController {
    
    self.hudForDataGathering = [MBProgressHUD showHUDAddedTo:viewController.view animated:YES];
    self.hudForDataGathering.mode = MBProgressHUDModeIndeterminate;
    self.hudForDataGathering.labelText = NSLocalizedString(@"HUDLabelTextGatherServerData", nil);
    [[UIApplication sharedApplication] beginIgnoringInteractionEvents];
    
    self.context = [(id)[[UIApplication sharedApplication] delegate] managedObjectContext];
    [self setStudentForCurrentUser];
    
    CENTROAPIClient *client = [CENTROAPIClient sharedClient];
    [[AFNetworkActivityIndicatorManager sharedManager] setEnabled:YES];
    
    NSDictionary *paramToken = @{@"auth_token": [[SSUser currentUser] token]};
    
    AFJSONRequestOperation *operationActivity = [self pullActivitiesDataWithClient:client Params:paramToken AndShowHUDInViewController:viewController];
    AFJSONRequestOperation *operationValues = [self pullValuesDataWithClient:client Params:paramToken AndShowHUDInViewController:viewController];
    AFJSONRequestOperation *operationCompany = [self pullCompanyDataWithClient:client Params:paramToken AndShowHUDInViewController:viewController];
    AFJSONRequestOperation *operationMission = [self pullMissionDataWithClient:client Params:paramToken AndShowHUDInViewController:viewController];
    AFJSONRequestOperation *operationVision = [self pullVisionDataWithClient:client Params:paramToken AndShowHUDInViewController:viewController];
    AFJSONRequestOperation *operationPurpose = [self pullPurposesDataWithClient:client Params:paramToken AndShowHUDInViewController:viewController];
    AFJSONRequestOperation *operationCosts = [self pullStudentCostsDataWithClient:client Params:paramToken AndShowHUDInViewController:viewController];
    AFJSONRequestOperation *operationIncomes = [self pullStudentIncomesDataWithClient:client Params:paramToken AndShowHUDInViewController:viewController];
    AFJSONRequestOperation *operationAssets = [self pullStudentAssetsDataWithClient:client Params:paramToken AndShowHUDInViewController:viewController];
    AFJSONRequestOperation *operationDebts = [self pullStudentDebtsDataWithClient:client Params:paramToken AndShowHUDInViewController:viewController];
    AFJSONRequestOperation *operationIndustryAndSegmentsData = [self pullIndustryAndSegmentsDataWithClient:client Params:paramToken AndShowHUDInViewController:viewController];
    AFJSONRequestOperation *operationIndustry = [self pullIndustryDataWithClient:client Params:paramToken AndShowHUDInViewController:viewController];
    AFJSONRequestOperation *operationCustomerProfile = [self pullCustomerProfileDataWithClient:client Params:paramToken AndShowHUDInViewController:viewController];
    AFJSONRequestOperation *operationEducations = [self pullEducationsDataWithClient:client Params:paramToken AndShowHUDInViewController:viewController];
    AFJSONRequestOperation *operationOccupations = [self pullOccupationsDataWithClient:client Params:paramToken AndShowHUDInViewController:viewController];
    AFJSONRequestOperation *operationInterests = [self pullInterestsDataWithClient:client Params:paramToken AndShowHUDInViewController:viewController];
    AFJSONRequestOperation *operationPriorities = [self pullPrioritiesDataWithClient:client Params:paramToken AndShowHUDInViewController:viewController];
    AFJSONRequestOperation *operationCustomerProfileSamples = [self pullCustomerProfileSamplesDataWithClient:client Params:paramToken AndShowHUDInViewController:viewController];
    AFJSONRequestOperation *operationNearbyCompetitor = [self pullNearbyCompetitorDataWithClient:client Params:paramToken AndShowHUDInViewController:viewController];
    AFJSONRequestOperation *operationCompetitorProfiles = [self pullCompetitorProfilesDataWithClient:client Params:paramToken AndShowHUDInViewController:viewController];
    AFJSONRequestOperation *operationProductCategory = [self pullProductCategoriesDataWithClient:client Params:paramToken AndShowHUDInViewController:viewController];
    AFJSONRequestOperation *operationProducts = [self pullProductsDataWithClient:client Params:paramToken AndShowHUDInViewController:viewController];
    AFJSONRequestOperation *operationValuePropositions = [self pullValuePropositionsDataWithClient:client Params:paramToken AndShowHUDInViewController:viewController];
    AFJSONRequestOperation *operationWorkingHours = [self pullWorkingHoursDataWithClient:client Params:paramToken AndShowHUDInViewController:viewController];
    AFJSONRequestOperation *operationEmployees = [self pullEmployeesDataWithClient:client Params:paramToken AndShowHUDInViewController:viewController];
    AFJSONRequestOperation *operationEmployeeEducations = [self pullEmployeeEducationsDataWithClient:client Params:paramToken AndShowHUDInViewController:viewController];
    AFJSONRequestOperation *operationResponsibilities = [self pullResponsibilitiesDataWithClient:client Params:paramToken AndShowHUDInViewController:viewController];
    AFJSONRequestOperation *operationEmployeeResponsibilities = [self pullEmployeeResponsibilitiesDataWithClient:client Params:paramToken AndShowHUDInViewController:viewController];
    AFJSONRequestOperation *operationBrandAttributes = [self pullBrandAttributesDataWithClient:client Params:paramToken AndShowHUDInViewController:viewController];
    AFJSONRequestOperation *operationCompanyCosts = [self pullCompanyCostsDataWithClient:client Params:paramToken AndShowHUDInViewController:viewController];
    AFJSONRequestOperation *operationCompanyAssets = [self pullCompanyAssetsDataWithClient:client Params:paramToken AndShowHUDInViewController:viewController];
    AFJSONRequestOperation *operationCompanyDebts = [self pullCompanyDebtsDataWithClient:client Params:paramToken AndShowHUDInViewController:viewController];
    
    
    
    NSOperationQueue *operationQueue = [[NSOperationQueue alloc] init];
    [operationQueue setMaxConcurrentOperationCount:1];
    
    [operationValues addDependency:operationActivity];
    [operationCompany addDependency:operationValues];
    [operationPurpose addDependency:operationCompany];
    [operationVision addDependency:operationPurpose];
    [operationMission addDependency:operationVision];
    [operationCosts addDependency:operationMission];
    [operationIncomes addDependency:operationCosts];
    [operationAssets addDependency:operationIncomes];
    [operationDebts addDependency:operationAssets];
    [operationIndustryAndSegmentsData addDependency:operationDebts];
    [operationIndustry addDependency:operationIndustryAndSegmentsData];
    [operationCustomerProfile addDependency:operationIndustry];
    [operationEducations addDependency:operationCustomerProfile];
    [operationOccupations addDependency:operationEducations];
    [operationInterests addDependency:operationOccupations];
    [operationPriorities addDependency:operationInterests];
    [operationCustomerProfileSamples addDependency:operationPriorities];
    [operationNearbyCompetitor addDependency:operationCustomerProfileSamples];
    [operationCompetitorProfiles addDependency:operationNearbyCompetitor];
    [operationProductCategory addDependency:operationCompetitorProfiles];
    [operationProducts addDependency:operationProductCategory];
    [operationValuePropositions addDependency:operationProducts];
    [operationWorkingHours addDependency:operationValuePropositions];
    [operationEmployees addDependency:operationWorkingHours];
    [operationEmployeeEducations addDependency:operationEmployees];
    [operationResponsibilities addDependency:operationEmployeeEducations];
    [operationEmployeeResponsibilities addDependency:operationResponsibilities];
    [operationBrandAttributes addDependency:operationEmployeeResponsibilities];
    [operationCompanyCosts addDependency:operationBrandAttributes];
    [operationCompanyAssets addDependency:operationCompanyCosts];
    [operationCompanyDebts addDependency:operationCompanyAssets];
    
    [self.hudForDataGathering show:YES];
    
    [operationQueue addOperations:@[operationActivity, operationValues, operationCompany, operationPurpose, operationVision, operationMission, operationCosts, operationIncomes, operationAssets, operationDebts, operationIndustryAndSegmentsData, operationIndustry, operationCustomerProfile, operationEducations, operationOccupations, operationInterests, operationPriorities, operationCustomerProfileSamples,operationNearbyCompetitor, operationCompetitorProfiles, operationProductCategory, operationProducts, operationValuePropositions, operationWorkingHours, operationEmployees, operationEmployeeEducations, operationResponsibilities, operationEmployeeResponsibilities, operationBrandAttributes, operationCompanyCosts, operationCompanyAssets, operationCompanyDebts] waitUntilFinished:NO];
    
}

-(void) pushAndShowHUDinViewController:(UIViewController *)viewController logOutAfter:(BOOL) logOut {
    
    [[UIApplication sharedApplication] beginIgnoringInteractionEvents];
    
    NSOperationQueue *operationQueue = [[NSOperationQueue alloc] init];
    [operationQueue setMaxConcurrentOperationCount:1];
    
    NSMutableArray *operationsArray = [[NSMutableArray alloc] initWithCapacity:34];
    
    NSOperationQueue *operationQueue2 = [[NSOperationQueue alloc] init];
    [operationQueue2 setMaxConcurrentOperationCount:1];
    
    NSMutableArray *operationsArray2 = [[NSMutableArray alloc] initWithCapacity:34];
    
    NSArray *activitiesToSync = [[SSUser currentUser] listOfNotSyncedActivities];
    
    CENTROAPIClient *client = [CENTROAPIClient sharedClient];
    
    self.context = [(id)[[UIApplication sharedApplication] delegate] managedObjectContext];
    
    self.hudForPush = [MBProgressHUD showHUDAddedTo:viewController.view animated:YES];
    self.hudForPush.mode = MBProgressHUDModeIndeterminate;
    
    if(logOut) {
        self.hudForPush.labelText = NSLocalizedString(@"HUDLabelTextLogOutAndSyncServerData", nil);
    } else {
        self.hudForPush.labelText = NSLocalizedString(@"HUDLabelTextSyncServerData", nil);
    }
    
    if([activitiesToSync count] > 0) {
        
        [[AFNetworkActivityIndicatorManager sharedManager] setEnabled:YES];
        
        for(Activity *activity in activitiesToSync) {
            int turn = [activity.turn intValue];
            
            if (turn == 1) {
                AFJSONRequestOperation *personalValues = [self pushValuesDataFromActivity:@"1" withClient:client showHUDInViewController:viewController];
                [operationsArray addObject:personalValues];
            } else if(turn == 2) {
                AFJSONRequestOperation *purposes = [self pushPurposesDataWithClient:client showHUDInViewController:viewController];
                [operationsArray addObject:purposes];
                AFJSONRequestOperation *vision = [self pushVisionDataWithClient:client showHUDInViewController:viewController];
                [vision addDependency:purposes];
                [operationsArray addObject:vision];
            } else if(turn == 3) {
                AFJSONRequestOperation *mission = [self pushMissionDataWithClient:client showHUDInViewController:viewController];
                [operationsArray addObject:mission];
            } else if(turn == 4) {
                AFJSONRequestOperation *companyValues = [self pushValuesDataFromActivity:@"4" withClient:client showHUDInViewController:viewController];
                [operationsArray addObject:companyValues];
            } else if(turn == 5) {
                [[SSUser currentUser] setActivityNumberAsCompleted:@"5" andSyncStatus:YES];
            } else if(turn == 6) {
                AFJSONRequestOperation *studentCosts = [self pushStudentCostsWithClient:client showHUDInViewController:viewController];
                [operationsArray addObject:studentCosts];
            } else if(turn == 7) {
                AFJSONRequestOperation *studentIncomes = [self pushStudentIncomesWithClient:client showHUDInViewController:viewController];
                [operationsArray addObject:studentIncomes];
            } else if(turn == 8) {
                [[SSUser currentUser] setActivityNumberAsCompleted:@"8" andSyncStatus:YES];
            }else if(turn == 9) {
                AFJSONRequestOperation *studentAssets = [self pushStudentAssetsWithClient:client showHUDInViewController:viewController];
                [operationsArray addObject:studentAssets];
            } else if(turn == 10) {
                AFJSONRequestOperation *studentDebts = [self pushStudentDebtsWithClient:client showHUDInViewController:viewController];
                [operationsArray addObject:studentDebts];
            } else if(turn == 11) {
                [[SSUser currentUser] setActivityNumberAsCompleted:@"11" andSyncStatus:YES];
            } else if(turn == 12) {
                AFJSONRequestOperation *marketAnalysis = [self pushMarketAnalysisWithClient:client showHUDInViewController:viewController];
                [operationsArray addObject:marketAnalysis];
            } else if(turn == 13) {
                AFJSONRequestOperation *customerProfile = [self pushCustomerProfileWithClient:client showHUDInViewController:viewController];
                [operationsArray addObject:customerProfile];
                AFJSONRequestOperation *customerEducation = [self pushCustomerEducationWithClient:client showHUDInViewController:viewController];
                [customerEducation addDependency:customerProfile];
                [operationsArray addObject:customerEducation];
                AFJSONRequestOperation *customerInterest = [self pushCustomerInterestWithClient:client showHUDInViewController:viewController];
                [customerInterest addDependency:customerEducation];
                [operationsArray addObject:customerInterest];
                AFJSONRequestOperation *customerOccupation = [self pushCustomerOccupationWithClient:client showHUDInViewController:viewController];
                [customerOccupation addDependency:customerInterest];
                [operationsArray addObject:customerOccupation];
                AFJSONRequestOperation *customerProfileSample = [self pushCustomerProfileSampleWithClient:client showHUDInViewController:viewController];
                [customerProfileSample addDependency:customerOccupation];
                [operationsArray addObject:customerProfileSample];
            } else if(turn == 14) {
                AFJSONRequestOperation *nearbyCompetitor = [self pushNearbyCompetitorsWithClient:client showHUDInViewController:viewController];
                [operationsArray addObject:nearbyCompetitor];
                AFJSONRequestOperation *competitorProfiles = [self pushCompetitorProfilesWithClient:client showHUDInViewController:viewController];
                [competitorProfiles addDependency:nearbyCompetitor];
                [operationsArray addObject:competitorProfiles];
            } else if(turn == 15) {
                AFJSONRequestOperation *company = [self pushCompanyWithClient:client showHUDInViewController:viewController];
                [operationsArray addObject:company];
                AFJSONRequestOperation *category = [self pushCategoriesWithClient:client showHUDInViewController:viewController];
                [category addDependency:company];
                [operationsArray addObject:category];
                AFJSONRequestOperation *product = [self pushItemWithClient:client showHUDInViewController:viewController];
                [product addDependency:category];
                [operationsArray addObject:product];
            } else if(turn == 16) {
                AFJSONRequestOperation *productPrice = [self pushItemPriceWithClient:client showHUDInViewController:viewController andTurn:@"16"];
                [operationsArray addObject:productPrice];
            } else if(turn == 17) {
                AFJSONRequestOperation *customerPriority = [self pushCustomerPrioritiesWithClient:client showHUDInViewController:viewController];
                [operationsArray addObject:customerPriority];
            } else if(turn == 18) {
                AFJSONRequestOperation *valuePropositions = [self pushValuePropositionsWithClient:client showHUDInViewController:viewController];
                [operationsArray addObject:valuePropositions];
            } else if(turn == 19) {
                [[SSUser currentUser] setActivityNumberAsCompleted:@"19" andSyncStatus:YES];
            } else if(turn == 20) {
                AFJSONRequestOperation *operatingHours = [self pushOperatingHoursWithClient:client showHUDInViewController:viewController];
                [operationsArray addObject:operatingHours];
            } else if(turn == 21) {
                AFJSONRequestOperation *companyForTeam = [self pushCompanyWithClient:client showHUDInViewController:viewController];
                [operationsArray addObject:companyForTeam];
                AFJSONRequestOperation *employees = [self pushEmployeesWithClient:client showHUDInViewController:viewController andTurn:@""];
                [employees addDependency:companyForTeam];
                [operationsArray addObject:employees];
                AFJSONRequestOperation *employeeEducations = [self pushEmployeeEducationsWithClient:client showHUDInViewController:viewController];
                [employeeEducations addDependency:employees];
                [operationsArray addObject:employeeEducations];
            } else if(turn == 22) {
                AFJSONRequestOperation *companyForSalaries = [self pushCompanyWithClient:client showHUDInViewController:viewController];
                [operationsArray addObject:companyForSalaries];
                AFJSONRequestOperation *employeesForSalaries = [self pushEmployeesWithClient:client showHUDInViewController:viewController andTurn:@"22"];
                [employeesForSalaries addDependency:companyForSalaries];
                [operationsArray addObject:employeesForSalaries];
            } else if(turn == 23) {
                AFJSONRequestOperation *responsibilities = [self pushResponsibilitiesWithClient:client showHUDInViewController:viewController];
                [operationsArray addObject:responsibilities];
                AFJSONRequestOperation *employeeResponsibilities = [self pushEmployeeResponsibilitiesWithClient:client showHUDInViewController:viewController andTurn:@"23"];
                [employeeResponsibilities addDependency:responsibilities];
                [operationsArray addObject:employeeResponsibilities];
            } else if(turn == 24) {
                AFJSONRequestOperation *employeeResponsibilitiesForCoreCompetencies = [self pushEmployeeResponsibilitiesWithClient:client showHUDInViewController:viewController andTurn:@"24"];
                [operationsArray addObject:employeeResponsibilitiesForCoreCompetencies];
            } else if(turn == 25) {
                [[SSUser currentUser] setActivityNumberAsCompleted:@"25" andSyncStatus:YES];
            } else if(turn == 26) {
                AFJSONRequestOperation *brandAttributes = [self pushBrandAttributesWithClient:client showHUDInViewController:viewController];
                [operationsArray addObject:brandAttributes];
            } else if(turn == 27) {
                AFJSONRequestOperation *companyCosts = [self pushCompanyCostsWithClient:client showHUDInViewController:viewController];
                [operationsArray addObject:companyCosts];
            } else if(turn == 28) {
                AFJSONRequestOperation *companyOtherCategory = [self pushCompanyWithClient:client showHUDInViewController:viewController];
                [operationsArray addObject:companyOtherCategory];
                AFJSONRequestOperation *businessIncome = [self pushItemPriceWithClient:client showHUDInViewController:viewController andTurn:@"28"];
                [businessIncome addDependency:companyOtherCategory];
                [operationsArray addObject:businessIncome];
            } else if(turn == 29) {
                [[SSUser currentUser] setActivityNumberAsCompleted:@"29" andSyncStatus:YES];
            } else if(turn == 30) {
                AFJSONRequestOperation *companyAssets = [self pushCompanyAssetsWithClient:client showHUDInViewController:viewController];
                [operationsArray addObject:companyAssets];
            } else if(turn == 31) {
                AFJSONRequestOperation *companyDebts = [self pushCompanyDebtsWithClient:client showHUDInViewController:viewController];
                [operationsArray addObject:companyDebts];
            } else if(turn == 32) {
                [[SSUser currentUser] setActivityNumberAsCompleted:@"32" andSyncStatus:YES];
            } else {
                NSLog(@"Not implemented yet.");
            }
        }
    }
    NSBlockOperation *stopHUD = [NSBlockOperation blockOperationWithBlock:^{
        if(logOut) {
            AFJSONRequestOperation *activities = [self pushActivitiesWithClient:client inViewController:viewController andStopHUD:NO];
            [operationsArray2 addObject:activities];
            
            AFJSONRequestOperation *logOut = [self logOutWithClient:client andPresentHUDInViewController:viewController];
            [logOut addDependency:activities];
            
            [operationsArray2 addObject:logOut];
        } else {
            AFJSONRequestOperation *activities = [self pushActivitiesWithClient:client inViewController:viewController andStopHUD:YES];
            [operationsArray2 addObject:activities];
        }
        [operationQueue2 addOperations:operationsArray2 waitUntilFinished:NO];
    }];
    
    if(operationsArray.count > 0) {
        [stopHUD addDependency:[operationsArray lastObject]];
    }
    
    [operationsArray addObject:stopHUD];
    
    [self.hudForPush show:YES];
    [operationQueue addOperations:operationsArray waitUntilFinished:NO];
}

#pragma mark - Individual pulls

-(AFJSONRequestOperation *) performUpdateWithClient:(CENTROAPIClient *) client Params:(NSDictionary *) paramToken AndShowHUDInViewController:(UIViewController *) viewController {
    
    [[AFNetworkActivityIndicatorManager sharedManager] incrementActivityCount];
    NSString *path = [NSString stringWithFormat:@"students/%@/patch.json", [[SSUser currentUser] studentID]];
    NSURLRequest *request = [client requestWithMethod:@"GET" path:path parameters:paramToken];
    
    AFJSONRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
        [[AFNetworkActivityIndicatorManager sharedManager] decrementActivityCount];
    } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
        [[AFNetworkActivityIndicatorManager sharedManager] decrementActivityCount];
        [self.hudForDataGathering hide:YES];
        [[SSUser currentUser] logOutAndPresentHUDInViewController:viewController];
        NSLog(@"Whoops, couldn't connect: %@", [JSON description]);
    }];
    
    return operation;
}

-(AFJSONRequestOperation *) pullActivitiesDataWithClient:(CENTROAPIClient *) client Params:(NSDictionary *) paramToken AndShowHUDInViewController:(UIViewController *) viewController {
    
    [[AFNetworkActivityIndicatorManager sharedManager] incrementActivityCount];
    NSString *pathActivity = [NSString stringWithFormat:@"students/%@/activities.json", [[SSUser currentUser] studentID]];
    NSURLRequest *requestActivity = [client requestWithMethod:@"GET" path:pathActivity parameters:paramToken];
    
    AFJSONRequestOperation *operationActivity = [AFJSONRequestOperation JSONRequestOperationWithRequest:requestActivity success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
        [[AFNetworkActivityIndicatorManager sharedManager] decrementActivityCount];
        
        NSEntityDescription *activity = [NSEntityDescription entityForName:@"Activity" inManagedObjectContext:self.context];
        
        NSDictionary *activityNode;
        for(activityNode in JSON) {
            
            Activity *tempActivity = (Activity *) [[NSManagedObject alloc] initWithEntity:activity
                                                           insertIntoManagedObjectContext:self.context];
            
            NSDate *completed;
            if([activityNode valueForKey:@"completed"] == [NSNull null]) {
                completed = nil;
            } else {
                NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
                [dateFormatter setDateFormat:@"yyyy-MM-dd"];
                completed = [dateFormatter dateFromString:[activityNode valueForKey:@"completed"]];
            }
            
            NSString *activityID;
            if ([activityNode valueForKey:@"id"] == [NSNull null]) {
                activityID = @"";
            } else {
                activityID = [activityNode valueForKey:@"id"];
            }
            
            NSString *name;
            if ([activityNode valueForKey:@"name"] == [NSNull null]) {
                name = @"";
            } else {
                name = [activityNode valueForKey:@"name"];
            }
            
            NSString *studentID;
            if ([activityNode valueForKey:@"studentID"] == [NSNull null]) {
                studentID = @"";
            } else {
                studentID = [activityNode valueForKey:@"student_id"];
            }
            
            NSString *synced;
            if ([activityNode valueForKey:@"synced"] == [NSNull null]) {
                synced = @"0";
            } else {
                synced = [activityNode valueForKey:@"synced"];
            }
            
            NSString *turn;
            if ([activityNode valueForKey:@"turn"] == [NSNull null]) {
                turn = @"";
            } else {
                turn = [activityNode valueForKey:@"turn"];
            }
            
            NSString *showCompletedScreen;
            if ([activityNode valueForKey:@"show_completed_screen"] == [NSNull null]) {
                showCompletedScreen = @"0";
            } else {
                showCompletedScreen = [activityNode valueForKey:@"show_completed_screen"];
            }
            
            tempActivity.completed = completed;
            tempActivity.activityID = [NSNumber numberWithInt:[activityID intValue]];
            tempActivity.name = name;
            tempActivity.studentID = [NSNumber numberWithInt:[studentID intValue]];
            tempActivity.synced = [NSNumber numberWithInt:[synced intValue]];
            tempActivity.turn = [NSNumber numberWithInt:[turn intValue]];
            tempActivity.showCompletedScreen = [NSNumber numberWithInt:[showCompletedScreen intValue]];
            
            [self.student addActivitiesObject:tempActivity];
        }
    } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
        [[AFNetworkActivityIndicatorManager sharedManager] decrementActivityCount];
        [self.hudForDataGathering hide:YES];
        [[SSUser currentUser] logOutAndPresentHUDInViewController:viewController];
        NSLog(@"Whoops, couldn't connect: %@", [JSON description]);
    }];
    
    return operationActivity;
}

-(AFJSONRequestOperation *) pullValuesDataWithClient:(CENTROAPIClient *) client Params:(NSDictionary *) paramToken AndShowHUDInViewController:(UIViewController *) viewController {
    
    [[AFNetworkActivityIndicatorManager sharedManager] incrementActivityCount];
    NSString *pathValues = [NSString stringWithFormat:@"students/%@/values.json", [[SSUser currentUser] studentID]];
    NSURLRequest *requestValues = [client requestWithMethod:@"GET" path:pathValues parameters:paramToken];
    
    AFJSONRequestOperation *operationValues= [AFJSONRequestOperation JSONRequestOperationWithRequest:requestValues success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
        [[AFNetworkActivityIndicatorManager sharedManager] decrementActivityCount];
        
        NSEntityDescription *values = [NSEntityDescription entityForName:@"Value" inManagedObjectContext:self.context];
        
        NSDictionary *valueNode;
        for(valueNode in JSON) {
            
            Value *tempValue = (Value *) [[NSManagedObject alloc] initWithEntity:values
                                                  insertIntoManagedObjectContext:self.context];
            NSString *valueID;
            if ([valueNode valueForKey:@"id"] == [NSNull null]) {
                valueID = @"";
            } else {
                valueID = [valueNode valueForKey:@"id"];
            }
            
            NSString *rank;
            if ([valueNode valueForKey:@"rank"] == [NSNull null]) {
                rank = @"";
            } else {
                rank = [valueNode valueForKey:@"rank"];
            }
            
            NSString *selectedOverValue;
            if ([valueNode valueForKey:@"selected_over_value"] == [NSNull null]) {
                selectedOverValue = @"";
            } else {
                selectedOverValue = [valueNode valueForKey:@"selected_over_value"];
            }
            
            NSString *studentID;
            if ([valueNode valueForKey:@"student_id"] == [NSNull null]) {
                studentID = @"";
            } else {
                studentID = [valueNode valueForKey:@"student_id"];
            }
            
            NSString *valueCode;
            if ([valueNode valueForKey:@"value_code"] == [NSNull null]) {
                valueCode = @"";
            } else {
                valueCode = [valueNode valueForKey:@"value_code"];
            }
            
            NSString *valueLiteralUS;
            if ([valueNode valueForKey:@"value_literal_us"] == [NSNull null]) {
                valueLiteralUS = @"";
            } else {
                valueLiteralUS = [valueNode valueForKey:@"value_literal_us"];
            }
            
            NSString *companyRank;
            if ([valueNode valueForKey:@"company_rank"] == [NSNull null]) {
                companyRank = @"";
            } else {
                companyRank = [valueNode valueForKey:@"company_rank"];
            }
            
            NSString *selectedAsCompanyValue;
            if ([valueNode valueForKey:@"selected_as_company_value"] == [NSNull null]) {
                selectedAsCompanyValue = @"0";
            } else {
                selectedAsCompanyValue = [valueNode valueForKey:@"selected_as_company_value"];
            }
            
            tempValue.valueID = [NSNumber numberWithInt:[valueID intValue]];
            tempValue.rank = [NSNumber numberWithInt:[rank intValue]];
            tempValue.selectedOver = selectedOverValue;
            tempValue.studentID = [NSNumber numberWithInt:[studentID intValue]];
            tempValue.valueCode = valueCode;
            tempValue.valueLiteralUS = valueLiteralUS;
            tempValue.companyRank = [NSNumber numberWithInt:[companyRank intValue]];
            tempValue.selectedAsCompanyValue = [NSNumber numberWithInt:[selectedAsCompanyValue intValue]];
            
            [self.student addValuesObject:tempValue];
        }
    } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
        [[AFNetworkActivityIndicatorManager sharedManager] decrementActivityCount];
        [self.hudForDataGathering hide:YES];
        [[SSUser currentUser] logOutAndPresentHUDInViewController:viewController];
        NSLog(@"Whoops, couldn't connect: %@", [JSON description]);
    }];
    
    return operationValues;
}

-(AFJSONRequestOperation *) pullCompanyDataWithClient:(CENTROAPIClient *) client Params:(NSDictionary *) paramToken AndShowHUDInViewController:(UIViewController *) viewController {
    
    [[AFNetworkActivityIndicatorManager sharedManager] incrementActivityCount];
    NSString *pathCompany = [NSString stringWithFormat:@"companies/%@.json", [[SSUser currentUser] companyID]];
    NSURLRequest *requestCompany = [client requestWithMethod:@"GET" path:pathCompany parameters:paramToken];
    
    AFJSONRequestOperation *operationCompany = [AFJSONRequestOperation JSONRequestOperationWithRequest:requestCompany success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
        [[AFNetworkActivityIndicatorManager sharedManager] decrementActivityCount];
        
        NSEntityDescription *company = [NSEntityDescription entityForName:@"Company" inManagedObjectContext:self.context];
        
        Company *tempCompany = (Company *) [[NSManagedObject alloc] initWithEntity:company
                                                    insertIntoManagedObjectContext:self.context];
        
        NSString *companyID;
        if ([JSON valueForKey:@"id"] == [NSNull null]) {
            companyID = @"";
        } else {
            companyID = [JSON valueForKey:@"id"];
        }
        
        NSString *name;
        if ([JSON valueForKey:@"name"] == [NSNull null]) {
            name = @"";
        } else {
            name = [JSON valueForKey:@"name"];
        }
        
        NSString *studentID;
        if ([JSON valueForKey:@"student_id"] == [NSNull null]) {
            studentID = @"";
        } else {
            studentID = [JSON valueForKey:@"student_id"];
        }
        
        NSString *productsQty;
        if ([JSON valueForKey:@"products_qty"] == [NSNull null]) {
            productsQty = @"";
        } else {
            productsQty = [JSON valueForKey:@"products_qty"];
        }
        
        NSString *productsAndServicesEstimate;
        if ([JSON valueForKey:@"products_services"] == [NSNull null]) {
            productsAndServicesEstimate = @"";
        } else {
            productsAndServicesEstimate = [JSON valueForKey:@"products_services"];
        }
        
        NSString *servicesQty;
        if ([JSON valueForKey:@"services_qty"] == [NSNull null]) {
            servicesQty = @"";
        } else {
            servicesQty = [JSON valueForKey:@"services_qty"];
        }
        
        NSString *isProductsSure;
        if ([JSON valueForKey:@"is_products_sure"] == [NSNull null]) {
            isProductsSure = @"1";
        } else {
            isProductsSure = [JSON valueForKey:@"is_products_sure"];
        }
        
        NSString *isServicesSure;
        if ([JSON valueForKey:@"is_services_sure"] == [NSNull null]) {
            isServicesSure = @"1";
        } else {
            isServicesSure = [JSON valueForKey:@"is_services_sure"];
        }
        
        NSString *otherProfitAmount;
        if ([JSON valueForKey:@"other_profit_amount"] == [NSNull null]) {
            otherProfitAmount = @"0.0";
        } else {
            otherProfitAmount = [JSON valueForKey:@"other_profit_amount"];
        }
        
        NSString *totalEmployeeBenefitsCosts;
        if ([JSON valueForKey:@"total_employee_benefits_costs"] == [NSNull null]) {
            totalEmployeeBenefitsCosts = @"0.0";
        } else {
            totalEmployeeBenefitsCosts = [JSON valueForKey:@"total_employee_benefits_costs"];
        }
        
        NSString *otherProfitFrequency;
        if ([JSON valueForKey:@"other_profit_frequency"] == [NSNull null]) {
            otherProfitFrequency = @"-1";
        } else {
            otherProfitFrequency = [JSON valueForKey:@"other_profit_frequency"];
        }
        
        NSString *isOtherProfitAmountSure;
        if ([JSON valueForKey:@"is_other_profit_amount_sure"] == [NSNull null]) {
            isOtherProfitAmountSure = @"1";
        } else {
            isOtherProfitAmountSure = [JSON valueForKey:@"is_other_profit_amount_sure"];
        }
        
        NSString *frequencyEmployeeBenefits;
        if ([JSON valueForKey:@"frequency_employee_benefits"] == [NSNull null]) {
            frequencyEmployeeBenefits = @"-1";
        } else {
            frequencyEmployeeBenefits = [JSON valueForKey:@"frequency_employee_benefits"];
        }
        
        NSString *numberOfEmployees;
        if ([JSON valueForKey:@"number_employees"] == [NSNull null]) {
            numberOfEmployees = @"-100";
        } else {
            numberOfEmployees = [JSON valueForKey:@"number_employees"];
        }
        
        tempCompany.companyID = [NSNumber numberWithInt:[companyID intValue]];
        tempCompany.name = name;
        tempCompany.studentID = [NSNumber numberWithInt:[studentID intValue]];
        tempCompany.productsQty = [NSNumber numberWithInt:[productsQty intValue]];
        tempCompany.productsAndServicesEstimate = [NSNumber numberWithInt:[productsAndServicesEstimate intValue]];
        tempCompany.servicesQty = [NSNumber numberWithInt:[servicesQty intValue]];
        tempCompany.isProductsSure = [NSNumber numberWithInt:[isProductsSure intValue]];
        tempCompany.isServicesSure = [NSNumber numberWithInt:[isServicesSure intValue]];
        tempCompany.otherProfitAmount = [NSNumber numberWithDouble:[otherProfitAmount doubleValue]];
        tempCompany.otherProfitFrequency = [NSNumber numberWithInt:[otherProfitFrequency intValue]];
        tempCompany.isOtherProfitAmountSure = [NSNumber numberWithInt:[isOtherProfitAmountSure intValue]];
        tempCompany.totalEmployeeBenefitsCosts = [NSNumber numberWithDouble:[totalEmployeeBenefitsCosts doubleValue]];
        tempCompany.frequencyEmployeeBenefits = [NSNumber numberWithInt:[frequencyEmployeeBenefits intValue]];
        tempCompany.numberOfEmployees = [NSNumber numberWithInt:[numberOfEmployees intValue]];
        
        self.student.company = tempCompany;
    } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
        [[AFNetworkActivityIndicatorManager sharedManager] decrementActivityCount];
        [self.hudForDataGathering hide:YES];
        [[SSUser currentUser] logOutAndPresentHUDInViewController:viewController];
        NSLog(@"Whoops, couldn't connect: %@", [JSON description]);
    }];
    
    return operationCompany;
}

-(AFJSONRequestOperation *) pullPurposesDataWithClient:(CENTROAPIClient *) client Params:(NSDictionary *) paramToken AndShowHUDInViewController:(UIViewController *) viewController {
    
    [[AFNetworkActivityIndicatorManager sharedManager] incrementActivityCount];
    NSString *pathPurpose = [NSString stringWithFormat:@"companies/%@/purposes.json", [[SSUser currentUser] companyID]];
    NSURLRequest *requestPurpose = [client requestWithMethod:@"GET" path:pathPurpose parameters:paramToken];
    
    AFJSONRequestOperation *operationPurpose = [AFJSONRequestOperation JSONRequestOperationWithRequest:requestPurpose success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
        [[AFNetworkActivityIndicatorManager sharedManager] decrementActivityCount];
        
        NSEntityDescription *purpose = [NSEntityDescription entityForName:@"Purpose" inManagedObjectContext:self.context];
        
        NSDictionary *purposeNode;
        for(purposeNode in JSON) {
            
            Purpose *tempPurpose = (Purpose *) [[NSManagedObject alloc] initWithEntity:purpose
                                                        insertIntoManagedObjectContext:self.context];
            
            NSString *companyID;
            if ([purposeNode valueForKey:@"company_id"] == [NSNull null]) {
                companyID = @"";
            } else {
                companyID = [purposeNode valueForKey:@"company_id"];
            }
            
            NSString *purposeID;
            if ([purposeNode valueForKey:@"id"] == [NSNull null]) {
                purposeID = @"";
            } else {
                purposeID = [purposeNode valueForKey:@"id"];
            }
            
            NSString *kind;
            if ([purposeNode valueForKey:@"kind"] == [NSNull null]) {
                kind = @"";
            } else {
                kind = [purposeNode valueForKey:@"kind"];
            }
            
            NSString *purpose;
            if ([purposeNode valueForKey:@"purpose"] == [NSNull null]) {
                purpose = @"";
            } else {
                purpose = [purposeNode valueForKey:@"purpose"];
            }
            
            tempPurpose.companyID = [NSNumber numberWithInt:[companyID intValue]];
            tempPurpose.purposeID = [NSNumber numberWithInt:[purposeID intValue]];
            tempPurpose.kind = kind;
            tempPurpose.purpose = purpose;
            
            [self.student.company addPurposesObject:tempPurpose];
        }
    } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
        [[AFNetworkActivityIndicatorManager sharedManager] decrementActivityCount];
        [self.hudForDataGathering hide:YES];
        [[SSUser currentUser] logOutAndPresentHUDInViewController:viewController];
        NSLog(@"Whoops, couldn't connect: %@", [JSON description]);
    }];
    
    return operationPurpose;
}

-(AFJSONRequestOperation *) pullVisionDataWithClient:(CENTROAPIClient *) client Params:(NSDictionary *) paramToken AndShowHUDInViewController:(UIViewController *) viewController {
    
    [[AFNetworkActivityIndicatorManager sharedManager] incrementActivityCount];
    NSString *pathVision = [NSString stringWithFormat:@"visions/%@.json", [[SSUser currentUser] companyID]];
    NSURLRequest *requestVision = [client requestWithMethod:@"GET" path:pathVision parameters:paramToken];
    
    AFJSONRequestOperation *operationVision = [AFJSONRequestOperation JSONRequestOperationWithRequest:requestVision success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
        [[AFNetworkActivityIndicatorManager sharedManager] decrementActivityCount];
        
        NSEntityDescription *vision = [NSEntityDescription entityForName:@"Vision" inManagedObjectContext:self.context];
        
        Vision *tempVision = (Vision *) [[NSManagedObject alloc] initWithEntity:vision
                                                 insertIntoManagedObjectContext:self.context];
        
        NSString *companyID;
        if ([JSON valueForKey:@"company_id"] == [NSNull null]) {
            companyID = @"";
        } else {
            companyID = [JSON valueForKey:@"company_id"];
        }
        
        NSString *visionID;
        if ([JSON valueForKey:@"id"] == [NSNull null]) {
            visionID = @"";
        } else {
            visionID = [JSON valueForKey:@"id"];
        }
        
        NSString *visionText;
        if ([JSON valueForKey:@"vision"] == [NSNull null]) {
            visionText = @"";
        } else {
            visionText = [JSON valueForKey:@"vision"];
        }
        
        tempVision.companyID = [NSNumber numberWithInt:[companyID intValue]];
        tempVision.visionID = [NSNumber numberWithInt:[visionID intValue]];
        tempVision.vision = visionText;
        
        self.student.company.vision = tempVision;
    } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
        [[AFNetworkActivityIndicatorManager sharedManager] decrementActivityCount];
        [self.hudForDataGathering hide:YES];
        [[SSUser currentUser] logOutAndPresentHUDInViewController:viewController];
        NSLog(@"Whoops, couldn't connect: %@", [JSON description]);
    }];
    
    return operationVision;
    
}

-(AFJSONRequestOperation *) pullMissionDataWithClient:(CENTROAPIClient *) client Params:(NSDictionary *) paramToken AndShowHUDInViewController:(UIViewController *) viewController {
    
    [[AFNetworkActivityIndicatorManager sharedManager] incrementActivityCount];
    NSString *pathMission = [NSString stringWithFormat:@"missions/%@.json", [[SSUser currentUser] companyID]];
    NSURLRequest *requestMission = [client requestWithMethod:@"GET" path:pathMission parameters:paramToken];
    
    AFJSONRequestOperation *operationMission = [AFJSONRequestOperation JSONRequestOperationWithRequest:requestMission success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
        [[AFNetworkActivityIndicatorManager sharedManager] decrementActivityCount];
        
        NSEntityDescription *mission = [NSEntityDescription entityForName:@"Mission" inManagedObjectContext:self.context];
        
        Mission *tempMission = (Mission *) [[NSManagedObject alloc] initWithEntity:mission
                                                    insertIntoManagedObjectContext:self.context];
        
        NSString *companyID;
        if ([JSON valueForKey:@"company_id"] == [NSNull null]) {
            companyID = @"";
        } else {
            companyID = [JSON valueForKey:@"company_id"];
        }
        
        NSString *missionID;
        if ([JSON valueForKey:@"id"] == [NSNull null]) {
            missionID = @"";
        } else {
            missionID = [JSON valueForKey:@"id"];
        }
        
        NSString *missionText;
        if ([JSON valueForKey:@"mission"] == [NSNull null]) {
            missionText = @"";
        } else {
            missionText = [JSON valueForKey:@"mission"];
        }
        
        tempMission.companyID = [NSNumber numberWithInt:[companyID intValue]];
        tempMission.missionID = [NSNumber numberWithInt:[missionID intValue]];
        tempMission.mission = missionText;
        
        self.student.company.mission = tempMission;
        
    } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
        [[AFNetworkActivityIndicatorManager sharedManager] decrementActivityCount];
        [self.hudForDataGathering hide:YES];
        [[SSUser currentUser] logOutAndPresentHUDInViewController:viewController];
        NSLog(@"Whoops, couldn't connect: %@", [JSON description]);
    }];
    
    return operationMission;
}

-(AFJSONRequestOperation *) pullStudentCostsDataWithClient:(CENTROAPIClient *) client Params:(NSDictionary *) paramToken AndShowHUDInViewController:(UIViewController *) viewController {
    
    [[AFNetworkActivityIndicatorManager sharedManager] incrementActivityCount];
    NSString *pathStudentCosts = [NSString stringWithFormat:@"students/%@/costs.json", [[SSUser currentUser] studentID]];
    NSURLRequest *requestStudentCosts = [client requestWithMethod:@"GET" path:pathStudentCosts parameters:paramToken];
    
    AFJSONRequestOperation *operationStudentCosts = [AFJSONRequestOperation JSONRequestOperationWithRequest:requestStudentCosts success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
        [[AFNetworkActivityIndicatorManager sharedManager] decrementActivityCount];
        
        NSEntityDescription *studentCosts = [NSEntityDescription entityForName:@"StudentCost" inManagedObjectContext:self.context];
        
        NSDictionary *studentCostNode;
        for(studentCostNode in JSON) {
            
            StudentCost *tempStudentCost = (StudentCost *) [[NSManagedObject alloc] initWithEntity:studentCosts
                                                                    insertIntoManagedObjectContext:self.context];
            NSString *studentCostID;
            if ([studentCostNode valueForKey:@"id"] == [NSNull null]) {
                studentCostID = @"";
            } else {
                studentCostID = [studentCostNode valueForKey:@"id"];
            }
            
            NSString *studentID;
            if ([studentCostNode valueForKey:@"student_id"] == [NSNull null]) {
                studentID = @"";
            } else {
                studentID = [studentCostNode valueForKey:@"student_id"];
            }
            
            NSString *isSure;
            if ([studentCostNode valueForKey:@"is_sure"] == [NSNull null]) {
                isSure = @"0";
            } else {
                isSure = [studentCostNode valueForKey:@"is_sure"];
            }
            
            NSString *frequency;
            if ([studentCostNode valueForKey:@"frequency"] == [NSNull null]) {
                frequency = @"-1";
            } else {
                frequency = [studentCostNode valueForKey:@"frequency"];
            }
            
            NSString *studentCostCode;
            if ([studentCostNode valueForKey:@"cost_code"] == [NSNull null]) {
                studentCostCode = @"";
            } else {
                studentCostCode = [studentCostNode valueForKey:@"cost_code"];
            }
            
            NSString *studentCostLiteralUS;
            if ([studentCostNode valueForKey:@"cost_literal_us"] == [NSNull null]) {
                studentCostLiteralUS = @"";
            } else {
                studentCostLiteralUS = [studentCostNode valueForKey:@"cost_literal_us"];
            }
            
            NSString *amount;
            if ([studentCostNode valueForKey:@"amount"] == [NSNull null]) {
                amount = @"0.0";
            } else {
                amount = [studentCostNode valueForKey:@"amount"];
            }
            
            NSString *selectedAsIncurredCost;
            if ([studentCostNode valueForKey:@"selected_as_incurred_cost"] == [NSNull null]) {
                selectedAsIncurredCost = @"0";
            } else {
                selectedAsIncurredCost = [studentCostNode valueForKey:@"selected_as_incurred_cost"];
            }
            
            tempStudentCost.studentCostID = [NSNumber numberWithInt:[studentCostID intValue]];
            tempStudentCost.studentID = [NSNumber numberWithInt:[studentID intValue]];
            tempStudentCost.isSure = [NSNumber numberWithInt:[isSure intValue]];
            tempStudentCost.frequency = [NSNumber numberWithInt:[frequency intValue]];
            tempStudentCost.studentCostCode = studentCostCode;
            tempStudentCost.studentCostLiteralUS = studentCostLiteralUS;
            tempStudentCost.amount = [NSNumber numberWithDouble:[amount doubleValue]];
            tempStudentCost.selectedAsIncurredCost = [NSNumber numberWithInt:[selectedAsIncurredCost intValue]];
            
            [self.student addCostsObject:tempStudentCost];
        }
        
    } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
        [[AFNetworkActivityIndicatorManager sharedManager] decrementActivityCount];
        [self.hudForDataGathering hide:YES];
        [[SSUser currentUser] logOutAndPresentHUDInViewController:viewController];
        NSLog(@"Whoops, couldn't connect: %@", [JSON description]);
    }];
    
    return operationStudentCosts;
}

-(AFJSONRequestOperation *) pullStudentIncomesDataWithClient:(CENTROAPIClient *) client Params:(NSDictionary *) paramToken AndShowHUDInViewController:(UIViewController *) viewController {
    
    [[AFNetworkActivityIndicatorManager sharedManager] incrementActivityCount];
    NSString *pathStudentIncomes = [NSString stringWithFormat:@"students/%@/incomes.json", [[SSUser currentUser] studentID]];
    NSURLRequest *requestStudentIncomes = [client requestWithMethod:@"GET" path:pathStudentIncomes parameters:paramToken];
    
    AFJSONRequestOperation *operationStudentIncomes = [AFJSONRequestOperation JSONRequestOperationWithRequest:requestStudentIncomes success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
        [[AFNetworkActivityIndicatorManager sharedManager] decrementActivityCount];
        
        NSEntityDescription *studentIncomes = [NSEntityDescription entityForName:@"StudentIncome" inManagedObjectContext:self.context];
        
        NSDictionary *studentIncomeNode;
        for(studentIncomeNode in JSON) {
            
            StudentIncome *tempStudentIncome = (StudentIncome *) [[NSManagedObject alloc] initWithEntity:studentIncomes
                                                                          insertIntoManagedObjectContext:self.context];
            NSString *studentIncomeID;
            if ([studentIncomeNode valueForKey:@"id"] == [NSNull null]) {
                studentIncomeID = @"";
            } else {
                studentIncomeID = [studentIncomeNode valueForKey:@"id"];
            }
            
            NSString *studentID;
            if ([studentIncomeNode valueForKey:@"student_id"] == [NSNull null]) {
                studentID = @"";
            } else {
                studentID = [studentIncomeNode valueForKey:@"student_id"];
            }
            
            NSString *isSure;
            if ([studentIncomeNode valueForKey:@"is_sure"] == [NSNull null]) {
                isSure = @"0";
            } else {
                isSure = [studentIncomeNode valueForKey:@"is_sure"];
            }
            
            NSString *frequency;
            if ([studentIncomeNode valueForKey:@"frequency"] == [NSNull null]) {
                frequency = @"-1";
            } else {
                frequency = [studentIncomeNode valueForKey:@"frequency"];
            }
            
            NSString *studentIncomeCode;
            if ([studentIncomeNode valueForKey:@"source_code"] == [NSNull null]) {
                studentIncomeCode = @"";
            } else {
                studentIncomeCode = [studentIncomeNode valueForKey:@"source_code"];
            }
            
            NSString *studentIncomeLiteralUS;
            if ([studentIncomeNode valueForKey:@"source_literal_us"] == [NSNull null]) {
                studentIncomeLiteralUS = @"";
            } else {
                studentIncomeLiteralUS = [studentIncomeNode valueForKey:@"source_literal_us"];
            }
            
            NSString *amount;
            if ([studentIncomeNode valueForKey:@"amount"] == [NSNull null]) {
                amount = @"0.0";
            } else {
                amount = [studentIncomeNode valueForKey:@"amount"];
            }
            
            NSString *selectedAsIncome;
            if ([studentIncomeNode valueForKey:@"selected_as_source_income"] == [NSNull null]) {
                selectedAsIncome = @"0";
            } else {
                selectedAsIncome = [studentIncomeNode valueForKey:@"selected_as_source_income"];
            }
            
            tempStudentIncome.studentIncomeID = [NSNumber numberWithInt:[studentIncomeID intValue]];
            tempStudentIncome.studentID = [NSNumber numberWithInt:[studentID intValue]];
            tempStudentIncome.isSure = [NSNumber numberWithInt:[isSure intValue]];
            tempStudentIncome.frequency = [NSNumber numberWithInt:[frequency intValue]];
            tempStudentIncome.studentIncomeCode = studentIncomeCode;
            tempStudentIncome.studentIncomeLiteralUS = studentIncomeLiteralUS;
            tempStudentIncome.amount = [NSNumber numberWithDouble:[amount doubleValue]];
            tempStudentIncome.selectedAsSourceOfIncome = [NSNumber numberWithInt:[selectedAsIncome intValue]];
            
            [self.student addIncomesObject:tempStudentIncome];
        }
        
    } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
        [[AFNetworkActivityIndicatorManager sharedManager] decrementActivityCount];
        [self.hudForDataGathering hide:YES];
        [[SSUser currentUser] logOutAndPresentHUDInViewController:viewController];
        NSLog(@"Whoops, couldn't connect: %@", [JSON description]);
    }];
    
    return operationStudentIncomes;
}

-(AFJSONRequestOperation *) pullStudentAssetsDataWithClient:(CENTROAPIClient *) client Params:(NSDictionary *) paramToken AndShowHUDInViewController:(UIViewController *) viewController {
    
    [[AFNetworkActivityIndicatorManager sharedManager] incrementActivityCount];
    NSString *pathStudentAssets = [NSString stringWithFormat:@"students/%@/assets.json", [[SSUser currentUser] studentID]];
    NSURLRequest *requestStudentAssets = [client requestWithMethod:@"GET" path:pathStudentAssets parameters:paramToken];
    
    AFJSONRequestOperation *operationStudentAssets = [AFJSONRequestOperation JSONRequestOperationWithRequest:requestStudentAssets success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
        [[AFNetworkActivityIndicatorManager sharedManager] decrementActivityCount];
        
        NSEntityDescription *studentAssets = [NSEntityDescription entityForName:@"StudentAsset" inManagedObjectContext:self.context];
        
        NSDictionary *studentAssetNode;
        for(studentAssetNode in JSON) {
            
            StudentAsset *tempStudentAsset = (StudentAsset *) [[NSManagedObject alloc] initWithEntity:studentAssets
                                                                       insertIntoManagedObjectContext:self.context];
            NSString *studentAssetID;
            if ([studentAssetNode valueForKey:@"id"] == [NSNull null]) {
                studentAssetID = @"";
            } else {
                studentAssetID = [studentAssetNode valueForKey:@"id"];
            }
            
            NSString *studentID;
            if ([studentAssetNode valueForKey:@"student_id"] == [NSNull null]) {
                studentID = @"";
            } else {
                studentID = [studentAssetNode valueForKey:@"student_id"];
            }
            
            NSString *isSure;
            if ([studentAssetNode valueForKey:@"is_sure"] == [NSNull null]) {
                isSure = @"0";
            } else {
                isSure = [studentAssetNode valueForKey:@"is_sure"];
            }
            
            NSString *studentAssetCode;
            if ([studentAssetNode valueForKey:@"asset_code"] == [NSNull null]) {
                studentAssetCode = @"";
            } else {
                studentAssetCode = [studentAssetNode valueForKey:@"asset_code"];
            }
            
            NSString *studentAssetLiteralUS;
            if ([studentAssetNode valueForKey:@"asset_literal_us"] == [NSNull null]) {
                studentAssetLiteralUS = @"";
            } else {
                studentAssetLiteralUS = [studentAssetNode valueForKey:@"asset_literal_us"];
            }
            
            NSString *amount;
            if ([studentAssetNode valueForKey:@"amount"] == [NSNull null]) {
                amount = @"0.0";
            } else {
                amount = [studentAssetNode valueForKey:@"amount"];
            }
            
            NSString *selectedAsAsset;
            if ([studentAssetNode valueForKey:@"selected_as_asset"] == [NSNull null]) {
                selectedAsAsset = @"0";
            } else {
                selectedAsAsset = [studentAssetNode valueForKey:@"selected_as_asset"];
            }
            
            tempStudentAsset.studentAssetID = [NSNumber numberWithInt:[studentAssetID intValue]];
            tempStudentAsset.studentID = [NSNumber numberWithInt:[studentID intValue]];
            tempStudentAsset.isSure = [NSNumber numberWithInt:[isSure intValue]];
            tempStudentAsset.studentAssetCode = studentAssetCode;
            tempStudentAsset.studentAssetLiteralUS = studentAssetLiteralUS;
            tempStudentAsset.amount = [NSNumber numberWithDouble:[amount doubleValue]];
            tempStudentAsset.selectedAsAsset = [NSNumber numberWithInt:[selectedAsAsset intValue]];
            
            [self.student addAssetsObject:tempStudentAsset];
        }
        
    } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
        [[AFNetworkActivityIndicatorManager sharedManager] decrementActivityCount];
        [self.hudForDataGathering hide:YES];
        [[SSUser currentUser] logOutAndPresentHUDInViewController:viewController];
        NSLog(@"Whoops, couldn't connect: %@", [JSON description]);
    }];
    
    return operationStudentAssets;
}

-(AFJSONRequestOperation *) pullStudentDebtsDataWithClient:(CENTROAPIClient *) client Params:(NSDictionary *) paramToken AndShowHUDInViewController:(UIViewController *) viewController {
    
    [[AFNetworkActivityIndicatorManager sharedManager] incrementActivityCount];
    NSString *pathStudentDebts = [NSString stringWithFormat:@"students/%@/debts.json", [[SSUser currentUser] studentID]];
    NSURLRequest *requestStudentDebts = [client requestWithMethod:@"GET" path:pathStudentDebts parameters:paramToken];
    
    AFJSONRequestOperation *operationStudentAssets = [AFJSONRequestOperation JSONRequestOperationWithRequest:requestStudentDebts success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
        [[AFNetworkActivityIndicatorManager sharedManager] decrementActivityCount];
        
        NSEntityDescription *studentDebts = [NSEntityDescription entityForName:@"StudentDebt" inManagedObjectContext:self.context];
        
        NSDictionary *studentDebtNode;
        for(studentDebtNode in JSON) {
            
            StudentDebt *tempStudentDebt = (StudentDebt *) [[NSManagedObject alloc] initWithEntity:studentDebts
                                                                    insertIntoManagedObjectContext:self.context];
            
            NSString *studentDebtID;
            if ([studentDebtNode valueForKey:@"id"] == [NSNull null]) {
                studentDebtID = @"";
            } else {
                studentDebtID = [studentDebtNode valueForKey:@"id"];
            }
            
            NSString *studentID;
            if ([studentDebtNode valueForKey:@"student_id"] == [NSNull null]) {
                studentID = @"";
            } else {
                studentID = [studentDebtNode valueForKey:@"student_id"];
            }
            
            NSString *isSure;
            if ([studentDebtNode valueForKey:@"is_sure"] == [NSNull null]) {
                isSure = @"0";
            } else {
                isSure = [studentDebtNode valueForKey:@"is_sure"];
            }
            
            NSString *studentDebtCode;
            if ([studentDebtNode valueForKey:@"debt_code"] == [NSNull null]) {
                studentDebtCode = @"";
            } else {
                studentDebtCode = [studentDebtNode valueForKey:@"debt_code"];
            }
            
            NSString *studentDebtLiteralUS;
            if ([studentDebtNode valueForKey:@"debt_literal_us"] == [NSNull null]) {
                studentDebtLiteralUS = @"";
            } else {
                studentDebtLiteralUS = [studentDebtNode valueForKey:@"debt_literal_us"];
            }
            
            NSString *amount;
            if ([studentDebtNode valueForKey:@"amount"] == [NSNull null]) {
                amount = @"0.0";
            } else {
                amount = [studentDebtNode valueForKey:@"amount"];
            }
            
            NSString *selectedAsAsset;
            if ([studentDebtNode valueForKey:@"selected_as_debt"] == [NSNull null]) {
                selectedAsAsset = @"0";
            } else {
                selectedAsAsset = [studentDebtNode valueForKey:@"selected_as_debt"];
            }
            
            tempStudentDebt.studentDebtID = [NSNumber numberWithInt:[studentDebtID intValue]];
            tempStudentDebt.studentID = [NSNumber numberWithInt:[studentID intValue]];
            tempStudentDebt.isSure = [NSNumber numberWithInt:[isSure intValue]];
            tempStudentDebt.studentDebtCode = studentDebtCode;
            tempStudentDebt.studentDebtLiteralUS = studentDebtLiteralUS;
            tempStudentDebt.amount = [NSNumber numberWithDouble:[amount doubleValue]];
            tempStudentDebt.selectedAsDebt = [NSNumber numberWithInt:[selectedAsAsset intValue]];
            
            [self.student addDebtsObject:tempStudentDebt];
        }
        
    } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
        [[AFNetworkActivityIndicatorManager sharedManager] decrementActivityCount];
        [self.hudForDataGathering hide:YES];
        [[SSUser currentUser] logOutAndPresentHUDInViewController:viewController];
        NSLog(@"Whoops, couldn't connect: %@", [JSON description]);
    }];
    
    return operationStudentAssets;
}

-(AFJSONRequestOperation *) pullIndustryAndSegmentsDataWithClient:(CENTROAPIClient *) client Params:(NSDictionary *) paramToken AndShowHUDInViewController:(UIViewController *) viewController {
    
    [[AFNetworkActivityIndicatorManager sharedManager] incrementActivityCount];
    NSString *pathIndustryAndSegmentsData = [NSString stringWithFormat:@"industry_and_segments.json"];
    NSURLRequest *requestStudentDebts = [client requestWithMethod:@"GET" path:pathIndustryAndSegmentsData parameters:paramToken];
    
    AFJSONRequestOperation *operationIndustryAndSegmentsData = [AFJSONRequestOperation JSONRequestOperationWithRequest:requestStudentDebts success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
        [[AFNetworkActivityIndicatorManager sharedManager] decrementActivityCount];
        
        NSEntityDescription *industryAndSegments = [NSEntityDescription entityForName:@"IndustryAndSegment"
                                                               inManagedObjectContext:self.context];
        
        NSDictionary *industryAndSegmentsNode;
        for(industryAndSegmentsNode in JSON) {
            
            IndustryAndSegment *tempIndustryAndSegment = (IndustryAndSegment *) [[NSManagedObject alloc] initWithEntity:industryAndSegments
                                                                                         insertIntoManagedObjectContext:self.context];
            NSString *industryAndSegmentID;
            if ([industryAndSegmentsNode valueForKey:@"id"] == [NSNull null]) {
                industryAndSegmentID = @"";
            } else {
                industryAndSegmentID = [industryAndSegmentsNode valueForKey:@"id"];
            }
            
            NSString *industryCode;
            if ([industryAndSegmentsNode valueForKey:@"industryCode"] == [NSNull null]) {
                industryCode = @"";
            } else {
                industryCode = [industryAndSegmentsNode valueForKey:@"industryCode"];
            }
            
            NSString *isSegment;
            if ([industryAndSegmentsNode valueForKey:@"isSegment"] == [NSNull null]) {
                isSegment = @"0";
            } else {
                isSegment = [industryAndSegmentsNode valueForKey:@"isSegment"];
            }
            
            NSString *industryLiteralUS;
            if ([industryAndSegmentsNode valueForKey:@"industryLiteralUS"] == [NSNull null]) {
                industryLiteralUS = @"";
            } else {
                industryLiteralUS = [industryAndSegmentsNode valueForKey:@"industryLiteralUS"];
            }
            
            NSString *segmentCode;
            if ([industryAndSegmentsNode valueForKey:@"segmentCode"] == [NSNull null]) {
                segmentCode = @"";
            } else {
                segmentCode = [industryAndSegmentsNode valueForKey:@"segmentCode"];
            }
            
            NSString *segmentLiteralUS;
            if ([industryAndSegmentsNode valueForKey:@"segmentLiteralUS"] == [NSNull null]) {
                segmentLiteralUS = @"";
            } else {
                segmentLiteralUS = [industryAndSegmentsNode valueForKey:@"segmentLiteralUS"];
            }
            
            tempIndustryAndSegment.industryAndSegmentID = [NSNumber numberWithInt:[industryAndSegmentID intValue]];
            tempIndustryAndSegment.industryCode = industryCode;
            tempIndustryAndSegment.isSegment = [NSNumber numberWithInt:[isSegment intValue]];
            tempIndustryAndSegment.industryLiteralUS = industryLiteralUS;
            tempIndustryAndSegment.segmentCode = segmentCode;
            tempIndustryAndSegment.segmentLiteralUS = segmentLiteralUS;
            
        }
    } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
        [[AFNetworkActivityIndicatorManager sharedManager] decrementActivityCount];
        [self.hudForDataGathering hide:YES];
        [[SSUser currentUser] logOutAndPresentHUDInViewController:viewController];
        NSLog(@"Whoops, couldn't connect: %@", [JSON description]);
    }];
    
    return operationIndustryAndSegmentsData;
}

-(AFJSONRequestOperation *) pullIndustryDataWithClient:(CENTROAPIClient *) client Params:(NSDictionary *) paramToken AndShowHUDInViewController:(UIViewController *) viewController {
    
    [[AFNetworkActivityIndicatorManager sharedManager] incrementActivityCount];
    NSString *pathIndustry = [NSString stringWithFormat:@"industries/%@.json", [[SSUser currentUser] companyID]];
    NSURLRequest *requestIndustry = [client requestWithMethod:@"GET" path:pathIndustry parameters:paramToken];
    
    AFJSONRequestOperation *operationIndustry = [AFJSONRequestOperation JSONRequestOperationWithRequest:requestIndustry success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
        [[AFNetworkActivityIndicatorManager sharedManager] decrementActivityCount];
        
        NSEntityDescription *industry = [NSEntityDescription entityForName:@"Industry"
                                                    inManagedObjectContext:self.context];
        
        Industry *tempIndustry = (Industry *) [[NSManagedObject alloc] initWithEntity:industry
                                                       insertIntoManagedObjectContext:self.context];
        
        NSString *companyID;
        if ([JSON valueForKey:@"company_id"] == [NSNull null]) {
            companyID = @"";
        } else {
            companyID = [JSON valueForKey:@"company_id"];
        }
        
        NSString *industryID;
        if ([JSON valueForKey:@"id"] == [NSNull null]) {
            industryID = @"";
        } else {
            industryID = [JSON valueForKey:@"id"];
        }
        
        NSString *growth;
        if ([JSON valueForKey:@"growth"] == [NSNull null]) {
            growth = @"";
        } else {
            growth = [JSON valueForKey:@"growth"];
        }
        
        NSString *growthRate;
        if ([JSON valueForKey:@"growth_rate"] == [NSNull null]) {
            growthRate = @"0.0";
        } else {
            growthRate = [JSON valueForKey:@"growth_rate"];
        }
        
        NSString *industryCode;
        if ([JSON valueForKey:@"industry"] == [NSNull null]) {
            industryCode = @"";
        } else {
            industryCode = [JSON valueForKey:@"industry"];
        }
        
        NSString *segmentCode;
        if ([JSON valueForKey:@"industry_segment"] == [NSNull null]) {
            segmentCode = @"";
        } else {
            segmentCode = [JSON valueForKey:@"industry_segment"];
        }
        
        NSString *marketAge;
        if ([JSON valueForKey:@"market_age"] == [NSNull null]) {
            marketAge = @"";
        } else {
            marketAge = [JSON valueForKey:@"market_age"];
        }
        
        NSString *regulations;
        if ([JSON valueForKey:@"regulations"] == [NSNull null]) {
            regulations = @"";
        } else {
            regulations = [JSON valueForKey:@"regulations"];
        }
        
        NSString *volatility;
        if ([JSON valueForKey:@"volatility"] == [NSNull null]) {
            volatility = @"";
        } else {
            volatility = [JSON valueForKey:@"volatility"];
        }
        
        tempIndustry.industryID = [NSNumber numberWithInt:[industryID intValue]];
        tempIndustry.companyID = [NSNumber numberWithInt:[companyID intValue]];
        tempIndustry.growth = [NSNumber numberWithInt:[growth intValue]];
        tempIndustry.growthRate = [NSNumber numberWithDouble:[growthRate doubleValue]];
        tempIndustry.industryCode = industryCode;
        tempIndustry.industrySegmentCode = segmentCode;
        tempIndustry.marketAge = [NSNumber numberWithInt:[marketAge intValue]];
        tempIndustry.regulations = [NSNumber numberWithInt:[regulations intValue]];
        tempIndustry.volatility = [NSNumber numberWithInt:[volatility intValue]];
        
        self.student.company.industry = tempIndustry;
        
    } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
        [[AFNetworkActivityIndicatorManager sharedManager] decrementActivityCount];
        [self.hudForDataGathering hide:YES];
        [[SSUser currentUser] logOutAndPresentHUDInViewController:viewController];
        NSLog(@"Whoops, couldn't connect: %@", [JSON description]);
    }];
    
    return operationIndustry;
}

-(AFJSONRequestOperation *) pullCustomerProfileDataWithClient:(CENTROAPIClient *) client Params:(NSDictionary *) paramToken AndShowHUDInViewController:(UIViewController *) viewController {
    
    [[AFNetworkActivityIndicatorManager sharedManager] incrementActivityCount];
    NSString *pathCustomerProfile = [NSString stringWithFormat:@"customer_profiles/%@.json", [[SSUser currentUser] companyID]];
    NSURLRequest *requestCustomerProfile = [client requestWithMethod:@"GET" path:pathCustomerProfile parameters:paramToken];
    
    AFJSONRequestOperation *operationCustomerProfile = [AFJSONRequestOperation JSONRequestOperationWithRequest:requestCustomerProfile success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
        [[AFNetworkActivityIndicatorManager sharedManager] decrementActivityCount];
        
        NSEntityDescription *customerProfile = [NSEntityDescription entityForName:@"CustomerProfile"
                                                           inManagedObjectContext:self.context];
        
        CustomerProfile *tempCustomerProfile = (CustomerProfile *) [[NSManagedObject alloc] initWithEntity:customerProfile
                                                                            insertIntoManagedObjectContext:self.context];
        
        NSString *companyID;
        if ([JSON valueForKey:@"company_id"] == [NSNull null]) {
            companyID = @"";
        } else {
            companyID = [JSON valueForKey:@"company_id"];
        }
        
        NSString *customerProfileID;
        if ([JSON valueForKey:@"id"] == [NSNull null]) {
            customerProfileID = @"";
        } else {
            customerProfileID = [JSON valueForKey:@"id"];
        }
        
        NSString *fromAge;
        if ([JSON valueForKey:@"from_age"] == [NSNull null]) {
            fromAge = @"1";
        } else {
            fromAge = [JSON valueForKey:@"from_age"];
        }
        
        NSString *toAge;
        if ([JSON valueForKey:@"to_age"] == [NSNull null]) {
            toAge = @"2";
        } else {
            toAge = [JSON valueForKey:@"to_age"];
        }
        
        NSString *fromIncome;
        if ([JSON valueForKey:@"from_income"] == [NSNull null]) {
            fromIncome = @"0.0";
        } else {
            fromIncome = [JSON valueForKey:@"from_income"];
        }
        
        NSString *toIncome;
        if ([JSON valueForKey:@"to_income"] == [NSNull null]) {
            toIncome = @"0.0";
        } else {
            toIncome = [JSON valueForKey:@"to_income"];
        }
        
        NSString *locationLongDrive;
        if ([JSON valueForKey:@"location_long_drive"] == [NSNull null]) {
            locationLongDrive = @"0.0";
        } else {
            locationLongDrive = [JSON valueForKey:@"location_long_drive"];
        }
        
        NSString *locationOnline;
        if ([JSON valueForKey:@"location_online"] == [NSNull null]) {
            locationOnline = @"0.0";
        } else {
            locationOnline = [JSON valueForKey:@"location_online"];
        }
        
        NSString *locationOther;
        if ([JSON valueForKey:@"location_other"] == [NSNull null]) {
            locationOther = @"0.0";
        } else {
            locationOther = [JSON valueForKey:@"location_other"];
        }
        
        NSString *locationShortDrive;
        if ([JSON valueForKey:@"location_short_drive"] == [NSNull null]) {
            locationShortDrive = @"0.0";
        } else {
            locationShortDrive = [JSON valueForKey:@"location_short_drive"];
        }
        
        NSString *locationWalk;
        if ([JSON valueForKey:@"location_walk"] == [NSNull null]) {
            locationWalk = @"0.0";
        } else {
            locationWalk = [JSON valueForKey:@"location_walk"];
        }
        
        NSString *menPercentage;
        if ([JSON valueForKey:@"men_percentage"] == [NSNull null]) {
            menPercentage = @"50.0";
        } else {
            menPercentage = [JSON valueForKey:@"men_percentage"];
        }
        
        NSString *womenPercentage;
        if ([JSON valueForKey:@"women_percentage"] == [NSNull null]) {
            womenPercentage = @"50.0";
        } else {
            womenPercentage = [JSON valueForKey:@"women_percentage"];
        }
        
        NSString *isAgeSure;
        if ([JSON valueForKey:@"is_age_sure"] == [NSNull null]) {
            isAgeSure = @"0";
        } else {
            isAgeSure = [JSON valueForKey:@"is_age_sure"];
        }
        
        NSString *isEducationSure;
        if ([JSON valueForKey:@"is_education_sure"] == [NSNull null]) {
            isEducationSure = @"0";
        } else {
            isEducationSure = [JSON valueForKey:@"is_education_sure"];
        }
        
        NSString *isGenderSure;
        if ([JSON valueForKey:@"is_gender_sure"] == [NSNull null]) {
            isGenderSure = @"0";
        } else {
            isGenderSure = [JSON valueForKey:@"is_gender_sure"];
        }
        
        NSString *isIncomeSure;
        if ([JSON valueForKey:@"is_income_sure"] == [NSNull null]) {
            isIncomeSure = @"0";
        } else {
            isIncomeSure = [JSON valueForKey:@"is_income_sure"];
        }
        
        NSString *isInterestSure;
        if ([JSON valueForKey:@"is_interest_sure"] == [NSNull null]) {
            isInterestSure = @"0";
        } else {
            isInterestSure = [JSON valueForKey:@"is_interest_sure"];
        }
        
        NSString *isLocationSure;
        if ([JSON valueForKey:@"is_location_sure"] == [NSNull null]) {
            isLocationSure = @"0";
        } else {
            isLocationSure = [JSON valueForKey:@"is_location_sure"];
        }
        
        NSString *isOcupationSure;
        if ([JSON valueForKey:@"is_occupation_sure"] == [NSNull null]) {
            isOcupationSure = @"0";
        } else {
            isOcupationSure = [JSON valueForKey:@"is_occupation_sure"];
        }
        
        tempCustomerProfile.companyID = [NSNumber numberWithInt:[companyID intValue]];
        tempCustomerProfile.fromAge = [NSNumber numberWithInt:[fromAge intValue]];
        tempCustomerProfile.fromIncome = [NSNumber numberWithDouble:[fromIncome doubleValue]];
        tempCustomerProfile.customerProfileID = [NSNumber numberWithInt:[customerProfileID intValue]];
        tempCustomerProfile.isAgeSure = [NSNumber numberWithInt:[isAgeSure intValue]];
        tempCustomerProfile.isEducationSure = [NSNumber numberWithInt:[isEducationSure intValue]];
        tempCustomerProfile.isGenderSure = [NSNumber numberWithInt:[isGenderSure intValue]];
        tempCustomerProfile.isIncomeSure = [NSNumber numberWithInt:[isIncomeSure intValue]];
        tempCustomerProfile.isInterestSure = [NSNumber numberWithInt:[isInterestSure intValue]];
        tempCustomerProfile.isLocationSure = [NSNumber numberWithInt:[isLocationSure intValue]];
        tempCustomerProfile.isOccupationSure = [NSNumber numberWithInt:[isOcupationSure intValue]];
        tempCustomerProfile.locationLongDrive = [NSNumber numberWithDouble:[locationLongDrive doubleValue]];
        tempCustomerProfile.locationOnline = [NSNumber numberWithDouble:[locationOnline doubleValue]];
        tempCustomerProfile.locationOther = [NSNumber numberWithDouble:[locationOther doubleValue]];
        tempCustomerProfile.locationShortDrive = [NSNumber numberWithDouble:[locationShortDrive doubleValue]];
        tempCustomerProfile.locationWalk = [NSNumber numberWithDouble:[locationWalk doubleValue]];
        tempCustomerProfile.menPercentage = [NSNumber numberWithDouble:[menPercentage doubleValue]];
        tempCustomerProfile.toAge = [NSNumber numberWithInt:[toAge intValue]];
        tempCustomerProfile.toIncome = [NSNumber numberWithDouble:[toIncome doubleValue]];
        tempCustomerProfile.womenPercentage = [NSNumber numberWithDouble:[womenPercentage doubleValue]];
        
        self.student.company.customerProfile = tempCustomerProfile;
        
    } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
        [[AFNetworkActivityIndicatorManager sharedManager] decrementActivityCount];
        [self.hudForDataGathering hide:YES];
        [[SSUser currentUser] logOutAndPresentHUDInViewController:viewController];
        NSLog(@"Whoops, couldn't connect: %@", [JSON description]);
    }];
    
    return operationCustomerProfile;
}

-(AFJSONRequestOperation *) pullEducationsDataWithClient:(CENTROAPIClient *) client Params:(NSDictionary *) paramToken AndShowHUDInViewController:(UIViewController *) viewController {
    
    [[AFNetworkActivityIndicatorManager sharedManager] incrementActivityCount];
    NSString *pathEducations = [NSString stringWithFormat:@"customer_profiles/%@/educations.json", [[SSUser currentUser] companyID]];
    NSURLRequest *requestEducations = [client requestWithMethod:@"GET" path:pathEducations parameters:paramToken];
    
    AFJSONRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:requestEducations success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
        [[AFNetworkActivityIndicatorManager sharedManager] decrementActivityCount];
        
        NSEntityDescription *educations = [NSEntityDescription entityForName:@"CustomerEducation" inManagedObjectContext:self.context];
        
        NSDictionary *educationNode;
        for(educationNode in JSON) {
            
            CustomerEducation *tempEducation = (CustomerEducation *) [[NSManagedObject alloc] initWithEntity:educations
                                                                              insertIntoManagedObjectContext:self.context];
            NSString *customerProfileID;
            if ([educationNode valueForKey:@"customer_profile_id"] == [NSNull null]) {
                customerProfileID = @"";
            } else {
                customerProfileID = [educationNode valueForKey:@"customer_profile_id"];
            }
            
            NSString *educationID;
            if ([educationNode valueForKey:@"id"] == [NSNull null]) {
                educationID = @"";
            } else {
                educationID = [educationNode valueForKey:@"id"];
            }
            
            NSString *educationCode;
            if ([educationNode valueForKey:@"education_code"] == [NSNull null]) {
                educationCode = @"";
            } else {
                educationCode = [educationNode valueForKey:@"education_code"];
            }
            
            NSString *educationLiteralUS;
            if ([educationNode valueForKey:@"education_literal_us"] == [NSNull null]) {
                educationLiteralUS = @"";
            } else {
                educationLiteralUS = [educationNode valueForKey:@"education_literal_us"];
            }
            
            NSString *selectedAsCustomerEducation;
            if ([educationNode valueForKey:@"selected_as_customer_education"] == [NSNull null]) {
                selectedAsCustomerEducation = @"0";
            } else {
                selectedAsCustomerEducation = [educationNode valueForKey:@"selected_as_customer_education"];
            }
            
            tempEducation.customerProfileID = [NSNumber numberWithInt:[customerProfileID intValue]];
            tempEducation.educationID = [NSNumber numberWithInt:[educationID intValue]];
            tempEducation.educationCode = educationCode;
            tempEducation.educationLiteralUS = educationLiteralUS;
            tempEducation.selectedAsCustomerEducation = [NSNumber numberWithInt:[selectedAsCustomerEducation intValue]];
            
            [self.student.company.customerProfile addEducationsObject:tempEducation];
        }
        
    } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
        [[AFNetworkActivityIndicatorManager sharedManager] decrementActivityCount];
        [self.hudForDataGathering hide:YES];
        [[SSUser currentUser] logOutAndPresentHUDInViewController:viewController];
        NSLog(@"Whoops, couldn't connect: %@", [JSON description]);
    }];
    
    return operation;
}

-(AFJSONRequestOperation *) pullOccupationsDataWithClient:(CENTROAPIClient *) client Params:(NSDictionary *) paramToken AndShowHUDInViewController:(UIViewController *) viewController {
    
    [[AFNetworkActivityIndicatorManager sharedManager] incrementActivityCount];
    NSString *pathOccupations = [NSString stringWithFormat:@"customer_profiles/%@/occupations.json", [[SSUser currentUser] companyID]];
    NSURLRequest *requestOccupations = [client requestWithMethod:@"GET" path:pathOccupations parameters:paramToken];
    
    AFJSONRequestOperation *operationOccupations = [AFJSONRequestOperation JSONRequestOperationWithRequest:requestOccupations success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
        [[AFNetworkActivityIndicatorManager sharedManager] decrementActivityCount];
        
        NSEntityDescription *occupations = [NSEntityDescription entityForName:@"CustomerOccupation" inManagedObjectContext:self.context];
        
        NSDictionary *occupationNode;
        for(occupationNode in JSON) {
            
            CustomerOccupation *tempOccupation = (CustomerOccupation *) [[NSManagedObject alloc] initWithEntity:occupations
                                                                                 insertIntoManagedObjectContext:self.context];
            NSString *customerProfileID;
            if ([occupationNode valueForKey:@"customer_profile_id"] == [NSNull null]) {
                customerProfileID = @"";
            } else {
                customerProfileID = [occupationNode valueForKey:@"customer_profile_id"];
            }
            
            NSString *occupationID;
            if ([occupationNode valueForKey:@"id"] == [NSNull null]) {
                occupationID = @"";
            } else {
                occupationID = [occupationNode valueForKey:@"id"];
            }
            
            NSString *occupationCode;
            if ([occupationNode valueForKey:@"occupation_code"] == [NSNull null]) {
                occupationCode = @"";
            } else {
                occupationCode = [occupationNode valueForKey:@"occupation_code"];
            }
            
            NSString *occupationLiteralUS;
            if ([occupationNode valueForKey:@"occupation_literal_us"] == [NSNull null]) {
                occupationLiteralUS = @"";
            } else {
                occupationLiteralUS = [occupationNode valueForKey:@"occupation_literal_us"];
            }
            
            NSString *selectedAsCustomerOccupation;
            if ([occupationNode valueForKey:@"selected_as_customer_occupation"] == [NSNull null]) {
                selectedAsCustomerOccupation = @"0";
            } else {
                selectedAsCustomerOccupation = [occupationNode valueForKey:@"selected_as_customer_occupation"];
            }
            
            tempOccupation.customerProfileID = [NSNumber numberWithInt:[customerProfileID intValue]];
            tempOccupation.occupationID = [NSNumber numberWithInt:[occupationID intValue]];
            tempOccupation.occupationCode = occupationCode;
            tempOccupation.occupationLiteralUS = occupationLiteralUS;
            tempOccupation.selectedAsCustomerOccupation = [NSNumber numberWithInt:[selectedAsCustomerOccupation intValue]];
            
            [self.student.company.customerProfile addOccupationsObject:tempOccupation];
        }
        
    } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
        [[AFNetworkActivityIndicatorManager sharedManager] decrementActivityCount];
        [self.hudForDataGathering hide:YES];
        [[SSUser currentUser] logOutAndPresentHUDInViewController:viewController];
        NSLog(@"Whoops, couldn't connect: %@", [JSON description]);
    }];
    
    return operationOccupations;
}

-(AFJSONRequestOperation *) pullInterestsDataWithClient:(CENTROAPIClient *) client Params:(NSDictionary *) paramToken AndShowHUDInViewController:(UIViewController *) viewController {
    
    [[AFNetworkActivityIndicatorManager sharedManager] incrementActivityCount];
    NSString *pathInterests = [NSString stringWithFormat:@"customer_profiles/%@/interests.json", [[SSUser currentUser] companyID]];
    NSURLRequest *requestInterests = [client requestWithMethod:@"GET" path:pathInterests parameters:paramToken];
    
    AFJSONRequestOperation *operationInterests = [AFJSONRequestOperation JSONRequestOperationWithRequest:requestInterests success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
        [[AFNetworkActivityIndicatorManager sharedManager] decrementActivityCount];
        
        NSEntityDescription *interests = [NSEntityDescription entityForName:@"CustomerInterest" inManagedObjectContext:self.context];
        
        NSDictionary *interestNode;
        for(interestNode in JSON) {
            
            CustomerInterest *tempInterest = (CustomerInterest *) [[NSManagedObject alloc] initWithEntity:interests
                                                                           insertIntoManagedObjectContext:self.context];
            NSString *customerProfileID;
            if ([interestNode valueForKey:@"customer_profile_id"] == [NSNull null]) {
                customerProfileID = @"";
            } else {
                customerProfileID = [interestNode valueForKey:@"customer_profile_id"];
            }
            
            NSString *interestID;
            if ([interestNode valueForKey:@"id"] == [NSNull null]) {
                interestID = @"";
            } else {
                interestID = [interestNode valueForKey:@"id"];
            }
            
            NSString *interestCode;
            if ([interestNode valueForKey:@"interest_code"] == [NSNull null]) {
                interestCode = @"";
            } else {
                interestCode = [interestNode valueForKey:@"interest_code"];
            }
            
            NSString *interestLiteralUS;
            if ([interestNode valueForKey:@"interest_literal_us"] == [NSNull null]) {
                interestLiteralUS = @"";
            } else {
                interestLiteralUS = [interestNode valueForKey:@"interest_literal_us"];
            }
            
            NSString *selectedAsCustomerInterest;
            if ([interestNode valueForKey:@"selected_as_customer_interest"] == [NSNull null]) {
                selectedAsCustomerInterest = @"0";
            } else {
                selectedAsCustomerInterest = [interestNode valueForKey:@"selected_as_customer_interest"];
            }
            
            tempInterest.customerProfileID = [NSNumber numberWithInt:[customerProfileID intValue]];
            tempInterest.interestID = [NSNumber numberWithInt:[interestID intValue]];
            tempInterest.interestCode = interestCode;
            tempInterest.interestLiteralUS = interestLiteralUS;
            tempInterest.selectedAsCustomerInterest = [NSNumber numberWithInt:[selectedAsCustomerInterest intValue]];
            
            [self.student.company.customerProfile addInterestsObject:tempInterest];
        }
        
    } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
        [[AFNetworkActivityIndicatorManager sharedManager] decrementActivityCount];
        [self.hudForDataGathering hide:YES];
        [[SSUser currentUser] logOutAndPresentHUDInViewController:viewController];
        NSLog(@"Whoops, couldn't connect: %@", [JSON description]);
    }];
    
    return operationInterests;
}


-(AFJSONRequestOperation *) pullPrioritiesDataWithClient:(CENTROAPIClient *) client Params:(NSDictionary *) paramToken AndShowHUDInViewController:(UIViewController *) viewController {
    
    [[AFNetworkActivityIndicatorManager sharedManager] incrementActivityCount];
    NSString *pathPriorities = [NSString stringWithFormat:@"customer_profiles/%@/priorities.json", [[SSUser currentUser] companyID]];
    NSURLRequest *requestPriorities = [client requestWithMethod:@"GET" path:pathPriorities parameters:paramToken];
    
    AFJSONRequestOperation *operationPriorities = [AFJSONRequestOperation JSONRequestOperationWithRequest:requestPriorities success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
        [[AFNetworkActivityIndicatorManager sharedManager] decrementActivityCount];
        
        NSEntityDescription *priorities = [NSEntityDescription entityForName:@"CustomerPriority" inManagedObjectContext:self.context];
        
        NSDictionary *priorityNode;
        for(priorityNode in JSON) {
            
            CustomerPriority *tempPriority = (CustomerPriority *) [[NSManagedObject alloc] initWithEntity:priorities
                                                                           insertIntoManagedObjectContext:self.context];
            
            NSString *customerProfileID;
            if ([priorityNode valueForKey:@"customer_profile_id"] == [NSNull null]) {
                customerProfileID = @"";
            } else {
                customerProfileID = [priorityNode valueForKey:@"customer_profile_id"];
            }
            
            NSString *priorityID;
            if ([priorityNode valueForKey:@"id"] == [NSNull null]) {
                priorityID = @"";
            } else {
                priorityID = [priorityNode valueForKey:@"id"];
            }
            
            NSString *priorityCode;
            if ([priorityNode valueForKey:@"priority_code"] == [NSNull null]) {
                priorityCode = @"";
            } else {
                priorityCode = [priorityNode valueForKey:@"priority_code"];
            }
            
            NSString *priorityLiteralUS;
            if ([priorityNode valueForKey:@"priority_literal_us"] == [NSNull null]) {
                priorityLiteralUS = @"";
            } else {
                priorityLiteralUS = [priorityNode valueForKey:@"priority_literal_us"];
            }
            
            NSString *rank;
            if ([priorityNode valueForKey:@"rank"] == [NSNull null]) {
                rank = @"";
            } else {
                rank = [priorityNode valueForKey:@"rank"];
            }
            
            tempPriority.customerProfileID = [NSNumber numberWithInt:[customerProfileID intValue]];
            tempPriority.priorityID = [NSNumber numberWithInt:[priorityID intValue]];
            tempPriority.priorityCode = priorityCode;
            tempPriority.priorityLiteralUS = priorityLiteralUS;
            tempPriority.rank = [NSNumber numberWithInt:[rank intValue]];
            
            [self.student.company.customerProfile addPrioritiesObject:tempPriority];
        }
        
    } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
        [[AFNetworkActivityIndicatorManager sharedManager] decrementActivityCount];
        [self.hudForDataGathering hide:YES];
        [[SSUser currentUser] logOutAndPresentHUDInViewController:viewController];
        NSLog(@"Whoops, couldn't connect: %@", [JSON description]);
    }];
    
    return operationPriorities;
}

-(AFJSONRequestOperation *) pullCustomerProfileSamplesDataWithClient:(CENTROAPIClient *) client Params:(NSDictionary *) paramToken AndShowHUDInViewController:(UIViewController *) viewController {
    
    [[AFNetworkActivityIndicatorManager sharedManager] incrementActivityCount];
    NSString *pathCustomerProfileSamples = [NSString stringWithFormat:@"companies/%@/customer_profile_samples.json", [[SSUser currentUser] companyID]];
    NSURLRequest *requestCustomerProfileSamples = [client requestWithMethod:@"GET" path:pathCustomerProfileSamples parameters:paramToken];
    
    AFJSONRequestOperation *operationPriorities = [AFJSONRequestOperation JSONRequestOperationWithRequest:requestCustomerProfileSamples success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
        [[AFNetworkActivityIndicatorManager sharedManager] decrementActivityCount];
        
        NSEntityDescription *customerProfileSamples = [NSEntityDescription entityForName:@"CustomerProfileSample" inManagedObjectContext:self.context];
        
        NSDictionary *customerProfileSampleNode;
        for(customerProfileSampleNode in JSON) {
            
            CustomerProfileSample *tempCustomerProfileSample = (CustomerProfileSample *) [[NSManagedObject alloc] initWithEntity:customerProfileSamples
                                                                                                  insertIntoManagedObjectContext:self.context];
            
            
            NSString *companyID;
            if ([customerProfileSampleNode valueForKey:@"company_id"] == [NSNull null]) {
                companyID = @"";
            } else {
                companyID = [customerProfileSampleNode valueForKey:@"company_id"];
            }
            
            NSString *customerProfileSampleID;
            if ([customerProfileSampleNode valueForKey:@"id"] == [NSNull null]) {
                customerProfileSampleID = @"";
            } else {
                customerProfileSampleID = [customerProfileSampleNode valueForKey:@"id"];
            }
            
            NSString *age;
            if ([customerProfileSampleNode valueForKey:@"age"] == [NSNull null]) {
                age = @"";
            } else {
                age = [customerProfileSampleNode valueForKey:@"age"];
            }
            
            NSString *educationLevel;
            if ([customerProfileSampleNode valueForKey:@"education_level"] == [NSNull null]) {
                educationLevel = @"";
            } else {
                educationLevel = [customerProfileSampleNode valueForKey:@"education_level"];
            }
            
            NSString *income;
            if ([customerProfileSampleNode valueForKey:@"income"] == [NSNull null]) {
                income = @"";
            } else {
                income = [customerProfileSampleNode valueForKey:@"income"];
            }
            
            NSString *interest;
            if ([customerProfileSampleNode valueForKey:@"interest"] == [NSNull null]) {
                interest = @"";
            } else {
                interest = [customerProfileSampleNode valueForKey:@"interest"];
            }
            
            NSString *location;
            if ([customerProfileSampleNode valueForKey:@"location"] == [NSNull null]) {
                location = @"";
            } else {
                location = [customerProfileSampleNode valueForKey:@"location"];
            }
            
            NSString *name;
            if ([customerProfileSampleNode valueForKey:@"name"] == [NSNull null]) {
                name = @"";
            } else {
                name = [customerProfileSampleNode valueForKey:@"name"];
            }
            
            NSString *profession;
            if ([customerProfileSampleNode valueForKey:@"profession"] == [NSNull null]) {
                profession = @"";
            } else {
                profession = [customerProfileSampleNode valueForKey:@"profession"];
            }
            
            tempCustomerProfileSample.companyID = [NSNumber numberWithInt:[companyID intValue]];
            tempCustomerProfileSample.customerProfileSampleID = [NSNumber numberWithInt:[customerProfileSampleID intValue]];
            tempCustomerProfileSample.age = [NSNumber numberWithInt:[age intValue]];
            tempCustomerProfileSample.educationLevel = educationLevel;
            tempCustomerProfileSample.income = [NSNumber numberWithInt:[income doubleValue]];
            tempCustomerProfileSample.interest = interest;
            tempCustomerProfileSample.location = location;
            tempCustomerProfileSample.name = name;
            tempCustomerProfileSample.profession = profession;
            
            [self.student.company addCustomerProfileSamplesObject:tempCustomerProfileSample];
        }
        
    } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
        [[AFNetworkActivityIndicatorManager sharedManager] decrementActivityCount];
        [self.hudForDataGathering hide:YES];
        [[SSUser currentUser] logOutAndPresentHUDInViewController:viewController];
        NSLog(@"Whoops, couldn't connect: %@", [JSON description]);
    }];
    
    return operationPriorities;
}

-(AFJSONRequestOperation *) pullNearbyCompetitorDataWithClient:(CENTROAPIClient *) client Params:(NSDictionary *) paramToken AndShowHUDInViewController:(UIViewController *) viewController {
    
    [[AFNetworkActivityIndicatorManager sharedManager] incrementActivityCount];
    NSString *pathNearbyCompetitorSamples = [NSString stringWithFormat:@"near_by_competitors/%@.json", [[SSUser currentUser] companyID]];
    NSURLRequest *requestNearbyCompetitorSamples = [client requestWithMethod:@"GET" path:pathNearbyCompetitorSamples parameters:paramToken];
    
    AFJSONRequestOperation *operationNearbyCompetitor = [AFJSONRequestOperation JSONRequestOperationWithRequest:requestNearbyCompetitorSamples success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
        [[AFNetworkActivityIndicatorManager sharedManager] decrementActivityCount];
        
        NSEntityDescription *nearbyCompetitors = [NSEntityDescription entityForName:@"NearbyCompetitor" inManagedObjectContext:self.context];
        
        NearbyCompetitor *tempNearbyCompetitor = (NearbyCompetitor *) [[NSManagedObject alloc] initWithEntity:nearbyCompetitors
                                                                               insertIntoManagedObjectContext:self.context];
        
        NSString *companyID;
        if ([JSON valueForKey:@"company_id"] == [NSNull null]) {
            companyID = @"";
        } else {
            companyID = [JSON valueForKey:@"company_id"];
        }
        
        NSString *nearbyCompetitorID;
        if ([JSON valueForKey:@"id"] == [NSNull null]) {
            nearbyCompetitorID = @"";
        } else {
            nearbyCompetitorID = [JSON valueForKey:@"id"];
        }
        
        NSString *longDriveCompetitors;
        if ([JSON valueForKey:@"long_drive"] == [NSNull null]) {
            longDriveCompetitors = @"";
        } else {
            longDriveCompetitors = [JSON valueForKey:@"long_drive"];
        }
        
        NSString *onlineCompetitors;
        if ([JSON valueForKey:@"online"] == [NSNull null]) {
            onlineCompetitors = @"";
        } else {
            onlineCompetitors = [JSON valueForKey:@"online"];
        }
        
        NSString *shortDriveCompetitors;
        if ([JSON valueForKey:@"short_drive"] == [NSNull null]) {
            shortDriveCompetitors = @"";
        } else {
            shortDriveCompetitors = [JSON valueForKey:@"short_drive"];
        }
        
        NSString *walkingDistanceCompetitors;
        if ([JSON valueForKey:@"walking_distance"] == [NSNull null]) {
            walkingDistanceCompetitors = @"";
        } else {
            walkingDistanceCompetitors = [JSON valueForKey:@"walking_distance"];
        }
        
        tempNearbyCompetitor.companyID = [NSNumber numberWithInt:[companyID intValue]];
        tempNearbyCompetitor.nearbyCompetitorID = [NSNumber numberWithInt:[nearbyCompetitorID intValue]];
        tempNearbyCompetitor.longDriveCompetitors = [NSNumber numberWithInt:[longDriveCompetitors intValue]];
        tempNearbyCompetitor.onlineCompetitors = [NSNumber numberWithInt:[onlineCompetitors intValue]];
        tempNearbyCompetitor.shortDriveCompetitors = [NSNumber numberWithInt:[shortDriveCompetitors intValue]];
        tempNearbyCompetitor.walkingDistanceCompetitors = [NSNumber numberWithInt:[walkingDistanceCompetitors intValue]];
        
        self.student.company.nearbyCompetitor = tempNearbyCompetitor;
        
    } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
        [[AFNetworkActivityIndicatorManager sharedManager] decrementActivityCount];
        [self.hudForDataGathering hide:YES];
        [[SSUser currentUser] logOutAndPresentHUDInViewController:viewController];
        NSLog(@"Whoops, couldn't connect: %@", [JSON description]);
    }];
    
    return operationNearbyCompetitor;
}

-(AFJSONRequestOperation *) pullCompetitorProfilesDataWithClient:(CENTROAPIClient *) client Params:(NSDictionary *) paramToken AndShowHUDInViewController:(UIViewController *) viewController {
    
    [[AFNetworkActivityIndicatorManager sharedManager] incrementActivityCount];
    NSString *pathCompetitorProfiles = [NSString stringWithFormat:@"companies/%@/competitor_profiles.json", [[SSUser currentUser] companyID]];
    NSURLRequest *requestCompetitorProfiles = [client requestWithMethod:@"GET" path:pathCompetitorProfiles parameters:paramToken];
    
    AFJSONRequestOperation *operationCompetitorProfiles = [AFJSONRequestOperation JSONRequestOperationWithRequest:requestCompetitorProfiles success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
        [[AFNetworkActivityIndicatorManager sharedManager] decrementActivityCount];
        
        NSEntityDescription *competitorProfiles = [NSEntityDescription entityForName:@"CompetitorProfile" inManagedObjectContext:self.context];
        
        NSDictionary *competitorProfileNode;
        for(competitorProfileNode in JSON) {
            
            CompetitorProfile *tempCompetitorProfile = (CompetitorProfile *) [[NSManagedObject alloc] initWithEntity:competitorProfiles
                                                                                      insertIntoManagedObjectContext:self.context];
            
            NSString *companyID;
            if ([competitorProfileNode valueForKey:@"company_id"] == [NSNull null]) {
                companyID = @"";
            } else {
                companyID = [competitorProfileNode valueForKey:@"company_id"];
            }
            NSString *competitorProfileID;
            if ([competitorProfileNode valueForKey:@"id"] == [NSNull null]) {
                competitorProfileID = @"";
            } else {
                competitorProfileID = [competitorProfileNode valueForKey:@"id"];
            }
            NSString *customerServiceRank;
            if ([competitorProfileNode valueForKey:@"customer_service_rank"] == [NSNull null]) {
                customerServiceRank = @"";
            } else {
                customerServiceRank = [competitorProfileNode valueForKey:@"customer_service_rank"];
            }
            NSString *frequencySellTargetAge;
            if ([competitorProfileNode valueForKey:@"frequency_sell_target_age"] == [NSNull null]) {
                frequencySellTargetAge = @"";
            } else {
                frequencySellTargetAge = [competitorProfileNode valueForKey:@"frequency_sell_target_age"];
            }
            NSString *frequencySellTargetEducation;
            if ([competitorProfileNode valueForKey:@"frequency_sell_target_education"] == [NSNull null]) {
                frequencySellTargetEducation = @"";
            } else {
                frequencySellTargetEducation = [competitorProfileNode valueForKey:@"frequency_sell_target_education"];
            }
            NSString *frequencySellTargetOccupation;
            if ([competitorProfileNode valueForKey:@"frequency_sell_target_occupation"] == [NSNull null]) {
                frequencySellTargetOccupation = @"";
            } else {
                frequencySellTargetOccupation = [competitorProfileNode valueForKey:@"frequency_sell_target_occupation"];
            }
            NSString *frequencySellTargetGenre;
            if ([competitorProfileNode valueForKey:@"frequency_sell_target_genre"] == [NSNull null]) {
                frequencySellTargetGenre = @"";
            } else {
                frequencySellTargetGenre = [competitorProfileNode valueForKey:@"frequency_sell_target_genre"];
            }
            NSString *frequencySellTargetIncome;
            if ([competitorProfileNode valueForKey:@"frequency_sell_target_income"] == [NSNull null]) {
                frequencySellTargetIncome = @"";
            } else {
                frequencySellTargetIncome = [competitorProfileNode valueForKey:@"frequency_sell_target_income"];
            }
            NSString *frequencySellTargetInterest;
            if ([competitorProfileNode valueForKey:@"frequency_sell_target_interest"] == [NSNull null]) {
                frequencySellTargetInterest = @"";
            } else {
                frequencySellTargetInterest = [competitorProfileNode valueForKey:@"frequency_sell_target_interest"];
            }
            NSString *locationRank;
            if ([competitorProfileNode valueForKey:@"location_rank"] == [NSNull null]) {
                locationRank = @"";
            } else {
                locationRank = [competitorProfileNode valueForKey:@"location_rank"];
            }
            NSString *name;
            if ([competitorProfileNode valueForKey:@"name"] == [NSNull null]) {
                name = @"";
            } else {
                name = [competitorProfileNode valueForKey:@"name"];
            }
            NSString *priceRank;
            if ([competitorProfileNode valueForKey:@"price_rank"] == [NSNull null]) {
                priceRank = @"";
            } else {
                priceRank = [competitorProfileNode valueForKey:@"price_rank"];
            }
            NSString *qualityRank;
            if ([competitorProfileNode valueForKey:@"quality_rank"] == [NSNull null]) {
                qualityRank = @"";
            } else {
                qualityRank = [competitorProfileNode valueForKey:@"quality_rank"];
            }
            NSString *sellLongDrive;
            if ([competitorProfileNode valueForKey:@"sell_long_drive"] == [NSNull null]) {
                sellLongDrive = @"0";
            } else {
                sellLongDrive = [competitorProfileNode valueForKey:@"sell_long_drive"];
            }
            NSString *sellOnline;
            if ([competitorProfileNode valueForKey:@"sell_online"] == [NSNull null]) {
                sellOnline = @"0";
            } else {
                sellOnline = [competitorProfileNode valueForKey:@"sell_online"];
            }
            NSString *sellShortDrive;
            if ([competitorProfileNode valueForKey:@"sell_short_drive"] == [NSNull null]) {
                sellShortDrive = @"0";
            } else {
                sellShortDrive = [competitorProfileNode valueForKey:@"sell_short_drive"];
            }
            NSString *sellWalkingDistance;
            if ([competitorProfileNode valueForKey:@"sell_walking_distance"] == [NSNull null]) {
                sellWalkingDistance = @"0";
            } else {
                sellWalkingDistance = [competitorProfileNode valueForKey:@"sell_walking_distance"];
            }
            NSString *speedRank;
            if ([competitorProfileNode valueForKey:@"speed_rank"] == [NSNull null]) {
                speedRank = @"";
            } else {
                speedRank = [competitorProfileNode valueForKey:@"speed_rank"];
            }
            
            tempCompetitorProfile.companyID = [NSNumber numberWithInt:[companyID intValue]];
            tempCompetitorProfile.competitorProfileID = [NSNumber numberWithInt:[competitorProfileID intValue]];
            tempCompetitorProfile.customerServiceRank = [NSNumber numberWithInt:[customerServiceRank intValue]];
            tempCompetitorProfile.frequencySellTargetAge = [NSNumber numberWithInt:[frequencySellTargetAge intValue]];
            tempCompetitorProfile.frequencySellTargetEducation = [NSNumber numberWithInt:[frequencySellTargetEducation intValue]];
            tempCompetitorProfile.frequencySellTargetOccupation = [NSNumber numberWithInt:[frequencySellTargetOccupation intValue]];
            tempCompetitorProfile.frequencySellTargetGenre = [NSNumber numberWithInt:[frequencySellTargetGenre intValue]];
            tempCompetitorProfile.frequencySellTargetIncome = [NSNumber numberWithInt:[frequencySellTargetIncome intValue]];
            tempCompetitorProfile.frequencySellTargetInterest = [NSNumber numberWithInt:[frequencySellTargetInterest intValue]];
            tempCompetitorProfile.locationRank = [NSNumber numberWithInt:[locationRank intValue]];
            tempCompetitorProfile.name = name;
            tempCompetitorProfile.priceRank = [NSNumber numberWithInt:[priceRank intValue]];
            tempCompetitorProfile.qualityRank = [NSNumber numberWithInt:[qualityRank intValue]];
            tempCompetitorProfile.sellLongDrive = [NSNumber numberWithInt:[sellLongDrive intValue]];
            tempCompetitorProfile.sellOnline = [NSNumber numberWithInt:[sellOnline intValue]];
            tempCompetitorProfile.sellShortDrive = [NSNumber numberWithInt:[sellShortDrive intValue]];
            tempCompetitorProfile.sellWalkingDistance = [NSNumber numberWithInt:[sellWalkingDistance intValue]];
            tempCompetitorProfile.speedRank = [NSNumber numberWithInt:[speedRank intValue]];
            
            [self.student.company addCompetitorProfilesObject:tempCompetitorProfile];
        }
    } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
        [[AFNetworkActivityIndicatorManager sharedManager] decrementActivityCount];
        [self.hudForDataGathering hide:YES];
        [[SSUser currentUser] logOutAndPresentHUDInViewController:viewController];
        NSLog(@"Whoops, couldn't connect: %@", [JSON description]);
    }];
    
    return operationCompetitorProfiles;
}

-(AFJSONRequestOperation *) pullProductCategoriesDataWithClient:(CENTROAPIClient *) client Params:(NSDictionary *) paramToken AndShowHUDInViewController:(UIViewController *) viewController {
    
    [[AFNetworkActivityIndicatorManager sharedManager] incrementActivityCount];
    NSString *pathCategories = [NSString stringWithFormat:@"companies/%@/categories.json", [[SSUser currentUser] companyID]];
    NSURLRequest *requestCategories = [client requestWithMethod:@"GET" path:pathCategories parameters:paramToken];
    
    AFJSONRequestOperation *operationCategories = [AFJSONRequestOperation JSONRequestOperationWithRequest:requestCategories success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
        [[AFNetworkActivityIndicatorManager sharedManager] decrementActivityCount];
        
        NSEntityDescription *categories = [NSEntityDescription entityForName:@"Category" inManagedObjectContext:self.context];
        
        NSDictionary *categoryNode;
        for(categoryNode in JSON) {
            
            Category *tempCategory = (Category *) [[NSManagedObject alloc] initWithEntity:categories
                                                           insertIntoManagedObjectContext:self.context];
            
            NSString *companyID;
            if ([categoryNode valueForKey:@"company_id"] == [NSNull null]) {
                companyID = @"";
            } else {
                companyID = [categoryNode valueForKey:@"company_id"];
            }
            NSString *categoryID;
            if ([categoryNode valueForKey:@"id"] == [NSNull null]) {
                categoryID = @"";
            } else {
                categoryID = [categoryNode valueForKey:@"id"];
            }
            NSString *name;
            if ([categoryNode valueForKey:@"name"] == [NSNull null]) {
                name = @"";
            } else {
                name = [categoryNode valueForKey:@"name"];
            }
            NSString *selectedAsCategory;
            if ([categoryNode valueForKey:@"selected_as_category"] == [NSNull null]) {
                selectedAsCategory = @"0";
            } else {
                selectedAsCategory = [categoryNode valueForKey:@"selected_as_category"];
            }
            
            
            tempCategory.companyID = [NSNumber numberWithInt:[companyID intValue]];
            tempCategory.categoryID = [NSNumber numberWithInt:[categoryID intValue]];
            tempCategory.name = name;
            tempCategory.selectedAsCategory = [NSNumber numberWithInt:[selectedAsCategory intValue]];
            
            [self.student.company addCategoriesObject:tempCategory];
        }
    } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
        [[AFNetworkActivityIndicatorManager sharedManager] decrementActivityCount];
        [self.hudForDataGathering hide:YES];
        [[SSUser currentUser] logOutAndPresentHUDInViewController:viewController];
        NSLog(@"Whoops, couldn't connect: %@", [JSON description]);
    }];
    
    return operationCategories;
}

-(AFJSONRequestOperation *) pullProductsDataWithClient:(CENTROAPIClient *) client Params:(NSDictionary *) paramToken AndShowHUDInViewController:(UIViewController *) viewController {
    
    [[AFNetworkActivityIndicatorManager sharedManager] incrementActivityCount];
    NSString *pathItems = [NSString stringWithFormat:@"companies/%@/items.json", [[SSUser currentUser] companyID]];
    NSURLRequest *requestItems = [client requestWithMethod:@"GET" path:pathItems parameters:paramToken];
    
    AFJSONRequestOperation *operationItems = [AFJSONRequestOperation JSONRequestOperationWithRequest:requestItems success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
        [[AFNetworkActivityIndicatorManager sharedManager] decrementActivityCount];
        
        NSEntityDescription *items = [NSEntityDescription entityForName:@"Product" inManagedObjectContext:self.context];
        
        NSDictionary *itemNode;
        for(itemNode in JSON) {
            
            Product *tempItem = (Product *) [[NSManagedObject alloc] initWithEntity:items
                                                     insertIntoManagedObjectContext:self.context];
            
            NSString *companyID;
            if ([itemNode valueForKey:@"company_id"] == [NSNull null]) {
                companyID = @"";
            } else {
                companyID = [itemNode valueForKey:@"company_id"];
            }
            NSString *categoryID;
            if ([itemNode valueForKey:@"category_id"] == [NSNull null]) {
                categoryID = @"";
            } else {
                categoryID = [itemNode valueForKey:@"category_id"];
            }
            NSString *productID;
            if ([itemNode valueForKey:@"id"] == [NSNull null]) {
                productID = @"";
            } else {
                productID = [itemNode valueForKey:@"id"];
            }
            NSString *isPriceSure;
            if ([itemNode valueForKey:@"is_price_sure"] == [NSNull null]) {
                isPriceSure = @"1";
            } else {
                isPriceSure = [itemNode valueForKey:@"is_price_sure"];
            }
            NSString *name;
            if ([itemNode valueForKey:@"item"] == [NSNull null]) {
                name = @"";
            } else {
                name = [itemNode valueForKey:@"item"];
            }
            NSString *price;
            if ([itemNode valueForKey:@"price"] == [NSNull null]) {
                price = @"0.0";
            } else {
                price = [itemNode valueForKey:@"price"];
            }
            NSString *selectedAsItem;
            if ([itemNode valueForKey:@"selected_as_item"] == [NSNull null]) {
                selectedAsItem = @"0";
            } else {
                selectedAsItem = [itemNode valueForKey:@"selected_as_item"];
            }
            NSString *selectedAsProfitableItem;
            if ([itemNode valueForKey:@"selected_as_profitable_item"] == [NSNull null]) {
                selectedAsProfitableItem = @"0";
            } else {
                selectedAsProfitableItem = [itemNode valueForKey:@"selected_as_profitable_item"];
            }
            NSString *profitAmount;
            if ([itemNode valueForKey:@"profit_amount"] == [NSNull null]) {
                profitAmount = @"0.0";
            } else {
                profitAmount = [itemNode valueForKey:@"profit_amount"];
            }
            NSString *profitFrequency;
            if ([itemNode valueForKey:@"profit_frequency"] == [NSNull null]) {
                profitFrequency = @"-1";
            } else {
                profitFrequency = [itemNode valueForKey:@"profit_frequency"];
            }
            NSString *isProfitAmountSure;
            if ([itemNode valueForKey:@"is_profit_amount_sure"] == [NSNull null]) {
                isProfitAmountSure = @"1";
            } else {
                isProfitAmountSure = [itemNode valueForKey:@"is_profit_amount_sure"];
            }
            
            tempItem.companyID = [NSNumber numberWithInt:[companyID intValue]];
            tempItem.categoryID = [NSNumber numberWithInt:[categoryID intValue]];
            tempItem.productID = [NSNumber numberWithInt:[productID intValue]];
            tempItem.name = name;
            tempItem.selectedAsItem = [NSNumber numberWithInt:[selectedAsItem intValue]];
            tempItem.isPriceSure = [NSNumber numberWithInt:[isPriceSure intValue]];
            tempItem.price = [NSNumber numberWithInt:[price doubleValue]];
            tempItem.selectedAsProfitableItem = [NSNumber numberWithInt:[selectedAsProfitableItem intValue]];
            tempItem.profitAmount = [NSNumber numberWithInt:[profitAmount doubleValue]];
            tempItem.profitFrequency = [NSNumber numberWithInt:[profitFrequency intValue]];
            tempItem.isProfitAmountSure = [NSNumber numberWithInt:[isProfitAmountSure intValue]];
            
            [self.student.company addProductsObject:tempItem];
        }
        
    } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
        [[AFNetworkActivityIndicatorManager sharedManager] decrementActivityCount];
        [self.hudForDataGathering hide:YES];
        [[SSUser currentUser] logOutAndPresentHUDInViewController:viewController];
        NSLog(@"Whoops, couldn't connect: %@", [JSON description]);
    }];
    
    return operationItems;
}

-(AFJSONRequestOperation *) pullValuePropositionsDataWithClient:(CENTROAPIClient *) client Params:(NSDictionary *) paramToken AndShowHUDInViewController:(UIViewController *) viewController {
    
    [[AFNetworkActivityIndicatorManager sharedManager] incrementActivityCount];
    NSString *pathValuePropositions = [NSString stringWithFormat:@"companies/%@/value_propositions.json", [[SSUser currentUser] companyID]];
    NSURLRequest *requestValuePropositions = [client requestWithMethod:@"GET" path:pathValuePropositions parameters:paramToken];
    
    AFJSONRequestOperation *operationValuePropositions = [AFJSONRequestOperation JSONRequestOperationWithRequest:requestValuePropositions success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
        [[AFNetworkActivityIndicatorManager sharedManager] decrementActivityCount];
        
        NSEntityDescription *valuePropositions = [NSEntityDescription entityForName:@"ValueProposition" inManagedObjectContext:self.context];
        
        NSDictionary *valuePropositionNode;
        for(valuePropositionNode in JSON) {
            
            ValueProposition *tempValueProposition = (ValueProposition *) [[NSManagedObject alloc] initWithEntity:valuePropositions
                                                                                   insertIntoManagedObjectContext:self.context];
            
            NSString *companyID;
            if ([valuePropositionNode valueForKey:@"company_id"] == [NSNull null]) {
                companyID = @"";
            } else {
                companyID = [valuePropositionNode valueForKey:@"company_id"];
            }
            NSString *valuePropositionID;
            if ([valuePropositionNode valueForKey:@"id"] == [NSNull null]) {
                valuePropositionID = @"";
            } else {
                valuePropositionID = [valuePropositionNode valueForKey:@"id"];
            }
            NSString *name;
            if ([valuePropositionNode valueForKey:@"name"] == [NSNull null]) {
                name = @"";
            } else {
                name = [valuePropositionNode valueForKey:@"name"];
            }
            NSString *isCompetitor;
            if ([valuePropositionNode valueForKey:@"is_competitor"] == [NSNull null]) {
                isCompetitor = @"1";
            } else {
                isCompetitor = [valuePropositionNode valueForKey:@"is_competitor"];
            }
            NSString *competitorProfileID;
            if ([valuePropositionNode valueForKey:@"competitor_profile_id"] == [NSNull null]) {
                competitorProfileID = @"";
            } else {
                competitorProfileID = [valuePropositionNode valueForKey:@"competitor_profile_id"];
            }
            NSString *priceRank;
            if ([valuePropositionNode valueForKey:@"price_rank"] == [NSNull null]) {
                priceRank = @"";
            } else {
                priceRank = [valuePropositionNode valueForKey:@"price_rank"];
            }
            NSString *qualityRank;
            if ([valuePropositionNode valueForKey:@"quality_rank"] == [NSNull null]) {
                qualityRank = @"";
            } else {
                qualityRank = [valuePropositionNode valueForKey:@"quality_rank"];
            }
            NSString *customerServiceRank;
            if ([valuePropositionNode valueForKey:@"customer_service_rank"] == [NSNull null]) {
                customerServiceRank = @"customer_service_rank";
            } else {
                customerServiceRank = [valuePropositionNode valueForKey:@""];
            }
            NSString *speedRank;
            if ([valuePropositionNode valueForKey:@"speed_rank"] == [NSNull null]) {
                speedRank = @"";
            } else {
                speedRank = [valuePropositionNode valueForKey:@"speed_rank"];
            }
            NSString *locationRank;
            if ([valuePropositionNode valueForKey:@"location_rank"] == [NSNull null]) {
                locationRank = @"";
            } else {
                locationRank = [valuePropositionNode valueForKey:@"location_rank"];
            }
            
            tempValueProposition.companyID = [NSNumber numberWithInt:[companyID intValue]];
            tempValueProposition.valuePropositionID = [NSNumber numberWithInt:[valuePropositionID intValue]];
            tempValueProposition.name = name;
            tempValueProposition.isCompetitor = [NSNumber numberWithInt:[isCompetitor intValue]];
            tempValueProposition.competitorProfileID = [NSNumber numberWithInt:[competitorProfileID intValue]];
            tempValueProposition.priceRank = [NSNumber numberWithInt:[priceRank intValue]];
            tempValueProposition.qualityRank = [NSNumber numberWithInt:[qualityRank intValue]];
            tempValueProposition.customerServiceRank = [NSNumber numberWithInt:[customerServiceRank doubleValue]];
            tempValueProposition.speedRank = [NSNumber numberWithInt:[speedRank intValue]];
            tempValueProposition.locationRank = [NSNumber numberWithInt:[locationRank doubleValue]];
            
            [self.student.company addValuePropositionsObject:tempValueProposition];
        }
        
    } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
        [[AFNetworkActivityIndicatorManager sharedManager] decrementActivityCount];
        [self.hudForDataGathering hide:YES];
        [[SSUser currentUser] logOutAndPresentHUDInViewController:viewController];
        NSLog(@"Whoops, couldn't connect: %@", [JSON description]);
    }];
    
    return operationValuePropositions;
}

-(AFJSONRequestOperation *) pullWorkingHoursDataWithClient:(CENTROAPIClient *) client Params:(NSDictionary *) paramToken AndShowHUDInViewController:(UIViewController *) viewController {
    
    [[AFNetworkActivityIndicatorManager sharedManager] incrementActivityCount];
    NSString *pathWorkingHours = [NSString stringWithFormat:@"companies/%@/working_hours.json", [[SSUser currentUser] companyID]];
    NSURLRequest *requestWorkingHours = [client requestWithMethod:@"GET" path:pathWorkingHours parameters:paramToken];
    
    AFJSONRequestOperation *operationWorkingHours = [AFJSONRequestOperation JSONRequestOperationWithRequest:requestWorkingHours success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
        [[AFNetworkActivityIndicatorManager sharedManager] decrementActivityCount];
        
        NSEntityDescription *workingHours = [NSEntityDescription entityForName:@"OperatingHour" inManagedObjectContext:self.context];
        
        NSDictionary *workingHourNode;
        for(workingHourNode in JSON) {
            
            OperatingHour *tempWorkingHour = (OperatingHour *) [[NSManagedObject alloc] initWithEntity:workingHours
                                                                        insertIntoManagedObjectContext:self.context];
            
            NSString *workingHourID;
            if ([workingHourNode valueForKey:@"id"] == [NSNull null]) {
                workingHourID = @"";
            } else {
                workingHourID = [workingHourNode valueForKey:@"id"];
            }
            
            NSString *companyID;
            if ([workingHourNode valueForKey:@"company_id"] == [NSNull null]) {
                companyID = @"";
            } else {
                companyID = [workingHourNode valueForKey:@"company_id"];
            }
            
            NSString *selectedAsWorkingDay;
            if ([workingHourNode valueForKey:@"selected_as_working_day"] == [NSNull null]) {
                selectedAsWorkingDay = @"0";
            } else {
                selectedAsWorkingDay = [workingHourNode valueForKey:@"selected_as_working_day"];
            }
            
            NSString *dayOfWeekUS;
            if ([workingHourNode valueForKey:@"day_of_week_us"] == [NSNull null]) {
                dayOfWeekUS = @"";
            } else {
                dayOfWeekUS = [workingHourNode valueForKey:@"day_of_week_us"];
            }
            
            NSString *dayOfWeekID;
            if ([workingHourNode valueForKey:@"day_of_week_id"] == [NSNull null]) {
                dayOfWeekID = @"";
            } else {
                dayOfWeekID = [workingHourNode valueForKey:@"day_of_week_id"];
            }
            
            NSDate *from;
            if ([workingHourNode valueForKey:@"from"] == [NSNull null]) {
                from = nil;
            } else {
                NSString *fromString = [workingHourNode valueForKey:@"from"];
                fromString = [fromString stringByReplacingOccurrencesOfString:@"Z" withString:@""];
                NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
                [dateFormatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss"];
                from = [dateFormatter dateFromString:fromString];
            }
            
            NSDate *to;
            if ([workingHourNode valueForKey:@"to"] == [NSNull null]) {
                to = nil;
            } else {
                NSString *toString = [workingHourNode valueForKey:@"to"];
                toString = [toString stringByReplacingOccurrencesOfString:@"Z" withString:@""];
                NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
                [dateFormatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss"];
                to = [dateFormatter dateFromString:toString];
            }
            
            tempWorkingHour.workingHourID = [NSNumber numberWithInt:[workingHourID intValue]];
            tempWorkingHour.companyID = [NSNumber numberWithInt:[companyID intValue]];
            tempWorkingHour.selectedAsWorkingDay = [NSNumber numberWithInt:[selectedAsWorkingDay intValue]];
            tempWorkingHour.dayOfWeekUS = dayOfWeekUS;
            tempWorkingHour.dayOfWeekID = [NSNumber numberWithInt:[dayOfWeekID intValue]];
            tempWorkingHour.from = from;
            tempWorkingHour.to = to;
            
            [self.student.company addOperatingHoursObject:tempWorkingHour];
        }
        
    } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
        [[AFNetworkActivityIndicatorManager sharedManager] decrementActivityCount];
        [self.hudForDataGathering hide:YES];
        [[SSUser currentUser] logOutAndPresentHUDInViewController:viewController];
        NSLog(@"Whoops, couldn't connect: %@", [JSON description]);
    }];
    
    return operationWorkingHours;
}

-(AFJSONRequestOperation *) pullEmployeesDataWithClient:(CENTROAPIClient *) client Params:(NSDictionary *) paramToken AndShowHUDInViewController:(UIViewController *) viewController {
    
    [[AFNetworkActivityIndicatorManager sharedManager] incrementActivityCount];
    NSString *path = [NSString stringWithFormat:@"companies/%@/employees.json", [[SSUser currentUser] companyID]];
    NSURLRequest *request = [client requestWithMethod:@"GET" path:path parameters:paramToken];
    
    AFJSONRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
        [[AFNetworkActivityIndicatorManager sharedManager] decrementActivityCount];
        
        NSEntityDescription *entityDescription = [NSEntityDescription entityForName:@"Employee" inManagedObjectContext:self.context];
        
        for(NSDictionary *dictionayNode in JSON) {
            
            Employee *tempEntity = (Employee *) [[NSManagedObject alloc] initWithEntity:entityDescription
                                                         insertIntoManagedObjectContext:self.context];
            
            NSString *companyID;
            if ([dictionayNode valueForKey:@"company_id"] == [NSNull null]) {
                companyID = @"";
            } else {
                companyID = [dictionayNode valueForKey:@"company_id"];
            }
            
            NSString *earning;
            if ([dictionayNode valueForKey:@"earning"] == [NSNull null]) {
                earning = @"0.0";
            } else {
                earning = [dictionayNode valueForKey:@"earning"];
            }
            
            NSString *earningFrequency;
            if ([dictionayNode valueForKey:@"earning_frequency"] == [NSNull null]) {
                earningFrequency = @"-1";
            } else {
                earningFrequency = [dictionayNode valueForKey:@"earning_frequency"];
            }
            
            NSString *name;
            if ([dictionayNode valueForKey:@"name"] == [NSNull null]) {
                name = @"";
            } else {
                name = [dictionayNode valueForKey:@"name"];
            }
            
            NSString *manager;
            if ([dictionayNode valueForKey:@"manager"] == [NSNull null]) {
                manager = @"0";
            } else {
                manager = [dictionayNode valueForKey:@"manager"];
            }
            
            NSString *employeeID;
            if ([dictionayNode valueForKey:@"id"] == [NSNull null]) {
                employeeID = @"";
            } else {
                employeeID = [dictionayNode valueForKey:@"id"];
            }
            
            NSString *professionalExperience;
            if ([dictionayNode valueForKey:@"professional_experience"] == [NSNull null]) {
                professionalExperience = @"";
            } else {
                professionalExperience = [dictionayNode valueForKey:@"professional_experience"];
            }
            
            NSString *selectedAsEmployee;
            if ([dictionayNode valueForKey:@"selected_as_employee"] == [NSNull null]) {
                selectedAsEmployee = @"0";
            } else {
                selectedAsEmployee = [dictionayNode valueForKey:@"selected_as_employee"];
            }
            
            NSString *weeksWork;
            if ([dictionayNode valueForKey:@"weeks_work"] == [NSNull null]) {
                weeksWork = @"0";
            } else {
                weeksWork = [dictionayNode valueForKey:@"weeks_work"];
            }
            
            NSString *myself;
            if ([dictionayNode valueForKey:@"myself"] == [NSNull null]) {
                myself = @"0";
            } else {
                myself = [dictionayNode valueForKey:@"myself"];
            }
            
            tempEntity.companyID = [NSNumber numberWithInt:[companyID intValue]];
            tempEntity.earning = [NSNumber numberWithDouble:[earning doubleValue]];
            tempEntity.earningFrequency = [NSNumber numberWithInt:[earningFrequency intValue]];
            tempEntity.employeeID = [NSNumber numberWithInt:[employeeID intValue]];
            tempEntity.manager = [NSNumber numberWithInt:[manager intValue]];
            tempEntity.name = name;
            tempEntity.professionalExperience = [NSNumber numberWithInt:[professionalExperience intValue]];
            tempEntity.selectedAsEmployee = [NSNumber numberWithInt:[selectedAsEmployee intValue]];
            tempEntity.weeksWork = [NSNumber numberWithInt:[weeksWork intValue]];
            tempEntity.myself = [NSNumber numberWithInt:[myself intValue]];
            
            [self.student.company addEmployeesObject:tempEntity];
        }
        
    } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
        [[AFNetworkActivityIndicatorManager sharedManager] decrementActivityCount];
        [self.hudForDataGathering hide:YES];
        [[SSUser currentUser] logOutAndPresentHUDInViewController:viewController];
        NSLog(@"Whoops, couldn't connect: %@", [JSON description]);
    }];
    
    return operation;
}

-(AFJSONRequestOperation *) pullEmployeeEducationsDataWithClient:(CENTROAPIClient *) client Params:(NSDictionary *) paramToken AndShowHUDInViewController:(UIViewController *) viewController {
    
    [[AFNetworkActivityIndicatorManager sharedManager] incrementActivityCount];
    NSString *pathEducations = [NSString stringWithFormat:@"employees/%@/educations.json", [[SSUser currentUser] companyID]];
    NSURLRequest *requestEducations = [client requestWithMethod:@"GET" path:pathEducations parameters:paramToken];
    
    AFJSONRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:requestEducations success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
        [[AFNetworkActivityIndicatorManager sharedManager] decrementActivityCount];
        
        NSEntityDescription *educations = [NSEntityDescription entityForName:@"EmployeeEducation" inManagedObjectContext:self.context];
        
        NSDictionary *educationNode;
        for(educationNode in JSON) {
            
            EmployeeEducation *tempEducation = (EmployeeEducation *) [[NSManagedObject alloc] initWithEntity:educations
                                                                              insertIntoManagedObjectContext:self.context];
            
            NSString *employeeID;
            if ([educationNode valueForKey:@"employee_id"] == [NSNull null]) {
                employeeID = @"";
            } else {
                employeeID = [educationNode valueForKey:@"employee_id"];
            }
            
            NSString *educationID;
            if ([educationNode valueForKey:@"id"] == [NSNull null]) {
                educationID = @"";
            } else {
                educationID = [educationNode valueForKey:@"id"];
            }
            
            NSString *educationCode;
            if ([educationNode valueForKey:@"education_code"] == [NSNull null]) {
                educationCode = @"";
            } else {
                educationCode = [educationNode valueForKey:@"education_code"];
            }
            
            NSString *educationLiteralUS;
            if ([educationNode valueForKey:@"education_literal_us"] == [NSNull null]) {
                educationLiteralUS = @"";
            } else {
                educationLiteralUS = [educationNode valueForKey:@"education_literal_us"];
            }
            
            NSString *selectedAsEmployeeEducation;
            if ([educationNode valueForKey:@"selected_as_employee_education"] == [NSNull null]) {
                selectedAsEmployeeEducation = @"0";
            } else {
                selectedAsEmployeeEducation = [educationNode valueForKey:@"selected_as_employee_education"];
            }
            
            tempEducation.employeeID = [NSNumber numberWithInt:[employeeID intValue]];
            tempEducation.educationID = [NSNumber numberWithInt:[educationID intValue]];
            tempEducation.educationCode = educationCode;
            tempEducation.educationLiteralUS = educationLiteralUS;
            tempEducation.selectedAsEmployeeEducation = [NSNumber numberWithInt:[selectedAsEmployeeEducation intValue]];
            tempEducation.companyID = [NSNumber numberWithInt:[[[SSUser currentUser] companyID] intValue]];
            
            [self.student.company addEmployeeEducationsObject:tempEducation];
        }
        
    } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
        [[AFNetworkActivityIndicatorManager sharedManager] decrementActivityCount];
        [self.hudForDataGathering hide:YES];
        [[SSUser currentUser] logOutAndPresentHUDInViewController:viewController];
        NSLog(@"Whoops, couldn't connect: %@", [JSON description]);
    }];
    
    return operation;
}

-(AFJSONRequestOperation *) pullResponsibilitiesDataWithClient:(CENTROAPIClient *) client Params:(NSDictionary *) paramToken AndShowHUDInViewController:(UIViewController *) viewController {
    
    [[AFNetworkActivityIndicatorManager sharedManager] incrementActivityCount];
    NSString *path = [NSString stringWithFormat:@"companies/%@/responsibilities.json", [[SSUser currentUser] companyID]];
    NSURLRequest *request = [client requestWithMethod:@"GET" path:path parameters:paramToken];
    
    AFJSONRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
        [[AFNetworkActivityIndicatorManager sharedManager] decrementActivityCount];
        
        NSEntityDescription *entity = [NSEntityDescription entityForName:@"Responsibility" inManagedObjectContext:self.context];
        
        for(NSDictionary *entityNode in JSON) {
            
            Responsibility *tempEntity = (Responsibility *) [[NSManagedObject alloc] initWithEntity:entity
                                                                     insertIntoManagedObjectContext:self.context];
            
            NSString *companyID;
            if ([entityNode valueForKey:@"company_id"] == [NSNull null]) {
                companyID = @"";
            } else {
                companyID = [entityNode valueForKey:@"company_id"];
            }
            
            NSString *responsibilityID;
            if ([entityNode valueForKey:@"id"] == [NSNull null]) {
                responsibilityID = @"";
            } else {
                responsibilityID = [entityNode valueForKey:@"id"];
            }
            
            NSString *responsibilityDescription;
            if ([entityNode valueForKey:@"responsibility"] == [NSNull null]) {
                responsibilityDescription = @"";
            } else {
                responsibilityDescription = [entityNode valueForKey:@"responsibility"];
            }
            
            NSString *selectedAsResponsibility;
            if ([entityNode valueForKey:@"selected_as_responsibility"] == [NSNull null]) {
                selectedAsResponsibility = @"0";
            } else {
                selectedAsResponsibility = [entityNode valueForKey:@"selected_as_responsibility"];
            }
            
            tempEntity.companyID = [NSNumber numberWithInt:[companyID intValue]];
            tempEntity.responsibilityID = [NSNumber numberWithInt:[responsibilityID intValue]];
            tempEntity.responsibilityDescription = responsibilityDescription;
            tempEntity.selectedAsResponsibility = [NSNumber numberWithInt:[selectedAsResponsibility intValue]];
            
            [self.student.company addResponsibilitiesObject:tempEntity];
        }
        
    } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
        [[AFNetworkActivityIndicatorManager sharedManager] decrementActivityCount];
        [self.hudForDataGathering hide:YES];
        [[SSUser currentUser] logOutAndPresentHUDInViewController:viewController];
        NSLog(@"Whoops, couldn't connect: %@", [JSON description]);
    }];
    
    return operation;
}


-(AFJSONRequestOperation *) pullEmployeeResponsibilitiesDataWithClient:(CENTROAPIClient *) client Params:(NSDictionary *) paramToken AndShowHUDInViewController:(UIViewController *) viewController {
    
    [[AFNetworkActivityIndicatorManager sharedManager] incrementActivityCount];
    NSString *path = [NSString stringWithFormat:@"companies/%@/employees_responsibilities.json", [[SSUser currentUser] companyID]];
    NSURLRequest *request = [client requestWithMethod:@"GET" path:path parameters:paramToken];
    
    AFJSONRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
        [[AFNetworkActivityIndicatorManager sharedManager] decrementActivityCount];
        
        NSEntityDescription *entity = [NSEntityDescription entityForName:@"EmployeeResponsibility" inManagedObjectContext:self.context];
        
        for(NSDictionary *entityNode in JSON) {
            
            EmployeeResponsibility *tempEntity = (EmployeeResponsibility *) [[NSManagedObject alloc] initWithEntity:entity
                                                                                     insertIntoManagedObjectContext:self.context];
            
            NSString *companyID;
            if ([entityNode valueForKey:@"company_id"] == [NSNull null]) {
                companyID = @"";
            } else {
                companyID = [entityNode valueForKey:@"company_id"];
            }
            
            NSString *employeeID;
            if ([entityNode valueForKey:@"employee_id"] == [NSNull null]) {
                employeeID = @"";
            } else {
                employeeID = [entityNode valueForKey:@"employee_id"];
            }
            
            NSString *frequencyHoursNeeded;
            if ([entityNode valueForKey:@"frequency_hours_needed"] == [NSNull null]) {
                frequencyHoursNeeded = @"";
            } else {
                frequencyHoursNeeded = [entityNode valueForKey:@"frequency_hours_needed"];
            }
            
            NSString *hoursNeeded;
            if ([entityNode valueForKey:@"hours_needed"] == [NSNull null]) {
                hoursNeeded = @"";
            } else {
                hoursNeeded = [entityNode valueForKey:@"hours_needed"];
            }
            
            NSString *employeeResponsibilityID;
            if ([entityNode valueForKey:@"id"] == [NSNull null]) {
                employeeResponsibilityID = @"";
            } else {
                employeeResponsibilityID = [entityNode valueForKey:@"id"];
            }
            
            NSString *isMyResponsibility;
            if ([entityNode valueForKey:@"is_my_responsibility"] == [NSNull null]) {
                isMyResponsibility = @"0";
            } else {
                isMyResponsibility = [entityNode valueForKey:@"is_my_responsibility"];
            }
            
            NSString *isOtherResponsibility;
            if ([entityNode valueForKey:@"is_other_responsibility"] == [NSNull null]) {
                isOtherResponsibility = @"0";
            } else {
                isOtherResponsibility = [entityNode valueForKey:@"is_other_responsibility"];
            }
            
            NSString *rank;
            if ([entityNode valueForKey:@"rank"] == [NSNull null]) {
                rank = @"";
            } else {
                rank = [entityNode valueForKey:@"rank"];
            }
            
            NSString *responsibilityID;
            if ([entityNode valueForKey:@"responsibility_id"] == [NSNull null]) {
                responsibilityID = @"";
            } else {
                responsibilityID = [entityNode valueForKey:@"responsibility_id"];
            }
            
            NSString *selectedAsResponsibility;
            if ([entityNode valueForKey:@"selected_as_responsibility"] == [NSNull null]) {
                selectedAsResponsibility = @"0";
            } else {
                selectedAsResponsibility = [entityNode valueForKey:@"selected_as_responsibility"];
            }
            
            tempEntity.companyID = [NSNumber numberWithInt:[companyID intValue]];
            tempEntity.employeeID = [NSNumber numberWithInt:[employeeID intValue]];
            tempEntity.frequencyHoursNeeded = [NSNumber numberWithInt:[frequencyHoursNeeded intValue]];
            tempEntity.hoursNeeded = [NSNumber numberWithInt:[hoursNeeded intValue]];
            tempEntity.employeeResponsibilityID = [NSNumber numberWithInt:[employeeResponsibilityID intValue]];
            tempEntity.isMyResponsibility = [NSNumber numberWithInt:[isMyResponsibility intValue]];
            tempEntity.isOtherResponsibility = [NSNumber numberWithInt:[isOtherResponsibility intValue]];
            tempEntity.rank = [NSNumber numberWithInt:[rank intValue]];
            tempEntity.responsibilityID = [NSNumber numberWithInt:[responsibilityID intValue]];
            tempEntity.selectedAsResponsibility = [NSNumber numberWithInt:[selectedAsResponsibility intValue]];
            
            [self.student.company addEmployeeResponsibilitiesObject:tempEntity];
        }
        
    } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
        [[AFNetworkActivityIndicatorManager sharedManager] decrementActivityCount];
        [self.hudForDataGathering hide:YES];
        [[SSUser currentUser] logOutAndPresentHUDInViewController:viewController];
        NSLog(@"Whoops, couldn't connect: %@", [JSON description]);
    }];
    
    return operation;
}

-(AFJSONRequestOperation *) pullBrandAttributesDataWithClient:(CENTROAPIClient *) client Params:(NSDictionary *) paramToken AndShowHUDInViewController:(UIViewController *) viewController {
    
    [[AFNetworkActivityIndicatorManager sharedManager] incrementActivityCount];
    NSString *path = [NSString stringWithFormat:@"companies/%@/brands.json", [[SSUser currentUser] companyID]];
    NSURLRequest *request = [client requestWithMethod:@"GET" path:path parameters:paramToken];
    
    AFJSONRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
        [[AFNetworkActivityIndicatorManager sharedManager] decrementActivityCount];
        
        NSEntityDescription *entity = [NSEntityDescription entityForName:@"BrandAttribute" inManagedObjectContext:self.context];
        
        for(NSDictionary *entityNode in JSON) {
            
            BrandAttribute *tempEntity = (BrandAttribute *) [[NSManagedObject alloc] initWithEntity:entity
                                                                     insertIntoManagedObjectContext:self.context];
            NSString *brandValueID;
            if ([entityNode valueForKey:@"id"] == [NSNull null]) {
                brandValueID = @"";
            } else {
                brandValueID = [entityNode valueForKey:@"id"];
            }
            
            NSString *brandValueRank;
            if ([entityNode valueForKey:@"brand_value_rank"] == [NSNull null]) {
                brandValueRank = @"";
            } else {
                brandValueRank = [entityNode valueForKey:@"brand_value_rank"];
            }
            
            NSString *selectedOverBrandValue;
            if ([entityNode valueForKey:@"selected_over_brand_value"] == [NSNull null]) {
                selectedOverBrandValue = @"";
            } else {
                selectedOverBrandValue = [entityNode valueForKey:@"selected_over_brand_value"];
            }
            
            NSString *companyID;
            if ([entityNode valueForKey:@"company_id"] == [NSNull null]) {
                companyID = @"";
            } else {
                companyID = [entityNode valueForKey:@"company_id"];
            }
            
            NSString *brandValueCode;
            if ([entityNode valueForKey:@"brand_value_code"] == [NSNull null]) {
                brandValueCode = @"";
            } else {
                brandValueCode = [entityNode valueForKey:@"brand_value_code"];
            }
            
            NSString *brandValueLiteralUS;
            if ([entityNode valueForKey:@"brand_value_literal_us"] == [NSNull null]) {
                brandValueLiteralUS = @"";
            } else {
                brandValueLiteralUS = [entityNode valueForKey:@"brand_value_literal_us"];
            }
            
            NSString *brandValuePropositionRank;
            if ([entityNode valueForKey:@"brand_value_proposition_rank"] == [NSNull null]) {
                brandValuePropositionRank = @"";
            } else {
                brandValuePropositionRank = [entityNode valueForKey:@"brand_value_proposition_rank"];
            }
            
            NSString *selectedAsBrandValueProposition;
            if ([entityNode valueForKey:@"selected_as_brand_value_proposition"] == [NSNull null]) {
                selectedAsBrandValueProposition = @"0";
            } else {
                selectedAsBrandValueProposition = [entityNode valueForKey:@"selected_as_brand_value_proposition"];
            }
            
            tempEntity.brandValueID = [NSNumber numberWithInt:[brandValueID intValue]];
            tempEntity.brandValueRank = [NSNumber numberWithInt:[brandValueRank intValue]];
            tempEntity.selectedOverBrandValue = selectedOverBrandValue;
            tempEntity.companyID = [NSNumber numberWithInt:[companyID intValue]];
            tempEntity.brandValueCode = brandValueCode;
            tempEntity.brandValueLiteralUS = brandValueLiteralUS;
            tempEntity.brandValuePropositionRank = [NSNumber numberWithInt:[brandValuePropositionRank intValue]];
            tempEntity.selectedAsBrandValueProposition = [NSNumber numberWithInt:[selectedAsBrandValueProposition intValue]];
            
            [self.student.company addBrandAttributesObject:tempEntity];
        }
    } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
        [[AFNetworkActivityIndicatorManager sharedManager] decrementActivityCount];
        [self.hudForDataGathering hide:YES];
        [[SSUser currentUser] logOutAndPresentHUDInViewController:viewController];
        NSLog(@"Whoops, couldn't connect: %@", [JSON description]);
    }];
    
    return operation;
}

-(AFJSONRequestOperation *) pullCompanyCostsDataWithClient:(CENTROAPIClient *) client Params:(NSDictionary *) paramToken AndShowHUDInViewController:(UIViewController *) viewController {
    
    [[AFNetworkActivityIndicatorManager sharedManager] incrementActivityCount];
    NSString *pathCompanyCosts = [NSString stringWithFormat:@"companies/%@/costs.json", [[SSUser currentUser] companyID]];
    NSURLRequest *requestCompanyCosts = [client requestWithMethod:@"GET" path:pathCompanyCosts parameters:paramToken];
    
    AFJSONRequestOperation *operationCompanyCosts = [AFJSONRequestOperation JSONRequestOperationWithRequest:requestCompanyCosts success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
        [[AFNetworkActivityIndicatorManager sharedManager] decrementActivityCount];
        
        NSEntityDescription *companyCosts = [NSEntityDescription entityForName:@"CompanyCost" inManagedObjectContext:self.context];
        
        NSDictionary *companyCostNode;
        for(companyCostNode in JSON) {
            
            CompanyCost *tempCompanyCost = (CompanyCost *) [[NSManagedObject alloc] initWithEntity:companyCosts
                                                                    insertIntoManagedObjectContext:self.context];
            NSString *companyCostID;
            if ([companyCostNode valueForKey:@"id"] == [NSNull null]) {
                companyCostID = @"";
            } else {
                companyCostID = [companyCostNode valueForKey:@"id"];
            }
            
            NSString *companyID;
            if ([companyCostNode valueForKey:@"company_id"] == [NSNull null]) {
                companyID = @"";
            } else {
                companyID = [companyCostNode valueForKey:@"company_id"];
            }
            
            NSString *isSure;
            if ([companyCostNode valueForKey:@"is_sure"] == [NSNull null]) {
                isSure = @"0";
            } else {
                isSure = [companyCostNode valueForKey:@"is_sure"];
            }
            
            NSString *frequency;
            if ([companyCostNode valueForKey:@"frequency"] == [NSNull null]) {
                frequency = @"-1";
            } else {
                frequency = [companyCostNode valueForKey:@"frequency"];
            }
            
            NSString *companyCostCode;
            if ([companyCostNode valueForKey:@"cost_code"] == [NSNull null]) {
                companyCostCode = @"";
            } else {
                companyCostCode = [companyCostNode valueForKey:@"cost_code"];
            }
            
            NSString *companyCostLiteralUS;
            if ([companyCostNode valueForKey:@"cost_literal_us"] == [NSNull null]) {
                companyCostLiteralUS = @"";
            } else {
                companyCostLiteralUS = [companyCostNode valueForKey:@"cost_literal_us"];
            }
            
            NSString *amount;
            if ([companyCostNode valueForKey:@"amount"] == [NSNull null]) {
                amount = @"0.0";
            } else {
                amount = [companyCostNode valueForKey:@"amount"];
            }
            
            NSString *selectedAsIncurredCost;
            if ([companyCostNode valueForKey:@"selected_as_incurred_cost"] == [NSNull null]) {
                selectedAsIncurredCost = @"0";
            } else {
                selectedAsIncurredCost = [companyCostNode valueForKey:@"selected_as_incurred_cost"];
            }
            
            tempCompanyCost.companyCostID = [NSNumber numberWithInt:[companyCostID intValue]];
            tempCompanyCost.companyID = [NSNumber numberWithInt:[companyID intValue]];
            tempCompanyCost.isSure = [NSNumber numberWithInt:[isSure intValue]];
            tempCompanyCost.frequency = [NSNumber numberWithInt:[frequency intValue]];
            tempCompanyCost.companyCostCode = companyCostCode;
            tempCompanyCost.companyCostLiteralUS = companyCostLiteralUS;
            tempCompanyCost.amount = [NSNumber numberWithDouble:[amount doubleValue]];
            tempCompanyCost.selectedAsIncurredCost = [NSNumber numberWithInt:[selectedAsIncurredCost intValue]];
            
            [self.student.company addCompanyCostsObject:tempCompanyCost];
        }
        
    } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
        [[AFNetworkActivityIndicatorManager sharedManager] decrementActivityCount];
        [self.hudForDataGathering hide:YES];
        [[SSUser currentUser] logOutAndPresentHUDInViewController:viewController];
        NSLog(@"Whoops, couldn't connect: %@", [JSON description]);
    }];
    
    return operationCompanyCosts;
}

-(AFJSONRequestOperation *) pullCompanyAssetsDataWithClient:(CENTROAPIClient *) client Params:(NSDictionary *) paramToken AndShowHUDInViewController:(UIViewController *) viewController {
    
    [[AFNetworkActivityIndicatorManager sharedManager] incrementActivityCount];
    NSString *pathCompanyAssets = [NSString stringWithFormat:@"companies/%@/assets.json", [[SSUser currentUser] companyID]];
    NSURLRequest *requestCompanyAssets = [client requestWithMethod:@"GET" path:pathCompanyAssets parameters:paramToken];
    
    AFJSONRequestOperation *operationCompanyAssets = [AFJSONRequestOperation JSONRequestOperationWithRequest:requestCompanyAssets success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
        [[AFNetworkActivityIndicatorManager sharedManager] decrementActivityCount];
        
        NSEntityDescription *companyAssets = [NSEntityDescription entityForName:@"CompanyAsset" inManagedObjectContext:self.context];
        
        NSDictionary *companyAssetNode;
        for(companyAssetNode in JSON) {
            
            CompanyAsset *tempCompanyAsset = (CompanyAsset *) [[NSManagedObject alloc] initWithEntity:companyAssets
                                                                       insertIntoManagedObjectContext:self.context];
            
            NSString *companyAssetID;
            if ([companyAssetNode valueForKey:@"id"] == [NSNull null]) {
                companyAssetID = @"";
            } else {
                companyAssetID = [companyAssetNode valueForKey:@"id"];
            }
            
            NSString *companyID;
            if ([companyAssetNode valueForKey:@"company_id"] == [NSNull null]) {
                companyID = @"";
            } else {
                companyID = [companyAssetNode valueForKey:@"company_id"];
            }
            
            NSString *isSure;
            if ([companyAssetNode valueForKey:@"is_sure"] == [NSNull null]) {
                isSure = @"0";
            } else {
                isSure = [companyAssetNode valueForKey:@"is_sure"];
            }
            
            NSString *companyAssetCode;
            if ([companyAssetNode valueForKey:@"asset_code"] == [NSNull null]) {
                companyAssetCode = @"";
            } else {
                companyAssetCode = [companyAssetNode valueForKey:@"asset_code"];
            }
            
            NSString *companyAssetLiteralUS;
            if ([companyAssetNode valueForKey:@"asset_literal_us"] == [NSNull null]) {
                companyAssetLiteralUS = @"";
            } else {
                companyAssetLiteralUS = [companyAssetNode valueForKey:@"asset_literal_us"];
            }
            
            NSString *amount;
            if ([companyAssetNode valueForKey:@"amount"] == [NSNull null]) {
                amount = @"0.0";
            } else {
                amount = [companyAssetNode valueForKey:@"amount"];
            }
            
            NSString *selectedAsAsset;
            if ([companyAssetNode valueForKey:@"selected_as_asset"] == [NSNull null]) {
                selectedAsAsset = @"0";
            } else {
                selectedAsAsset = [companyAssetNode valueForKey:@"selected_as_asset"];
            }
            
            tempCompanyAsset.companyAssetID = [NSNumber numberWithInt:[companyAssetID intValue]];
            tempCompanyAsset.companyID = [NSNumber numberWithInt:[companyID intValue]];
            tempCompanyAsset.isSure = [NSNumber numberWithInt:[isSure intValue]];
            tempCompanyAsset.companyAssetCode = companyAssetCode;
            tempCompanyAsset.companyAssetLiteralUS = companyAssetLiteralUS;
            tempCompanyAsset.amount = [NSNumber numberWithDouble:[amount doubleValue]];
            tempCompanyAsset.selectedAsAsset = [NSNumber numberWithInt:[selectedAsAsset intValue]];
            
            [self.student.company addCompanyAssetsObject:tempCompanyAsset];
        }
        
    } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
        [[AFNetworkActivityIndicatorManager sharedManager] decrementActivityCount];
        [self.hudForDataGathering hide:YES];
        [[SSUser currentUser] logOutAndPresentHUDInViewController:viewController];
        NSLog(@"Whoops, couldn't connect: %@", [JSON description]);
    }];
    
    return operationCompanyAssets;
}

-(AFJSONRequestOperation *) pullCompanyDebtsDataWithClient:(CENTROAPIClient *) client Params:(NSDictionary *) paramToken AndShowHUDInViewController:(UIViewController *) viewController {
    
    [[AFNetworkActivityIndicatorManager sharedManager] incrementActivityCount];
    NSString *pathCompanyDebts = [NSString stringWithFormat:@"companies/%@/debts.json", [[SSUser currentUser] companyID]];
    NSURLRequest *requestCompanyDebts = [client requestWithMethod:@"GET" path:pathCompanyDebts parameters:paramToken];
    
    AFJSONRequestOperation *operationCompanyDebts = [AFJSONRequestOperation JSONRequestOperationWithRequest:requestCompanyDebts success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
        [[AFNetworkActivityIndicatorManager sharedManager] decrementActivityCount];
        
        NSEntityDescription *companyDebts = [NSEntityDescription entityForName:@"CompanyDebt" inManagedObjectContext:self.context];
        
        NSDictionary *companyDebtNode;
        for(companyDebtNode in JSON) {
            
            CompanyDebt *tempCompanyDebt = (CompanyDebt *) [[NSManagedObject alloc] initWithEntity:companyDebts
                                                                    insertIntoManagedObjectContext:self.context];
            
            NSString *companyDebtID;
            if ([companyDebtNode valueForKey:@"id"] == [NSNull null]) {
                companyDebtID = @"";
            } else {
                companyDebtID = [companyDebtNode valueForKey:@"id"];
            }
            
            NSString *companyID;
            if ([companyDebtNode valueForKey:@"company_id"] == [NSNull null]) {
                companyID = @"";
            } else {
                companyID = [companyDebtNode valueForKey:@"company_id"];
            }
            
            NSString *isSure;
            if ([companyDebtNode valueForKey:@"is_sure"] == [NSNull null]) {
                isSure = @"0";
            } else {
                isSure = [companyDebtNode valueForKey:@"is_sure"];
            }
            
            NSString *companyDebtCode;
            if ([companyDebtNode valueForKey:@"debt_code"] == [NSNull null]) {
                companyDebtCode = @"";
            } else {
                companyDebtCode = [companyDebtNode valueForKey:@"debt_code"];
            }
            
            NSString *companyDebtLiteralUS;
            if ([companyDebtNode valueForKey:@"debt_literal_us"] == [NSNull null]) {
                companyDebtLiteralUS = @"";
            } else {
                companyDebtLiteralUS = [companyDebtNode valueForKey:@"debt_literal_us"];
            }
            
            NSString *amount;
            if ([companyDebtNode valueForKey:@"amount"] == [NSNull null]) {
                amount = @"0.0";
            } else {
                amount = [companyDebtNode valueForKey:@"amount"];
            }
            
            NSString *selectedAsDebt;
            if ([companyDebtNode valueForKey:@"selected_as_debt"] == [NSNull null]) {
                selectedAsDebt = @"0";
            } else {
                selectedAsDebt = [companyDebtNode valueForKey:@"selected_as_debt"];
            }
            
            tempCompanyDebt.companyDebtID = [NSNumber numberWithInt:[companyDebtID intValue]];
            tempCompanyDebt.companyID = [NSNumber numberWithInt:[companyID intValue]];
            tempCompanyDebt.isSure = [NSNumber numberWithInt:[isSure intValue]];
            tempCompanyDebt.companyDebtCode = companyDebtCode;
            tempCompanyDebt.companyDebtLiteralUS = companyDebtLiteralUS;
            tempCompanyDebt.amount = [NSNumber numberWithDouble:[amount doubleValue]];
            tempCompanyDebt.selectedAsDebt = [NSNumber numberWithInt:[selectedAsDebt intValue]];
            
            [self.student.company addCompanyDebtsObject:tempCompanyDebt];
        }
        
        [self.hudForDataGathering hide:YES];
        [[UIApplication sharedApplication] endIgnoringInteractionEvents];
        NSError *error;
        if (![self.context save:&error]) {
            NSLog(@"Whoops, couldn't save: %@", [error localizedDescription]);
            [[SSUser currentUser] logOutAndPresentHUDInViewController:viewController];
        }
        
    } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
        [[AFNetworkActivityIndicatorManager sharedManager] decrementActivityCount];
        [self.hudForDataGathering hide:YES];
        [[UIApplication sharedApplication] endIgnoringInteractionEvents];
        [[SSUser currentUser] logOutAndPresentHUDInViewController:viewController];
        NSLog(@"Whoops, couldn't connect: %@", [JSON description]);
    }];
    
    return operationCompanyDebts;
}

#pragma mark - Individual pushs

-(AFJSONRequestOperation *) pushActivitiesWithClient:(CENTROAPIClient *) client inViewController:(UIViewController *) viewController andStopHUD:(BOOL) stopHUD {
    
    NSFetchRequest *activityFetchRequest = [[NSFetchRequest alloc] init];
    
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Activity" inManagedObjectContext:self.context];
    
    [activityFetchRequest setEntity:entity];
    
    [activityFetchRequest setPredicate:[NSPredicate predicateWithFormat:@"studentID == %@", [[SSUser currentUser] studentID]]];
    
    activityFetchRequest.sortDescriptors = [NSArray arrayWithObject:[NSSortDescriptor sortDescriptorWithKey:@"turn" ascending:YES selector:nil]];
    
    if(![NSThread isMainThread]){
        [self performSelectorOnMainThread:@selector(switchToMainThread) withObject:nil waitUntilDone:YES];
    }
    
    NSError *errorSV;
    NSArray *activitiesResult = [self.context executeFetchRequest:activityFetchRequest error:&errorSV];
    if (activitiesResult.count == 0) {
        return nil;
    } else {
        NSMutableDictionary *params = [NSMutableDictionary dictionaryWithCapacity:35];
        [params setObject:[[SSUser currentUser] token] forKey:@"auth_token"];
        [params setObject:@"1" forKey:@"bulk"];
        
        for(Activity *activity in activitiesResult) {
            
            NSDictionary *tempActivityDict = [NSDictionary dictionaryWithObjectsAndKeys:
                                              activity.completed, @"completed",
                                              activity.activityID, @"id",
                                              activity.name, @"name",
                                              activity.studentID, @"student_id",
                                              activity.synced, @"synced",
                                              activity.turn, @"turn",
                                              activity.showCompletedScreen, @"show_completed_screen",
                                              nil];
            
            NSString *tempKey = [NSString stringWithFormat:@"activities_%@", activity.activityID];
            [params setObject:tempActivityDict forKey:tempKey];
            
        }
        
        [[AFNetworkActivityIndicatorManager sharedManager] incrementActivityCount];
        NSString *path = @"activities/bulk.json";
        NSURLRequest *request = [client requestWithMethod:@"PUT" path:path parameters:params];
        
        AFJSONRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
            [[AFNetworkActivityIndicatorManager sharedManager] decrementActivityCount];
            if(stopHUD) {
                [self.hudForPush hide:YES];
                [[UIApplication sharedApplication] endIgnoringInteractionEvents];
            }
            if([viewController isKindOfClass:[SSActivitiesViewController class]]) {
                [[(SSActivitiesViewController *)viewController syncButton] setEnabled:NO];
            }
        } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
            [[AFNetworkActivityIndicatorManager sharedManager] decrementActivityCount];
            [self.hudForPush hide:YES];
        }];
        
        return operation;
    }
}

-(void) switchToMainThread {}

-(AFJSONRequestOperation *) logOutWithClient:(CENTROAPIClient *) client andPresentHUDInViewController:(UIViewController *) hudViewController {
    
    
    [[AFNetworkActivityIndicatorManager sharedManager] setEnabled:YES];
    [[AFNetworkActivityIndicatorManager sharedManager] incrementActivityCount];
    
    NSDictionary *params = @{@"email": [[SSUser currentUser] username]};
    
    NSString *path = @"users/sign_out.json";
    NSURLRequest *request = [client requestWithMethod:@"DELETE" path:path parameters:params];
    
    AFJSONRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
        [[AFNetworkActivityIndicatorManager sharedManager] decrementActivityCount];
        
        [[SSUser currentUser] localLogOut];
        
        NSManagedObjectContext *context = [(id)[[UIApplication sharedApplication] delegate] managedObjectContext];
        
        NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
        NSEntityDescription *entity = [NSEntityDescription entityForName:@"Student"
                                                  inManagedObjectContext:context];
        [fetchRequest setEntity:entity];
        
        NSError *errorFetch;
        NSArray *fetchedObjects = [context executeFetchRequest:fetchRequest error:&errorFetch];
        
        for (Student *stud in fetchedObjects) {
            [context deleteObject:stud];
        }
        
        NSFetchRequest *fetchRequestIS = [[NSFetchRequest alloc] init];
        NSEntityDescription *entityIS = [NSEntityDescription entityForName:@"IndustryAndSegment"
                                                    inManagedObjectContext:context];
        [fetchRequestIS setEntity:entityIS];
        
        NSError *errorFetchIS;
        NSArray *fetchedObjectsIS = [context executeFetchRequest:fetchRequestIS error:&errorFetchIS];
        
        for (IndustryAndSegment *is in fetchedObjectsIS) {
            [context deleteObject:is];
        }
        NSError *error;
        if (![context save:&error]) {
            
            NSLog(@"Whoops, couldn't save: %@", [error localizedDescription]);
        }
        
        [self.hudForPush hide:YES];
        [[UIApplication sharedApplication] endIgnoringInteractionEvents];
        [hudViewController.parentViewController.tabBarController setSelectedIndex:0];
        
    } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
        [[AFNetworkActivityIndicatorManager sharedManager] decrementActivityCount];
        [self.hudForPush hide:YES];
        [[UIApplication sharedApplication] endIgnoringInteractionEvents];
        [SSUtils showAlertViewBasedOnNetworkError:error];
    }];
    
    return operation;
}

-(AFJSONRequestOperation *) pushValuesDataFromActivity: (NSString *) activityTurn withClient:(CENTROAPIClient *) client showHUDInViewController:(UIViewController *) viewController {
    
    NSFetchRequest *valuesFetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Value" inManagedObjectContext:self.context];
    
    [valuesFetchRequest setEntity:entity];
    [valuesFetchRequest setPredicate:[NSPredicate predicateWithFormat:@"studentID == %@", [[SSUser currentUser] studentID]]];
    valuesFetchRequest.sortDescriptors = [NSArray arrayWithObject:[NSSortDescriptor sortDescriptorWithKey:@"rank" ascending:YES selector:nil]];
    
    NSError *errorSV;
    NSArray *values = [self.context executeFetchRequest:valuesFetchRequest error:&errorSV];
    
    if (values.count == 0) {
        return nil;
    } else {
        NSMutableDictionary *params = [NSMutableDictionary dictionaryWithCapacity:28];
        [params setObject:[[SSUser currentUser] token] forKey:@"auth_token"];
        [params setObject:@"1" forKey:@"bulk"];
        
        for(Value *value in values) {
            
            NSDictionary *tempValueDict = [NSDictionary dictionaryWithObjectsAndKeys:
                                           value.companyRank, @"company_rank",
                                           value.rank, @"rank",
                                           value.selectedAsCompanyValue, @"selected_as_company_value",
                                           value.selectedOver, @"selected_over_value",
                                           value.studentID, @"student_id",
                                           value.valueCode, @"value_code",
                                           value.valueID, @"id",
                                           value.valueLiteralUS, @"value_literal_us",
                                           nil];
            
            NSString *tempKey = [NSString stringWithFormat:@"values_%@", value.valueID];
            [params setObject:tempValueDict forKey:tempKey];
        }
        
        
        [[AFNetworkActivityIndicatorManager sharedManager] incrementActivityCount];
        NSString *path = @"values/bulk.json";
        NSURLRequest *request = [client requestWithMethod:@"PUT" path:path parameters:params];
        
        AFJSONRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
            [[AFNetworkActivityIndicatorManager sharedManager] decrementActivityCount];
            [[SSUser currentUser] setActivityNumberAsCompleted:activityTurn andSyncStatus:YES];
        } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
            [[AFNetworkActivityIndicatorManager sharedManager] decrementActivityCount];
            [[SSUser currentUser] setActivityNumberAsCompleted:activityTurn andSyncStatus:NO];
        }];
        
        return operation;
    }
}

-(AFJSONRequestOperation *) pushPurposesDataWithClient:(CENTROAPIClient *) client showHUDInViewController:(UIViewController *) viewController {
    
    NSFetchRequest *purposesFetchRequest = [[NSFetchRequest alloc] init];
    
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Company" inManagedObjectContext:self.context];
    
    [purposesFetchRequest setEntity:entity];
    
    [purposesFetchRequest setPredicate:[NSPredicate predicateWithFormat:@"companyID == %@", [[SSUser currentUser] companyID]]];
    
    purposesFetchRequest.sortDescriptors = [NSArray arrayWithObject:[NSSortDescriptor sortDescriptorWithKey:@"companyID" ascending:YES selector:nil]];
    
    NSError *errorSV;
    NSArray *companyArray = [self.context executeFetchRequest:purposesFetchRequest error:&errorSV];
    if (companyArray.count == 0) {
        return nil;
    } else {
        
        Company *company = [companyArray objectAtIndex:0];
        
        NSMutableDictionary *params = [NSMutableDictionary dictionaryWithCapacity:5];
        [params setObject:[[SSUser currentUser] token] forKey:@"auth_token"];
        [params setObject:@"1" forKey:@"bulk"];
        
        for(Purpose *purpose in company.purposes) {
            
            
            NSDictionary *tempPurposeDict = [NSDictionary dictionaryWithObjectsAndKeys:
                                             purpose.companyID, @"company_id",
                                             purpose.kind, @"kind",
                                             purpose.purposeID, @"id",
                                             purpose.purpose, @"purpose",
                                             nil];
            
            NSString *tempKey = [NSString stringWithFormat:@"purposes_%@", purpose.purposeID];
            [params setObject:tempPurposeDict forKey:tempKey];
        }
        
        [[AFNetworkActivityIndicatorManager sharedManager] incrementActivityCount];
        NSString *path = @"purposes/bulk.json";
        NSURLRequest *request = [client requestWithMethod:@"PUT" path:path parameters:params];
        
        AFJSONRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
            [[AFNetworkActivityIndicatorManager sharedManager] decrementActivityCount];
        } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
            [[AFNetworkActivityIndicatorManager sharedManager] decrementActivityCount];
        }];
        
        return operation;
    }
}

-(AFJSONRequestOperation *) pushVisionDataWithClient:(CENTROAPIClient *) client showHUDInViewController:(UIViewController *) viewController {
    
    NSFetchRequest *visionFetchRequest = [[NSFetchRequest alloc] init];
    
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Vision" inManagedObjectContext:self.context];
    
    [visionFetchRequest setEntity:entity];
    
    [visionFetchRequest setPredicate:[NSPredicate predicateWithFormat:@"companyID == %@", [[SSUser currentUser] companyID]]];
    
    visionFetchRequest.sortDescriptors = [NSArray arrayWithObject:[NSSortDescriptor sortDescriptorWithKey:@"visionID" ascending:YES selector:nil]];
    
    NSError *errorSV;
    NSArray *visionResult = [self.context executeFetchRequest:visionFetchRequest error:&errorSV];
    if (visionResult.count == 0) {
        return nil;
    } else {
        NSMutableDictionary *params = [NSMutableDictionary dictionaryWithCapacity:3];
        [params setObject:[[SSUser currentUser] token] forKey:@"auth_token"];
        
        Vision *vision = [visionResult objectAtIndex:0];
        
        NSDictionary *visionDict = [NSDictionary dictionaryWithObjectsAndKeys:
                                    vision.companyID, @"company_id",
                                    vision.visionID, @"id",
                                    vision.vision, @"vision",
                                    nil];
        
        [params setObject:visionDict forKey:@"vision"];
        
        [[AFNetworkActivityIndicatorManager sharedManager] incrementActivityCount];
        NSString *path = [NSString stringWithFormat:@"visions/%@.json", vision.visionID];
        NSURLRequest *request = [client requestWithMethod:@"PUT" path:path parameters:params];
        
        AFJSONRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
            [[AFNetworkActivityIndicatorManager sharedManager] decrementActivityCount];
            [[SSUser currentUser] setActivityNumberAsCompleted:@"2" andSyncStatus:YES];
        } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
            [[AFNetworkActivityIndicatorManager sharedManager] decrementActivityCount];
            [[SSUser currentUser] setActivityNumberAsCompleted:@"2" andSyncStatus:NO];
        }];
        
        return operation;
    }
}


-(AFJSONRequestOperation *) pushMissionDataWithClient:(CENTROAPIClient *) client showHUDInViewController:(UIViewController *) viewController {
    
    NSFetchRequest *missionFetchRequest = [[NSFetchRequest alloc] init];
    
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Mission" inManagedObjectContext:self.context];
    
    [missionFetchRequest setEntity:entity];
    
    [missionFetchRequest setPredicate:[NSPredicate predicateWithFormat:@"companyID == %@", [[SSUser currentUser] companyID]]];
    
    missionFetchRequest.sortDescriptors = [NSArray arrayWithObject:[NSSortDescriptor sortDescriptorWithKey:@"missionID" ascending:YES selector:nil]];
    
    NSError *errorSV;
    NSArray *misionResult = [self.context executeFetchRequest:missionFetchRequest error:&errorSV];
    if (misionResult.count == 0) {
        return nil;
    } else {
        NSMutableDictionary *params = [NSMutableDictionary dictionaryWithCapacity:3];
        [params setObject:[[SSUser currentUser] token] forKey:@"auth_token"];
        
        Mission *mission = [misionResult objectAtIndex:0];
        
        NSDictionary *missionDict = [NSDictionary dictionaryWithObjectsAndKeys:
                                     mission.companyID, @"company_id",
                                     mission.missionID, @"id",
                                     mission.mission, @"mission",
                                     nil];
        
        [params setObject:missionDict forKey:@"mission"];
        
        [[AFNetworkActivityIndicatorManager sharedManager] incrementActivityCount];
        NSString *path = [NSString stringWithFormat:@"missions/%@.json", mission.missionID];
        NSURLRequest *request = [client requestWithMethod:@"PUT" path:path parameters:params];
        
        AFJSONRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
            [[AFNetworkActivityIndicatorManager sharedManager] decrementActivityCount];
            [[SSUser currentUser] setActivityNumberAsCompleted:@"3" andSyncStatus:YES];
        } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
            [[AFNetworkActivityIndicatorManager sharedManager] decrementActivityCount];
            [[SSUser currentUser] setActivityNumberAsCompleted:@"3" andSyncStatus:NO];
        }];
        
        return operation;
    }
}

-(AFJSONRequestOperation *) pushStudentCostsWithClient:(CENTROAPIClient *) client showHUDInViewController:(UIViewController *) viewController {
    
    NSFetchRequest *studentCostsFetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"StudentCost" inManagedObjectContext:self.context];
    
    [studentCostsFetchRequest setEntity:entity];
    [studentCostsFetchRequest setPredicate:[NSPredicate predicateWithFormat:@"studentID == %@", [[SSUser currentUser] studentID]]];
    studentCostsFetchRequest.sortDescriptors = [NSArray arrayWithObject:[NSSortDescriptor sortDescriptorWithKey:@"studentCostID" ascending:YES selector:nil]];
    
    NSError *errorSV;
    NSArray *studentCosts = [self.context executeFetchRequest:studentCostsFetchRequest error:&errorSV];
    
    if (studentCosts.count == 0) {
        return nil;
    } else {
        NSMutableDictionary *params = [NSMutableDictionary dictionaryWithCapacity:29];
        [params setObject:[[SSUser currentUser] token] forKey:@"auth_token"];
        [params setObject:@"1" forKey:@"bulk"];
        
        for(StudentCost *studentCost in studentCosts) {
            NSDictionary *tempStudentCostDict = [NSDictionary dictionaryWithObjectsAndKeys:
                                                 studentCost.amount, @"amount",
                                                 studentCost.frequency, @"frequency",
                                                 studentCost.isSure, @"is_sure",
                                                 studentCost.studentCostCode, @"cost_code",
                                                 studentCost.studentCostID, @"id",
                                                 studentCost.studentCostLiteralUS, @"cost_literal_us",
                                                 studentCost.studentID, @"student_id",
                                                 studentCost.selectedAsIncurredCost, @"selected_as_incurred_cost",
                                                 nil];
            
            NSString *tempKey = [NSString stringWithFormat:@"costs_%@", studentCost.studentCostID];
            [params setObject:tempStudentCostDict forKey:tempKey];
        }
        
        
        [[AFNetworkActivityIndicatorManager sharedManager] incrementActivityCount];
        NSString *path = @"costs/bulk.json";
        NSURLRequest *request = [client requestWithMethod:@"PUT" path:path parameters:params];
        
        AFJSONRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
            [[AFNetworkActivityIndicatorManager sharedManager] decrementActivityCount];
            [[SSUser currentUser] setActivityNumberAsCompleted:@"6" andSyncStatus:YES];
        } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
            [[AFNetworkActivityIndicatorManager sharedManager] decrementActivityCount];
            [[SSUser currentUser] setActivityNumberAsCompleted:@"6" andSyncStatus:NO];
        }];
        
        return operation;
    }
}

-(AFJSONRequestOperation *) pushStudentIncomesWithClient:(CENTROAPIClient *) client showHUDInViewController:(UIViewController *) viewController {
    
    NSFetchRequest *studentIncomesFetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"StudentIncome" inManagedObjectContext:self.context];
    
    [studentIncomesFetchRequest setEntity:entity];
    [studentIncomesFetchRequest setPredicate:[NSPredicate predicateWithFormat:@"studentID == %@", [[SSUser currentUser] studentID]]];
    studentIncomesFetchRequest.sortDescriptors = [NSArray arrayWithObject:[NSSortDescriptor sortDescriptorWithKey:@"studentIncomeID" ascending:YES selector:nil]];
    
    NSError *errorSV;
    NSArray *studentIncomes = [self.context executeFetchRequest:studentIncomesFetchRequest error:&errorSV];
    
    if (studentIncomes.count == 0) {
        return nil;
    } else {
        NSMutableDictionary *params = [NSMutableDictionary dictionaryWithCapacity:9];
        [params setObject:[[SSUser currentUser] token] forKey:@"auth_token"];
        [params setObject:@"1" forKey:@"bulk"];
        
        for(StudentIncome *studentIncome in studentIncomes) {
            NSDictionary *tempStudentIncomeDict = [NSDictionary dictionaryWithObjectsAndKeys:
                                                   studentIncome.amount, @"amount",
                                                   studentIncome.frequency, @"frequency",
                                                   studentIncome.isSure, @"is_sure",
                                                   studentIncome.studentIncomeCode, @"source_code",
                                                   studentIncome.studentIncomeID, @"id",
                                                   studentIncome.studentIncomeLiteralUS, @"source_literal_us",
                                                   studentIncome.studentID, @"student_id",
                                                   studentIncome.selectedAsSourceOfIncome, @"selected_as_source_income",
                                                   nil];
            
            NSString *tempKey = [NSString stringWithFormat:@"incomes_%@", studentIncome.studentIncomeID];
            [params setObject:tempStudentIncomeDict forKey:tempKey];
        }
        
        
        [[AFNetworkActivityIndicatorManager sharedManager] incrementActivityCount];
        NSString *path = @"incomes/bulk.json";
        NSURLRequest *request = [client requestWithMethod:@"PUT" path:path parameters:params];
        
        AFJSONRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
            [[AFNetworkActivityIndicatorManager sharedManager] decrementActivityCount];
            [[SSUser currentUser] setActivityNumberAsCompleted:@"7" andSyncStatus:YES];
        } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
            [[AFNetworkActivityIndicatorManager sharedManager] decrementActivityCount];
            [[SSUser currentUser] setActivityNumberAsCompleted:@"7" andSyncStatus:NO];
        }];
        
        return operation;
    }
}

-(AFJSONRequestOperation *) pushStudentAssetsWithClient:(CENTROAPIClient *) client showHUDInViewController:(UIViewController *) viewController {
    
    NSFetchRequest *studentAssetsFetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"StudentAsset" inManagedObjectContext:self.context];
    
    [studentAssetsFetchRequest setEntity:entity];
    [studentAssetsFetchRequest setPredicate:[NSPredicate predicateWithFormat:@"studentID == %@", [[SSUser currentUser] studentID]]];
    studentAssetsFetchRequest.sortDescriptors = [NSArray arrayWithObject:[NSSortDescriptor sortDescriptorWithKey:@"studentAssetID" ascending:YES selector:nil]];
    
    NSError *errorSV;
    NSArray *studentAssets = [self.context executeFetchRequest:studentAssetsFetchRequest error:&errorSV];
    
    if (studentAssets.count == 0) {
        return nil;
    } else {
        NSMutableDictionary *params = [NSMutableDictionary dictionaryWithCapacity:9];
        [params setObject:[[SSUser currentUser] token] forKey:@"auth_token"];
        [params setObject:@"1" forKey:@"bulk"];
        
        for(StudentAsset *studentAsset in studentAssets) {
            NSDictionary *tempStudentAssetDict = [NSDictionary dictionaryWithObjectsAndKeys:
                                                  studentAsset.amount, @"amount",
                                                  studentAsset.isSure, @"is_sure",
                                                  studentAsset.studentAssetCode, @"asset_code",
                                                  studentAsset.studentAssetID, @"id",
                                                  studentAsset.studentAssetLiteralUS, @"asset_literal_us",
                                                  studentAsset.studentID, @"student_id",
                                                  studentAsset.selectedAsAsset, @"selected_as_asset",
                                                  nil];
            
            NSString *tempKey = [NSString stringWithFormat:@"assets_%@", studentAsset.studentAssetID];
            [params setObject:tempStudentAssetDict forKey:tempKey];
        }
        
        
        [[AFNetworkActivityIndicatorManager sharedManager] incrementActivityCount];
        NSString *path = @"assets/bulk.json";
        NSURLRequest *request = [client requestWithMethod:@"PUT" path:path parameters:params];
        
        AFJSONRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
            [[AFNetworkActivityIndicatorManager sharedManager] decrementActivityCount];
            [[SSUser currentUser] setActivityNumberAsCompleted:@"9" andSyncStatus:YES];
        } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
            [[AFNetworkActivityIndicatorManager sharedManager] decrementActivityCount];
            [[SSUser currentUser] setActivityNumberAsCompleted:@"9" andSyncStatus:NO];
        }];
        
        return operation;
    }
}

-(AFJSONRequestOperation *) pushStudentDebtsWithClient:(CENTROAPIClient *) client showHUDInViewController:(UIViewController *) viewController {
    
    NSFetchRequest *studentDebtsFetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"StudentDebt" inManagedObjectContext:self.context];
    
    [studentDebtsFetchRequest setEntity:entity];
    [studentDebtsFetchRequest setPredicate:[NSPredicate predicateWithFormat:@"studentID == %@", [[SSUser currentUser] studentID]]];
    studentDebtsFetchRequest.sortDescriptors = [NSArray arrayWithObject:[NSSortDescriptor sortDescriptorWithKey:@"studentDebtID" ascending:YES selector:nil]];
    
    NSError *errorSV;
    NSArray *studentDebts = [self.context executeFetchRequest:studentDebtsFetchRequest error:&errorSV];
    
    if (studentDebts.count == 0) {
        return nil;
    } else {
        NSMutableDictionary *params = [NSMutableDictionary dictionaryWithCapacity:9];
        [params setObject:[[SSUser currentUser] token] forKey:@"auth_token"];
        [params setObject:@"1" forKey:@"bulk"];
        
        for(StudentDebt *studentDebt in studentDebts) {
            NSDictionary *tempStudentDebtDict = [NSDictionary dictionaryWithObjectsAndKeys:
                                                 studentDebt.amount, @"amount",
                                                 studentDebt.isSure, @"is_sure",
                                                 studentDebt.studentDebtCode, @"debt_code",
                                                 studentDebt.studentDebtID, @"id",
                                                 studentDebt.studentDebtLiteralUS, @"debt_literal_us",
                                                 studentDebt.studentID, @"student_id",
                                                 studentDebt.selectedAsDebt, @"selected_as_debt",
                                                 nil];
            
            NSString *tempKey = [NSString stringWithFormat:@"debts_%@", studentDebt.studentDebtID];
            [params setObject:tempStudentDebtDict forKey:tempKey];
        }
        
        
        [[AFNetworkActivityIndicatorManager sharedManager] incrementActivityCount];
        NSString *path = @"debts/bulk.json";
        NSURLRequest *request = [client requestWithMethod:@"PUT" path:path parameters:params];
        
        AFJSONRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
            [[AFNetworkActivityIndicatorManager sharedManager] decrementActivityCount];
            [[SSUser currentUser] setActivityNumberAsCompleted:@"10" andSyncStatus:YES];
        } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
            [[AFNetworkActivityIndicatorManager sharedManager] decrementActivityCount];
            [[SSUser currentUser] setActivityNumberAsCompleted:@"10" andSyncStatus:NO];
        }];
        
        return operation;
    }
}

-(AFJSONRequestOperation *) pushMarketAnalysisWithClient:(CENTROAPIClient *) client showHUDInViewController:(UIViewController *) viewController {
    
    NSFetchRequest *marketAnalysisFetchRequest = [[NSFetchRequest alloc] init];
    
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Industry" inManagedObjectContext:self.context];
    
    [marketAnalysisFetchRequest setEntity:entity];
    
    [marketAnalysisFetchRequest setPredicate:[NSPredicate predicateWithFormat:@"companyID == %@", [[SSUser currentUser] companyID]]];
    
    marketAnalysisFetchRequest.sortDescriptors = [NSArray arrayWithObject:[NSSortDescriptor sortDescriptorWithKey:@"industryID" ascending:YES selector:nil]];
    
    NSError *errorSV;
    NSArray *marketAnalysisResult = [self.context executeFetchRequest:marketAnalysisFetchRequest error:&errorSV];
    if (marketAnalysisResult.count == 0) {
        return nil;
    } else {
        NSMutableDictionary *params = [NSMutableDictionary dictionaryWithCapacity:3];
        [params setObject:[[SSUser currentUser] token] forKey:@"auth_token"];
        
        Industry *industry = [marketAnalysisResult objectAtIndex:0];
        
        NSDictionary *marketAnalysisDict = [NSDictionary dictionaryWithObjectsAndKeys:
                                            industry.growth, @"growth",
                                            industry.growthRate, @"growth_rate",
                                            industry.industryCode, @"industry",
                                            industry.industryID, @"id",
                                            industry.industrySegmentCode, @"industry_segment",
                                            industry.marketAge, @"market_age",
                                            industry.regulations, @"regulations",
                                            industry.volatility, @"volatility",
                                            industry.companyID, @"company_id",
                                            nil];
        
        [params setObject:marketAnalysisDict forKey:@"industry"];
        
        [[AFNetworkActivityIndicatorManager sharedManager] incrementActivityCount];
        NSString *path = [NSString stringWithFormat:@"industries/%@.json", industry.industryID];
        NSURLRequest *request = [client requestWithMethod:@"PUT" path:path parameters:params];
        
        AFJSONRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
            [[AFNetworkActivityIndicatorManager sharedManager] decrementActivityCount];
            [[SSUser currentUser] setActivityNumberAsCompleted:@"12" andSyncStatus:YES];
        } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
            [[AFNetworkActivityIndicatorManager sharedManager] decrementActivityCount];
            [[SSUser currentUser] setActivityNumberAsCompleted:@"12" andSyncStatus:NO];
        }];
        
        return operation;
    }
}

-(AFJSONRequestOperation *) pushCustomerProfileWithClient:(CENTROAPIClient *) client showHUDInViewController:(UIViewController *) viewController {
    
    NSFetchRequest *customerProfileFetchRequest = [[NSFetchRequest alloc] init];
    
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"CustomerProfile" inManagedObjectContext:self.context];
    
    [customerProfileFetchRequest setEntity:entity];
    
    [customerProfileFetchRequest setPredicate:[NSPredicate predicateWithFormat:@"companyID == %@", [[SSUser currentUser] companyID]]];
    
    customerProfileFetchRequest.sortDescriptors = [NSArray arrayWithObject:[NSSortDescriptor sortDescriptorWithKey:@"customerProfileID" ascending:YES selector:nil]];
    
    NSError *errorSV;
    NSArray *customerProfileResult = [self.context executeFetchRequest:customerProfileFetchRequest error:&errorSV];
    if (customerProfileResult.count == 0) {
        return nil;
    } else {
        NSMutableDictionary *params = [NSMutableDictionary dictionaryWithCapacity:3];
        [params setObject:[[SSUser currentUser] token] forKey:@"auth_token"];
        
        CustomerProfile *customerProfile = [customerProfileResult objectAtIndex:0];
        
        NSDictionary *customerProfileDict = [NSDictionary dictionaryWithObjectsAndKeys:
                                             customerProfile.companyID, @"company_id",
                                             customerProfile.customerProfileID, @"id",
                                             customerProfile.fromAge, @"from_age",
                                             customerProfile.fromIncome, @"from_income",
                                             customerProfile.isAgeSure, @"is_age_sure",
                                             customerProfile.isEducationSure, @"is_education_sure",
                                             customerProfile.isGenderSure, @"is_gender_sure",
                                             customerProfile.isIncomeSure, @"is_income_sure",
                                             customerProfile.isInterestSure, @"is_interest_sure",
                                             customerProfile.isLocationSure, @"is_location_sure",
                                             customerProfile.isOccupationSure, @"is_occupation_sure",
                                             customerProfile.locationLongDrive, @"location_long_drive",
                                             customerProfile.locationOnline, @"location_online",
                                             customerProfile.locationOther, @"location_other",
                                             customerProfile.locationShortDrive, @"location_short_drive",
                                             customerProfile.locationWalk, @"location_walk",
                                             customerProfile.menPercentage, @"men_percentage",
                                             customerProfile.toAge, @"to_age",
                                             customerProfile.toIncome, @"to_income",
                                             customerProfile.womenPercentage, @"women_percentage",
                                             nil];
        
        [params setObject:customerProfileDict forKey:@"customer_profile"];
        
        [[AFNetworkActivityIndicatorManager sharedManager] incrementActivityCount];
        NSString *path = [NSString stringWithFormat:@"customer_profiles/%@.json", customerProfile.customerProfileID];
        NSURLRequest *request = [client requestWithMethod:@"PUT" path:path parameters:params];
        
        AFJSONRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
            [[AFNetworkActivityIndicatorManager sharedManager] decrementActivityCount];
        } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
            [[AFNetworkActivityIndicatorManager sharedManager] decrementActivityCount];
        }];
        
        return operation;
    }
}

-(AFJSONRequestOperation *) pushCustomerEducationWithClient:(CENTROAPIClient *) client showHUDInViewController:(UIViewController *) viewController {
    
    NSFetchRequest *customerEducationFetchRequest = [[NSFetchRequest alloc] init];
    
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"CustomerEducation" inManagedObjectContext:self.context];
    
    [customerEducationFetchRequest setEntity:entity];
    
    [customerEducationFetchRequest setPredicate:[NSPredicate predicateWithFormat:@"customerProfileID == %@", [[SSUser currentUser] companyID]]];
    
    customerEducationFetchRequest.sortDescriptors = [NSArray arrayWithObject:[NSSortDescriptor sortDescriptorWithKey:@"educationID" ascending:YES selector:nil]];
    
    NSError *errorSV;
    NSArray *customerEducationResult = [self.context executeFetchRequest:customerEducationFetchRequest error:&errorSV];
    if (customerEducationResult.count == 0) {
        return nil;
    } else {
        NSMutableDictionary *params = [NSMutableDictionary dictionaryWithCapacity:9];
        [params setObject:[[SSUser currentUser] token] forKey:@"auth_token"];
        [params setObject:@"1" forKey:@"bulk"];
        
        for(CustomerEducation *customerEducation in customerEducationResult) {
            NSDictionary *tempCustomerEducationDict = [NSDictionary dictionaryWithObjectsAndKeys:
                                                       customerEducation.educationID, @"id",
                                                       customerEducation.customerProfileID, @"customer_profile_id",
                                                       customerEducation.educationCode, @"education_code",
                                                       customerEducation.educationLiteralUS, @"education_literal_us",
                                                       customerEducation.selectedAsCustomerEducation, @"selected_as_customer_education",
                                                       nil];
            
            NSString *tempKey = [NSString stringWithFormat:@"educations_%@", customerEducation.educationID];
            [params setObject:tempCustomerEducationDict forKey:tempKey];
        }
        
        
        [[AFNetworkActivityIndicatorManager sharedManager] incrementActivityCount];
        NSString *path = @"educations/bulk.json";
        NSURLRequest *request = [client requestWithMethod:@"PUT" path:path parameters:params];
        
        AFJSONRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
            [[AFNetworkActivityIndicatorManager sharedManager] decrementActivityCount];
        } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
            [[AFNetworkActivityIndicatorManager sharedManager] decrementActivityCount];
        }];
        
        return operation;
    }
}

-(AFJSONRequestOperation *) pushCustomerInterestWithClient:(CENTROAPIClient *) client showHUDInViewController:(UIViewController *) viewController {
    
    NSFetchRequest *customerInterestFetchRequest = [[NSFetchRequest alloc] init];
    
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"CustomerInterest" inManagedObjectContext:self.context];
    
    [customerInterestFetchRequest setEntity:entity];
    
    [customerInterestFetchRequest setPredicate:[NSPredicate predicateWithFormat:@"customerProfileID == %@", [[SSUser currentUser] companyID]]];
    
    customerInterestFetchRequest.sortDescriptors = [NSArray arrayWithObject:[NSSortDescriptor sortDescriptorWithKey:@"interestID" ascending:YES selector:nil]];
    
    NSError *errorSV;
    NSArray *customerInterestResult = [self.context executeFetchRequest:customerInterestFetchRequest error:&errorSV];
    if (customerInterestResult.count == 0) {
        return nil;
    } else {
        NSMutableDictionary *params = [NSMutableDictionary dictionaryWithCapacity:20];
        [params setObject:[[SSUser currentUser] token] forKey:@"auth_token"];
        [params setObject:@"1" forKey:@"bulk"];
        
        for(CustomerInterest *customerInterest in customerInterestResult) {
            NSDictionary *tempCustomerInterestDict = [NSDictionary dictionaryWithObjectsAndKeys:
                                                      customerInterest.interestID, @"id",
                                                      customerInterest.customerProfileID, @"customer_profile_id",
                                                      customerInterest.interestCode, @"interest_code",
                                                      customerInterest.interestLiteralUS, @"interest_literal_us",
                                                      customerInterest.selectedAsCustomerInterest, @"selected_as_customer_interest",
                                                      nil];
            
            NSString *tempKey = [NSString stringWithFormat:@"interests_%@", customerInterest.interestID];
            [params setObject:tempCustomerInterestDict forKey:tempKey];
        }
        
        
        [[AFNetworkActivityIndicatorManager sharedManager] incrementActivityCount];
        NSString *path = @"interests/bulk.json";
        NSURLRequest *request = [client requestWithMethod:@"PUT" path:path parameters:params];
        
        AFJSONRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
            [[AFNetworkActivityIndicatorManager sharedManager] decrementActivityCount];
        } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
            [[AFNetworkActivityIndicatorManager sharedManager] decrementActivityCount];
        }];
        
        return operation;
    }
}

-(AFJSONRequestOperation *) pushCustomerOccupationWithClient:(CENTROAPIClient *) client showHUDInViewController:(UIViewController *) viewController {
    
    NSFetchRequest *customerOccupationFetchRequest = [[NSFetchRequest alloc] init];
    
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"CustomerOccupation" inManagedObjectContext:self.context];
    
    [customerOccupationFetchRequest setEntity:entity];
    
    [customerOccupationFetchRequest setPredicate:[NSPredicate predicateWithFormat:@"customerProfileID == %@", [[SSUser currentUser] companyID]]];
    
    customerOccupationFetchRequest.sortDescriptors = [NSArray arrayWithObject:[NSSortDescriptor sortDescriptorWithKey:@"occupationID" ascending:YES selector:nil]];
    
    NSError *errorSV;
    NSArray *customerOccupationResult = [self.context executeFetchRequest:customerOccupationFetchRequest error:&errorSV];
    if (customerOccupationResult.count == 0) {
        return nil;
    } else {
        NSMutableDictionary *params = [NSMutableDictionary dictionaryWithCapacity:20];
        [params setObject:[[SSUser currentUser] token] forKey:@"auth_token"];
        [params setObject:@"1" forKey:@"bulk"];
        
        for(CustomerOccupation *customerOccupation in customerOccupationResult) {
            NSDictionary *tempCustomerOccupationDict = [NSDictionary dictionaryWithObjectsAndKeys:
                                                        customerOccupation.occupationID, @"id",
                                                        customerOccupation.customerProfileID, @"customer_profile_id",
                                                        customerOccupation.occupationCode, @"occupation_code",
                                                        customerOccupation.occupationLiteralUS, @"occupation_literal_us",
                                                        customerOccupation.selectedAsCustomerOccupation, @"selected_as_customer_occupation",
                                                        nil];
            
            NSString *tempKey = [NSString stringWithFormat:@"occupations_%@", customerOccupation.occupationID];
            [params setObject:tempCustomerOccupationDict forKey:tempKey];
        }
        
        
        [[AFNetworkActivityIndicatorManager sharedManager] incrementActivityCount];
        NSString *path = @"occupations/bulk.json";
        NSURLRequest *request = [client requestWithMethod:@"PUT" path:path parameters:params];
        
        AFJSONRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
            [[AFNetworkActivityIndicatorManager sharedManager] decrementActivityCount];
        } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
            [[AFNetworkActivityIndicatorManager sharedManager] decrementActivityCount];
        }];
        
        return operation;
    }
}

-(AFJSONRequestOperation *) pushCustomerProfileSampleWithClient:(CENTROAPIClient *) client showHUDInViewController:(UIViewController *) viewController {
    
    NSFetchRequest *customerProfileSampleFetchRequest = [[NSFetchRequest alloc] init];
    
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"CustomerProfileSample" inManagedObjectContext:self.context];
    
    [customerProfileSampleFetchRequest setEntity:entity];
    
    [customerProfileSampleFetchRequest setPredicate:[NSPredicate predicateWithFormat:@"companyID == %@", [[SSUser currentUser] companyID]]];
    
    customerProfileSampleFetchRequest.sortDescriptors = [NSArray arrayWithObject:[NSSortDescriptor sortDescriptorWithKey:@"customerProfileSampleID" ascending:YES selector:nil]];
    
    NSError *errorSV;
    NSArray *customerProfileResult = [self.context executeFetchRequest:customerProfileSampleFetchRequest error:&errorSV];
    if (customerProfileResult.count == 0) {
        return nil;
    } else {
        NSMutableDictionary *params = [NSMutableDictionary dictionaryWithCapacity:6];
        [params setObject:[[SSUser currentUser] token] forKey:@"auth_token"];
        [params setObject:@"1" forKey:@"bulk"];
        
        for(CustomerProfileSample *customerProfileSample in customerProfileResult) {
            
            NSMutableDictionary *customerProfileDict = [[NSMutableDictionary alloc] initWithCapacity:9];
            
            if (customerProfileSample.age == nil) {
                [customerProfileDict setObject:[NSNull null] forKey:@"age"];
            } else {
                [customerProfileDict setObject:customerProfileSample.age forKey:@"age"];
            }
            
            if (customerProfileSample.educationLevel == nil) {
                [customerProfileDict setObject:[NSNull null] forKey:@"education_level"];
            } else {
                [customerProfileDict setObject:customerProfileSample.educationLevel forKey:@"education_level"];
            }
            
            if (customerProfileSample.income == nil) {
                [customerProfileDict setObject:[NSNull null] forKey:@"income"];
            } else {
                [customerProfileDict setObject:customerProfileSample.income forKey:@"income"];
            }
            
            if (customerProfileSample.customerProfileSampleID == nil) {
                [customerProfileDict setObject:[NSNull null] forKey:@"id"];
            } else {
                [customerProfileDict setObject:customerProfileSample.customerProfileSampleID forKey:@"id"];
            }
            
            if (customerProfileSample.interest == nil) {
                [customerProfileDict setObject:[NSNull null] forKey:@"interest"];
            } else {
                [customerProfileDict setObject:customerProfileSample.interest forKey:@"interest"];
            }
            
            if (customerProfileSample.location == nil) {
                [customerProfileDict setObject:[NSNull null] forKey:@"location"];
            } else {
                [customerProfileDict setObject:customerProfileSample.location forKey:@"location"];
            }
            
            if (customerProfileSample.name == nil) {
                [customerProfileDict setObject:[NSNull null] forKey:@"name"];
            } else {
                [customerProfileDict setObject:customerProfileSample.name forKey:@"name"];
            }
            
            if (customerProfileSample.companyID == nil) {
                [customerProfileDict setObject:[NSNull null] forKey:@"company_id"];
            } else {
                [customerProfileDict setObject:customerProfileSample.companyID forKey:@"company_id"];
            }
            
            if (customerProfileSample.profession == nil) {
                [customerProfileDict setObject:[NSNull null] forKey:@"profession"];
            } else {
                [customerProfileDict setObject:customerProfileSample.profession forKey:@"profession"];
            }
            
            NSString *tempKey = [NSString stringWithFormat:@"customer_profile_samples_%@", customerProfileSample.customerProfileSampleID];
            [params setObject:customerProfileDict forKey:tempKey];
        }
        
        [[AFNetworkActivityIndicatorManager sharedManager] incrementActivityCount];
        NSString *path = [NSString stringWithFormat:@"customer_profile_samples/bulk.json"];
        NSURLRequest *request = [client requestWithMethod:@"PUT" path:path parameters:params];
        
        AFJSONRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
            [[AFNetworkActivityIndicatorManager sharedManager] decrementActivityCount];
            [[SSUser currentUser] setActivityNumberAsCompleted:@"13" andSyncStatus:YES];
        } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
            [[AFNetworkActivityIndicatorManager sharedManager] decrementActivityCount];
            [[SSUser currentUser] setActivityNumberAsCompleted:@"13" andSyncStatus:NO];
        }];
        
        return operation;
    }
}

-(AFJSONRequestOperation *) pushNearbyCompetitorsWithClient:(CENTROAPIClient *) client showHUDInViewController:(UIViewController *) viewController {
    
    NSFetchRequest *nearbyCompetitorFetchRequest = [[NSFetchRequest alloc] init];
    
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"NearbyCompetitor" inManagedObjectContext:self.context];
    
    [nearbyCompetitorFetchRequest setEntity:entity];
    
    [nearbyCompetitorFetchRequest setPredicate:[NSPredicate predicateWithFormat:@"companyID == %@", [[SSUser currentUser] companyID]]];
    
    nearbyCompetitorFetchRequest.sortDescriptors = [NSArray arrayWithObject:[NSSortDescriptor sortDescriptorWithKey:@"nearbyCompetitorID" ascending:YES selector:nil]];
    
    NSError *errorSV;
    NSArray *nearbyCompetitorResult = [self.context executeFetchRequest:nearbyCompetitorFetchRequest error:&errorSV];
    if (nearbyCompetitorResult.count == 0) {
        return nil;
    } else {
        NSMutableDictionary *params = [NSMutableDictionary dictionaryWithCapacity:3];
        [params setObject:[[SSUser currentUser] token] forKey:@"auth_token"];
        
        NearbyCompetitor *nearbyCompetitor = [nearbyCompetitorResult objectAtIndex:0];
        
        NSDictionary *nearbyCompetitorDict = [NSDictionary dictionaryWithObjectsAndKeys:
                                              nearbyCompetitor.companyID, @"company_id",
                                              nearbyCompetitor.nearbyCompetitorID, @"id",
                                              nearbyCompetitor.longDriveCompetitors, @"long_drive",
                                              nearbyCompetitor.onlineCompetitors, @"online",
                                              nearbyCompetitor.shortDriveCompetitors, @"short_drive",
                                              nearbyCompetitor.walkingDistanceCompetitors, @"walking_distance",
                                              nil];
        
        [params setObject:nearbyCompetitorDict forKey:@"near_by_competitor"];
        
        [[AFNetworkActivityIndicatorManager sharedManager] incrementActivityCount];
        NSString *path = [NSString stringWithFormat:@"near_by_competitors/%@.json", nearbyCompetitor.nearbyCompetitorID];
        NSURLRequest *request = [client requestWithMethod:@"PUT" path:path parameters:params];
        
        AFJSONRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
            [[AFNetworkActivityIndicatorManager sharedManager] decrementActivityCount];
        } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
            [[AFNetworkActivityIndicatorManager sharedManager] decrementActivityCount];
        }];
        
        return operation;
    }
}

-(AFJSONRequestOperation *) pushCompetitorProfilesWithClient:(CENTROAPIClient *) client showHUDInViewController:(UIViewController *) viewController {
    
    NSFetchRequest *competitorProfileFetchRequest = [[NSFetchRequest alloc] init];
    
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"CompetitorProfile" inManagedObjectContext:self.context];
    
    [competitorProfileFetchRequest setEntity:entity];
    
    [competitorProfileFetchRequest setPredicate:[NSPredicate predicateWithFormat:@"companyID == %@", [[SSUser currentUser] companyID]]];
    
    competitorProfileFetchRequest.sortDescriptors = [NSArray arrayWithObject:[NSSortDescriptor sortDescriptorWithKey:@"competitorProfileID" ascending:YES selector:nil]];
    
    NSError *errorSV;
    NSArray *competitorProfileResult = [self.context executeFetchRequest:competitorProfileFetchRequest error:&errorSV];
    if (competitorProfileResult.count == 0) {
        return nil;
    } else {
        NSMutableDictionary *params = [NSMutableDictionary dictionaryWithCapacity:11];
        [params setObject:[[SSUser currentUser] token] forKey:@"auth_token"];
        [params setObject:@"1" forKey:@"bulk"];
        
        for(CompetitorProfile *competitorProfile in competitorProfileResult) {
            
            NSDictionary *competitorProfileDict = [NSDictionary dictionaryWithObjectsAndKeys:
                                                   competitorProfile.companyID, @"company_id",
                                                   competitorProfile.competitorProfileID, @"id",
                                                   competitorProfile.customerServiceRank, @"customer_service_rank",
                                                   competitorProfile.frequencySellTargetAge, @"frequency_sell_target_age",
                                                   competitorProfile.frequencySellTargetEducation, @"frequency_sell_target_education",
                                                   competitorProfile.frequencySellTargetOccupation, @"frequency_sell_target_occupation",
                                                   competitorProfile.frequencySellTargetGenre, @"frequency_sell_target_genre",
                                                   competitorProfile.frequencySellTargetIncome, @"frequency_sell_target_income",
                                                   competitorProfile.frequencySellTargetInterest, @"frequency_sell_target_interest",
                                                   competitorProfile.locationRank, @"location_rank",
                                                   competitorProfile.name, @"name",
                                                   competitorProfile.priceRank, @"price_rank",
                                                   competitorProfile.qualityRank, @"quality_rank",
                                                   competitorProfile.sellLongDrive, @"sell_long_drive",
                                                   competitorProfile.sellOnline, @"sell_online",
                                                   competitorProfile.sellShortDrive, @"sell_short_drive",
                                                   competitorProfile.sellWalkingDistance, @"sell_walking_distance",
                                                   competitorProfile.speedRank, @"speed_rank",
                                                   nil];
            
            NSString *tempKey = [NSString stringWithFormat:@"competitor_profiles_%@", competitorProfile.competitorProfileID];
            [params setObject:competitorProfileDict forKey:tempKey];
        }
        
        [[AFNetworkActivityIndicatorManager sharedManager] incrementActivityCount];
        NSString *path = [NSString stringWithFormat:@"competitor_profiles/bulk.json"];
        NSURLRequest *request = [client requestWithMethod:@"PUT" path:path parameters:params];
        
        AFJSONRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
            [[AFNetworkActivityIndicatorManager sharedManager] decrementActivityCount];
            [[SSUser currentUser] setActivityNumberAsCompleted:@"14" andSyncStatus:YES];
        } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
            [[AFNetworkActivityIndicatorManager sharedManager] decrementActivityCount];
            [[SSUser currentUser] setActivityNumberAsCompleted:@"14" andSyncStatus:NO];
        }];
        
        return operation;
    }
}

-(AFJSONRequestOperation *) pushCompanyWithClient:(CENTROAPIClient *) client showHUDInViewController:(UIViewController *) viewController {
    
    NSFetchRequest *companyFetchRequest = [[NSFetchRequest alloc] init];
    
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Company" inManagedObjectContext:self.context];
    
    [companyFetchRequest setEntity:entity];
    
    [companyFetchRequest setPredicate:[NSPredicate predicateWithFormat:@"companyID == %@", [[SSUser currentUser] companyID]]];
    
    companyFetchRequest.sortDescriptors = [NSArray arrayWithObject:[NSSortDescriptor sortDescriptorWithKey:@"companyID" ascending:YES selector:nil]];
    
    NSError *errorSV;
    NSArray *companyResult = [self.context executeFetchRequest:companyFetchRequest error:&errorSV];
    if (companyResult.count == 0) {
        return nil;
    } else {
        NSMutableDictionary *params = [NSMutableDictionary dictionaryWithCapacity:3];
        [params setObject:[[SSUser currentUser] token] forKey:@"auth_token"];
        
        Company *company = [companyResult objectAtIndex:0];
        
        NSDictionary *companyDict = [NSDictionary dictionaryWithObjectsAndKeys:
                                     company.companyID, @"id",
                                     company.name, @"name",
                                     company.studentID, @"student_id",
                                     company.productsQty, @"products_qty",
                                     company.productsAndServicesEstimate, @"products_services",
                                     company.servicesQty, @"services_qty",
                                     company.isProductsSure, @"is_products_sure",
                                     company.isServicesSure, @"is_services_sure",
                                     company.otherProfitAmount, @"other_profit_amount",
                                     company.otherProfitFrequency, @"other_profit_frequency",
                                     company.isOtherProfitAmountSure, @"is_other_profit_amount_sure",
                                     company.totalEmployeeBenefitsCosts, @"total_employee_benefits_costs",
                                     company.frequencyEmployeeBenefits, @"frequency_employee_benefits",
                                     company.numberOfEmployees, @"number_employees",
                                     nil];
        
        [params setObject:companyDict forKey:@"company"];
        
        [[AFNetworkActivityIndicatorManager sharedManager] incrementActivityCount];
        NSString *path = [NSString stringWithFormat:@"companies/%@.json", company.companyID];
        NSURLRequest *request = [client requestWithMethod:@"PUT" path:path parameters:params];
        
        AFJSONRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
            [[AFNetworkActivityIndicatorManager sharedManager] decrementActivityCount];
        } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
            [[AFNetworkActivityIndicatorManager sharedManager] decrementActivityCount];
        }];
        
        return operation;
    }
}

-(AFJSONRequestOperation *) pushCategoriesWithClient:(CENTROAPIClient *) client showHUDInViewController:(UIViewController *) viewController {
    
    NSFetchRequest *categoriesFetchRequest = [[NSFetchRequest alloc] init];
    
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Category" inManagedObjectContext:self.context];
    
    [categoriesFetchRequest setEntity:entity];
    
    [categoriesFetchRequest setPredicate:[NSPredicate predicateWithFormat:@"companyID == %@", [[SSUser currentUser] companyID]]];
    
    categoriesFetchRequest.sortDescriptors = [NSArray arrayWithObject:[NSSortDescriptor sortDescriptorWithKey:@"categoryID" ascending:YES selector:nil]];
    
    NSError *error;
    NSArray *categoryResult = [self.context executeFetchRequest:categoriesFetchRequest error:&error];
    if (categoryResult.count == 0) {
        return nil;
    } else {
        NSMutableDictionary *params = [NSMutableDictionary dictionaryWithCapacity:6];
        [params setObject:[[SSUser currentUser] token] forKey:@"auth_token"];
        [params setObject:@"1" forKey:@"bulk"];
        
        for(Category *category in categoryResult) {
            
            NSDictionary *categoryDict = [NSDictionary dictionaryWithObjectsAndKeys:
                                          category.companyID, @"company_id",
                                          category.name, @"name",
                                          category.selectedAsCategory, @"selected_as_category",
                                          category.categoryID, @"id",
                                          nil];
            
            NSString *tempKey = [NSString stringWithFormat:@"categories_%@", category.categoryID];
            [params setObject:categoryDict forKey:tempKey];
        }
        
        [[AFNetworkActivityIndicatorManager sharedManager] incrementActivityCount];
        NSString *path = [NSString stringWithFormat:@"categories/bulk.json"];
        NSURLRequest *request = [client requestWithMethod:@"PUT" path:path parameters:params];
        
        AFJSONRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
            [[AFNetworkActivityIndicatorManager sharedManager] decrementActivityCount];
        } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
            [[AFNetworkActivityIndicatorManager sharedManager] decrementActivityCount];
        }];
        
        return operation;
    }
}

-(AFJSONRequestOperation *) pushItemWithClient:(CENTROAPIClient *) client showHUDInViewController:(UIViewController *) viewController {
    
    NSFetchRequest *productFetchRequest = [[NSFetchRequest alloc] init];
    
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Product" inManagedObjectContext:self.context];
    
    [productFetchRequest setEntity:entity];
    
    [productFetchRequest setPredicate:[NSPredicate predicateWithFormat:@"companyID == %@", [[SSUser currentUser] companyID]]];
    
    productFetchRequest.sortDescriptors = [NSArray arrayWithObject:[NSSortDescriptor sortDescriptorWithKey:@"productID" ascending:YES selector:nil]];
    
    NSError *error;
    NSArray *productResult = [self.context executeFetchRequest:productFetchRequest error:&error];
    if (productResult.count == 0) {
        return nil;
    } else {
        NSMutableDictionary *params = [NSMutableDictionary dictionaryWithCapacity:11];
        [params setObject:[[SSUser currentUser] token] forKey:@"auth_token"];
        [params setObject:@"1" forKey:@"bulk"];
        
        for(Product *product in productResult) {
            
            NSDictionary *productDict = [NSDictionary dictionaryWithObjectsAndKeys:
                                         product.categoryID, @"category_id",
                                         product.isPriceSure, @"is_price_sure",
                                         product.name, @"item",
                                         product.price, @"price",
                                         product.selectedAsItem, @"selected_as_item",
                                         product.selectedAsProfitableItem, @"selected_as_profitable_item",
                                         product.profitAmount, @"profit_amount",
                                         product.profitFrequency, @"profit_frequency",
                                         product.isProfitAmountSure, @"is_profit_amount_sure",
                                         product.companyID, @"company_id",
                                         product.productID, @"id",
                                         nil];
            
            NSString *tempKey = [NSString stringWithFormat:@"items_%@", product.productID];
            [params setObject:productDict forKey:tempKey];
        }
        
        [[AFNetworkActivityIndicatorManager sharedManager] incrementActivityCount];
        NSString *path = [NSString stringWithFormat:@"items/bulk.json"];
        NSURLRequest *request = [client requestWithMethod:@"PUT" path:path parameters:params];
        
        AFJSONRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
            [[AFNetworkActivityIndicatorManager sharedManager] decrementActivityCount];
            [[SSUser currentUser] setActivityNumberAsCompleted:@"15" andSyncStatus:YES];
        } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
            [[AFNetworkActivityIndicatorManager sharedManager] decrementActivityCount];
            [[SSUser currentUser] setActivityNumberAsCompleted:@"15" andSyncStatus:NO];
        }];
        
        return operation;
    }
}

-(AFJSONRequestOperation *) pushItemPriceWithClient:(CENTROAPIClient *) client showHUDInViewController:(UIViewController *) viewController andTurn:(NSString *) turn {
    
    NSFetchRequest *productFetchRequest = [[NSFetchRequest alloc] init];
    
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Product" inManagedObjectContext:self.context];
    
    [productFetchRequest setEntity:entity];
    
    [productFetchRequest setPredicate:[NSPredicate predicateWithFormat:@"companyID == %@", [[SSUser currentUser] companyID]]];
    
    productFetchRequest.sortDescriptors = [NSArray arrayWithObject:[NSSortDescriptor sortDescriptorWithKey:@"productID" ascending:YES selector:nil]];
    
    NSError *error;
    NSArray *productResult = [self.context executeFetchRequest:productFetchRequest error:&error];
    if (productResult.count == 0) {
        return nil;
    } else {
        NSMutableDictionary *params = [NSMutableDictionary dictionaryWithCapacity:11];
        [params setObject:[[SSUser currentUser] token] forKey:@"auth_token"];
        [params setObject:@"1" forKey:@"bulk"];
        
        for(Product *product in productResult) {
            
            NSDictionary *productDict = [NSDictionary dictionaryWithObjectsAndKeys:
                                         product.categoryID, @"category_id",
                                         product.isPriceSure, @"is_price_sure",
                                         product.name, @"item",
                                         product.price, @"price",
                                         product.selectedAsItem, @"selected_as_item",
                                         product.selectedAsProfitableItem, @"selected_as_profitable_item",
                                         product.profitAmount, @"profit_amount",
                                         product.profitFrequency, @"profit_frequency",
                                         product.isProfitAmountSure, @"is_profit_amount_sure",
                                         product.companyID, @"company_id",
                                         product.productID, @"id",
                                         nil];
            
            NSString *tempKey = [NSString stringWithFormat:@"items_%@", product.productID];
            [params setObject:productDict forKey:tempKey];
        }
        
        [[AFNetworkActivityIndicatorManager sharedManager] incrementActivityCount];
        NSString *path = [NSString stringWithFormat:@"items/bulk.json"];
        NSURLRequest *request = [client requestWithMethod:@"PUT" path:path parameters:params];
        
        AFJSONRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
            [[AFNetworkActivityIndicatorManager sharedManager] decrementActivityCount];
            [[SSUser currentUser] setActivityNumberAsCompleted:turn andSyncStatus:YES];
        } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
            [[AFNetworkActivityIndicatorManager sharedManager] decrementActivityCount];
            [[SSUser currentUser] setActivityNumberAsCompleted:turn andSyncStatus:NO];
        }];
        
        return operation;
    }
}

-(AFJSONRequestOperation *) pushCustomerPrioritiesWithClient:(CENTROAPIClient *) client showHUDInViewController:(UIViewController *) viewController {
    
    NSFetchRequest *customerPriorityFetchRequest = [[NSFetchRequest alloc] init];
    
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"CustomerPriority" inManagedObjectContext:self.context];
    
    [customerPriorityFetchRequest setEntity:entity];
    
    [customerPriorityFetchRequest setPredicate:[NSPredicate predicateWithFormat:@"customerProfileID == %@", [[SSUser currentUser] companyID]]];
    
    customerPriorityFetchRequest.sortDescriptors = [NSArray arrayWithObject:[NSSortDescriptor sortDescriptorWithKey:@"priorityID" ascending:YES selector:nil]];
    
    NSError *errorSV;
    NSArray *customerPriorityResult = [self.context executeFetchRequest:customerPriorityFetchRequest error:&errorSV];
    if (customerPriorityResult.count == 0) {
        return nil;
    } else {
        NSMutableDictionary *params = [NSMutableDictionary dictionaryWithCapacity:8];
        [params setObject:[[SSUser currentUser] token] forKey:@"auth_token"];
        [params setObject:@"1" forKey:@"bulk"];
        
        for(CustomerPriority *customerPriority in customerPriorityResult) {
            NSDictionary *tempCustomerPriorityDict = [NSDictionary dictionaryWithObjectsAndKeys:
                                                      customerPriority.customerProfileID, @"customer_profile_id",
                                                      customerPriority.priorityID, @"id",
                                                      customerPriority.priorityCode, @"priority_code",
                                                      customerPriority.priorityLiteralUS, @"priority_literal_us",
                                                      customerPriority.rank, @"rank",
                                                      nil];
            
            NSString *tempKey = [NSString stringWithFormat:@"priorities_%@", customerPriority.priorityID];
            [params setObject:tempCustomerPriorityDict forKey:tempKey];
        }
        
        
        [[AFNetworkActivityIndicatorManager sharedManager] incrementActivityCount];
        NSString *path = @"priorities/bulk.json";
        NSURLRequest *request = [client requestWithMethod:@"PUT" path:path parameters:params];
        
        AFJSONRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
            [[AFNetworkActivityIndicatorManager sharedManager] decrementActivityCount];
            [[SSUser currentUser] setActivityNumberAsCompleted:@"17" andSyncStatus:YES];
        } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
            [[AFNetworkActivityIndicatorManager sharedManager] decrementActivityCount];
            [[SSUser currentUser] setActivityNumberAsCompleted:@"17" andSyncStatus:NO];
        }];
        
        return operation;
    }
}

-(AFJSONRequestOperation *) pushValuePropositionsWithClient:(CENTROAPIClient *) client showHUDInViewController:(UIViewController *) viewController {
    
    NSFetchRequest *valuePropositionsFetchRequest = [[NSFetchRequest alloc] init];
    
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"ValueProposition" inManagedObjectContext:self.context];
    
    [valuePropositionsFetchRequest setEntity:entity];
    
    [valuePropositionsFetchRequest setPredicate:[NSPredicate predicateWithFormat:@"companyID == %@", [[SSUser currentUser] companyID]]];
    
    valuePropositionsFetchRequest.sortDescriptors = [NSArray arrayWithObject:[NSSortDescriptor sortDescriptorWithKey:@"valuePropositionID" ascending:YES selector:nil]];
    
    NSError *errorSV;
    NSArray *valuePropositionResult = [self.context executeFetchRequest:valuePropositionsFetchRequest error:&errorSV];
    if (valuePropositionResult.count == 0) {
        return nil;
    } else {
        NSMutableDictionary *params = [NSMutableDictionary dictionaryWithCapacity:12];
        [params setObject:[[SSUser currentUser] token] forKey:@"auth_token"];
        [params setObject:@"1" forKey:@"bulk"];
        
        for(ValueProposition *valueProposition in valuePropositionResult) {
            NSDictionary *tempCustomerPriorityDict = [NSDictionary dictionaryWithObjectsAndKeys:
                                                      valueProposition.companyID, @"company_id",
                                                      valueProposition.valuePropositionID, @"id",
                                                      valueProposition.name, @"name",
                                                      valueProposition.isCompetitor, @"is_competitor",
                                                      valueProposition.competitorProfileID, @"competitor_profile_id",
                                                      valueProposition.priceRank, @"price_rank",
                                                      valueProposition.qualityRank, @"quality_rank",
                                                      valueProposition.customerServiceRank, @"customer_service_rank",
                                                      valueProposition.speedRank, @"speed_rank",
                                                      valueProposition.locationRank, @"location_rank",
                                                      nil];
            
            NSString *tempKey = [NSString stringWithFormat:@"value_propositions_%@", valueProposition.valuePropositionID];
            [params setObject:tempCustomerPriorityDict forKey:tempKey];
        }
        
        
        [[AFNetworkActivityIndicatorManager sharedManager] incrementActivityCount];
        NSString *path = @"value_propositions/bulk.json";
        NSURLRequest *request = [client requestWithMethod:@"PUT" path:path parameters:params];
        
        AFJSONRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
            [[AFNetworkActivityIndicatorManager sharedManager] decrementActivityCount];
            [[SSUser currentUser] setActivityNumberAsCompleted:@"18" andSyncStatus:YES];
        } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
            [[AFNetworkActivityIndicatorManager sharedManager] decrementActivityCount];
            [[SSUser currentUser] setActivityNumberAsCompleted:@"18" andSyncStatus:NO];
        }];
        
        return operation;
    }
}

-(AFJSONRequestOperation *) pushOperatingHoursWithClient:(CENTROAPIClient *) client showHUDInViewController:(UIViewController *) viewController {
    
    NSFetchRequest *operatingHoursFetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"OperatingHour" inManagedObjectContext:self.context];
    
    [operatingHoursFetchRequest setEntity:entity];
    [operatingHoursFetchRequest setPredicate:[NSPredicate predicateWithFormat:@"companyID == %@", [[SSUser currentUser] companyID]]];
    operatingHoursFetchRequest.sortDescriptors = [NSArray arrayWithObject:[NSSortDescriptor sortDescriptorWithKey:@"workingHourID" ascending:YES selector:nil]];
    
    NSError *error;
    NSArray *operatingHours = [self.context executeFetchRequest:operatingHoursFetchRequest error:&error];
    
    if (operatingHours.count == 0) {
        return nil;
    } else {
        NSMutableDictionary *params = [NSMutableDictionary dictionaryWithCapacity:3];
        [params setObject:[[SSUser currentUser] token] forKey:@"auth_token"];
        [params setObject:@"1" forKey:@"bulk"];
        
        for(OperatingHour *operatingHour in operatingHours) {
            NSMutableDictionary *operatingHoursDict = [[NSMutableDictionary alloc] initWithCapacity:7];
            
            NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
            [dateFormatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss"];
            NSString *to = [dateFormatter stringFromDate:operatingHour.to];
            NSString *from = [dateFormatter stringFromDate:operatingHour.from];
            
            if (operatingHour.companyID == nil) {
                [operatingHoursDict setObject:[NSNull null] forKey:@"company_id"];
            } else {
                [operatingHoursDict setObject:operatingHour.companyID forKey:@"company_id"];
            }
            
            if (operatingHour.dayOfWeekID == nil) {
                [operatingHoursDict setObject:[NSNull null] forKey:@"day_of_week_id"];
            } else {
                [operatingHoursDict setObject:operatingHour.dayOfWeekID forKey:@"day_of_week_id"];
            }
            
            if (operatingHour.dayOfWeekUS == nil) {
                [operatingHoursDict setObject:[NSNull null] forKey:@"day_of_week_us"];
            } else {
                [operatingHoursDict setObject:operatingHour.dayOfWeekUS forKey:@"day_of_week_us"];
            }
            
            if (operatingHour.from == nil) {
                [operatingHoursDict setObject:[NSNull null] forKey:@"from"];
            } else {
                [operatingHoursDict setObject:from forKey:@"from"];
            }
            
            if (operatingHour.workingHourID == nil) {
                [operatingHoursDict setObject:[NSNull null] forKey:@"id"];
            } else {
                [operatingHoursDict setObject:operatingHour.workingHourID forKey:@"id"];
            }
            
            if (operatingHour.selectedAsWorkingDay == nil) {
                [operatingHoursDict setObject:[NSNull null] forKey:@"selected_as_working_day"];
            } else {
                [operatingHoursDict setObject:operatingHour.selectedAsWorkingDay forKey:@"selected_as_working_day"];
            }
            
            if (operatingHour.to == nil) {
                [operatingHoursDict setObject:[NSNull null] forKey:@"to"];
            } else {
                [operatingHoursDict setObject:to forKey:@"to"];
            }
            
            NSString *tempKey = [NSString stringWithFormat:@"working_hours_%@", operatingHour.workingHourID];
            [params setObject:operatingHoursDict forKey:tempKey];
        }
        
        
        [[AFNetworkActivityIndicatorManager sharedManager] incrementActivityCount];
        NSString *path = @"working_hours/bulk.json";
        NSURLRequest *request = [client requestWithMethod:@"PUT" path:path parameters:params];
        
        AFJSONRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
            [[AFNetworkActivityIndicatorManager sharedManager] decrementActivityCount];
            [[SSUser currentUser] setActivityNumberAsCompleted:@"20" andSyncStatus:YES];
        } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
            [[AFNetworkActivityIndicatorManager sharedManager] decrementActivityCount];
            [[SSUser currentUser] setActivityNumberAsCompleted:@"20" andSyncStatus:NO];
        }];
        
        return operation;
    }
}

-(AFJSONRequestOperation *) pushEmployeesWithClient:(CENTROAPIClient *) client showHUDInViewController:(UIViewController *) viewController andTurn:(NSString *) turn {
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Employee" inManagedObjectContext:self.context];
    
    [fetchRequest setEntity:entity];
    [fetchRequest setPredicate:[NSPredicate predicateWithFormat:@"companyID == %@", [[SSUser currentUser] companyID]]];
    fetchRequest.sortDescriptors = [NSArray arrayWithObject:[NSSortDescriptor sortDescriptorWithKey:@"employeeID" ascending:YES selector:nil]];
    
    NSError *error;
    NSArray *results = [self.context executeFetchRequest:fetchRequest error:&error];
    
    if (results.count == 0) {
        return nil;
    } else {
        NSMutableDictionary *params = [NSMutableDictionary dictionaryWithCapacity:3];
        [params setObject:[[SSUser currentUser] token] forKey:@"auth_token"];
        [params setObject:@"1" forKey:@"bulk"];
        
        for(Employee *result in results) {
            NSDictionary *tempDict = [NSDictionary dictionaryWithObjectsAndKeys:
                                      result.companyID, @"company_id",
                                      result.employeeID, @"id",
                                      result.earning, @"earning",
                                      result.earningFrequency, @"earning_frequency",
                                      result.manager, @"manager",
                                      result.name, @"name",
                                      result.professionalExperience, @"professional_experience",
                                      result.weeksWork, @"weeks_work",
                                      result.selectedAsEmployee, @"selected_as_employee",
                                      result.myself, @"myself",
                                      nil];
            
            NSString *tempKey = [NSString stringWithFormat:@"employees_%@", result.employeeID];
            [params setObject:tempDict forKey:tempKey];
        }
        
        
        [[AFNetworkActivityIndicatorManager sharedManager] incrementActivityCount];
        NSString *path = @"employees/bulk.json";
        NSURLRequest *request = [client requestWithMethod:@"PUT" path:path parameters:params];
        
        AFJSONRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
            [[AFNetworkActivityIndicatorManager sharedManager] decrementActivityCount];
            if(![turn isEqualToString:@""]) {
                [[SSUser currentUser] setActivityNumberAsCompleted:turn andSyncStatus:YES];
            }
        } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
            [[AFNetworkActivityIndicatorManager sharedManager] decrementActivityCount];
            if(![turn isEqualToString:@""]) {
                [[SSUser currentUser] setActivityNumberAsCompleted:turn andSyncStatus:NO];
            }
        }];
        
        return operation;
    }
}

-(AFJSONRequestOperation *) pushEmployeeEducationsWithClient:(CENTROAPIClient *) client showHUDInViewController:(UIViewController *) viewController {
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"EmployeeEducation" inManagedObjectContext:self.context];
    
    [fetchRequest setEntity:entity];
    [fetchRequest setPredicate:[NSPredicate predicateWithFormat:@"companyID == %@", [[SSUser currentUser] companyID]]];
    fetchRequest.sortDescriptors = [NSArray arrayWithObject:[NSSortDescriptor sortDescriptorWithKey:@"educationID" ascending:YES selector:nil]];
    
    NSError *error;
    NSArray *results = [self.context executeFetchRequest:fetchRequest error:&error];
    
    if (results.count == 0) {
        return nil;
    } else {
        NSMutableDictionary *params = [NSMutableDictionary dictionaryWithCapacity:3];
        [params setObject:[[SSUser currentUser] token] forKey:@"auth_token"];
        [params setObject:@"1" forKey:@"bulk"];
        
        for(EmployeeEducation *result in results) {
            NSDictionary *tempDict = [NSDictionary dictionaryWithObjectsAndKeys:
                                      result.educationCode, @"education_code",
                                      result.educationID, @"id",
                                      result.educationLiteralUS, @"education_literal_us",
                                      result.employeeID, @"employee_id",
                                      result.selectedAsEmployeeEducation, @"selected_as_employee_education",
                                      nil];
            
            NSString *tempKey = [NSString stringWithFormat:@"employee_educations_%@", result.educationID];
            [params setObject:tempDict forKey:tempKey];
        }
        
        [[AFNetworkActivityIndicatorManager sharedManager] incrementActivityCount];
        NSString *path = @"educations/bulk.json";
        NSURLRequest *request = [client requestWithMethod:@"PUT" path:path parameters:params];
        
        AFJSONRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
            [[AFNetworkActivityIndicatorManager sharedManager] decrementActivityCount];
            [[SSUser currentUser] setActivityNumberAsCompleted:@"21" andSyncStatus:YES];
        } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
            [[AFNetworkActivityIndicatorManager sharedManager] decrementActivityCount];
            [[SSUser currentUser] setActivityNumberAsCompleted:@"21" andSyncStatus:NO];
        }];
        
        return operation;
    }
}

-(AFJSONRequestOperation *) pushResponsibilitiesWithClient:(CENTROAPIClient *) client showHUDInViewController:(UIViewController *) viewController {
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Responsibility" inManagedObjectContext:self.context];
    
    [fetchRequest setEntity:entity];
    [fetchRequest setPredicate:[NSPredicate predicateWithFormat:@"companyID == %@", [[SSUser currentUser] companyID]]];
    fetchRequest.sortDescriptors = [NSArray arrayWithObject:[NSSortDescriptor sortDescriptorWithKey:@"responsibilityID" ascending:YES selector:nil]];
    
    NSError *error;
    NSArray *results = [self.context executeFetchRequest:fetchRequest error:&error];
    
    if (results.count == 0) {
        return nil;
    } else {
        NSMutableDictionary *params = [NSMutableDictionary dictionaryWithCapacity:3];
        [params setObject:[[SSUser currentUser] token] forKey:@"auth_token"];
        [params setObject:@"1" forKey:@"bulk"];
        
        for(Responsibility *result in results) {
            NSDictionary *tempDict = [NSDictionary dictionaryWithObjectsAndKeys:
                                      result.companyID, @"company_id",
                                      result.responsibilityID, @"id",
                                      result.responsibilityDescription, @"responsibility",
                                      result.selectedAsResponsibility, @"selected_as_responsibility",
                                      nil];
            
            NSString *tempKey = [NSString stringWithFormat:@"responsibilities_%@", result.responsibilityID];
            [params setObject:tempDict forKey:tempKey];
        }
        
        [[AFNetworkActivityIndicatorManager sharedManager] incrementActivityCount];
        NSString *path = @"responsibilities/bulk.json";
        NSURLRequest *request = [client requestWithMethod:@"PUT" path:path parameters:params];
        
        AFJSONRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
            [[AFNetworkActivityIndicatorManager sharedManager] decrementActivityCount];
        } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
            [[AFNetworkActivityIndicatorManager sharedManager] decrementActivityCount];
        }];
        
        return operation;
    }
}

-(AFJSONRequestOperation *) pushEmployeeResponsibilitiesWithClient:(CENTROAPIClient *) client showHUDInViewController:(UIViewController *) viewController andTurn:(NSString *) turn {
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"EmployeeResponsibility" inManagedObjectContext:self.context];
    
    [fetchRequest setEntity:entity];
    [fetchRequest setPredicate:[NSPredicate predicateWithFormat:@"companyID == %@", [[SSUser currentUser] companyID]]];
    fetchRequest.sortDescriptors = [NSArray arrayWithObject:[NSSortDescriptor sortDescriptorWithKey:@"employeeResponsibilityID" ascending:YES selector:nil]];
    
    NSError *error;
    NSArray *results = [self.context executeFetchRequest:fetchRequest error:&error];
    
    if (results.count == 0) {
        return nil;
    } else {
        NSMutableDictionary *params = [NSMutableDictionary dictionaryWithCapacity:3];
        [params setObject:[[SSUser currentUser] token] forKey:@"auth_token"];
        [params setObject:@"1" forKey:@"bulk"];
        
        for(EmployeeResponsibility *result in results) {
            NSDictionary *tempDict = [NSDictionary dictionaryWithObjectsAndKeys:
                                      result.companyID, @"company_id",
                                      result.employeeID, @"employee_id",
                                      result.frequencyHoursNeeded, @"frequency_hours_needed",
                                      result.hoursNeeded, @"hours_needed",
                                      result.employeeResponsibilityID, @"id",
                                      result.isMyResponsibility, @"is_my_responsibility",
                                      result.isOtherResponsibility, @"is_other_responsibility",
                                      result.rank, @"rank",
                                      result.responsibilityID, @"responsibility_id",
                                      result.selectedAsResponsibility, @"selected_as_responsibility",
                                      nil];
            
            NSString *tempKey = [NSString stringWithFormat:@"employees_responsibilities_%@", result.employeeResponsibilityID];
            [params setObject:tempDict forKey:tempKey];
        }
        
        [[AFNetworkActivityIndicatorManager sharedManager] incrementActivityCount];
        NSString *path = @"employees_responsibilities/bulk.json";
        NSURLRequest *request = [client requestWithMethod:@"PUT" path:path parameters:params];
        
        AFJSONRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
            [[AFNetworkActivityIndicatorManager sharedManager] decrementActivityCount];
            [[SSUser currentUser] setActivityNumberAsCompleted:turn andSyncStatus:YES];
        } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
            [[AFNetworkActivityIndicatorManager sharedManager] decrementActivityCount];
            [[SSUser currentUser] setActivityNumberAsCompleted:turn andSyncStatus:NO];
        }];
        
        return operation;
    }
}

-(AFJSONRequestOperation *) pushBrandAttributesWithClient:(CENTROAPIClient *) client showHUDInViewController:(UIViewController *) viewController {
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"BrandAttribute" inManagedObjectContext:self.context];
    
    [fetchRequest setEntity:entity];
    [fetchRequest setPredicate:[NSPredicate predicateWithFormat:@"companyID == %@", [[SSUser currentUser] companyID]]];
    fetchRequest.sortDescriptors = [NSArray arrayWithObject:[NSSortDescriptor sortDescriptorWithKey:@"brandValueID" ascending:YES selector:nil]];
    
    NSError *error;
    NSArray *attributes = [self.context executeFetchRequest:fetchRequest error:&error];
    
    if (attributes.count == 0) {
        return nil;
    } else {
        NSMutableDictionary *params = [NSMutableDictionary dictionaryWithCapacity:3];
        [params setObject:[[SSUser currentUser] token] forKey:@"auth_token"];
        [params setObject:@"1" forKey:@"bulk"];
        
        for(BrandAttribute *attribute in attributes) {
            
            NSDictionary *tempAttributeDict = [NSDictionary dictionaryWithObjectsAndKeys:
                                               attribute.brandValuePropositionRank, @"brand_value_proposition_rank",
                                               attribute.brandValueRank, @"brand_value_rank",
                                               attribute.selectedAsBrandValueProposition, @"selected_as_brand_value_proposition",
                                               attribute.selectedOverBrandValue, @"selected_over_brand_value",
                                               attribute.companyID, @"company_id",
                                               attribute.brandValueCode, @"brand_value_code",
                                               attribute.brandValueID, @"id",
                                               attribute.brandValueLiteralUS, @"brand_value_literal_us",
                                               nil];
            
            NSString *tempKey = [NSString stringWithFormat:@"brands_%@", attribute.brandValueID];
            [params setObject:tempAttributeDict forKey:tempKey];
        }
        
        
        [[AFNetworkActivityIndicatorManager sharedManager] incrementActivityCount];
        NSString *path = @"brands/bulk.json";
        NSURLRequest *request = [client requestWithMethod:@"PUT" path:path parameters:params];
        
        AFJSONRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
            [[AFNetworkActivityIndicatorManager sharedManager] decrementActivityCount];
            [[SSUser currentUser] setActivityNumberAsCompleted:@"26" andSyncStatus:YES];
        } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
            [[AFNetworkActivityIndicatorManager sharedManager] decrementActivityCount];
            [[SSUser currentUser] setActivityNumberAsCompleted:@"26" andSyncStatus:NO];
        }];
        
        return operation;
    }
}

-(AFJSONRequestOperation *) pushCompanyCostsWithClient:(CENTROAPIClient *) client showHUDInViewController:(UIViewController *) viewController {
    
    NSFetchRequest *companyCostsFetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"CompanyCost" inManagedObjectContext:self.context];
    
    [companyCostsFetchRequest setEntity:entity];
    [companyCostsFetchRequest setPredicate:[NSPredicate predicateWithFormat:@"companyID == %@", [[SSUser currentUser] companyID]]];
    companyCostsFetchRequest.sortDescriptors = [NSArray arrayWithObject:[NSSortDescriptor sortDescriptorWithKey:@"companyCostID" ascending:YES selector:nil]];
    
    NSError *error;
    NSArray *companyCosts = [self.context executeFetchRequest:companyCostsFetchRequest error:&error];
    
    if (companyCosts.count == 0) {
        return nil;
    } else {
        NSMutableDictionary *params = [NSMutableDictionary dictionaryWithCapacity:16];
        [params setObject:[[SSUser currentUser] token] forKey:@"auth_token"];
        [params setObject:@"1" forKey:@"bulk"];
        
        for(CompanyCost *companyCost in companyCosts) {
            NSDictionary *tempCompanyCostDict = [NSDictionary dictionaryWithObjectsAndKeys:
                                                 companyCost.amount, @"amount",
                                                 companyCost.frequency, @"frequency",
                                                 companyCost.isSure, @"is_sure",
                                                 companyCost.companyCostCode, @"cost_code",
                                                 companyCost.companyCostID, @"id",
                                                 companyCost.companyCostLiteralUS, @"cost_literal_us",
                                                 companyCost.companyID, @"company_id",
                                                 companyCost.selectedAsIncurredCost, @"selected_as_incurred_cost",
                                                 nil];
            
            NSString *tempKey = [NSString stringWithFormat:@"costs_%@", companyCost.companyCostID];
            [params setObject:tempCompanyCostDict forKey:tempKey];
        }
        
        [[AFNetworkActivityIndicatorManager sharedManager] incrementActivityCount];
        NSString *path = @"costs/bulk.json";
        NSURLRequest *request = [client requestWithMethod:@"PUT" path:path parameters:params];
        
        AFJSONRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
            [[AFNetworkActivityIndicatorManager sharedManager] decrementActivityCount];
            [[SSUser currentUser] setActivityNumberAsCompleted:@"27" andSyncStatus:YES];
        } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
            [[AFNetworkActivityIndicatorManager sharedManager] decrementActivityCount];
            [[SSUser currentUser] setActivityNumberAsCompleted:@"27" andSyncStatus:NO];
        }];
        
        return operation;
    }
}

-(AFJSONRequestOperation *) pushCompanyAssetsWithClient:(CENTROAPIClient *) client showHUDInViewController:(UIViewController *) viewController {
    
    NSFetchRequest *companyAssetsFetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"CompanyAsset" inManagedObjectContext:self.context];
    
    [companyAssetsFetchRequest setEntity:entity];
    [companyAssetsFetchRequest setPredicate:[NSPredicate predicateWithFormat:@"companyID == %@", [[SSUser currentUser] companyID]]];
    companyAssetsFetchRequest.sortDescriptors = [NSArray arrayWithObject:[NSSortDescriptor sortDescriptorWithKey:@"companyAssetID" ascending:YES selector:nil]];
    
    NSError *errorSV;
    NSArray *companyAssets = [self.context executeFetchRequest:companyAssetsFetchRequest error:&errorSV];
    
    if (companyAssets.count == 0) {
        return nil;
    } else {
        NSMutableDictionary *params = [NSMutableDictionary dictionaryWithCapacity:9];
        [params setObject:[[SSUser currentUser] token] forKey:@"auth_token"];
        [params setObject:@"1" forKey:@"bulk"];
        
        for(CompanyAsset *companyAsset in companyAssets) {
            
            NSDictionary *tempCompanyAssetDict = [NSDictionary dictionaryWithObjectsAndKeys:
                                                  companyAsset.amount, @"amount",
                                                  companyAsset.isSure, @"is_sure",
                                                  companyAsset.companyAssetCode, @"asset_code",
                                                  companyAsset.companyAssetID, @"id",
                                                  companyAsset.companyAssetLiteralUS, @"asset_literal_us",
                                                  companyAsset.companyID, @"company_id",
                                                  companyAsset.selectedAsAsset, @"selected_as_asset",
                                                  nil];
            
            NSString *tempKey = [NSString stringWithFormat:@"assets_%@", companyAsset.companyAssetID];
            [params setObject:tempCompanyAssetDict forKey:tempKey];
        }
        
        
        [[AFNetworkActivityIndicatorManager sharedManager] incrementActivityCount];
        NSString *path = @"assets/bulk.json";
        NSURLRequest *request = [client requestWithMethod:@"PUT" path:path parameters:params];
        
        AFJSONRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
            [[AFNetworkActivityIndicatorManager sharedManager] decrementActivityCount];
            [[SSUser currentUser] setActivityNumberAsCompleted:@"30" andSyncStatus:YES];
        } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
            [[AFNetworkActivityIndicatorManager sharedManager] decrementActivityCount];
            [[SSUser currentUser] setActivityNumberAsCompleted:@"30" andSyncStatus:NO];
        }];
        
        return operation;
    }
}

-(AFJSONRequestOperation *) pushCompanyDebtsWithClient:(CENTROAPIClient *) client showHUDInViewController:(UIViewController *) viewController {
    
    NSFetchRequest *companyDebtsFetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"CompanyDebt" inManagedObjectContext:self.context];
    
    [companyDebtsFetchRequest setEntity:entity];
    [companyDebtsFetchRequest setPredicate:[NSPredicate predicateWithFormat:@"companyID == %@", [[SSUser currentUser] companyID]]];
    companyDebtsFetchRequest.sortDescriptors = [NSArray arrayWithObject:[NSSortDescriptor sortDescriptorWithKey:@"companyDebtID" ascending:YES selector:nil]];
    
    NSError *error;
    NSArray *companyDebts = [self.context executeFetchRequest:companyDebtsFetchRequest error:&error];
    
    if (companyDebts.count == 0) {
        return nil;
    } else {
        NSMutableDictionary *params = [NSMutableDictionary dictionaryWithCapacity:9];
        [params setObject:[[SSUser currentUser] token] forKey:@"auth_token"];
        [params setObject:@"1" forKey:@"bulk"];
        
        for(CompanyDebt *companyDebt in companyDebts) {
            NSDictionary *tempCompanyDebtDict = [NSDictionary dictionaryWithObjectsAndKeys:
                                                 companyDebt.amount, @"amount",
                                                 companyDebt.isSure, @"is_sure",
                                                 companyDebt.companyDebtCode, @"debt_code",
                                                 companyDebt.companyDebtID, @"id",
                                                 companyDebt.companyDebtLiteralUS, @"debt_literal_us",
                                                 companyDebt.companyID, @"company_id",
                                                 companyDebt.selectedAsDebt, @"selected_as_debt",
                                                 nil];
            
            NSString *tempKey = [NSString stringWithFormat:@"debts_%@", companyDebt.companyDebtID];
            [params setObject:tempCompanyDebtDict forKey:tempKey];
        }
        
        
        [[AFNetworkActivityIndicatorManager sharedManager] incrementActivityCount];
        NSString *path = @"debts/bulk.json";
        NSURLRequest *request = [client requestWithMethod:@"PUT" path:path parameters:params];
        
        AFJSONRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
            [[AFNetworkActivityIndicatorManager sharedManager] decrementActivityCount];
            [[SSUser currentUser] setActivityNumberAsCompleted:@"31" andSyncStatus:YES];
        } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
            [[AFNetworkActivityIndicatorManager sharedManager] decrementActivityCount];
            [[SSUser currentUser] setActivityNumberAsCompleted:@"31" andSyncStatus:NO];
        }];
        
        return operation;
    }
}

#pragma mark - Support methods

-(void) setStudentForCurrentUser {
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Student"
                                              inManagedObjectContext:self.context];
    [fetchRequest setEntity:entity];
    
    [fetchRequest setPredicate:[NSPredicate predicateWithFormat:@"studentID = %@", [[SSUser currentUser] studentID]]];
    
    NSError *error;
    NSArray *fetchedObjects = [self.context executeFetchRequest:fetchRequest error:&error];
    if (fetchedObjects.count == 0) {
        
    } else {
        self.student = (Student *) [fetchedObjects objectAtIndex:0];
    }
}

@end