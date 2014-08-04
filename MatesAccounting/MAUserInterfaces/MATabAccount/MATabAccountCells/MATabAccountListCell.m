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
    [self.accountTimeLabel setText:[account.accountDate dateToString:@"HH:mm"]];
    [self.accountTotalFeeLabel setText:[account.totalFee stringValue]];
    [self.payerNameLabel setText:@"dsfdtw"];
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