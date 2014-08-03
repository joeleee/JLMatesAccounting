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

@interface MAAccountDetailConsumerDetailCell ()

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
    double fee = data.fee > 0 ? data.fee : -data.fee;
    [self.consumerNameLabel setText:data.member.name];
    [self.consumerFeeTextField setText:(0 != fee) ? [@(fee) stringValue] : nil];

    if (self.status) {
        self.consumerFeeTextField.userInteractionEnabled = YES;
        self.consumerFeeTextField.backgroundColor = UIColorFromRGB(222, 222, 222);
    } else {
        self.consumerFeeTextField.userInteractionEnabled = NO;
        self.consumerFeeTextField.backgroundColor = [UIColor clearColor];
    }
}

- (IBAction)feeTextFieldEditingDidBegin:(id)sender
{
    [self.actionDelegate actionWithData:sender cell:self type:0];
}

- (IBAction)feeTextFieldEditingDidEnd:(id)sender
{
    [self.actionDelegate actionWithData:sender cell:self type:1];
}

+ (CGFloat)cellHeight:(id)data
{
    return 40.0f;
}

+ (NSString *)reuseIdentifier
{
    return [self className];
}

@end