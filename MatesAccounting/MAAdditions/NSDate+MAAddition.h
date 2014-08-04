//
//  NSDate+MAAddition.h
//  MatesAccounting
//
//  Created by Lee on 13-12-8.
//  Copyright (c) 2013年 Lee. All rights reserved.
//

#import <Foundation/Foundation.h>

extern NSTimeInterval const oneDaySeconds;

@interface NSDate (MAAddition)

/**
 * format example: @"yyyy-MM-dd"
 */
- (NSString *)dateToString:(NSString *)format;

+ (NSDate *)dateWithString:(NSString *)dateString format:(NSString *)format;

- (NSDateComponents *)dateComponents;

@end