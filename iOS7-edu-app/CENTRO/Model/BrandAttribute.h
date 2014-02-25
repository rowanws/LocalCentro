//
//  BrandAttribute.h
//  CENTRO
//
//  Created by Centro Community Partners on 10/24/13.
//  Copyright (c) 2013 Centro Community Partners. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Company;

@interface BrandAttribute : NSManagedObject

@property (nonatomic, retain) NSString * brandValueCode;
@property (nonatomic, retain) NSNumber * brandValueID;
@property (nonatomic, retain) NSString * brandValueLiteralUS;
@property (nonatomic, retain) NSNumber * brandValuePropositionRank;
@property (nonatomic, retain) NSNumber * brandValueRank;
@property (nonatomic, retain) NSNumber * companyID;
@property (nonatomic, retain) NSNumber * selectedAsBrandValueProposition;
@property (nonatomic, retain) NSString * selectedOverBrandValue;
@property (nonatomic, retain) Company *company;

@end
