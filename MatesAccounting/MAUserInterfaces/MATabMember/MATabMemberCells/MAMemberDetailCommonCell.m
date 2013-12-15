//
//  MAMemberDetailCell.m
//  MatesAccounting
//
//  Created by Lee on 13-12-8.
//  Copyright (c) 2013年 Lee. All rights reserved.
//

#import "MAMemberDetailCommonCell.h"

#import "MMember.h"

@interface MAMemberDetailCommonCell ()

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UITextField *detailTextField;

@property (nonatomic, strong) MMember *member;

@end

@implementation MAMemberDetailCommonCell

- (id)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super initWithCoder:aDecoder]) {
    }

    return self;
}

- (void)reuseCellWithData:(MMember *)member
{
    self.detailTextField.keyboardType = self.keyboardType;
    self.member = member;
    if (self.status) {
        self.detailTextField.userInteractionEnabled = YES;
        self.detailTextField.backgroundColor = UIColorFromRGB(222, 222, 222);
    } else {
        self.detailTextField.userInteractionEnabled = NO;
        self.detailTextField.backgroundColor = [UIColor clearColor];
    }
}

+ (CGFloat)cellHeight:(id)data
{
    return 50.0f;
}

+ (NSString *)reuseIdentifier
{
    return [self className];
}

- (void)setTitle:(NSString *)title detail:(NSString *)detail
{
    [self.titleLabel setText:title];
    [self.detailTextField setText:detail];
}

@end