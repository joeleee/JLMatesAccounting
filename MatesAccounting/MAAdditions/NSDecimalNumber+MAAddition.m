//
//  NSDecimalNumber+MAAddition.m
//  MatesAccounting
//
//  Created by Joe Lee on 2014-8-12.
//  Copyright (c) 2014年 Lee. All rights reserved.
//

#import "NSDecimalNumber+MAAddition.h"

@implementation NSDecimalNumber (MAAddition)

- (NSDecimalNumber *)inverseNumber
{
    NSDecimalNumber *inverse = [self decimalNumberByMultiplyingBy:MAIntegerDecimal(-1)];
    return inverse;
}

@end