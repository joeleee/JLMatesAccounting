//
//  MARootTabBarController.m
//  MatesAccounting
//
//  Created by Lee on 13-11-12.
//  Copyright (c) 2013年 Lee. All rights reserved.
//

#import "MARootTabBarController.h"

@interface MARootTabBarController ()

@end

@implementation MARootTabBarController

- (id)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super initWithCoder:aDecoder]) {
    }

    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [[UITabBar appearance] setBarTintColor:MA_COLOR_BAR_BACKGROUND];
    [[UITabBar appearance] setTintColor:MA_COLOR_BAR_ITEM];
}

@end