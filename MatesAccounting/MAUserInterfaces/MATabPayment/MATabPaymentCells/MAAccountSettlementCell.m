//
//  MAAccountSettlementCell.m
//  MatesAccounting
//
//  Created by Joe Lee on 2014-8-6.
//  Copyright (c) 2014年 Lee. All rights reserved.
//

#import "MAAccountSettlementCell.h"

#import "MFriend.h"
#import "MAAccountManager.h"

@interface MAAccountSettlementCell ()

@property (weak, nonatomic) IBOutlet UILabel *payerNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *receiverNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *feeLabel;

@end

@implementation MAAccountSettlementCell

- (id)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super initWithCoder:aDecoder]) {
    }

    return self;
}

- (void)reuseCellWithData:(id)data
{
    MA_QUICK_ASSERT([data isKindOfClass:MAAccountSettlement.class], @"Wrong Type");
    MAAccountSettlement *accountSettlement = data;
    self.payerNameLabel.text = accountSettlement.fromMember.name;
    self.receiverNameLabel.text = accountSettlement.toMember.name;
    self.feeLabel.text = [@(accountSettlement.fee) stringValue];
}

+ (CGFloat)cellHeight:(id)data
{
    return 80.0f;
}

+ (NSString *)reuseIdentifier
{
    return [self className];
}

@end