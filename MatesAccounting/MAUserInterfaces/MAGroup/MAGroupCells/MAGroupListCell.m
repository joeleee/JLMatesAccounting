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

@interface MAGroupListCell ()

@property (weak, nonatomic) IBOutlet UIView *miniBackgroundView;
@property (weak, nonatomic) IBOutlet UILabel *groupNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *groupCreateDataLabel;
@property (weak, nonatomic) IBOutlet UILabel *groupMemberCountLabel;
@property (weak, nonatomic) IBOutlet UILabel *groupAccountCountLabel;
@property (weak, nonatomic) IBOutlet UILabel *groupTotalFeeLabel;
@property (weak, nonatomic) IBOutlet UIButton *groupDetailButton;

@property (nonatomic, strong) MGroup *group;

@end

@implementation MAGroupListCell

- (id)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super initWithCoder:aDecoder]) {
    }

    return self;
}

- (void)reuseCellWithData:(MGroup *)data
{
    self.group = data;

    [self.groupNameLabel setText:self.group.groupName];
    [self.groupCreateDataLabel setText:[self.group.createDate description]];
    [self.groupMemberCountLabel setText:[@([self.group.relationshipToMember count]) stringValue]];
    [self.groupAccountCountLabel setText:[@([self.group.accounts count]) stringValue]];
    double totalFee = 0;
    for (MAccount *account in self.group.accounts) {
        totalFee += [account.totalFee doubleValue];
    }
    [self.groupTotalFeeLabel setText:[@(totalFee) stringValue]];
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