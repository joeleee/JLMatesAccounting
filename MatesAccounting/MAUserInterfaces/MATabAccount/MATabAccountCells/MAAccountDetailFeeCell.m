//
//  MAAccountDetailFeeCell.m
//  MatesAccounting
//
//  Created by Lee on 13-12-1.
//  Copyright (c) 2013年 Lee. All rights reserved.
//

#import "MAAccountDetailFeeCell.h"

@interface MAAccountDetailFeeCell () <UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UILabel *feeTitleLabel;
@property (weak, nonatomic) IBOutlet UITextField *feeTextField;

@end

@implementation MAAccountDetailFeeCell

- (id)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super initWithCoder:aDecoder]) {
    }

    return self;
}

- (void)reuseCellWithData:(NSString *)data
{
    if (self.status) {
        [self.feeTextField setText:data];
        self.feeTextField.userInteractionEnabled = YES;
        self.feeTextField.backgroundColor = UIColorFromRGB(222, 222, 222);
    } else {
        [self.feeTextField setText:[@([data doubleValue]) stringValue]];
        self.feeTextField.userInteractionEnabled = NO;
        self.feeTextField.backgroundColor = [UIColor clearColor];
    }
}

+ (CGFloat)cellHeight:(id)data
{
    return 60.0f;
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