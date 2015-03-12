//
//  SubTrip.h
//  chtrips
//
//  Created by Hisoka on 15/3/12.
//  Copyright (c) 2015年 HSK.ltd. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface SubTrip : NSManagedObject

@property (nonatomic, retain) NSString * keyID;
@property (nonatomic, retain) NSDate * subDate;
@property (nonatomic, retain) NSString * subStartTime;
@property (nonatomic, retain) NSString * subTitle;
@property (nonatomic, retain) NSString * subAddress;
@property (nonatomic, retain) NSString * subLat;
@property (nonatomic, retain) NSString * subLng;
@property (nonatomic, retain) NSString * subEndTime;

@end
