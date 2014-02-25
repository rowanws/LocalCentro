//
//  CustomerProfile.h
//  CENTRO
//
//  Created by Centro Community Partners on 10/24/13.
//  Copyright (c) 2013 Centro Community Partners. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Company, CustomerEducation, CustomerInterest, CustomerOccupation, CustomerPriority;

@interface CustomerProfile : NSManagedObject

@property (nonatomic, retain) NSNumber * companyID;
@property (nonatomic, retain) NSNumber * customerProfileID;
@property (nonatomic, retain) NSNumber * fromAge;
@property (nonatomic, retain) NSNumber * fromIncome;
@property (nonatomic, retain) NSNumber * isAgeSure;
@property (nonatomic, retain) NSNumber * isEducationSure;
@property (nonatomic, retain) NSNumber * isGenderSure;
@property (nonatomic, retain) NSNumber * isIncomeSure;
@property (nonatomic, retain) NSNumber * isInterestSure;
@property (nonatomic, retain) NSNumber * isLocationSure;
@property (nonatomic, retain) NSNumber * isOccupationSure;
@property (nonatomic, retain) NSNumber * locationLongDrive;
@property (nonatomic, retain) NSNumber * locationOnline;
@property (nonatomic, retain) NSNumber * locationOther;
@property (nonatomic, retain) NSNumber * locationShortDrive;
@property (nonatomic, retain) NSNumber * locationWalk;
@property (nonatomic, retain) NSNumber * menPercentage;
@property (nonatomic, retain) NSNumber * toAge;
@property (nonatomic, retain) NSNumber * toIncome;
@property (nonatomic, retain) NSNumber * womenPercentage;
@property (nonatomic, retain) Company *company;
@property (nonatomic, retain) NSSet *educations;
@property (nonatomic, retain) NSSet *interests;
@property (nonatomic, retain) NSSet *occupations;
@property (nonatomic, retain) NSSet *priorities;
@end

@interface CustomerProfile (CoreDataGeneratedAccessors)

- (void)addEducationsObject:(CustomerEducation *)value;
- (void)removeEducationsObject:(CustomerEducation *)value;
- (void)addEducations:(NSSet *)values;
- (void)removeEducations:(NSSet *)values;

- (void)addInterestsObject:(CustomerInterest *)value;
- (void)removeInterestsObject:(CustomerInterest *)value;
- (void)addInterests:(NSSet *)values;
- (void)removeInterests:(NSSet *)values;

- (void)addOccupationsObject:(CustomerOccupation *)value;
- (void)removeOccupationsObject:(CustomerOccupation *)value;
- (void)addOccupations:(NSSet *)values;
- (void)removeOccupations:(NSSet *)values;

- (void)addPrioritiesObject:(CustomerPriority *)value;
- (void)removePrioritiesObject:(CustomerPriority *)value;
- (void)addPriorities:(NSSet *)values;
- (void)removePriorities:(NSSet *)values;

@end
