//
//  NSDecimalNumber+MAAddition.h
//  MatesAccounting
//
//  Created by Joe Lee on 2014-8-12.
//  Copyright (c) 2014年 Lee. All rights reserved.
//

#import <Foundation/Foundation.h>

#define MATwoPreciseDecimal(double) [NSDecimalNumber decimalNumberWithString:[NSString stringWithFormat:@"%.2f", double]]
#define MAIntegerDecimal(integer) [NSDecimalNumber decimalNumberWithString:[NSString stringWithFormat:@"%d", integer]]
#define MAULongDecimal(ulong) [NSDecimalNumber decimalNumberWithString:[NSString stringWithFormat:@"%lu", ulong]]
#define DecimalZero [NSDecimalNumber zero]

@interface NSDecimalNumber (MAAddition)

- (NSDecimalNumber *)inverseNumber;

@end