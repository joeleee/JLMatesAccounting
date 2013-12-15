//
//  MAMemberDetailBirthdayCell.m
//  MatesAccounting
//
//  Created by Lee on 13-12-8.
//  Copyright (c) 2013年 Lee. All rights reserved.
//

#import "MAMemberDetailBirthdayCell.h"

#import "MMember.h"

@interface MAMemberDetailBirthdayCell ()

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *birthdayLabel;
@property (weak, nonatomic) IBOutlet UIDatePicker *birthdayDatePicker;

@property (nonatomic, strong) MMember *member;

@end

@implementation MAMemberDetailBirthdayCell

- (id)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super initWithCoder:aDecoder]) {
    }

    return self;
}

- (void)reuseCellWithData:(MMember *)member
{
    self.member = member;
    if (0 != self.status) {
        [self.birthdayDatePicker setHidden:NO];
    } else {
        [self.birthdayDatePicker setHidden:YES];
    }
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
    NSString *birthdayDateString = [sender.date dateToString:@"yyyy-MM-dd"];
    [self.birthdayLabel setText:birthdayDateString];
}

@end