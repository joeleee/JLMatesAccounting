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
@property (weak, nonatomic) IBOutlet UILabel *settlementTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *receiverNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *feeLabel;
@property (weak, nonatomic) IBOutlet UIView *dividingLineView;

@end

@implementation MAAccountSettlementCell

- (id)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super initWithCoder:aDecoder]) {
    }

    return self;
}

- (void)awakeFromNib
{
    self.payerNameLabel.textColor = MA_COLOR_TABSETTLEMENT_PAYER_NAME;
    self.receiverNameLabel.textColor = MA_COLOR_TABSETTLEMENT_REVEIVER_NAME;
    self.settlementTitleLabel.textColor = MA_COLOR_TABSETTLEMENT_SETTLTMENT_TITLE;
    self.feeLabel.textColor = MA_COLOR_TABSETTLEMENT_FEE;
    self.dividingLineView.backgroundColor = MA_COLOR_TABSETTLEMENT_DIVIDING_LINE;
}

- (void)reuseCellWithData:(id)data
{
    MA_ASSERT([data isKindOfClass:MAAccountSettlement.class], @"Wrong Type");
    MAAccountSettlement *accountSettlement = data;
    self.payerNameLabel.text = accountSettlement.fromMember.name;
    self.settlementTitleLabel.text = @"should\npay";
    self.receiverNameLabel.text = accountSettlement.toMember.name;
    self.feeLabel.text = [accountSettlement.fee description];
}

+ (CGFloat)cellHeight:(id)data
{
    return 80.0f;
}

@end