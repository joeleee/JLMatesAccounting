//
//  MAGroupListCell.m
//  MatesAccounting
//
//  Created by Lee on 13-11-29.
//  Copyright (c) 2013年 Lee. All rights reserved.
//

#import "MAGroupListCell.h"

#import "MGroup.h"
#import "MAccount+expand.h"

@interface MAGroupListCell () <MAManualLayoutAfterLayoutSubviewsProtocol>

@property (weak, nonatomic) IBOutlet UIView *miniBackgroundView;
@property (weak, nonatomic) IBOutlet UILabel *groupNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *groupMemberCountTitle;
@property (weak, nonatomic) IBOutlet UILabel *groupMemberCountLabel;
@property (weak, nonatomic) IBOutlet UILabel *groupAccountCountTitle;
@property (weak, nonatomic) IBOutlet UILabel *groupAccountCountLabel;
@property (weak, nonatomic) IBOutlet UILabel *groupTotalFeeTitle;
@property (weak, nonatomic) IBOutlet UILabel *groupTotalFeeLabel;
@property (weak, nonatomic) IBOutlet UIButton *groupDetailButton;

@property (nonatomic, strong) MGroup *group;

@end

@implementation MAGroupListCell

- (id)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super initWithCoder:aDecoder]) {
        [self needManualLayoutAfterLayoutSubviews];
    }

    return self;
}

- (void)reuseCellWithData:(MGroup *)data
{
    self.group = data;

    [self.groupNameLabel setText:self.group.groupName];
    [self.groupMemberCountLabel setText:[@([self.group.relationshipToMember count]) stringValue]];
    [self.groupAccountCountLabel setText:[@([self.group.accounts count]) stringValue]];
    NSDecimalNumber *totalFee = DecimalZero;
    for (MAccount *account in self.group.accounts) {
        totalFee = [totalFee decimalNumberByAdding:account.totalFee];
    }
    [self.groupTotalFeeLabel setText:[totalFee description]];
}

#pragma mark MAManualLayoutAfterLayoutSubviewsProtocol
- (void)manualLayoutAfterLayoutSubviews
{
    self.groupNameLabel.textColor = MA_COLOR_GROUP_GROUP_NAME;
    self.groupMemberCountTitle.textColor = MA_COLOR_GROUP_GROUP_TITLE;
    self.groupMemberCountLabel.textColor = MA_COLOR_GROUP_GROUP_LABEL;
    self.groupAccountCountTitle.textColor = MA_COLOR_GROUP_GROUP_TITLE;
    self.groupAccountCountLabel.textColor = MA_COLOR_GROUP_GROUP_LABEL;
    self.groupTotalFeeTitle.textColor = MA_COLOR_GROUP_GROUP_TITLE;
    self.groupTotalFeeLabel.textColor = MA_COLOR_GROUP_COAST_FEE;
}

+ (CGFloat)cellHeight:(id)data
{
    return 80.0f;
}

+ (NSString *)reuseIdentifier
{
    return [self className];
}

- (IBAction)didGroupDetailButtonTaped:(UIButton *)sender
{
    [self.actionDelegate actionWithData:self.group
                                   cell:self
                                   type:0];
}

@end