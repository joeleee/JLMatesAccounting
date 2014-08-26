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

@property (weak, nonatomic) IBOutlet UILabel *headerTitleLabel;

@end

@implementation MATabAccountListSectionHeader

- (MATabAccountListSectionHeader *)initWithHeaderTitle:(NSString *)title
{
    NSArray *nibArray = [[NSBundle mainBundle]loadNibNamed:@"MATabAccountViews" owner:self options:nil];
    self = nibArray[0];

    if (self) {
        [self setBackgroundColor:MA_COLOR_TABLE_HEADER_BACKGROUND];
        self.headerTitleLabel.text = title;
        [self.headerTitleLabel setTextColor:MA_COLOR_TABLE_HEADER_TITLE];
    }

    return self;
}

- (void)setHeaderTitle:(NSString *)headerTitle
{
    self.headerTitleLabel.text = headerTitle;
}

@end