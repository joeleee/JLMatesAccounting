//
//  NSDate+MAAddition.m
//  MatesAccounting
//
//  Created by Lee on 13-12-8.
//  Copyright (c) 2013年 Lee. All rights reserved.
//

#import "NSDate+MAAddition.h"

double const oneDaySeconds = 24 * 60 * 60;

@implementation NSDate (MAAddition)

- (NSString *)dateToString:(NSString *)format
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:format];
    NSString *dateString = [formatter stringFromDate:self];

    return dateString;
}

+ (NSDate *)dateWithString:(NSString *)dateString format:(NSString *)format
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:format];
    NSDate *date = [formatter dateFromString:dateString];

    return date;
}

- (NSDateComponents *)dateComponents
{
    NSInteger unitFlags = NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit | NSWeekdayCalendarUnit |
    NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit;

    NSDateComponents *dateComponent = [[NSCalendar currentCalendar] components:unitFlags fromDate:self];

    return dateComponent;
}

@end