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

@interface MATabAccountGroupInfoCell ()

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
    [self.groupNameLabel setTextColor:MA_COLOR_LABEL];

    [self.memberCountLabel setText:[@([group.relationshipToMember count]) stringValue]];
    [self.memberCountLabel setTextColor:MA_COLOR_LABEL];
    [self.memberCountTitle setTextColor:MA_COLOR_SUB_TITLE];

    [self.accountCountLabel setText:[@([group.accounts count]) stringValue]];
    [self.accountCountLabel setTextColor:MA_COLOR_LABEL];
    [self.accountCountTitle setTextColor:MA_COLOR_SUB_TITLE];

    NSDecimalNumber *totalFee = DecimalZero;
    for (MAccount *account in group.accounts) {
        totalFee = [totalFee decimalNumberByAdding:account.totalFee];
    }
    [self.totalFeesLabel setText:[totalFee stringValue]];
    [self.totalFeesLabel setTextColor:MA_COLOR_OUTCOME];
    [self.totalFeesTitle setTextColor:MA_COLOR_SUB_TITLE];
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