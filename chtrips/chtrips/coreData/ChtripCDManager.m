//
//  ChtripCDManager.m
//  chtrips
//
//  Created by Hisoka on 15/3/12.
//  Copyright (c) 2015年 HSK.ltd. All rights reserved.
//

#import "ChtripCDManager.h"

#import "Trip.h"
#import "SubTrip.h"

@implementation ChtripCDManager

#pragma mark 获取所有行程
- (NSArray *) getAllTrip
{
    NSArray *allTrip = [Trip allWithOrder:@"startDate DESC"];
    
    return allTrip;
}

#pragma mark 添加行程
- (BOOL) addTrip:(NSDictionary *)tripData
{
    Trip *newTrip = [Trip create:tripData];
    
    return [newTrip save];
}

#pragma mark 添加子行程sections
- (BOOL) addSubTripSections:(NSDictionary *)subTripData
{
    SubTrip *newSubTrip = [SubTrip create:subTripData];
    
    return [newSubTrip save];
}

#pragma mark 通过时间戳创建keyID
- (NSString *) makeKeyID
{
    UInt64 unixTime = [[NSDate date] timeIntervalSince1970] * 1000;
    
    return [NSString stringWithFormat:@"%llu", unixTime];
}


@end
