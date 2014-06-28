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

@interface MAMemberDetailCommonCell ()

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UITextField *detailTextField;

@end

@implementation MAMemberDetailCommonCell

- (id)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super initWithCoder:aDecoder]) {
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

- (IBAction)didDetailTextEditingChanged:(UITextField *)sender
{
    [self.actionDelegate actionWithData:sender.text cell:self type:self.tag];
}

- (IBAction)didDetailTextValueChanged:(UITextField *)sender
{
    [self.actionDelegate actionWithData:sender.text cell:self type:self.tag];
}

@end