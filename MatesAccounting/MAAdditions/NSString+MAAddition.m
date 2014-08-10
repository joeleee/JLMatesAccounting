//
//  NSString+MAAddition.m
//  MatesAccounting
//
//  Created by Joe Lee on 2014-8-10.
//  Copyright (c) 2014年 Lee. All rights reserved.
//

#import "NSString+MAAddition.h"

@implementation NSString (MAAddition)

- (BOOL)isTwoDecimalPlaces
{
    NSRange decimalRange = [self rangeOfString:@"."];
    if (decimalRange.location != [self rangeOfString:@"." options:NSBackwardsSearch].location) {
        return NO;
    } else if (NSNotFound != decimalRange.location &&
               decimalRange.location + decimalRange.length < self.length - 2) {
        return NO;
    }

    return YES;
}

@end