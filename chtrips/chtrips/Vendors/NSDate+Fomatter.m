//
//  NSDate+Fomatter.m
//  WithTrip
//
//  Created by Zhou Bin on 14-4-3.
//  Copyright (c) 2014年 Zhou Bin. All rights reserved.
//

#import "NSDate+Fomatter.h"
#import "NSDate-Utilities.h"

@implementation WTDateDistanceObject
@end

@implementation NSDate (Formatter)

- (BOOL)isChinese {
    NSString *language = [[NSLocale preferredLanguages] objectAtIndex:0];
    
    return [language isEqualToString:@"zh-Hans"];
}

- (NSDate *)startOfMonth
{
    NSCalendar * calendar = [NSCalendar currentCalendar];
    
    NSDateComponents * currentDateComponents = [calendar components: NSYearCalendarUnit | NSMonthCalendarUnit fromDate: self];
    NSDate * startOfMonth = [calendar dateFromComponents: currentDateComponents];
    
    return startOfMonth;
}

- (NSDate *) dateByAddingMonths: (NSInteger) monthsToAdd
{
    NSCalendar * calendar = [NSCalendar currentCalendar];
    
    NSDateComponents * months = [[NSDateComponents alloc] init];
    [months setMonth: monthsToAdd];
    
    return [calendar dateByAddingComponents: months toDate: self options: 0];
}

- (NSDate *) endOfMonth
{
    NSCalendar * calendar = [NSCalendar currentCalendar];
    
    NSDate * plusOneMonthDate = [self dateByAddingMonths: 1];
    NSDateComponents * plusOneMonthDateComponents = [calendar components: NSYearCalendarUnit | NSMonthCalendarUnit fromDate: plusOneMonthDate];
    NSDate * endOfMonth = [[calendar dateFromComponents: plusOneMonthDateComponents] dateByAddingTimeInterval: -1]; // One second before the start of next month
    
    return endOfMonth;
}

- (NSString *)monthAndDay {

    NSDateFormatter *f = [[NSDateFormatter alloc] init];
    
    if ([self isChinese]) {
        f.dateFormat = @"MMMdd日";
    }else {
        f.dateFormat = @"MMM/dd";
    }
    
    return [f stringFromDate:self];
}

//返回 “星期x” 描述
- (NSString *)weekDayDescription {
    NSDateFormatter *f = [[NSDateFormatter alloc] init];
    f.dateFormat = @"eeee";
    return [f stringFromDate:self];
}

- (NSString *)monthAndDayWithWeekDayDescription {
    NSString *monthAndDay = [self monthAndDay];
    return [NSString stringWithFormat:@"%@ %@", monthAndDay, [self weekDayDescription]];
}

- (NSString *)monthAndDayWithSeparator:(NSString *)sep {
    NSDateComponents *components = [[NSCalendar currentCalendar] components:NSCalendarUnitDay | NSCalendarUnitMonth fromDate:self];
    NSString *dateString = [NSString stringWithFormat:@"%02ld%@%02ld",(long)components.month, sep, (long)components.day];
    return dateString;
}

- (NSString *)hourAndMinute {
    NSDateComponents *components = [[NSCalendar currentCalendar] components:NSCalendarUnitHour | NSCalendarUnitMinute fromDate:self];
    NSString *dateString = [NSString stringWithFormat:@"%02ld:%02ld",(long)components.hour,(long)components.minute];
    return dateString;
}

- (NSString *)monthAndDayDescriptionWithDateToSelf:(NSDate *)date {

    NSString *descString = nil;
    
    if ([self isYesterdayToSelf:date]) {
        descString = NSLocalizedString(@"yesterday", nil);
    }else
        
        if ([self isTodayToSelf:date]) {
            descString = NSLocalizedString(@"today", nil);
        }else
            
            if ([self isTomorrowToSelf:date]) {
                descString = NSLocalizedString(@"tomorrow", nil);
            }
    
    if (descString) {
        return [NSString stringWithFormat:@"%@", descString];
    }else{
            if ([self isChinese]) {
                return [NSString stringWithFormat:@"%ld年%@ %@",(long)[date year], [date monthAndDay], [date weekDayDescription]];
            }else {
                return [NSString stringWithFormat:@"%ld/%@ %@",(long)[date year], [date monthAndDay], [date weekDayDescription]];
            }
            
        }
    
    return @"-/-";

}

- (NSString *)monthAndDayWithDescription {
    NSString *monthAndDayString = [self monthAndDay];
    NSString *descString = nil;
    
    if ([self isYesterday]) {
        descString = NSLocalizedString(@"yesterday", nil);
    }else
    
    if ([self isToday]) {
        descString = NSLocalizedString(@"today", nil);
    }else
    
    if ([self isTomorrow]) {
        descString = NSLocalizedString(@"tomorrow", nil);
    }
    
    if (descString) {
        return [NSString stringWithFormat:@"%@ %@",monthAndDayString,descString];
    }else{
        if (![self isThisYear]) {
            
            if ([self isChinese]) {
                return [NSString stringWithFormat:@"%ld年%@ %@",(long)[self year], [self monthAndDay], [self weekDayDescription]];
            }else {
                return [NSString stringWithFormat:@"%ld/%@ %@",(long)[self year], [self monthAndDay], [self weekDayDescription]];
            }
            
        }else{
            return [self monthAndDayWithWeekDayDescription];
        }
        
    }
    
    return @"-/-";
}

- (BOOL)isTodayToSelf:(NSDate *)date {
    return [date isEqualToDateIgnoringTime:self];
}

- (BOOL)isYesterdayToSelf:(NSDate *)date {
    return [date isEqualToDateIgnoringTime:[self dateByAddingDays:-1]];
}

- (BOOL)isTomorrowToSelf:(NSDate *)date {
    return [date isEqualToDateIgnoringTime:[self dateByAddingDays:1]];
}

- (WTDateDistanceObject *)distanceFromToday {
    NSDate *now = [NSDate date];
    
    NSInteger minutesAfterNow = [self minutesAfterDate:now];
    if (minutesAfterNow < 60) {
        WTDateDistanceObject *object = [WTDateDistanceObject new];
        object.value = minutesAfterNow;
        object.unit = WTDateDistanceUnitMinute;
        if (minutesAfterNow < 10) {
            object.digitIntegerValue = minutesAfterNow;
            object.tenDigitIntegerValue = 0;
        }else {
            
            object.digitIntegerValue = minutesAfterNow % 10;
            object.tenDigitIntegerValue = minutesAfterNow / 10;
        }
        return object;
    }else {
        NSInteger hoursAfterNow = [self hoursAfterDate:now];
        WTDateDistanceObject *object = [WTDateDistanceObject new];
        object.value = hoursAfterNow;
        object.unit = WTDateDistanceUnitHour;
        if (hoursAfterNow < 24) {
            if (hoursAfterNow < 10) {
                object.digitIntegerValue = hoursAfterNow;
                object.tenDigitIntegerValue = 0;
            }else {
                object.digitIntegerValue = hoursAfterNow % 10;
                object.tenDigitIntegerValue = hoursAfterNow / 10;
            }
            return object;
        }else {
            NSInteger daysAfterNow = [NSDate natureDaysFromDate:[NSDate date] toDate:self];
            WTDateDistanceObject *object = [WTDateDistanceObject new];
            object.value = daysAfterNow;
            object.unit = WTDateDistanceUnitDay;
            if (daysAfterNow < 100) {
                if (daysAfterNow < 10) {
                    object.digitIntegerValue = daysAfterNow;
                    object.tenDigitIntegerValue = 0;
                }else {
                    object.digitIntegerValue = daysAfterNow % 10;
                    object.tenDigitIntegerValue = daysAfterNow / 10;
                }
                return object;
            }else {
                //大于100天
                WTDateDistanceObject *object = [WTDateDistanceObject new];
                object.unit = WTDateDistanceUnitMonth;
                object.digitIntegerValue = 3;
                object.tenDigitIntegerValue = 0;
                return object;
            }
        }
    }
    
    return nil;
}

- (NSString *)mediumStyleString {
    NSDateFormatter *f = [[NSDateFormatter alloc] init];
    f.dateStyle = NSDateFormatterMediumStyle;
    return [f stringFromDate:self];
}

- (NSString *)fullStyleString {
    NSString *string = [NSString stringWithFormat:@"%@ %@",[self mediumStyleString],[self hourAndMinute]];
    return string;
}

- (NSString *)fullStyleWithWeekDayDescriptionString {
    NSDateFormatter *f = [NSDateFormatter new];
    f.dateStyle = NSDateFormatterFullStyle;
    return [f stringFromDate:self];
}

- (NSString *)durationDescriptionToDate:(NSDate *)date {
    NSInteger hours = [self hoursBeforeDate:date];
    NSInteger minutes = [self minutesBeforeDate:date];
    NSInteger minutesModBySixty = minutes % 60;
    
    if (0 != hours) {
        return [NSString stringWithFormat:@"%ld%@%ld%@", (long)hours, NSLocalizedString(@"hours", nil), (long)minutesModBySixty, NSLocalizedString(@"minutes", nil)];
    }else {
        return [NSString stringWithFormat:@"%ld%@", (long)minutesModBySixty, NSLocalizedString(@"minutes", nil)];
    }
    
    return @"--";
}

- (NSInteger)natureDaysBeforeDate:(NSDate *)date {
    
    NSDate *fromDate;
    NSDate *toDate;
    
    NSCalendar *calendar = [NSCalendar currentCalendar];
    
    [calendar rangeOfUnit:NSDayCalendarUnit startDate:&fromDate
                 interval:NULL forDate:self];
    [calendar rangeOfUnit:NSDayCalendarUnit startDate:&toDate
                 interval:NULL forDate:date];
    
    NSDateComponents *difference = [calendar components:NSDayCalendarUnit
                                               fromDate:fromDate toDate:toDate options:0];
    
    return [difference day];
}


+ (NSInteger)natureDaysFromDate:(NSDate *)date1 toDate:(NSDate *)date2 {
    
    NSDate *fromDate;
    NSDate *toDate;
    
    NSCalendar *calendar = [NSCalendar currentCalendar];
    
    [calendar rangeOfUnit:NSDayCalendarUnit startDate:&fromDate
                 interval:NULL forDate:date1];
    [calendar rangeOfUnit:NSDayCalendarUnit startDate:&toDate
                 interval:NULL forDate:date2];
    
    NSDateComponents *difference = [calendar components:NSDayCalendarUnit
                                               fromDate:fromDate toDate:toDate options:0];
    
    return [difference day];
}


+ (NSDate *)tomorrowNoon {
    NSDate *tomorrow = [NSDate dateTomorrow];
    NSDate *tomorrowStart = [tomorrow dateAtStartOfDay];
    NSDate *tomorrowNoon = [tomorrowStart dateByAddingHours:12];
    return tomorrowNoon;
}


- (NSDate *)tomorrowNoon {
    NSDate *tomorrow = [self dateByAddingDays:1];
    NSDate *tomorrowStart = [tomorrow dateAtStartOfDay];
    NSDate *tomorrowNoon = [tomorrowStart dateByAddingHours:12];
    return tomorrowNoon;
}

+ (NSDate *) setupNoonByNum:(int)dayNum
{
    NSDate *setDay = [self dateTomorrow];
    NSDate *setDayStart = [setDay dateAtStartOfDay];
    NSDate *setDayNoon = [setDayStart dateByAddingHours:12];
    return setDayNoon;
}

- (NSDate *) setupNoonByNum:(int)dayNum
{
    NSDate *setDay = [self dateByAddingDays:dayNum];
    NSDate *setDayStart = [setDay dateAtStartOfDay];
    NSDate *setDayNoon = [setDayStart dateByAddingHours:12];
    return setDayNoon;
}

@end
