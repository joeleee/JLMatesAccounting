//
//  MAMemberAccountListCell.m
//  MatesAccounting
//
//  Created by Joe Lee on 2014-9-21.
//  Copyright (c) 2014年 Lee. All rights reserved.
//

#import "MAMemberAccountListCell.h"

#import "MAccount+expand.h"
#import "RMemberToAccount.h"
#import "MFriend.h"

@interface MAMemberAccountListCell () <MAManualLayoutAfterLayoutSubviewsProtocol>

@end

@implementation MAMemberAccountListCell

- (id)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super initWithCoder:aDecoder]) {
        [self needManualLayoutAfterLayoutSubviews];
    }

    return self;
}

- (void)reuseCellWithData:(id)data
{
    MAccount *account = data;
    [self.accountDetailLabel setText:account.detail];
    [self.accountTimeLabel setText:[account.accountDate dateToString:@"yyy-MM-dd HH:mm"]];
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

#pragma mark MAManualLayoutAfterLayoutSubviewsProtocol
- (void)manualLayoutAfterLayoutSubviews
{
    [self.accountDetailLabel setTextColor:MA_COLOR_TABACCOUNT_ACCOUNT_DETAIL];
    [self.accountTimeLabel setTextColor:MA_COLOR_TABACCOUNT_TIME];
    [self.accountTotalFeeLabel setTextColor:MA_COLOR_TABACCOUNT_ACCOUNT_COAST];
    [self.payerNameLabel setTextColor:MA_COLOR_TABACCOUNT_USER_NAME];
    [self.dividingLineView setBackgroundColor:MA_COLOR_TABACCOUNT_DIVIDING_LINE];
}

@end