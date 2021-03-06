//
//  MAAccountDetailDeleteCell.m
//  MatesAccounting
//
//  Created by Joe Lee on 2014-9-13.
//  Copyright (c) 2014年 Lee. All rights reserved.
//

#import "MAAccountDetailDeleteCell.h"

@interface MAAccountDetailDeleteCell ()

@property (weak, nonatomic) IBOutlet UIButton *deleteAccountButton;

@end

@implementation MAAccountDetailDeleteCell

- (id)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super initWithCoder:aDecoder]) {
    }
    return self;
}

- (void)awakeFromNib
{
    [self.deleteAccountButton setBackgroundColor:MA_COLOR_TABACCOUNT_DETAIL_DELETE];
    [self.deleteAccountButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    self.deleteAccountButton.layer.cornerRadius = 3.0;
}

- (void)reuseCellWithData:(id)data
{
}

+ (CGFloat)cellHeight:(id)data
{
    return 120.0f;
}

#pragma mark actions
- (IBAction)didDeleteAccountButtonTapped:(id)sender
{
    [self.actionDelegate actionWithData:nil cell:self type:0];
}

@end