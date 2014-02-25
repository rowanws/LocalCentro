//
//  EmployeeEducation.h
//  CENTRO
//
//  Created by Centro Community Partners on 10/24/13.
//  Copyright (c) 2013 Centro Community Partners. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Company;

@interface EmployeeEducation : NSManagedObject

@property (nonatomic, retain) NSNumber * companyID;
@property (nonatomic, retain) NSString * educationCode;
@property (nonatomic, retain) NSNumber * educationID;
@property (nonatomic, retain) NSString * educationLiteralUS;
@property (nonatomic, retain) NSNumber * employeeID;
@property (nonatomic, retain) NSNumber * selectedAsEmployeeEducation;
@property (nonatomic, retain) Company *company;

@end
