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

@property (nonatomic, strong) UILabel *titleLabel;

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

        [self addSubview:self.titleLabel];
        [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-10-[_titleLabel]-10-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_titleLabel)]];
        [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-0-[_titleLabel]-0-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_titleLabel)]];
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
    [_titleLabel setTextColor:MA_COLOR_TABACCOUNT_TABLE_HEADER_TITLE];
    return _titleLabel;
}

@end