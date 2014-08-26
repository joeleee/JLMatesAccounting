//
//  MATabAccountListCell.m
//  MatesAccounting
//
//  Created by Lee on 13-11-27.
//  Copyright (c) 2013年 Lee. All rights reserved.
//

#import "MATabAccountListCell.h"

#import "MAccount.h"

@interface MATabAccountListCell ()

@property (weak, nonatomic) IBOutlet UIView *miniBackgroundView;
@property (weak, nonatomic) IBOutlet UILabel *payerNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *accountTimeLabel;
@property (weak, nonatomic) IBOutlet UILabel *accountTotalFeeLabel;
@property (weak, nonatomic) IBOutlet UILabel *accountDetailLabel;

@end

@implementation MATabAccountListCell

- (id)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super initWithCoder:aDecoder]) {
    }

    return self;
}

- (void)reuseCellWithData:(id)data
{
    MAccount *account = data;
    [self.accountDetailLabel setText:account.detail];
    [self.accountDetailLabel setTextColor:MA_COLOR_ACCOUNT_DETAIL];

    [self.accountTimeLabel setText:[account.accountDate dateToString:@"HH:mm"]];
    [self.accountTimeLabel setTextColor:MA_COLOR_TIME];

    [self.accountTotalFeeLabel setText:[account.totalFee stringValue]];
    [self.accountTotalFeeLabel setTextColor:MA_COLOR_ACCOUNT_COAST];

    [self.payerNameLabel setText:@"dsfdtw"];
    [self.payerNameLabel setTextColor:MA_COLOR_USER_NAME];

    [self.dividingLineView setBackgroundColor:MA_COLOR_DIVIDING_LINE];
}

+ (CGFloat)cellHeight:(id)data
{
    return 0.0f;
}

+ (NSString *)reuseIdentifier
{
    return [self className];
}

@end