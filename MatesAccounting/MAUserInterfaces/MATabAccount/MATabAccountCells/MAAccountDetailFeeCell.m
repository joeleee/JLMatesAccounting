//
//  MAAccountDetailFeeCell.m
//  MatesAccounting
//
//  Created by Lee on 13-12-1.
//  Copyright (c) 2013年 Lee. All rights reserved.
//

#import "MAAccountDetailFeeCell.h"

@interface MAAccountDetailFeeCell ()

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

- (void)reuseCellWithData:(id)data
{
    if (self.status) {
        self.feeTextField.userInteractionEnabled = YES;
        self.feeTextField.backgroundColor = UIColorFromRGB(222, 222, 222);
    } else {
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

@end