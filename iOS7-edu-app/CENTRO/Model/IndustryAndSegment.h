//
//  IndustryAndSegment.h
//  CENTRO
//
//  Created by Centro Community Partners on 10/24/13.
//  Copyright (c) 2013 Centro Community Partners. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface IndustryAndSegment : NSManagedObject

@property (nonatomic, retain) NSNumber * industryAndSegmentID;
@property (nonatomic, retain) NSString * industryCode;
@property (nonatomic, retain) NSString * industryLiteralUS;
@property (nonatomic, retain) NSNumber * isSegment;
@property (nonatomic, retain) NSString * segmentCode;
@property (nonatomic, retain) NSString * segmentLiteralUS;

@end
