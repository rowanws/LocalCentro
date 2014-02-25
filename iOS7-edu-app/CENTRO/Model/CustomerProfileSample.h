//
//  CustomerProfileSample.h
//  CENTRO
//
//  Created by Centro Community Partners on 10/24/13.
//  Copyright (c) 2013 Centro Community Partners. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Company;

@interface CustomerProfileSample : NSManagedObject

@property (nonatomic, retain) NSNumber * age;
@property (nonatomic, retain) NSNumber * companyID;
@property (nonatomic, retain) NSNumber * customerProfileSampleID;
@property (nonatomic, retain) NSString * educationLevel;
@property (nonatomic, retain) NSNumber * income;
@property (nonatomic, retain) NSString * interest;
@property (nonatomic, retain) NSString * location;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSString * profession;
@property (nonatomic, retain) Company *company;

@end
