//
//  Purpose.h
//  CENTRO
//
//  Created by Centro Community Partners on 10/24/13.
//  Copyright (c) 2013 Centro Community Partners. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Company;

@interface Purpose : NSManagedObject

@property (nonatomic, retain) NSNumber * companyID;
@property (nonatomic, retain) NSString * kind;
@property (nonatomic, retain) NSString * purpose;
@property (nonatomic, retain) NSNumber * purposeID;
@property (nonatomic, retain) Company *company;

@end
