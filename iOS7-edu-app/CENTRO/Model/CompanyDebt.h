//
//  CompanyDebt.h
//  CENTRO
//
//  Created by Centro Community Partners on 10/24/13.
//  Copyright (c) 2013 Centro Community Partners. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Company;

@interface CompanyDebt : NSManagedObject

@property (nonatomic, retain) NSNumber * amount;
@property (nonatomic, retain) NSString * companyDebtCode;
@property (nonatomic, retain) NSNumber * companyDebtID;
@property (nonatomic, retain) NSString * companyDebtLiteralUS;
@property (nonatomic, retain) NSNumber * companyID;
@property (nonatomic, retain) NSNumber * isSure;
@property (nonatomic, retain) NSNumber * selectedAsDebt;
@property (nonatomic, retain) Company *company;

@end
