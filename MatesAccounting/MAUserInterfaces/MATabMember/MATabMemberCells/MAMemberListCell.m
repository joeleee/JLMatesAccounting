//
//  MAMemberListCell.m
//  MatesAccounting
//
//  Created by Lee on 13-12-7.
//  Copyright (c) 2013年 Lee. All rights reserved.
//

#import "MAMemberListCell.h"

#import "MFriend.h"
#import "MGroup+expand.h"
#import "RMemberToGroup+expand.h"
#import "MAGroupManager.h"

@interface MAMemberListCell () <MAManualLayoutAfterLayoutSubviewsProtocol>

@property (weak, nonatomic) IBOutlet UILabel *memberNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *totalFeeTitle;
@property (weak, nonatomic) IBOutlet UILabel *totalFeeLabel;
@property (weak, nonatomic) IBOutlet UILabel *phoneTitle;
@property (weak, nonatomic) IBOutlet UILabel *phoneLabel;
@property (weak, nonatomic) IBOutlet UIButton *memberInfoButton;

@property (nonatomic, strong) MFriend *member;

@end

@implementation MAMemberListCell

- (id)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super initWithCoder:aDecoder]) {
        [self needManualLayoutAfterLayoutSubviews];
    }

    return self;
}

- (void)reuseCellWithData:(MFriend *)data
{
    self.member = data;
    self.memberNameLabel.text = self.member.name;
    self.phoneLabel.text = [self.member.telephoneNumber stringValue];

    NSArray *relationToMembers = [MACurrentGroup relationshipToMembersByFriend:data];
    if (relationToMembers.count > 0) {
        RMemberToGroup *memberToGroup = relationToMembers[0];
        self.totalFeeLabel.text = [memberToGroup.fee description];

        NSComparisonResult result = [memberToGroup.fee compare:DecimalZero];
        if (NSOrderedAscending == result) {
            self.totalFeeLabel.textColor = MA_COLOR_TABACCOUNT_DETAIL_MEMBER_COAST;
        } else if (NSOrderedSame == result) {
            self.totalFeeLabel.textColor = MA_COLOR_TABACCOUNT_DETAIL_MEMBER_NULL;
        } else if (NSOrderedDescending == result) {
            self.totalFeeLabel.textColor = MA_COLOR_TABACCOUNT_DETAIL_MEMBER_PAY;
        }
    }
}

+ (CGFloat)cellHeight:(id)data
{
    return 65.0f;
}

+ (NSString *)reuseIdentifier
{
    return [self className];
}

- (IBAction)didInfoButtonTaped:(UIButton *)sender
{
    [self.actionDelegate actionWithData:self.member cell:self type:0];
}

#pragma mark MAManualLayoutAfterLayoutSubviewsProtocol
- (void)manualLayoutAfterLayoutSubviews
{
    self.memberNameLabel.textColor = MA_COLOR_TABMEMBER_MEMBERS_NAME;
    self.totalFeeTitle.textColor = MA_COLOR_TABMEMBER_BALANCE_TITLE;
    self.phoneTitle.textColor = MA_COLOR_TABMEMBER_BALANCE_TITLE;
    self.phoneLabel.textColor = MA_COLOR_TABMEMBER_DETAIL_TITLE;
}

@end