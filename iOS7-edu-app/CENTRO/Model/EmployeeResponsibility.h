//
//  EmployeeResponsibility.h
//  CENTRO
//
//  Created by Centro Community Partners on 10/24/13.
//  Copyright (c) 2013 Centro Community Partners. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Company;

@interface EmployeeResponsibility : NSManagedObject

@property (nonatomic, retain) NSNumber * companyID;
@property (nonatomic, retain) NSNumber * employeeID;
@property (nonatomic, retain) NSNumber * employeeResponsibilityID;
@property (nonatomic, retain) NSNumber * frequencyHoursNeeded;
@property (nonatomic, retain) NSNumber * hoursNeeded;
@property (nonatomic, retain) NSNumber * isMyResponsibility;
@property (nonatomic, retain) NSNumber * isOtherResponsibility;
@property (nonatomic, retain) NSNumber * rank;
@property (nonatomic, retain) NSNumber * responsibilityID;
@property (nonatomic, retain) NSNumber * selectedAsResponsibility;
@property (nonatomic, retain) Company *company;

@end
