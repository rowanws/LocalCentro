//
//  Activity.h
//  CENTRO
//
//  Created by Centro Community Partners on 10/24/13.
//  Copyright (c) 2013 Centro Community Partners. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Student;

@interface Activity : NSManagedObject

@property (nonatomic, retain) NSNumber * activityID;
@property (nonatomic, retain) NSDate * completed;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSNumber * showCompletedScreen;
@property (nonatomic, retain) NSNumber * studentID;
@property (nonatomic, retain) NSNumber * synced;
@property (nonatomic, retain) NSNumber * turn;
@property (nonatomic, retain) Student *student;

@end
