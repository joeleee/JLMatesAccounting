//
//  MATabAccountListTableHeader.m
//  MatesAccounting
//
//  Created by Lee on 13-11-27.
//  Copyright (c) 2013年 Lee. All rights reserved.
//

#import "MATabAccountListTableHeader.h"

@interface MATabAccountListTableHeader ()

@property (weak, nonatomic) IBOutlet UILabel *headerTitleLabel;

@end

@implementation MATabAccountListTableHeader

- (MATabAccountListTableHeader *)initWithHeaderTitle:(NSString *)title
{
    NSArray *nibArray = [[NSBundle mainBundle]loadNibNamed:@"MAViews" owner:self options:nil];
    self = nibArray[0];

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