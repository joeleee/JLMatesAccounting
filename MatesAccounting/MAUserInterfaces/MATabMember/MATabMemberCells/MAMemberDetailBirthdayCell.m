//
//  MAMemberDetailBirthdayCell.m
//  MatesAccounting
//
//  Created by Lee on 13-12-8.
//  Copyright (c) 2013年 Lee. All rights reserved.
//

#import "MAMemberDetailBirthdayCell.h"

#import "MFriend.h"

@interface MAMemberDetailBirthdayCell () <MAManualLayoutAfterLayoutSubviewsProtocol>

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *birthdayLabel;
@property (weak, nonatomic) IBOutlet UIDatePicker *birthdayDatePicker;

@end

@implementation MAMemberDetailBirthdayCell

- (id)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super initWithCoder:aDecoder]) {
        [self needManualLayoutAfterLayoutSubviews];
    }

    return self;
}

- (void)reuseCellWithData:(NSDate *)date
{
    if (!date) {
        date = [NSDate dateWithTimeIntervalSince1970:0.0f];
    }

    [self.birthdayDatePicker setDate:date animated:YES];
    [self.birthdayLabel setText:[date dateToString:@"yyyy-MM-dd"]];

    if (self.status) {
        [self.birthdayDatePicker setHidden:NO];
    } else {
        [self.birthdayDatePicker setHidden:YES];
    }
}

#pragma MAManualLayoutAfterLayoutSubviewsProtocol
- (void)manualLayoutAfterLayoutSubviews
{
    self.titleLabel.textColor = MA_COLOR_TABMEMBER_DETAIL_TITLE;
    self.birthdayLabel.textColor = MA_COLOR_TABMEMBER_DETAIL_LABEL;
}

+ (CGFloat)cellHeight:(id)data
{
    NSNumber *isEditing = data;
    if ([isEditing boolValue]) {
        return 205.0f;
    } else {
        return 50.0f;
    }
}

+ (NSString *)reuseIdentifier
{
    return [self className];
}

- (IBAction)didBirthdayDatePickerValueChanged:(UIDatePicker *)sender
{
    [self.actionDelegate actionWithData:sender.date cell:self type:self.tag];
    [self.birthdayLabel setText:[sender.date dateToString:@"yyyy-MM-dd"]];
}

@end