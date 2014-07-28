//
//  MAMemberListCell.m
//  MatesAccounting
//
//  Created by Lee on 13-12-7.
//  Copyright (c) 2013年 Lee. All rights reserved.
//

#import "MAMemberListCell.h"

#import "MFriend.h"

@interface MAMemberListCell ()

@property (weak, nonatomic) IBOutlet UILabel *memberNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *coastFeeLabel;
@property (weak, nonatomic) IBOutlet UILabel *totalFeeLabel;
@property (weak, nonatomic) IBOutlet UILabel *coastFeeTitle;
@property (weak, nonatomic) IBOutlet UILabel *totalFeeTitle;
@property (weak, nonatomic) IBOutlet UIButton *memberInfoButton;

@property (nonatomic, strong) MFriend *member;

@end

@implementation MAMemberListCell

- (id)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super initWithCoder:aDecoder]) {
    }

    return self;
}

- (void)reuseCellWithData:(id)data
{
    self.member = data;
    self.memberNameLabel.text = self.member.name;
}

+ (CGFloat)cellHeight:(id)data
{
    return 65.0f;
}

+ (NSString *)reuseIdentifier
{
    return [self className];
}

- (IBAction)didInfoButtonTaped:(UIButton *)sender
{
    [self.actionDelegate actionWithData:self.member cell:self type:0];
}

@end