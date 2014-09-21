//
//  MAMemberAccountListCell.h
//  MatesAccounting
//
//  Created by Joe Lee on 2014-9-21.
//  Copyright (c) 2014年 Lee. All rights reserved.
//

#import "MABaseCell.h"

@interface MAMemberAccountListCell : MABaseCell

@property (weak, nonatomic) IBOutlet UIView *miniBackgroundView;
@property (weak, nonatomic) IBOutlet UILabel *payerNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *accountTimeLabel;
@property (weak, nonatomic) IBOutlet UILabel *accountTotalFeeLabel;
@property (weak, nonatomic) IBOutlet UILabel *accountDetailLabel;
@property (weak, nonatomic) IBOutlet UIView *dividingLineView;

@end