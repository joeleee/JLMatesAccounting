//
//  MAMemberDetailCell.m
//  MatesAccounting
//
//  Created by Lee on 13-12-8.
//  Copyright (c) 2013年 Lee. All rights reserved.
//

#import "MAMemberDetailCommonCell.h"

#import "MFriend.h"

NSString * const kMemberDetailCellTitle = @"kMemberDetailCellTitle";
NSString * const kMemberDetailCellContent = @"kMemberDetailCellContent";
NSString * const kMemberDetailCellKeyboardType = @"kMemberDetailCellKeyboardType";

@interface MAMemberDetailCommonCell () <MAManualLayoutAfterLayoutSubviewsProtocol>

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UITextField *detailTextField;

@end

@implementation MAMemberDetailCommonCell

- (id)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super initWithCoder:aDecoder]) {
      [self needManualLayoutAfterLayoutSubviews];
    }

    return self;
}

- (void)reuseCellWithData:(NSDictionary *)info
{
    [self.titleLabel setText:[info objectForKey:kMemberDetailCellTitle]];
    [self.detailTextField setText:[info objectForKey:kMemberDetailCellContent]];
    [self.detailTextField setKeyboardType:[[info objectForKey:kMemberDetailCellKeyboardType] integerValue]];

    if (self.status) {
        self.detailTextField.userInteractionEnabled = YES;
        self.detailTextField.backgroundColor = MA_COLOR_TABACCOUNT_DETAIL_EDITVIEW;
        self.detailTextField.textColor = MA_COLOR_TABMEMBER_DETAIL_LABEL_EDIT;
    } else {
        self.detailTextField.userInteractionEnabled = NO;
        self.detailTextField.backgroundColor = [UIColor clearColor];
        self.detailTextField.textColor = MA_COLOR_TABMEMBER_DETAIL_LABEL;
    }
}

#pragma mark MAManualLayoutAfterLayoutSubviewsProtocol
- (void)manualLayoutAfterLayoutSubviews
{
    self.titleLabel.textColor = MA_COLOR_TABMEMBER_DETAIL_TITLE;
}

+ (CGFloat)cellHeight:(id)data
{
    return 50.0f;
}

- (IBAction)didDetailTextEditingChanged:(UITextField *)sender
{
    [self.actionDelegate actionWithData:sender.text cell:self type:self.tag];
}

- (IBAction)didDetailTextValueChanged:(UITextField *)sender
{
    [self.actionDelegate actionWithData:sender.text cell:self type:self.tag];
}

@end