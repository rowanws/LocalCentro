//
//  NearbyCompetitor.h
//  CENTRO
//
//  Created by Centro Community Partners on 10/24/13.
//  Copyright (c) 2013 Centro Community Partners. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Company;

@interface NearbyCompetitor : NSManagedObject

@property (nonatomic, retain) NSNumber * companyID;
@property (nonatomic, retain) NSNumber * longDriveCompetitors;
@property (nonatomic, retain) NSNumber * nearbyCompetitorID;
@property (nonatomic, retain) NSNumber * onlineCompetitors;
@property (nonatomic, retain) NSNumber * shortDriveCompetitors;
@property (nonatomic, retain) NSNumber * walkingDistanceCompetitors;
@property (nonatomic, retain) Company *company;

@end
