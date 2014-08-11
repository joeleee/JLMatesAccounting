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

@interface MAAccountDetailConsumerDetailCell () <UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UILabel *consumerNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *consumerTypeLabel;
@property (weak, nonatomic) IBOutlet UITextField *consumerFeeTextField;

@end

@implementation MAAccountDetailConsumerDetailCell

- (id)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super initWithCoder:aDecoder]) {
    }

    return self;
}

- (void)reuseCellWithData:(MAFeeOfMember *)data
{
    NSDecimalNumber *fee = (NSOrderedDescending == [data.fee compare:DecimalZero]) ? data.fee : [data.fee inverseNumber];
    [self.consumerNameLabel setText:data.member.name];
    [self.consumerFeeTextField setText:(NSOrderedSame != [fee compare:DecimalZero]) ? [fee description] : nil];

    if (self.status) {
        self.consumerFeeTextField.userInteractionEnabled = YES;
        self.consumerFeeTextField.backgroundColor = UIColorFromRGB(222, 222, 222);
    } else {
        self.consumerFeeTextField.userInteractionEnabled = NO;
        self.consumerFeeTextField.backgroundColor = [UIColor clearColor];
    }
}

+ (CGFloat)cellHeight:(id)data
{
    return 40.0f;
}

+ (NSString *)reuseIdentifier
{
    return [self className];
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

@end