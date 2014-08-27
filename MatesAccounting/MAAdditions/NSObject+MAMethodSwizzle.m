//
//  NSObject+MAMethodSwizzle.m
//  MatesAccounting
//
//  Created by Joe Lee on 2014-8-27.
//  Copyright (c) 2014年 Lee. All rights reserved.
//

#import "NSObject+MAMethodSwizzle.h"

#import <objc/runtime.h>

@implementation NSObject (MAMethodSwizzle)

+ (BOOL)swizzlingClass:(Class)aClass originMethodSEL:(SEL)originMethodSEL newMethodSEL:(SEL)newMethodSEL isInstanceMethod:(BOOL)isInstanceMethod
{
    if (!aClass) {
        return NO;
    }

    Method originMethod = nil;
    Method newMethod = nil;
    if (isInstanceMethod) {
        originMethod = class_getInstanceMethod(aClass, originMethodSEL);
        newMethod = class_getInstanceMethod(aClass, newMethodSEL);
    } else {
        originMethod = class_getClassMethod(aClass, originMethodSEL);
        newMethod = class_getClassMethod(aClass, newMethodSEL);
    }

    if (!originMethod || !newMethod) {
        return NO;
    }

    method_exchangeImplementations(originMethod, newMethod);
    return YES;
}

@end