//
//  Trip.h
//  chtrips
//
//  Created by Hisoka on 15/3/17.
//  Copyright (c) 2015年 HSK.ltd. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Trip : NSManagedObject

@property (nonatomic, retain) NSNumber * endDate;
@property (nonatomic, retain) NSData * frontData;
@property (nonatomic, retain) NSString * keyID;
@property (nonatomic, retain) NSNumber * startDate;
@property (nonatomic, retain) NSString * tripName;

@end
