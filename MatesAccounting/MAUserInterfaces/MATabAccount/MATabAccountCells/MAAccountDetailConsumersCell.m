//
//  MAAccountDetailConsumersCell.m
//  MatesAccounting
//
//  Created by Lee on 13-12-1.
//  Copyright (c) 2013年 Lee. All rights reserved.
//

#import "MAAccountDetailConsumersCell.h"

@interface MAAccountDetailConsumersCell ()

@property (weak, nonatomic) IBOutlet UILabel *consumersTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *consumersDescriptionLabel;

@end

@implementation MAAccountDetailConsumersCell

- (id)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super initWithCoder:aDecoder]) {
    }

    return self;
}

- (void)awakeFromNib
{
    self.consumersTitleLabel.textColor = MA_COLOR_TABACCOUNT_DETAIL_INFO_TITLE;
    self.consumersDescriptionLabel.textColor = MA_COLOR_TABACCOUNT_DETAIL_INFO_LABEL;
}

- (void)reuseCellWithData:(id)data
{
    [self.consumersDescriptionLabel setText:data];
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