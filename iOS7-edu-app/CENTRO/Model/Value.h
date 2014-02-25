//
//  Value.h
//  CENTRO
//
//  Created by Centro Community Partners on 10/24/13.
//  Copyright (c) 2013 Centro Community Partners. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Student;

@interface Value : NSManagedObject

@property (nonatomic, retain) NSNumber * companyRank;
@property (nonatomic, retain) NSNumber * rank;
@property (nonatomic, retain) NSNumber * selectedAsCompanyValue;
@property (nonatomic, retain) NSString * selectedOver;
@property (nonatomic, retain) NSNumber * studentID;
@property (nonatomic, retain) NSString * valueCode;
@property (nonatomic, retain) NSNumber * valueID;
@property (nonatomic, retain) NSString * valueLiteralUS;
@property (nonatomic, retain) Student *student;

@end
