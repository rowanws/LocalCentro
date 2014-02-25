//
//  CustomerPriority.h
//  CENTRO
//
//  Created by Centro Community Partners on 10/24/13.
//  Copyright (c) 2013 Centro Community Partners. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class CustomerProfile;

@interface CustomerPriority : NSManagedObject

@property (nonatomic, retain) NSNumber * customerProfileID;
@property (nonatomic, retain) NSString * priorityCode;
@property (nonatomic, retain) NSNumber * priorityID;
@property (nonatomic, retain) NSString * priorityLiteralUS;
@property (nonatomic, retain) NSNumber * rank;
@property (nonatomic, retain) CustomerProfile *customerProfile;

@end
