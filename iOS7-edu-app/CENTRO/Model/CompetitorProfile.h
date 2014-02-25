//
//  CompetitorProfile.h
//  CENTRO
//
//  Created by Centro Community Partners on 10/24/13.
//  Copyright (c) 2013 Centro Community Partners. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Company;

@interface CompetitorProfile : NSManagedObject

@property (nonatomic, retain) NSNumber * companyID;
@property (nonatomic, retain) NSNumber * competitorProfileID;
@property (nonatomic, retain) NSNumber * customerServiceRank;
@property (nonatomic, retain) NSNumber * frequencySellTargetAge;
@property (nonatomic, retain) NSNumber * frequencySellTargetEducation;
@property (nonatomic, retain) NSNumber * frequencySellTargetGenre;
@property (nonatomic, retain) NSNumber * frequencySellTargetIncome;
@property (nonatomic, retain) NSNumber * frequencySellTargetInterest;
@property (nonatomic, retain) NSNumber * frequencySellTargetOccupation;
@property (nonatomic, retain) NSNumber * locationRank;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSNumber * priceRank;
@property (nonatomic, retain) NSNumber * qualityRank;
@property (nonatomic, retain) NSNumber * sellLongDrive;
@property (nonatomic, retain) NSNumber * sellOnline;
@property (nonatomic, retain) NSNumber * sellShortDrive;
@property (nonatomic, retain) NSNumber * sellWalkingDistance;
@property (nonatomic, retain) NSNumber * speedRank;
@property (nonatomic, retain) Company *company;

@end
