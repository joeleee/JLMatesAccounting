//
//  NSObject+MAMethodSwizzle.h
//  MatesAccounting
//
//  Created by Joe Lee on 2014-8-27.
//  Copyright (c) 2014年 Lee. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSObject (MAMethodSwizzle)

+ (BOOL)swizzlingClass:(Class)aClass originMethodSEL:(SEL)originMethodSEL newMethodSEL:(SEL)newMethodSEL isInstanceMethod:(BOOL)isInstanceMethod;

@end