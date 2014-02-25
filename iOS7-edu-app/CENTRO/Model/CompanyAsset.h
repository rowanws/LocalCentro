//
//  CompanyAsset.h
//  CENTRO
//
//  Created by Centro Community Partners on 10/24/13.
//  Copyright (c) 2013 Centro Community Partners. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Company;

@interface CompanyAsset : NSManagedObject

@property (nonatomic, retain) NSNumber * amount;
@property (nonatomic, retain) NSString * companyAssetCode;
@property (nonatomic, retain) NSNumber * companyAssetID;
@property (nonatomic, retain) NSString * companyAssetLiteralUS;
@property (nonatomic, retain) NSNumber * companyID;
@property (nonatomic, retain) NSNumber * isSure;
@property (nonatomic, retain) NSNumber * selectedAsAsset;
@property (nonatomic, retain) Company *company;

@end
