//
//  NSDate+Fomatter.h
//  WithTrip
//
//  Created by Zhou Bin on 14-4-3.
//  Copyright (c) 2014年 Zhou Bin. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, WTDateDistanceUnit){
    WTDateDistanceUnitMinute = 0,
    WTDateDistanceUnitHour,
    WTDateDistanceUnitDay,
    WTDateDistanceUnitMonth,
    WTDateDistanceUnitYear
};

@interface WTDateDistanceObject : NSObject
///单位，比如 “小时，天，年，分钟”
@property (nonatomic) WTDateDistanceUnit unit;
///个位数字
@property (nonatomic) NSInteger digitIntegerValue;
///十位数字
@property (nonatomic) NSInteger tenDigitIntegerValue;
///具体相差值 根据情况不同返回“天数”、“分钟”、“小时”等
@property (nonatomic) NSInteger value;
@end

@interface NSDate (Formatter)
///如："月/日"
- (NSString *)monthAndDay;

///一个月的第一天
- (NSDate *)startOfMonth;

///一个月的最后一天
- (NSDate *)endOfMonth;

///如：“月-日” 在monthAndDay的基础上，自定义分割符号
- (NSString *)monthAndDayWithSeparator:(NSString *)sep;

///如："17:13"
- (NSString *)hourAndMinute;

/**
 * 如果当前日期为，昨天、今天或后天，则加描述后缀
 * 如果不是今年的话，加上年份
 * 如："4/13 后天" “1970/02/01“
 */
- (NSString *)monthAndDayWithDescription;

/**
 * 根据self的值，给出与所给定date相关的描述
 */
- (NSString *)monthAndDayDescriptionWithDateToSelf:(NSDate *)date;

/**
 * 用于倒计时视图
 * 当差距小于1小时，返回以“分钟”为单位
 * 当差距小于24小时，返回以“小时”为单位
 * 当差距大于24小时时，返回以“天”为单位
 * 当差距大于99天时，返回03，单位为“月”，界面上应显示“大于3个月”
 */
- (WTDateDistanceObject *)distanceFromToday;

///描述性的年月日
- (NSString *)mediumStyleString;

///描述年月日和时间
- (NSString *)fullStyleString;

///描述年月日及周几
- (NSString *)fullStyleWithWeekDayDescriptionString;

///到特定日期的持续时间描述 “3小时12分钟”
- (NSString *)durationDescriptionToDate:(NSDate *)date;

///离某个日期还有多少自然日
- (NSInteger)natureDaysBeforeDate:(NSDate *)date;

///
+ (NSInteger)natureDaysFromDate:(NSDate *)date1 toDate:(NSDate *)date2;

//明天中午12点
+ (NSDate *)tomorrowNoon;

- (NSDate *)tomorrowNoon;

//几天后
+ (NSDate *) setupNoonByNum:(int)dayNum;

- (NSDate *) setupNoonByNum:(int)dayNum;


//对于当前的NSDate对象来说，date是 “昨天、今天、明天” 的判断
- (BOOL)isTodayToSelf:(NSDate *)date;
- (BOOL)isYesterdayToSelf:(NSDate *)date;
- (BOOL)isTomorrowToSelf:(NSDate *)date;

@end
