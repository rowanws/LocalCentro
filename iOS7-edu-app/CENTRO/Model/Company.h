//
//  Company.h
//  CENTRO
//
//  Created by Centro Community Partners on 10/24/13.
//  Copyright (c) 2013 Centro Community Partners. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class BrandAttribute, Category, CompanyAsset, CompanyCost, CompanyDebt, CompetitorProfile, CustomerProfile, CustomerProfileSample, Employee, EmployeeEducation, EmployeeResponsibility, Industry, Mission, NearbyCompetitor, OperatingHour, Product, Purpose, Responsibility, Student, ValueProposition, Vision;

@interface Company : NSManagedObject

@property (nonatomic, retain) NSNumber * companyID;
@property (nonatomic, retain) NSNumber * frequencyEmployeeBenefits;
@property (nonatomic, retain) NSNumber * isOtherProfitAmountSure;
@property (nonatomic, retain) NSNumber * isProductsSure;
@property (nonatomic, retain) NSNumber * isServicesSure;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSNumber * numberOfEmployees;
@property (nonatomic, retain) NSNumber * otherProfitAmount;
@property (nonatomic, retain) NSNumber * otherProfitFrequency;
@property (nonatomic, retain) NSNumber * productsAndServicesEstimate;
@property (nonatomic, retain) NSNumber * productsQty;
@property (nonatomic, retain) NSNumber * servicesQty;
@property (nonatomic, retain) NSNumber * studentID;
@property (nonatomic, retain) NSNumber * totalEmployeeBenefitsCosts;
@property (nonatomic, retain) NSSet *brandAttributes;
@property (nonatomic, retain) NSSet *categories;
@property (nonatomic, retain) NSSet *companyAssets;
@property (nonatomic, retain) NSSet *companyCosts;
@property (nonatomic, retain) NSSet *companyDebts;
@property (nonatomic, retain) NSSet *competitorProfiles;
@property (nonatomic, retain) CustomerProfile *customerProfile;
@property (nonatomic, retain) NSSet *customerProfileSamples;
@property (nonatomic, retain) NSSet *employeeEducations;
@property (nonatomic, retain) NSSet *employeeResponsibilities;
@property (nonatomic, retain) NSSet *employees;
@property (nonatomic, retain) Industry *industry;
@property (nonatomic, retain) Mission *mission;
@property (nonatomic, retain) NearbyCompetitor *nearbyCompetitor;
@property (nonatomic, retain) NSSet *operatingHours;
@property (nonatomic, retain) NSSet *products;
@property (nonatomic, retain) NSSet *purposes;
@property (nonatomic, retain) NSSet *responsibilities;
@property (nonatomic, retain) Student *student;
@property (nonatomic, retain) NSSet *valuePropositions;
@property (nonatomic, retain) Vision *vision;
@end

@interface Company (CoreDataGeneratedAccessors)

- (void)addBrandAttributesObject:(BrandAttribute *)value;
- (void)removeBrandAttributesObject:(BrandAttribute *)value;
- (void)addBrandAttributes:(NSSet *)values;
- (void)removeBrandAttributes:(NSSet *)values;

- (void)addCategoriesObject:(Category *)value;
- (void)removeCategoriesObject:(Category *)value;
- (void)addCategories:(NSSet *)values;
- (void)removeCategories:(NSSet *)values;

- (void)addCompanyAssetsObject:(CompanyAsset *)value;
- (void)removeCompanyAssetsObject:(CompanyAsset *)value;
- (void)addCompanyAssets:(NSSet *)values;
- (void)removeCompanyAssets:(NSSet *)values;

- (void)addCompanyCostsObject:(CompanyCost *)value;
- (void)removeCompanyCostsObject:(CompanyCost *)value;
- (void)addCompanyCosts:(NSSet *)values;
- (void)removeCompanyCosts:(NSSet *)values;

- (void)addCompanyDebtsObject:(CompanyDebt *)value;
- (void)removeCompanyDebtsObject:(CompanyDebt *)value;
- (void)addCompanyDebts:(NSSet *)values;
- (void)removeCompanyDebts:(NSSet *)values;

- (void)addCompetitorProfilesObject:(CompetitorProfile *)value;
- (void)removeCompetitorProfilesObject:(CompetitorProfile *)value;
- (void)addCompetitorProfiles:(NSSet *)values;
- (void)removeCompetitorProfiles:(NSSet *)values;

- (void)addCustomerProfileSamplesObject:(CustomerProfileSample *)value;
- (void)removeCustomerProfileSamplesObject:(CustomerProfileSample *)value;
- (void)addCustomerProfileSamples:(NSSet *)values;
- (void)removeCustomerProfileSamples:(NSSet *)values;

- (void)addEmployeeEducationsObject:(EmployeeEducation *)value;
- (void)removeEmployeeEducationsObject:(EmployeeEducation *)value;
- (void)addEmployeeEducations:(NSSet *)values;
- (void)removeEmployeeEducations:(NSSet *)values;

- (void)addEmployeeResponsibilitiesObject:(EmployeeResponsibility *)value;
- (void)removeEmployeeResponsibilitiesObject:(EmployeeResponsibility *)value;
- (void)addEmployeeResponsibilities:(NSSet *)values;
- (void)removeEmployeeResponsibilities:(NSSet *)values;

- (void)addEmployeesObject:(Employee *)value;
- (void)removeEmployeesObject:(Employee *)value;
- (void)addEmployees:(NSSet *)values;
- (void)removeEmployees:(NSSet *)values;

- (void)addOperatingHoursObject:(OperatingHour *)value;
- (void)removeOperatingHoursObject:(OperatingHour *)value;
- (void)addOperatingHours:(NSSet *)values;
- (void)removeOperatingHours:(NSSet *)values;

- (void)addProductsObject:(Product *)value;
- (void)removeProductsObject:(Product *)value;
- (void)addProducts:(NSSet *)values;
- (void)removeProducts:(NSSet *)values;

- (void)addPurposesObject:(Purpose *)value;
- (void)removePurposesObject:(Purpose *)value;
- (void)addPurposes:(NSSet *)values;
- (void)removePurposes:(NSSet *)values;

- (void)addResponsibilitiesObject:(Responsibility *)value;
- (void)removeResponsibilitiesObject:(Responsibility *)value;
- (void)addResponsibilities:(NSSet *)values;
- (void)removeResponsibilities:(NSSet *)values;

- (void)addValuePropositionsObject:(ValueProposition *)value;
- (void)removeValuePropositionsObject:(ValueProposition *)value;
- (void)addValuePropositions:(NSSet *)values;
- (void)removeValuePropositions:(NSSet *)values;

@end
