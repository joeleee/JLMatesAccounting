//
//  MAAccountDetailPayersCell.m
//  MatesAccounting
//
//  Created by Lee on 13-12-1.
//  Copyright (c) 2013年 Lee. All rights reserved.
//

#import "MAAccountDetailPayersCell.h"

@interface MAAccountDetailPayersCell ()

@property (weak, nonatomic) IBOutlet UILabel *payersTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *payersDescriptionLabel;

@end

@implementation MAAccountDetailPayersCell

- (id)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super initWithCoder:aDecoder]) {
    }

    return self;
}

- (void)awakeFromNib
{
    self.payersTitleLabel.textColor = MA_COLOR_TABACCOUNT_DETAIL_INFO_TITLE;
    self.payersDescriptionLabel.textColor = MA_COLOR_TABACCOUNT_DETAIL_INFO_LABEL;
}

- (void)reuseCellWithData:(NSString *)data
{
    [self.payersDescriptionLabel setText:data];
    if (self.status) {
        [self setSelectionStyle:UITableViewCellSelectionStyleDefault];
        [self setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
    } else {
        [self setSelectionStyle:UITableViewCellSelectionStyleNone];
        [self setAccessoryType:UITableViewCellAccessoryNone];
    }
}

+ (CGFloat)cellHeight:(id)data
{
    return 40.0f;
}

@end