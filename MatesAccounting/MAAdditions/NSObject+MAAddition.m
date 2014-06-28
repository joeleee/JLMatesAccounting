//
//  NSObject+MAAddition.m
//  MatesAccounting
//
//  Created by Lee on 13-11-29.
//  Copyright (c) 2013年 Lee. All rights reserved.
//

#if (TARGET_OS_IPHONE)

#import "NSObject+MAAddition.h"

#import <objc/runtime.h>

@implementation NSObject (MAAddition)

+ (NSString *)className
{
	return [NSString stringWithUTF8String:class_getName(self)];
}

- (NSString *)className
{
	return [NSString stringWithUTF8String:class_getName([self class])];
}

@end

#endif