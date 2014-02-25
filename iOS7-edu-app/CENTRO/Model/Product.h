//
//  Product.h
//  CENTRO
//
//  Created by Centro Community Partners on 10/24/13.
//  Copyright (c) 2013 Centro Community Partners. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Company;

@interface Product : NSManagedObject

@property (nonatomic, retain) NSNumber * categoryID;
@property (nonatomic, retain) NSNumber * companyID;
@property (nonatomic, retain) NSNumber * isPriceSure;
@property (nonatomic, retain) NSNumber * isProfitAmountSure;
@property (nonatomic, retain) NSNumber * monthlyProfitAmount;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSNumber * price;
@property (nonatomic, retain) NSNumber * productID;
@property (nonatomic, retain) NSNumber * profitAmount;
@property (nonatomic, retain) NSNumber * profitFrequency;
@property (nonatomic, retain) NSNumber * selectedAsItem;
@property (nonatomic, retain) NSNumber * selectedAsProfitableItem;
@property (nonatomic, retain) Company *company;

@end
