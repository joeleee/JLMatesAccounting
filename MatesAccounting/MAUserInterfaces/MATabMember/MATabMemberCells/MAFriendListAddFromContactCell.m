//
//  MAFriendListAddFromContactCell.m
//  MatesAccounting
//
//  Created by Joe Lee on 2014-11-4.
//  Copyright (c) 2014年 Lee. All rights reserved.
//

#import "MAFriendListAddFromContactCell.h"


@interface MAFriendListAddFromContactCell ()

@property (weak, nonatomic) IBOutlet UIButton *addFriendButton;

@end


@implementation MAFriendListAddFromContactCell

- (id)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super initWithCoder:aDecoder]) {
    }

    return self;
}

- (void)awakeFromNib
{
    self.backgroundColor = MA_COLOR_VIEW_BACKGROUND;
    [self.addFriendButton setTitleColor:MA_COLOR_TABMEMBER_PAYER_NAME forState:UIControlStateNormal];
    [self.addFriendButton setBackgroundColor:MA_COLOR_TABACCOUNT_DETAIL_MEMBER_PAY];

    self.addFriendButton.layer.cornerRadius = 7;
    self.addFriendButton.layer.shadowColor = [MA_COLOR_TABACCOUNT_DETAIL_MEMBER_PAY CGColor];
    self.addFriendButton.layer.shadowOffset = CGSizeMake(2.0f, 2.0f);
    self.addFriendButton.layer.shadowOpacity = 0.2f;
    self.addFriendButton.layer.shadowRadius = 1.5f;
}

- (void)reuseCellWithData:(NSString *)title
{
    [self.addFriendButton setTitle:title forState:UIControlStateNormal];
}

+ (CGFloat)cellHeight:(id)data
{
    return 80.0f;
}

- (IBAction)didAddFriendButtonTapped:(id)sender
{
    [self.actionDelegate actionWithData:nil cell:self type:0];
}

@end