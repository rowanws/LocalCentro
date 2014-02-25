//
//  StudentIncome.h
//  CENTRO
//
//  Created by Centro Community Partners on 10/24/13.
//  Copyright (c) 2013 Centro Community Partners. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Student;

@interface StudentIncome : NSManagedObject

@property (nonatomic, retain) NSNumber * amount;
@property (nonatomic, retain) NSNumber * frequency;
@property (nonatomic, retain) NSNumber * isSure;
@property (nonatomic, retain) NSNumber * monthlyAmount;
@property (nonatomic, retain) NSNumber * selectedAsSourceOfIncome;
@property (nonatomic, retain) NSNumber * studentID;
@property (nonatomic, retain) NSString * studentIncomeCode;
@property (nonatomic, retain) NSNumber * studentIncomeID;
@property (nonatomic, retain) NSString * studentIncomeLiteralUS;
@property (nonatomic, retain) NSSet *student;
@end

@interface StudentIncome (CoreDataGeneratedAccessors)

- (void)addStudentObject:(Student *)value;
- (void)removeStudentObject:(Student *)value;
- (void)addStudent:(NSSet *)values;
- (void)removeStudent:(NSSet *)values;

@end
