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

#define MA_QUICK_ASSERT(value, message) NSAssert(value, @"MA Assert Wrong - %@ : %s %@", message, __FUNCTION__, [self class])

#define MALogInfo(...) NSLog(__VA_ARGS__)
#define MALogError(...) NSLog(__VA_ARGS__)

#define MALogTestInfo(...) NSLog(__VA_ARGS__)

#define MA_HIDE_KEYBOARD [[UIApplication sharedApplication] sendAction:@selector(resignFirstResponder) to:nil from:nil forEvent:nil]

#define MA_STATUSBAR_HEIGHT (20.0f)
#define MA_NAVIGATIONBAR_HEIGHT ((UIDeviceOrientationLandscapeLeft == [[UIDevice currentDevice] orientation] || UIDeviceOrientationLandscapeRight == [[UIDevice currentDevice] orientation]) ? 32.0f : [[[[UIApplication sharedApplication] rootNavigationController] navigationBar] height])
#define MA_TABBAR_HEIGHT [[[[UIApplication sharedApplication] rootTabBarController] tabBar] height]

#endif /* ifndef MAGLOBALDEFINITIONS_H */

#pragma mark - definition blocks
typedef void (^ PersistentBlock) (BOOL isSucceed, id data, NSError *error, NSDictionary *userInfo);

typedef enum {
    MAGenderUnknow = 0,
    MAGenderFemale = 1,
    MAGenderMale = 2
} MAGenderEnum;