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

@property (weak, nonatomic) IBOutlet UILabel *headerTitleLabel;

@end

@implementation MAAccountDetailSectionHeader

- (MAAccountDetailSectionHeader *)initWithHeaderTitle:(NSString *)title
{
    NSArray *nibArray = [[NSBundle mainBundle]loadNibNamed:@"MATabAccountViews" owner:self options:nil];
    self = nibArray[1];

    if (self) {
        self.headerTitleLabel.text = title;
    }

    return self;
}

- (void)setHeaderTitle:(NSString *)headerTitle
{
    self.headerTitleLabel.text = headerTitle;
}

@end