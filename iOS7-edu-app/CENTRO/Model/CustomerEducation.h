//
//  CustomerEducation.h
//  CENTRO
//
//  Created by Centro Community Partners on 10/24/13.
//  Copyright (c) 2013 Centro Community Partners. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class CustomerProfile;

@interface CustomerEducation : NSManagedObject

@property (nonatomic, retain) NSNumber * customerProfileID;
@property (nonatomic, retain) NSString * educationCode;
@property (nonatomic, retain) NSNumber * educationID;
@property (nonatomic, retain) NSString * educationLiteralUS;
@property (nonatomic, retain) NSNumber * selectedAsCustomerEducation;
@property (nonatomic, retain) CustomerProfile *customerProfile;

@end
