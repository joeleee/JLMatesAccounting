//
//  UIColor+MAAddition.h
//  MatesAccounting
//
//  Created by Lee on 13-12-7.
//  Copyright (c) 2013年 Lee. All rights reserved.
//

#import <UIKit/UIKit.h>

#define UIColorFromHexRGB(rgbValue)                             \
    [UIColor                                                    \
colorWithRed: ((CGFloat)((rgbValue & 0xFF0000) >> 16)) / 255.0f \
green: ((CGFloat)((rgbValue & 0x00FF00) >> 8)) / 255.0f         \
blue: ((CGFloat)(rgbValue & 0x0000FF)) / 255.0f                 \
alpha: 1.0f]

#define UIColorFromHexRGBA(rgbValue, alphaValue)                \
    [UIColor                                                    \
colorWithRed: ((CGFloat)((rgbValue & 0xFF0000) >> 16)) / 255.0f \
green: ((CGFloat)((rgbValue & 0x00FF00) >> 8)) / 255.0f         \
blue: ((CGFloat)(rgbValue & 0x0000FF)) / 255.0f                 \
alpha: alphaValue]

#define UIColorFromRGB(r, g, b)                   \
    [UIColor colorWithRed : ((CGFloat)r) / 255.0f \
    green : ((CGFloat)g) / 255.0f                 \
    blue : ((CGFloat)b) / 255.0f                  \
    alpha : 1.0f]

#define UIColorFromRGBA(r, g, b, a)               \
    [UIColor colorWithRed : ((CGFloat)r) / 255.0f \
    green : ((CGFloat)g) / 255.0f                 \
    blue : ((CGFloat)b) / 255.0f                  \
    alpha : (a)]

@interface UIColor (MAAddition)

@end