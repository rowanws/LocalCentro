//
//  Employee.h
//  CENTRO
//
//  Created by Centro Community Partners on 10/24/13.
//  Copyright (c) 2013 Centro Community Partners. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Company;

@interface Employee : NSManagedObject

@property (nonatomic, retain) NSNumber * companyID;
@property (nonatomic, retain) NSNumber * earning;
@property (nonatomic, retain) NSNumber * earningFrequency;
@property (nonatomic, retain) NSNumber * employeeID;
@property (nonatomic, retain) NSNumber * manager;
@property (nonatomic, retain) NSNumber * myself;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSNumber * professionalExperience;
@property (nonatomic, retain) NSNumber * selectedAsEmployee;
@property (nonatomic, retain) NSNumber * weeksWork;
@property (nonatomic, retain) Company *company;

@end
