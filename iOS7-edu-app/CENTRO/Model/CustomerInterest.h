//
//  CustomerInterest.h
//  CENTRO
//
//  Created by Centro Community Partners on 10/24/13.
//  Copyright (c) 2013 Centro Community Partners. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class CustomerProfile;

@interface CustomerInterest : NSManagedObject

@property (nonatomic, retain) NSNumber * customerProfileID;
@property (nonatomic, retain) NSString * interestCode;
@property (nonatomic, retain) NSNumber * interestID;
@property (nonatomic, retain) NSString * interestLiteralUS;
@property (nonatomic, retain) NSNumber * selectedAsCustomerInterest;
@property (nonatomic, retain) CustomerProfile *customerProfile;

@end
