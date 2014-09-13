//
//  MAAccountDetailConsumerDetailCell.m
//  MatesAccounting
//
//  Created by Lee on 13-12-1.
//  Copyright (c) 2013年 Lee. All rights reserved.
//

#import "MAAccountDetailConsumerDetailCell.h"

#import "RMemberToAccount.h"
#import "MFriend.h"
#import "MAAccountManager.h"

@interface MAAccountDetailConsumerDetailCell () <UITextFieldDelegate, MAManualLayoutAfterLayoutSubviewsProtocol>

@property (weak, nonatomic) IBOutlet UILabel *consumerNameLabel;
@property (weak, nonatomic) IBOutlet UITextField *consumerFeeTextField;

@end

@implementation MAAccountDetailConsumerDetailCell

- (id)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super initWithCoder:aDecoder]) {
        [self needManualLayoutAfterLayoutSubviews];
    }

    return self;
}

- (void)reuseCellWithData:(MAFeeOfMember *)data
{
    NSComparisonResult result = [data.fee compare:DecimalZero];
    [self.consumerNameLabel setText:data.member.name];
    [self.consumerFeeTextField setText:(NSOrderedSame != result) ? [data.fee description] : nil];
    if (NSOrderedAscending == result) {
        self.consumerFeeTextField.textColor = MA_COLOR_TABACCOUNT_DETAIL_MEMBER_COAST;
    } else if (NSOrderedSame == result) {
        self.consumerFeeTextField.textColor = MA_COLOR_TABACCOUNT_DETAIL_MEMBER_NULL;
    } else if (NSOrderedDescending == result) {
        self.consumerFeeTextField.textColor = MA_COLOR_TABACCOUNT_DETAIL_MEMBER_PAY;
    }

    if (self.status) {
        self.consumerFeeTextField.userInteractionEnabled = YES;
        self.consumerFeeTextField.backgroundColor = MA_COLOR_TABACCOUNT_DETAIL_EDITVIEW;
    } else {
        self.consumerFeeTextField.userInteractionEnabled = NO;
        self.consumerFeeTextField.backgroundColor = [UIColor clearColor];
    }
}

+ (CGFloat)cellHeight:(id)data
{
    return 40.0f;
}

#pragma mark UITextFieldDelegate
- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    [self.actionDelegate actionWithData:textField cell:self type:0];
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    [self.actionDelegate actionWithData:textField cell:self type:1];
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    NSString *resultText = [textField.text stringByReplacingCharactersInRange:range withString:string];
    return [resultText isTwoDecimalPlaces];
}

#pragma mark MAManualLayoutAfterLayoutSubviewsProtocol
- (void)manualLayoutAfterLayoutSubviews
{
    self.consumerNameLabel.textColor = MA_COLOR_TABACCOUNT_USER_NAME;
}

@end