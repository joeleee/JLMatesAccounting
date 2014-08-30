//
//  MAFriendListCell.m
//  MatesAccounting
//
//  Created by Lee on 13-12-14.
//  Copyright (c) 2013年 Lee. All rights reserved.
//

#import "MAFriendListCell.h"

#import "MFriend.h"

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

@end

@implementation MAFriendListCell

- (id)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super initWithCoder:aDecoder]) {
        [self needManualLayoutAfterLayoutSubviews];
    }

    return self;
}

- (void)reuseCellWithData:(MFriend *)data
{
    [self.friendNameLabel setText:data.name];
    [self.phoneNumberLabel setText:[data.telephoneNumber stringValue]];
    if (0 < data.eMail.length) {
        [self.eMailLabel setText:data.eMail];
    } else {
        [self.eMailLabel setText:@"With out E-mail"];
    }
    [self.accountCountLabel setText:[@(data.relationshipToAccount.count) stringValue]];
    [self.groupCountLabel setText:[@(data.relationshipToGroup.count) stringValue]];
}

#pragma mark MAManualLayoutAfterLayoutSubviewsProtocol
- (void)manualLayoutAfterLayoutSubviews
{
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

+ (CGFloat)cellHeight:(id)data
{
    return 50.0f;
}

+ (NSString *)reuseIdentifier
{
    return [self className];
}

@end