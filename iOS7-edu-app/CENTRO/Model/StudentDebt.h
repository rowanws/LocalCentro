//
//  StudentDebt.h
//  CENTRO
//
//  Created by Centro Community Partners on 10/24/13.
//  Copyright (c) 2013 Centro Community Partners. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Student;

@interface StudentDebt : NSManagedObject

@property (nonatomic, retain) NSNumber * amount;
@property (nonatomic, retain) NSNumber * isSure;
@property (nonatomic, retain) NSNumber * selectedAsDebt;
@property (nonatomic, retain) NSString * studentDebtCode;
@property (nonatomic, retain) NSNumber * studentDebtID;
@property (nonatomic, retain) NSString * studentDebtLiteralUS;
@property (nonatomic, retain) NSNumber * studentID;
@property (nonatomic, retain) Student *student;

@end
