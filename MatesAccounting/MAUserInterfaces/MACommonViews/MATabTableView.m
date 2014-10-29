//
//  MATabTableView.m
//  MatesAccounting
//
//  Created by Joe Lee on 2014-10-30.
//  Copyright (c) 2014年 Lee. All rights reserved.
//

#import "MATabTableView.h"

@implementation MATabTableView

- (void)setContentInset:(UIEdgeInsets)contentInset
{
    contentInset.top = MA_STATUSBAR_HEIGHT + MA_NAVIGATIONBAR_HEIGHT;
    contentInset.bottom = MA_TABBAR_HEIGHT;
    [super setContentInset:contentInset];
    [self setScrollIndicatorInsets:contentInset];
}

- (void)setScrollIndicatorInsets:(UIEdgeInsets)scrollIndicatorInsets
{
    scrollIndicatorInsets.top = MA_STATUSBAR_HEIGHT + MA_NAVIGATIONBAR_HEIGHT;
    scrollIndicatorInsets.bottom = MA_TABBAR_HEIGHT;
    [super setScrollIndicatorInsets:scrollIndicatorInsets];
}

@end