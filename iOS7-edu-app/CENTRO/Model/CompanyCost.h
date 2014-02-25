//
//  CompanyCost.h
//  CENTRO
//
//  Created by Centro Community Partners on 10/24/13.
//  Copyright (c) 2013 Centro Community Partners. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Company;

@interface CompanyCost : NSManagedObject

@property (nonatomic, retain) NSNumber * amount;
@property (nonatomic, retain) NSString * companyCostCode;
@property (nonatomic, retain) NSNumber * companyCostID;
@property (nonatomic, retain) NSString * companyCostLiteralUS;
@property (nonatomic, retain) NSNumber * companyID;
@property (nonatomic, retain) NSNumber * frequency;
@property (nonatomic, retain) NSNumber * isSure;
@property (nonatomic, retain) NSNumber * monthlyAmount;
@property (nonatomic, retain) NSNumber * selectedAsIncurredCost;
@property (nonatomic, retain) Company *company;

@end
