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
- (NSString *) deletesubTripWithDay:(NSString *)keyID subDate:(NSString *)subDate isAll:(BOOL)isAll
{
    // 是否要删除全部行程
    if (!isAll) {
        NSUInteger subTripCount = [SubTrip countWhere:@"keyID == %@ AND subTitle == %@", keyID, @"section"];
        
        if ((int)subTripCount <= 1) {
            return NSLocalizedString(@"TEXT_NOT_DELETE_LAST_DAY", Nil);
        }
    }
    
    NSArray *subTripArr = [SubTrip where:@"keyID == %@ AND subDate == %@", keyID, subDate];
    
    if (![subTripArr isKindOfClass:[NSArray class]]) {
        return NSLocalizedString(@"TEXT_DELETE_FAILD", Nil);
    }
    
    for (SubTrip *trips in subTripArr) {
        [self deleteSubTrip:trips.keyID subID:trips.subID];
    }
    
    if (!isAll) {
        [self updateSubTripWithDay:keyID subDate:subDate];
    }
    
    return NSLocalizedString(@"TEXT_DELETE_SUCCESS", Nil);
}

#pragma mark 删除行程下的欲购清单
- (void) deleteBuyList:(NSString *)keyID buyID:(NSString *)buyID
{
    [[BuyList find:@"keyID == %@ AND buyID == %@", keyID, buyID] delete];
}

#pragma mark 删除整条行程
- (void) deleteTrip:(NSString *)keyID
{
    NSArray *subTripArr = [SubTrip where:@"keyID == %@", keyID];
    
    // 删除子行程
    for (SubTrip *trips in subTripArr) {
        [self deletesubTripWithDay:keyID subDate:[NSString stringWithFormat:@"%@", trips.subDate] isAll:YES];
    }
    
    // 删除欲购清单
    NSArray *buyListArr = [BuyList where:@"keyID == %@", keyID];
    
    for (BuyList *buys in buyListArr) {
        [self deleteBuyList:buys.keyID buyID:buys.buyID];
    }
    
    // 删除行程
    
    [[Trip find:@"keyID == %@", keyID] delete];
}

#pragma mark 更新删除后的天事件
- (void) updateSubTripWithDay:(NSString *)keyID subDate:(NSString *)subDate
{
    NSString *whereStr = [NSString stringWithFormat:@"keyID == %@ AND subDate > %@", keyID, subDate];
    NSArray *subTripArr = [SubTrip where:whereStr order:@{@"subDate": @"ASC"}];
    
    for (SubTrip *trips in subTripArr) {

        int newSubDate = [trips.subDate doubleValue] - 3600 * 24;
        int newSubStartTime = [trips.subStartTime doubleValue] - 3600 * 24;
        
        if ([trips.subTitle isEqualToString:@"section"]) {
            newSubStartTime = 0;
        }
        
        NSDictionary *updateTrip = [[NSDictionary alloc] initWithObjectsAndKeys:trips.subID, @"subID",
                                                                                [NSNumber numberWithDouble:newSubDate], @"subDate",
                                                                                [NSNumber  numberWithDouble:newSubStartTime], @"subStartTime",
                                                                                [NSNumber  numberWithDouble:newSubStartTime], @"subEndTime",
                                                                                nil];
        [self updateSubTrip:updateTrip];
    }
    
}

#pragma mark 通过时间戳创建keyID
- (NSString *) makeKeyID
{
    UInt64 unixTime = [[NSDate date] timeIntervalSince1970] * 1000 + ((arc4random() % 501) + 500);
    
    return [NSString stringWithFormat:@"%llu", unixTime];
}

@end
