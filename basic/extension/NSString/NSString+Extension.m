//
//  NSString+Extension.m
//  YE
//
//  Created by huangdx on 2017/10/24.
//  Copyright © 2017年 ye.com. All rights reserved.
//

#import "NSString+Extension.h"

@implementation NSString (Extension)

- (NSDate *) date
{
    /*
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *minimumDateComponents = [calendar components:NSCalendarUnitDay | NSCalendarUnitMonth | NSCalendarUnitYear fromDate:[NSDate date]];
    [minimumDateComponents setYear:1900];
    NSDate *minDate = [calendar dateFromComponents:minimumDateComponents];
    NSDate *maxDate = [NSDate date];
    NSDate *selectDate = nil;
    if (self.length) {
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"yyyy年MM月dd日"];
        selectDate = [dateFormatter dateFromString:self];
    }
    return selectDate;
     */
    NSDate *resDate = nil;
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy年MM月dd日"];
    resDate = [dateFormatter dateFromString:self];
    return resDate;
}

+ (NSString *) dateStringFromTimeInterval:(NSInteger)timeInterval
{
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:timeInterval];
    NSLog(@"date_dsfr :%@",date);
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy年MM月dd日"];
    return [dateFormatter stringFromDate:date];
}

+ (NSString *) timeStringFromInteger:(NSInteger)timeInteger
{
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:timeInteger];
    NSLog(@"date_dsfr :%@",date);
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"hh:mm"];
    return [dateFormatter stringFromDate:date];
}

+ (NSString *) periodStringFromTimeInterval:(NSInteger)startTime to:(NSInteger)endTime
{
    NSLog(@"startTime:%ld endTime:%ld",startTime, endTime);
    NSString *startStr = [NSString timeStringFromInteger:startTime];
    NSString *endStr = [NSString timeStringFromInteger:endTime];
    NSLog(@"start str:%@ end str:%@",startStr, endStr);
    return [NSString stringWithFormat:@"%@-%@",startStr,endStr];
}

+ (NSString *) UUID
{
    CFUUIDRef uuidRef = CFUUIDCreate(NULL);
    CFStringRef uuid = CFUUIDCreateString(NULL, uuidRef);
    
    CFRelease(uuidRef);
    
    return (__bridge_transfer NSString *)uuid;
}

+ (NSString *) weekDayStringFromInteger:(NSInteger)dayNumber
{
    NSString *dayString = nil;
    if (dayNumber == 2)
    {
        dayString = @"二";
    }else if(dayNumber == 3)
    {
        dayString = @"三";
    }else if(dayNumber == 4)
    {
        dayString = @"四";
    }else if(dayNumber == 5)
    {
        dayString = @"五";
    }else if(dayNumber == 6)
    {
        dayString = @"六";
    }else if(dayNumber == 7)
    {
        dayString = @"日";
    }else
    {
        dayString = @"一";
    }
    return [NSString stringWithFormat:@"星期%@",dayString];
}
@end
