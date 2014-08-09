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
    [self.view setBackgroundColor:[UIColor whiteColor]];

    [[[UIApplication sharedApplication] rootTabBarController] setDelegate:self];

    NSUInteger tabIndex = [[NSUserDefaults standardUserDefaults] integerForKey:kLastSelectedTabIndex];
    if (tabIndex < [[UIApplication sharedApplication] rootTabBarController].viewControllers.count) {
        [[[UIApplication sharedApplication] rootTabBarController] setSelectedIndex:tabIndex];
    }
}

#pragma mark - UITabBarControllerDelegate
- (void)tabBarController:(UITabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController
{
    NSUInteger tabIndex = [tabBarController.viewControllers indexOfObject:viewController];
    [[NSUserDefaults standardUserDefaults] setInteger:tabIndex forKey:kLastSelectedTabIndex];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

@end