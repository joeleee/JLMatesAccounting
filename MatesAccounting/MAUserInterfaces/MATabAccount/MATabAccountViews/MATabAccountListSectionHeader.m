//
//  MATabAccountListSectionHeader.m
//  MatesAccounting
//
//  Created by Lee on 13-11-28.
//  Copyright (c) 2013年 Lee. All rights reserved.
//

#import "MATabAccountListSectionHeader.h"

CGFloat const kTabAccountListSectionHeaderHeight = 30.0f;

@interface MATabAccountListSectionHeader ()

@end

@implementation MATabAccountListSectionHeader

- (id)initWithReuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithReuseIdentifier:reuseIdentifier]) {
        [self.contentView setBackgroundColor:MA_COLOR_TABLE_HEADER_BACKGROUND];
        self.contentView.layer.shadowColor = MA_COLOR_TABLE_HEADER_SHADOW.CGColor;
        self.contentView.layer.shadowOpacity = 0.2;
        self.contentView.layer.shadowRadius = 3;
        self.contentView.layer.shadowOffset = CGSizeMake(0, 0.1);
        [self.textLabel setTextColor:MA_COLOR_TABLE_HEADER_TITLE];
    }

    return  self;
}

- (void)reuseWithHeaderTitle:(NSString *)title
{
    self.textLabel.text = title;
}

@end