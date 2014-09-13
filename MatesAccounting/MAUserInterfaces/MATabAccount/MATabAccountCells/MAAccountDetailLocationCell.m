//
//  MAAccountDetailLocationCell.m
//  MatesAccounting
//
//  Created by Lee on 13-12-1.
//  Copyright (c) 2013年 Lee. All rights reserved.
//

#import "MAAccountDetailLocationCell.h"

@interface MAAccountDetailLocationCell () <MAManualLayoutAfterLayoutSubviewsProtocol>

@property (weak, nonatomic) IBOutlet UILabel *locationTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *locationDescriptionLabel;

@end

@implementation MAAccountDetailLocationCell

- (id)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super initWithCoder:aDecoder]) {
        [self needManualLayoutAfterLayoutSubviews];
    }

    return self;
}

- (void)reuseCellWithData:(NSString *)data
{
    [self.locationDescriptionLabel setText:data];
    if (self.status) {
        [self setSelectionStyle:UITableViewCellSelectionStyleNone];
        [self setAccessoryType:UITableViewCellAccessoryNone];
    } else {
        [self setSelectionStyle:UITableViewCellSelectionStyleNone];
        [self setAccessoryType:UITableViewCellAccessoryNone];
    }
}

+ (CGFloat)cellHeight:(id)data
{
    return 40.0f;
}

#pragma mark MAManualLayoutAfterLayoutSubviewsProtocol
- (void)manualLayoutAfterLayoutSubviews
{
    self.locationTitleLabel.textColor = MA_COLOR_TABACCOUNT_DETAIL_INFO_TITLE;
    self.locationDescriptionLabel.textColor = MA_COLOR_TABACCOUNT_DETAIL_INFO_LABEL;
}

@end