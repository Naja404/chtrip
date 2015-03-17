//
//  SubTrip.h
//  chtrips
//
//  Created by Hisoka on 15/3/17.
//  Copyright (c) 2015年 HSK.ltd. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface SubTrip : NSManagedObject

@property (nonatomic, retain) NSString * keyID;
@property (nonatomic, retain) NSString * subAddress;
@property (nonatomic, retain) NSNumber * subDate;
@property (nonatomic, retain) NSNumber * subEndTime;
@property (nonatomic, retain) NSString * subLat;
@property (nonatomic, retain) NSString * subLng;
@property (nonatomic, retain) NSNumber * subStartTime;
@property (nonatomic, retain) NSString * subTitle;

@end
