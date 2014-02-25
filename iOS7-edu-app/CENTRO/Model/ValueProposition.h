//
//  ValueProposition.h
//  CENTRO
//
//  Created by Centro Community Partners on 10/24/13.
//  Copyright (c) 2013 Centro Community Partners. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Company;

@interface ValueProposition : NSManagedObject

@property (nonatomic, retain) NSNumber * companyID;
@property (nonatomic, retain) NSNumber * competitorProfileID;
@property (nonatomic, retain) NSNumber * customerServiceRank;
@property (nonatomic, retain) NSNumber * isCompetitor;
@property (nonatomic, retain) NSNumber * locationRank;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSNumber * priceRank;
@property (nonatomic, retain) NSNumber * qualityRank;
@property (nonatomic, retain) NSNumber * speedRank;
@property (nonatomic, retain) NSNumber * valuePropositionID;
@property (nonatomic, retain) Company *company;

@end
