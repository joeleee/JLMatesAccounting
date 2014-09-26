//
//  MATabAccountListCell.m
//  MatesAccounting
//
//  Created by Lee on 13-11-27.
//  Copyright (c) 2013年 Lee. All rights reserved.
//

#import "MATabAccountListCell.h"

#import "MAccount+expand.h"
#import "RMemberToAccount.h"
#import "MFriend.h"

@interface MATabAccountListCell ()

@property (weak, nonatomic) IBOutlet UIView *miniBackgroundView;
@property (weak, nonatomic) IBOutlet UILabel *payerNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *accountTimeLabel;
@property (weak, nonatomic) IBOutlet UILabel *accountTotalFeeLabel;
@property (weak, nonatomic) IBOutlet UILabel *accountDetailLabel;
@property (weak, nonatomic) IBOutlet UIView *dividingLineView;

@end

@implementation MATabAccountListCell

- (id)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super initWithCoder:aDecoder]) {
    }

    return self;
}

- (void)awakeFromNib
{
    [self.accountDetailLabel setTextColor:MA_COLOR_TABACCOUNT_ACCOUNT_DETAIL];
    [self.accountTimeLabel setTextColor:MA_COLOR_TABACCOUNT_TIME];
    [self.accountTotalFeeLabel setTextColor:MA_COLOR_TABACCOUNT_ACCOUNT_COAST];
    [self.payerNameLabel setTextColor:MA_COLOR_TABACCOUNT_USER_NAME];
    [self.dividingLineView setBackgroundColor:MA_COLOR_TABACCOUNT_DIVIDING_LINE];
}

- (void)reuseCellWithData:(id)data
{
    MAccount *account = data;
    [self.accountDetailLabel setText:account.detail];
    [self.accountTimeLabel setText:[account.accountDate dateToString:@"HH:mm"]];
    [self.accountTotalFeeLabel setText:[account.totalFee stringValue]];

    NSSet *payers = [account.relationshipToMember filteredSetUsingPredicate:[NSPredicate predicateWithFormat:@"%K > 0", @"fee"]];
    NSString *payerString = [[(RMemberToAccount *)payers.allObjects.firstObject member] name];
    if (payers.count > 1) {
        unsigned long remainedCount = payers.count - 1;
        payerString = [NSString stringWithFormat:@"%@ (%lu more...)", payerString, remainedCount];
    }
    [self.payerNameLabel setText:payerString];
}

+ (CGFloat)cellHeight:(id)data
{
    return 80;
}

@end