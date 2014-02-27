//
//  UIViewController+MAAddition.m
//  MatesAccounting
//
//  Created by Lee on 14-2-27.
//  Copyright (c) 2014年 Lee. All rights reserved.
//

#import "UIViewController+MAAddition.h"

@implementation UIViewController (MAAddition)

- (void)disappear:(BOOL)animated
{
    NSArray *viewControllers = [self.navigationController viewControllers];
    if (1 < [viewControllers count] && self == [viewControllers lastObject]) {
        [self.navigationController popViewControllerAnimated:animated];
    } else {
        [self.navigationController dismissViewControllerAnimated:animated completion:nil];
    }
}

@end