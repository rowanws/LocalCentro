//
//  Industry.h
//  CENTRO
//
//  Created by Centro Community Partners on 10/24/13.
//  Copyright (c) 2013 Centro Community Partners. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Company;

@interface Industry : NSManagedObject

@property (nonatomic, retain) NSNumber * companyID;
@property (nonatomic, retain) NSNumber * growth;
@property (nonatomic, retain) NSNumber * growthRate;
@property (nonatomic, retain) NSString * industryCode;
@property (nonatomic, retain) NSNumber * industryID;
@property (nonatomic, retain) NSString * industrySegmentCode;
@property (nonatomic, retain) NSNumber * marketAge;
@property (nonatomic, retain) NSNumber * regulations;
@property (nonatomic, retain) NSNumber * volatility;
@property (nonatomic, retain) Company *company;

@end
