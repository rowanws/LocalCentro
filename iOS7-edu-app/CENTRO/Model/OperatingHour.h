//
//  OperatingHour.h
//  CENTRO
//
//  Created by Centro Community Partners on 10/24/13.
//  Copyright (c) 2013 Centro Community Partners. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Company;

@interface OperatingHour : NSManagedObject

@property (nonatomic, retain) NSNumber * companyID;
@property (nonatomic, retain) NSNumber * dayOfWeekID;
@property (nonatomic, retain) NSString * dayOfWeekUS;
@property (nonatomic, retain) NSDate * from;
@property (nonatomic, retain) NSNumber * selectedAsWorkingDay;
@property (nonatomic, retain) NSDate * to;
@property (nonatomic, retain) NSNumber * workingHourID;
@property (nonatomic, retain) Company *company;

@end
