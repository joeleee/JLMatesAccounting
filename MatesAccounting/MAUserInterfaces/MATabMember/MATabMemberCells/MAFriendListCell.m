//
//  MAFriendListCell.m
//  MatesAccounting
//
//  Created by Lee on 13-12-14.
//  Copyright (c) 2013年 Lee. All rights reserved.
//

#import "MAFriendListCell.h"

#import "MFriend.h"
#import "RMemberToAccount.h"

@interface MAFriendListCell () <MAManualLayoutAfterLayoutSubviewsProtocol>

@property (weak, nonatomic) IBOutlet UILabel *friendNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *phoneTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *phoneNumberLabel;
@property (weak, nonatomic) IBOutlet UILabel *eMailLabel;
@property (weak, nonatomic) IBOutlet UILabel *accountTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *accountCountLabel;
@property (weak, nonatomic) IBOutlet UILabel *groupTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *groupCountLabel;
@property (weak, nonatomic) IBOutlet UIView *dividingLineView;

@property (nonatomic, strong) MFriend *friend;

@end

@implementation MAFriendListCell

- (id)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super initWithCoder:aDecoder]) {
        [self needManualLayoutAfterLayoutSubviews];
    }

    return self;
}

- (void)setSelected:(BOOL)selected
{
    [super setSelected:selected];
    self.backgroundColor = selected ? MA_COLOR_TABMEMBER_SELECTED_BACKGROUND : MA_COLOR_VIEW_BACKGROUND;
}

- (void)reuseCellWithData:(MFriend *)data
{
    if (self.friend == data) {
        return;
    }
    self.friend = data;

    [self.friendNameLabel setText:data.name];
    [self.phoneNumberLabel setText:[data.telephoneNumber stringValue]];
    if (0 < data.eMail.length) {
        [self.eMailLabel setText:data.eMail];
    } else {
        [self.eMailLabel setText:@"With out E-mail"];
    }
    NSMutableSet *accountSet = [NSMutableSet set];
    for (RMemberToAccount *memberToAccount in data.relationshipToAccount) {
        [accountSet addObject:memberToAccount.account];
    }
    [self.accountCountLabel setText:[@(accountSet.count) stringValue]];
    [self.groupCountLabel setText:[@(data.relationshipToGroup.count) stringValue]];
}

+ (CGFloat)cellHeight:(id)data
{
    return 50.0f;
}

+ (NSString *)reuseIdentifier
{
    return [self className];
}

#pragma mark MAManualLayoutAfterLayoutSubviewsProtocol
- (void)manualLayoutAfterLayoutSubviews
{
    self.backgroundColor = MA_COLOR_VIEW_BACKGROUND;
    self.friendNameLabel.textColor = MA_COLOR_TABMEMBER_PAYER_NAME;
    self.phoneTitleLabel.textColor = MA_COLOR_TABMEMBER_BALANCE_TITLE;
    self.phoneNumberLabel.textColor = MA_COLOR_TABMEMBER_BALANCE_TITLE;
    self.eMailLabel.textColor = MA_COLOR_TABMEMBER_BALANCE_TITLE;
    self.accountTitleLabel.textColor = MA_COLOR_TABMEMBER_BALANCE_TITLE;
    self.accountCountLabel.textColor = MA_COLOR_TABMEMBER_BALANCE;
    self.groupTitleLabel.textColor = MA_COLOR_TABMEMBER_BALANCE_TITLE;
    self.groupCountLabel.textColor = MA_COLOR_TABMEMBER_BALANCE;
    self.dividingLineView.backgroundColor = MA_COLOR_TABMEMBER_DIVIDING_LINE;
}

@end