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

- (void)reuseCellWithData:(RMemberToAccount *)data
{
    NSNumber *fee = data.fee;
    [self.consumerNameLabel setText:data.member.name];
    [self.consumerFeeTextField setText:[fee stringValue]];
    if (0 > [fee doubleValue]) {
        [self.consumerTypeLabel setText:@"支付"];
    } else {
        [self.consumerTypeLabel setText:@"消费"];
    }

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

@end