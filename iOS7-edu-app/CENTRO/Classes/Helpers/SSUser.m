//
//  SSUser.m
//  CENTRO
//
//  Created by Centro Community Partners.
//  Copyright (c) 2013 Centro Community Partners. All rights reserved.
//

#import "SSUser.h"
#import "CENTROAPIClient.h"
#import "SSUtils.h"
#import "MBProgressHUD.h"
#import "Student.h"
#import "Activity.h"
#import "IndustryAndSegment.h"
#import "SSServerData.h"

@interface SSUser()

@property (strong, nonatomic) NSUserDefaults *settings;

@end

@implementation SSUser

+ (SSUser *)currentUser {
    static SSUser *_sharedUser = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedUser = [[self alloc] init];
    });
    
    return _sharedUser;
}

- (id)init {
    if (self = [super init]) {
        self.settings = [NSUserDefaults standardUserDefaults];
        self.segueToPerform = @"";
    }
    return self;
}


- (void) registerUser:(NSString *) username withAuthToken:(NSString *) authToken ID:(NSString *) studentID andCompanyID:(NSString *) companyID {
    
    [self.settings setObject:username forKey:@"username"];
    [self.settings setObject:authToken forKey:@"authToken"];
    [self.settings setObject:studentID forKey:@"studentID"];
    [self.settings setObject:companyID forKey:@"companyID"];
    [self.settings synchronize];
    
}

- (BOOL) isLoggedIn {
    
    NSString *username = [self.settings stringForKey:@"username"];
    NSString *authToken = [self.settings stringForKey:@"authToken"];
    NSString *studentID = [self.settings stringForKey:@"studentID"];
    NSString *companyID = [self.settings stringForKey:@"companyID"];
    
    if(username && authToken && studentID && companyID) {
        return YES;
    } else {
        return NO;
    }
}

- (void) localLogOut {
    [self.settings setObject:nil forKey:@"username"];
    [self.settings setObject:nil forKey:@"authToken"];
    [self.settings setObject:nil forKey:@"studentID"];
    [self.settings setObject:nil forKey:@"companyID"];
    [self.settings synchronize];
}

- (void) logOutAndPresentHUDInViewController:(UIViewController *) hudViewController {
    if([[CENTROAPIClient sharedClient] networkIsReachable]) {
        [[[SSServerData alloc] init] pushAndShowHUDinViewController:hudViewController logOutAfter:YES];
    }
}

- (NSString *) username {
    return [self.settings stringForKey:@"username"];
}

- (NSString *) token {
    return [self.settings stringForKey:@"authToken"];
}

- (NSString *) studentID {
    return [self.settings stringForKey:@"studentID"];
}

- (NSString *) companyID {
    return [self.settings stringForKey:@"companyID"];
}

- (void) setActivityNumberAsCompleted: (NSString *) activityNumber andSyncStatus: (BOOL) synced {
    
    NSManagedObjectContext *context = [(id)[[UIApplication sharedApplication] delegate] managedObjectContext];
    
    NSFetchRequest *activitiesFetchRequest = [[NSFetchRequest alloc] init];
    
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Activity"
                                              inManagedObjectContext:context];
    [activitiesFetchRequest setEntity:entity];
    
    [activitiesFetchRequest setPredicate:[NSPredicate predicateWithFormat:@"turn = %@", activityNumber]];
    
    activitiesFetchRequest.sortDescriptors = [NSArray arrayWithObject:[NSSortDescriptor sortDescriptorWithKey:@"turn" ascending:YES selector:nil]];
    
    NSError *errorSV;
    NSArray *activitiesFetchedObjects = [context executeFetchRequest:activitiesFetchRequest error:&errorSV];
    if (activitiesFetchedObjects.count == 0) {

    } else {
        [[activitiesFetchedObjects objectAtIndex:0] setCompleted:[NSDate date]];
        [[activitiesFetchedObjects objectAtIndex:0] setSynced:[NSNumber numberWithBool:synced]];
        [[activitiesFetchedObjects objectAtIndex:0] setShowCompletedScreen:[NSNumber numberWithBool:YES]];

        [context save:nil];
    }
}



- (void) setActivityNumberAsIncompleted:(NSString *) activityNumber {
    
    NSManagedObjectContext *context = [(id)[[UIApplication sharedApplication] delegate] managedObjectContext];
    
    NSFetchRequest *activitiesFetchRequest = [[NSFetchRequest alloc] init];
    
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Activity"
                                              inManagedObjectContext:context];
    [activitiesFetchRequest setEntity:entity];
    
    [activitiesFetchRequest setPredicate:[NSPredicate predicateWithFormat:@"turn = %@", activityNumber]];
    
    activitiesFetchRequest.sortDescriptors = [NSArray arrayWithObject:[NSSortDescriptor sortDescriptorWithKey:@"turn" ascending:YES selector:nil]];
    
    NSError *errorSV;
    NSArray *activitiesFetchedObjects = [context executeFetchRequest:activitiesFetchRequest error:&errorSV];
    if (activitiesFetchedObjects.count == 0) {
    } else {
        [[activitiesFetchedObjects objectAtIndex:0] setShowCompletedScreen:[NSNumber numberWithBool:NO]];
        [context save:nil];
    }
}

- (NSArray *) listOfNotSyncedActivities {

    NSManagedObjectContext *context = [(id)[[UIApplication sharedApplication] delegate] managedObjectContext];
    
    NSFetchRequest *activitiesFetchRequest = [[NSFetchRequest alloc] init];
    
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Activity"
                                              inManagedObjectContext:context];
    [activitiesFetchRequest setEntity:entity];
    
    [activitiesFetchRequest setPredicate:[NSPredicate predicateWithFormat:@"completed != %@ AND synced == %@", nil, [NSNumber numberWithBool:NO]]];
    
    activitiesFetchRequest.sortDescriptors = [NSArray arrayWithObject:[NSSortDescriptor sortDescriptorWithKey:@"turn" ascending:YES selector:nil]];
    
    NSError *errorSV;
    NSArray *activitiesFetchedObjects = [context executeFetchRequest:activitiesFetchRequest error:&errorSV];
    if (activitiesFetchedObjects.count == 0) {
        return nil;
    } else {
        return activitiesFetchedObjects;
    }

}

@end