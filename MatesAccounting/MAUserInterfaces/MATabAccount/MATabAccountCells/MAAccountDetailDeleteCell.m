//
//  MAAccountDetailDeleteCell.m
//  MatesAccounting
//
//  Created by Joe Lee on 2014-9-13.
//  Copyright (c) 2014年 Lee. All rights reserved.
//

#import "MAAccountDetailDeleteCell.h"

@interface MAAccountDetailDeleteCell () <MAManualLayoutAfterLayoutSubviewsProtocol>

@property (weak, nonatomic) IBOutlet UIButton *deleteAccountButton;

@end

@implementation MAAccountDetailDeleteCell

- (id)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super initWithCoder:aDecoder]) {
        [self needManualLayoutAfterLayoutSubviews];
    }
    return self;
}

- (void)reuseCellWithData:(id)data
{
}

+ (CGFloat)cellHeight:(id)data
{
    return 50.0f;
}

#pragma mark actions
- (IBAction)didDeleteAccountButtonTapped:(id)sender
{
    [self.actionDelegate actionWithData:nil cell:self type:0];
}

#pragma mark MAManualLayoutAfterLayoutSubviewsProtocol
- (void)manualLayoutAfterLayoutSubviews
{
    [self.deleteAccountButton setBackgroundColor:MA_COLOR_TABACCOUNT_DETAIL_DELETE];
    [self.deleteAccountButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    self.deleteAccountButton.layer.cornerRadius = 5.0;
}

@end