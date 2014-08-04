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
@property (weak, nonatomic) IBOutlet UILabel *memberCountLabel;
@property (weak, nonatomic) IBOutlet UILabel *accountCountLabel;
@property (weak, nonatomic) IBOutlet UILabel *totalFeesLabel;
@property (weak, nonatomic) IBOutlet UILabel *groupNameLabel;

@property (nonatomic, strong) MGroup *group;

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
    self.group = data;
    [self refreshUI];
}

- (void)refreshUI
{
    [self.groupNameLabel setText:self.group.groupName];
    [self.memberCountLabel setText:[@([self.group.relationshipToMember count]) stringValue]];
    [self.accountCountLabel setText:[@([self.group.accounts count]) stringValue]];
    double totalFee = 0;
    for (MAccount *account in self.group.accounts) {
        totalFee += [account.totalFee doubleValue];
    }
    [self.totalFeesLabel setText:[@(totalFee) stringValue]];
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