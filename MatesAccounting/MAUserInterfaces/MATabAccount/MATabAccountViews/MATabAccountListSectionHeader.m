//
//  MATabAccountListSectionHeader.m
//  MatesAccounting
//
//  Created by Lee on 13-11-28.
//  Copyright (c) 2013年 Lee. All rights reserved.
//

#import "MATabAccountListSectionHeader.h"

CGFloat const kTabAccountListSectionHeaderHeight = 20.0f;

@interface MATabAccountListSectionHeader ()

@property (weak, nonatomic) IBOutlet UILabel *headerTitleLabel;

@end

@implementation MATabAccountListSectionHeader

- (MATabAccountListSectionHeader *)initWithHeaderTitle:(NSString *)title
{
    NSArray *nibArray = [[NSBundle mainBundle]loadNibNamed:@"MATabAccountViews" owner:self options:nil];
    self = nibArray[0];

    if (self) {
        self.autoresizingMask = (UIViewAutoresizingFlexibleWidth |
                                 UIViewAutoresizingFlexibleHeight |
                                 UIViewAutoresizingFlexibleLeftMargin |
                                 UIViewAutoresizingFlexibleRightMargin |
                                 UIViewAutoresizingFlexibleTopMargin |
                                 UIViewAutoresizingFlexibleBottomMargin);
        self.headerTitleLabel.text = title;
    }

    return self;
}

- (void)setHeaderTitle:(NSString *)headerTitle
{
    self.headerTitleLabel.text = headerTitle;
}

@end