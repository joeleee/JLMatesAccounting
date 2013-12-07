//
//  MAMemberListSectionHeader.m
//  MatesAccounting
//
//  Created by Lee on 13-12-7.
//  Copyright (c) 2013年 Lee. All rights reserved.
//

#import "MAMemberListSectionHeader.h"

@implementation MAMemberListSectionHeader

+ (id)headerViewInTableView:(UITableView *)tableView
{
    MAMemberListSectionHeader *headerView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:[self className]];
    if (!headerView) {
        headerView = [[MAMemberListSectionHeader alloc] initWithReuseIdentifier:[self className]];
    }

    return headerView;
}

- (id)initWithReuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithReuseIdentifier:reuseIdentifier]) {
        [self.textLabel setFont:[UIFont systemFontOfSize:16.0f]];
        [self.textLabel setTextColor:UIColorFromRGB(0, 64, 128)];
    }

    return self;
}

- (void)setHeaderTitle:(NSString *)headerTitle
{
    [self.textLabel setText:headerTitle];
}

@end