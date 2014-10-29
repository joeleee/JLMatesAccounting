//
//  UIApplication+MAAddition.m
//  MatesAccounting
//
//  Created by Joe Lee on 2014-8-8.
//  Copyright (c) 2014年 Lee. All rights reserved.
//

#import "UIApplication+MAAddition.h"

@implementation UIApplication (MAAddition)

- (MAAppDelegate *)appDelegate
{
    MA_ASSERT([self.delegate isKindOfClass:MAAppDelegate.class], @"Application delegate is not MAAppDelegate.class");
    return self.delegate;
}

- (MARootNavigationController *)rootNavigationController
{
    id rootNavigationController = [[self.delegate window] rootViewController];
    MA_ASSERT([rootNavigationController isKindOfClass:MARootNavigationController.class], @"Root NavigationController is not MARootNavigationController.class");

    return rootNavigationController;
}

- (MARootTabBarController *)rootTabBarController
{
    id rootTabBarController = [[self rootNavigationController] viewControllers][0];
    MA_ASSERT([rootTabBarController isKindOfClass:MARootTabBarController.class], @"Root TabBarController is not MARootTabBarController.class");

    return rootTabBarController;
}

@end