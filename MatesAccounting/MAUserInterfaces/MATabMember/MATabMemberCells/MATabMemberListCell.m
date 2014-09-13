//
//  MATabMemberListCell.m
//  MatesAccounting
//
//  Created by Lee on 13-12-12.
//  Copyright (c) 2013年 Lee. All rights reserved.
//

#import "MATabMemberListCell.h"

#import "MFriend.h"
#import "MGroup+expand.h"
#import "MAGroupManager.h"
#import "RMemberToGroup+expand.h"

@interface MATabMemberListCell () <MAManualLayoutAfterLayoutSubviewsProtocol>

@property (weak, nonatomic) IBOutlet UILabel *memberNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *memberFeeTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *memberFeeLabel;
@property (weak, nonatomic) IBOutlet UIView *dividingLineView;

@end

@implementation MATabMemberListCell

- (id)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super initWithCoder:aDecoder]) {
        [self needManualLayoutAfterLayoutSubviews];
    }

    return self;
}

- (void)reuseCellWithData:(MFriend *)data
{
    [self.memberNameLabel setText:data.name];

    NSArray *relationToMembers = [MACurrentGroup relationshipToMembersByFriend:data];
    if (relationToMembers.count > 0) {
        RMemberToGroup *memberToGroup = relationToMembers[0];
        [self.memberFeeLabel setText:[memberToGroup.fee description]];

        NSComparisonResult result = [memberToGroup.fee compare:DecimalZero];
        if (NSOrderedAscending == result) {
            self.memberFeeLabel.textColor = MA_COLOR_TABACCOUNT_DETAIL_MEMBER_COAST;
        } else if (NSOrderedSame == result) {
            self.memberFeeLabel.textColor = MA_COLOR_TABACCOUNT_DETAIL_MEMBER_NULL;
        } else if (NSOrderedDescending == result) {
            self.memberFeeLabel.textColor = MA_COLOR_TABACCOUNT_DETAIL_MEMBER_PAY;
        }
    }
}

#pragma mark MAManualLayoutAfterLayoutSubviewsProtocol
- (void)manualLayoutAfterLayoutSubviews
{
    self.backgroundColor = MA_COLOR_VIEW_BACKGROUND;
    self.memberNameLabel.textColor = MA_COLOR_TABMEMBER_PAYER_NAME;
    self.memberFeeTitleLabel.textColor = MA_COLOR_TABMEMBER_BALANCE_TITLE;
    self.dividingLineView.backgroundColor = MA_COLOR_TABMEMBER_DIVIDING_LINE;
}

+ (CGFloat)cellHeight:(id)data
{
    return 80.0f;
}

@end