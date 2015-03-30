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
#import "BuyList.h"

@implementation ChtripCDManager

#pragma mark 获取所有行程
- (NSArray *) getAllTrip
{
    NSArray *allTrip = [Trip allWithOrder:@"startDate DESC"];
    
    return allTrip;
}

- (SubTrip *) subTripBysubID:(NSString *)subID
{
    return [SubTrip find:@"subID == %@", subID];
}

#pragma mark 根据keyID获取子行程的最后一天日期
- (NSArray *) getSubTripLastDateByKeyID:(NSString *)keyID
{
    NSArray *lastDate = [SubTrip where:@{@"keyID" : keyID}
                                 order:@{@"subDate" : @"DESC"}
                                 limit:@(1)];
    return lastDate;
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

#pragma mark 更新子行程
- (BOOL) updateSubTrip:(NSDictionary *)subTripData
{
    SubTrip *updateSubTrip = [self subTripBysubID:[subTripData objectForKey:@"subID"]];
    
//    updateSubTrip.subDate = [subTripData objectForKey:@"subDate"];
//    updateSubTrip.subEndTime = [subTripData objectForKey:@"subEndTime"];
//    updateSubTrip.subStartTime = [subTripData objectForKey:@"subStartTime"];
//    updateSubTrip.subTitle = [subTripData objectForKey:@"subTitle"];
//    updateSubTrip.subAddress = [subTripData objectForKey:@"subAddress"];
//    updateSubTrip.subLat = [subTripData objectForKey:@"subLat"];
//    updateSubTrip.subLng = [subTripData objectForKey:@"subLng"];
    [updateSubTrip update:subTripData];

    return [updateSubTrip save];
}

#pragma mark 添加购物清单
- (BOOL) addBuy:(NSDictionary *)buyData
{
    BuyList *buy = [BuyList create:buyData];
    
    return [buy save];
}

#pragma mark 获取购物清单更新数据
- (BuyList *) buyListWithbuyID:(NSString *)buyID
{
    return [BuyList find:@"buyID == %@", buyID];
}

#pragma mark 更新购物清单状态
- (BOOL) updateBuy:(NSDictionary *)buyData
{
    BuyList *updateBuyList = [self buyListWithbuyID:[buyData objectForKey:@"buyID"]];
    
    [updateBuyList update:buyData];
    
    return [updateBuyList save];
}

#pragma mark 删除子行程
- (void) deleteSubTrip:(NSString *)keyID subID:(NSString *)subID
{
    [[SubTrip find:@"keyID == %@ AND subID == %@", keyID, subID] delete];
}

#pragma mark 删除整天行程
- (void) deletesubTripWithDay:(NSString *)keyID subDate:(NSString *)subDate
{
    
    NSArray *subTripArr = [SubTrip where:@"keyID == %@ AND subDate == %@", keyID, subDate];
    
    if (![subTripArr isKindOfClass:[NSArray class]]) {
        NSLog(@"no");
    }
    
    for (NSArray *trips in subTripArr) {
        
            NSLog(@"%@", [trips objectAtIndex:2]);
//        [self deleteSubTrip:[trips objectForKey:@"keyID"] subID:[trips objectForKey:@"subID"]];
    }
    
}

#pragma mark 通过时间戳创建keyID
- (NSString *) makeKeyID
{
    UInt64 unixTime = [[NSDate date] timeIntervalSince1970] * 1000 + ((arc4random() % 501) + 500);
    
    return [NSString stringWithFormat:@"%llu", unixTime];
}

@end
