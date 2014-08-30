//
//  MAAccountDetailSectionHeader.m
//  MatesAccounting
//
//  Created by Lee on 13-12-1.
//  Copyright (c) 2013年 Lee. All rights reserved.
//

#import "MAAccountDetailSectionHeader.h"

CGFloat const kAccountDetailSectionHeaderHeight = 30.0f;

@interface MAAccountDetailSectionHeader ()

@end

@implementation MAAccountDetailSectionHeader

- (id)initWithReuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithReuseIdentifier:reuseIdentifier]) {
        [self.contentView setBackgroundColor:MA_COLOR_TABACCOUNT_TABLE_HEADER_BACKGROUND];
        self.contentView.layer.shadowColor = MA_COLOR_TABACCOUNT_TABLE_HEADER_SHADOW.CGColor;
        self.contentView.layer.shadowOpacity = 0.2;
        self.contentView.layer.shadowRadius = 3;
        self.contentView.layer.shadowOffset = CGSizeMake(0, 0.1);
        [self.textLabel setTextColor:MA_COLOR_TABACCOUNT_TABLE_HEADER_TITLE];
    }

    return  self;
}

- (void)reuseWithHeaderTitle:(NSString *)title
{
    self.textLabel.text = title;
}

@end