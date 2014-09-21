//
//  MAMemberAccountListSectionHeader.m
//  MatesAccounting
//
//  Created by Joe Lee on 2014-9-21.
//  Copyright (c) 2014年 Lee. All rights reserved.
//

#import "MAMemberAccountListSectionHeader.h"

CGFloat const kMemberAccountListSectionHeaderHeight = 50.0f;

@interface MAMemberAccountListSectionHeader ()

@property (nonatomic, strong) UILabel *titleLabel;

@end

@implementation MAMemberAccountListSectionHeader

- (id)initWithReuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithReuseIdentifier:reuseIdentifier]) {
        [self.contentView setBackgroundColor:MA_COLOR_TABACCOUNT_TABLE_HEADER_BACKGROUND];

        [self addSubview:self.titleLabel];
        [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-10-[_titleLabel]-10-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_titleLabel)]];
        [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-5-[_titleLabel]-5-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_titleLabel)]];
    }

    return self;
}

- (void)reuseWithHeaderTitle:(NSString *)title
{
    self.titleLabel.text = title;
}

#pragma mark property
- (UILabel *)titleLabel
{
    if (_titleLabel) {
        return _titleLabel;
    }

    _titleLabel = [[UILabel alloc] init];
    _titleLabel.translatesAutoresizingMaskIntoConstraints = NO;
    _titleLabel.textAlignment = NSTextAlignmentCenter;
    [_titleLabel setTextColor:MA_COLOR_TABACCOUNT_GROUP_NAME];
    return _titleLabel;
}

@end