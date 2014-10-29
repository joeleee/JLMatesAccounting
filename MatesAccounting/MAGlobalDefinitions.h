//
//  MAGlobalDefinitions.h
//  MatesAccounting
//
//  Created by Lee on 13-11-15.
//  Copyright (c) 2013年 Lee. All rights reserved.
//

#import <Foundation/Foundation.h>

#ifndef MAGLOBALDEFINITIONS_H
  #define MAGLOBALDEFINITIONS_H

  #define MA_INVOKE_BLOCK_SAFELY(block, ...) { \
        if (block) {                         \
            block(__VA_ARGS__);              \
        }                                    \
}

#define MA_ASSERT(value, message) NSAssert(value, @"MA Assert Wrong - \"%@\" : %s %@", message, __FUNCTION__, [self class])
#define MA_ASSERT_FAILED(message) NSAssert(NO, @"MA Assert Failed - \"%@\" : %s %@", message, __FUNCTION__, [self class])

#define MALogInfo(...) NSLog(__VA_ARGS__)
#define MALogError(...) NSLog(__VA_ARGS__)

#define MALogTestInfo(...) NSLog(__VA_ARGS__)

#define MA_HIDE_KEYBOARD [[UIApplication sharedApplication] sendAction:@selector(resignFirstResponder) to:nil from:nil forEvent:nil]

#define MA_STATUSBAR_HEIGHT ([[UIApplication sharedApplication] statusBarFrame].size.height)
#define MA_NAVIGATIONBAR_HEIGHT ([[[[UIApplication sharedApplication] rootNavigationController] navigationBar] height])
#define MA_TABBAR_HEIGHT [[[[UIApplication sharedApplication] rootTabBarController] tabBar] height]

#endif /* ifndef MAGLOBALDEFINITIONS_H */

typedef enum {
    MAGenderUnknow = 0,
    MAGenderFemale = 1,
    MAGenderMale = 2
} MAGenderEnum;