//
//  NSDate+RExtension.m
//  RTUsefulExtension
//
//  Created by ricky on 13-4-27.
//  Copyright (c) 2013年 ricky. All rights reserved.
//

#import "NSDate+RExtension.h"

static NSDateFormatter * _dateFormatter = nil;

@implementation NSDate (RExtension)

+ (void)load
{
    if (!_dateFormatter)
        _dateFormatter = [[NSDateFormatter alloc] init];
}

+ (NSDate*)dateFromString:(NSString *)string
{
    NSDate *date = nil;
    [_dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    date = [_dateFormatter dateFromString:string];
    if (!date) {
        NSLog(@"Convert string to date failed with string: %@",string);
    }
    return date;
}

+ (NSDate*)dateFromString:(NSString*)string
               withFormat:(NSString*)format
{    
    [_dateFormatter setDateFormat:format];
    return [_dateFormatter dateFromString:string];
}

- (NSString*)stringWithFormat:(NSString *)format
{
    [_dateFormatter setDateFormat:format];
    return [_dateFormatter stringFromDate:self];
}

- (NSString*)humanPreferredTimeString
{
    NSString *dateStr = @"秒前";
    if ([self timeIntervalSince1970] == 0)
        return nil;
    NSTimeInterval time = -ceilf([self timeIntervalSinceNow])+1;
    if (time > 60.0) {
        time /= 60;
        dateStr = @"分钟前";
        if (time > 60.0) {
            time /= 60;
            dateStr = @"小时前";
            if (time > 24.0) {
                time /= 24;
                dateStr = @"天前";
                if (time > 7) {     // 一星期以前的，直接显示时间
                    if (!_dateFormatter) {
                        _dateFormatter = [[NSDateFormatter alloc] init];
                    }
                    [_dateFormatter setDateFormat:@"MM月dd日 HH:mm"];
                    dateStr = [_dateFormatter stringFromDate:self];
                    return dateStr;
                }
            }
        }
    }
    dateStr = [NSString stringWithFormat:@"%d%@",(int)time,dateStr];
    return dateStr;
}

- (NSInteger)dayComponent
{
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *component = [calendar components:NSDayCalendarUnit
                                              fromDate:self];
    return component.day;
}

- (NSInteger)yearComponent
{
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *component = [calendar components:NSYearCalendarUnit
                                              fromDate:self];
    return component.year;
}

- (NSInteger)monthComponent
{
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *component = [calendar components:NSMonthCalendarUnit
                                              fromDate:self];
    return component.month;
}

- (NSInteger)hourComponent
{
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *component = [calendar components:NSHourCalendarUnit
                                              fromDate:self];
    return component.hour;
}

- (NSInteger)secondComponent
{
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *component = [calendar components:NSSecondCalendarUnit
                                              fromDate:self];
    return component.second;
}

- (NSInteger)minuteComponent
{
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *component = [calendar components:NSMinuteCalendarUnit
                                              fromDate:self];
    return component.minute;
}

- (NSInteger)weekComponent
{
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *component = [calendar components:NSWeekCalendarUnit
                                              fromDate:self];
    return component.week;
}

@end
