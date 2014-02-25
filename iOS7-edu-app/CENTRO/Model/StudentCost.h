//
//  StudentCost.h
//  CENTRO
//
//  Created by Centro Community Partners on 10/24/13.
//  Copyright (c) 2013 Centro Community Partners. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Student;

@interface StudentCost : NSManagedObject

@property (nonatomic, retain) NSNumber * amount;
@property (nonatomic, retain) NSNumber * frequency;
@property (nonatomic, retain) NSNumber * isSure;
@property (nonatomic, retain) NSNumber * monthlyAmount;
@property (nonatomic, retain) NSNumber * selectedAsIncurredCost;
@property (nonatomic, retain) NSString * studentCostCode;
@property (nonatomic, retain) NSNumber * studentCostID;
@property (nonatomic, retain) NSString * studentCostLiteralUS;
@property (nonatomic, retain) NSNumber * studentID;
@property (nonatomic, retain) Student *student;

@end
