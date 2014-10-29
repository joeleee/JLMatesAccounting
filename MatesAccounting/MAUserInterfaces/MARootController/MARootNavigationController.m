//
//  MARootNavigationController.m
//  MatesAccounting
//
//  Created by Lee on 13-11-12.
//  Copyright (c) 2013年 Lee. All rights reserved.
//

#import "MARootNavigationController.h"

NSString * const kLastSelectedTabIndex = @"kLastSelectedTabIndex";

@interface MARootNavigationController () <UITabBarControllerDelegate>

@end

@implementation MARootNavigationController

- (id)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super initWithCoder:aDecoder]) {
    }

    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.view setBackgroundColor:MA_COLOR_VIEW_BACKGROUND];

    [[UINavigationBar appearance] setBarTintColor:MA_COLOR_BAR_BACKGROUND];
    [[UINavigationBar appearance] setTintColor:MA_COLOR_BAR_ITEM];
    NSShadow *shadow = [[NSShadow alloc] init];
    shadow.shadowColor = [UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.8];
    shadow.shadowOffset = CGSizeMake(0, 1);
    [[UINavigationBar appearance] setTitleTextAttributes:@{NSForegroundColorAttributeName: MA_COLOR_BAR_TITLE, NSShadowAttributeName: shadow, NSFontAttributeName: MA_FONT_BAR_TITLE}];

    [[[UIApplication sharedApplication] rootTabBarController] setDelegate:self];

    NSUInteger tabIndex = [[[NSUserDefaults standardUserDefaults] objectForKey:kLastSelectedTabIndex] unsignedIntegerValue];
    if (tabIndex < [[UIApplication sharedApplication] rootTabBarController].viewControllers.count) {
        [[[UIApplication sharedApplication] rootTabBarController] setSelectedIndex:tabIndex];
    }
}

- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}

#pragma mark - UITabBarControllerDelegate
- (void)tabBarController:(UITabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController
{
    NSUInteger tabIndex = [tabBarController.viewControllers indexOfObject:viewController];
    [[NSUserDefaults standardUserDefaults] setObject:@(tabIndex) forKey:kLastSelectedTabIndex];
    if (![[NSUserDefaults standardUserDefaults] synchronize]) {
        MA_ASSERT_FAILED(@"Set tabBar index failed!");
    }
}

@end