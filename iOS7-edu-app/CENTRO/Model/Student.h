//
//  Student.h
//  CENTRO
//
//  Created by Centro Community Partners on 10/24/13.
//  Copyright (c) 2013 Centro Community Partners. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Activity, Company, StudentAsset, StudentCost, StudentDebt, StudentIncome, Value;

@interface Student : NSManagedObject

@property (nonatomic, retain) NSDate * dateOfBirth;
@property (nonatomic, retain) NSString * email;
@property (nonatomic, retain) NSString * firstName;
@property (nonatomic, retain) NSString * gender;
@property (nonatomic, retain) NSString * lastName;
@property (nonatomic, retain) NSString * phoneNumber;
@property (nonatomic, retain) NSString * phoneType;
@property (nonatomic, retain) NSString * preferredName;
@property (nonatomic, retain) NSNumber * studentID;
@property (nonatomic, retain) NSSet *activities;
@property (nonatomic, retain) NSSet *assets;
@property (nonatomic, retain) Company *company;
@property (nonatomic, retain) NSSet *costs;
@property (nonatomic, retain) NSSet *debts;
@property (nonatomic, retain) NSSet *incomes;
@property (nonatomic, retain) NSSet *values;
@end

@interface Student (CoreDataGeneratedAccessors)

- (void)addActivitiesObject:(Activity *)value;
- (void)removeActivitiesObject:(Activity *)value;
- (void)addActivities:(NSSet *)values;
- (void)removeActivities:(NSSet *)values;

- (void)addAssetsObject:(StudentAsset *)value;
- (void)removeAssetsObject:(StudentAsset *)value;
- (void)addAssets:(NSSet *)values;
- (void)removeAssets:(NSSet *)values;

- (void)addCostsObject:(StudentCost *)value;
- (void)removeCostsObject:(StudentCost *)value;
- (void)addCosts:(NSSet *)values;
- (void)removeCosts:(NSSet *)values;

- (void)addDebtsObject:(StudentDebt *)value;
- (void)removeDebtsObject:(StudentDebt *)value;
- (void)addDebts:(NSSet *)values;
- (void)removeDebts:(NSSet *)values;

- (void)addIncomesObject:(StudentIncome *)value;
- (void)removeIncomesObject:(StudentIncome *)value;
- (void)addIncomes:(NSSet *)values;
- (void)removeIncomes:(NSSet *)values;

- (void)addValuesObject:(Value *)value;
- (void)removeValuesObject:(Value *)value;
- (void)addValues:(NSSet *)values;
- (void)removeValues:(NSSet *)values;

@end
