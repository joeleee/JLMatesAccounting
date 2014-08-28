//
//  MATabAccountGroupInfoCell.m
//  MatesAccounting
//
//  Created by Lee on 13-11-28.
//  Copyright (c) 2013年 Lee. All rights reserved.
//

#import "MATabAccountGroupInfoCell.h"

#import "MGroup.h"
#import "MAccount+expand.h"

@interface MATabAccountGroupInfoCell () <MAManualLayoutAfterLayoutSubviewsProtocol>

@property (weak, nonatomic) IBOutlet UIView *miniBackgroundView;
@property (weak, nonatomic) IBOutlet UILabel *memberCountTitle;
@property (weak, nonatomic) IBOutlet UILabel *memberCountLabel;
@property (weak, nonatomic) IBOutlet UILabel *accountCountTitle;
@property (weak, nonatomic) IBOutlet UILabel *accountCountLabel;
@property (weak, nonatomic) IBOutlet UILabel *totalFeesTitle;
@property (weak, nonatomic) IBOutlet UILabel *totalFeesLabel;
@property (weak, nonatomic) IBOutlet UILabel *groupNameLabel;

@end

@implementation MATabAccountGroupInfoCell

- (id)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super initWithCoder:aDecoder]) {
        [self needManualLayoutAfterLayoutSubviews];
    }

    return self;
}

- (void)reuseCellWithData:(MGroup *)data
{
    [self refreshUIWithGroup:data];
}

- (void)refreshUIWithGroup:(MGroup *)group
{
    [self.groupNameLabel setText:group.groupName];

    [self.memberCountLabel setText:[@([group.relationshipToMember count]) stringValue]];

    [self.accountCountLabel setText:[@([group.accounts count]) stringValue]];

    NSDecimalNumber *totalFee = DecimalZero;
    for (MAccount *account in group.accounts) {
        totalFee = [totalFee decimalNumberByAdding:account.totalFee];
    }
    [self.totalFeesLabel setText:[totalFee stringValue]];
}

#pragma mark MAManualLayoutAfterLayoutSubviewsProtocol
- (void)manualLayoutAfterLayoutSubviews
{
    [self.groupNameLabel setTextColor:MA_COLOR_TABACCOUNT_GROUP_NAME];
    [self.memberCountLabel setTextColor:MA_COLOR_TABACCOUNT_GROUP_NAME];
    [self.memberCountTitle setTextColor:MA_COLOR_GROUP_GROUP_TITLE];
    [self.accountCountLabel setTextColor:MA_COLOR_TABACCOUNT_GROUP_NAME];
    [self.accountCountTitle setTextColor:MA_COLOR_GROUP_GROUP_TITLE];
    [self.totalFeesLabel setTextColor:MA_COLOR_TABACCOUNT_ACCOUNT_COAST];
    [self.totalFeesTitle setTextColor:MA_COLOR_GROUP_GROUP_TITLE];
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