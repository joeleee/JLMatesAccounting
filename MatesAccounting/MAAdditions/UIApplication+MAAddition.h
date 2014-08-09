//
//  UIApplication+MAAddition.h
//  MatesAccounting
//
//  Created by Joe Lee on 2014-8-8.
//  Copyright (c) 2014年 Lee. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIApplication (MAAddition)

- (MAAppDelegate *)appDelegate;
- (MARootNavigationController *)rootNavigationController;
- (MARootTabBarController *)rootTabBarController;

@end