//
//  MAAccountDetailDateCell.m
//  MatesAccounting
//
//  Created by Lee on 13-12-1.
//  Copyright (c) 2013年 Lee. All rights reserved.
//

#import "MAAccountDetailDateCell.h"

@interface MAAccountDetailDateCell ()

@property (weak, nonatomic) IBOutlet UILabel *dateTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *dateDescriptionLabel;
@property (weak, nonatomic) IBOutlet UIDatePicker *datePicker;

@end

@implementation MAAccountDetailDateCell

- (id)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super initWithCoder:aDecoder]) {
    }

    return self;
}

- (void)reuseCellWithData:(id)data
{
    if (self.status) {
        [self setSelectionStyle:UITableViewCellSelectionStyleDefault];
        if (self.datePicker.isHidden) {
            [self setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
        } else {
            [self setAccessoryType:UITableViewCellAccessoryNone];
        }
    } else {
        [self setSelectionStyle:UITableViewCellSelectionStyleNone];
        [self setAccessoryType:UITableViewCellAccessoryNone];
    }
}

+ (CGFloat)cellHeight:(id)data
{
    if ([data boolValue]) {
        return 200.0f;
    } else {
        return 40.0f;
    }
}

+ (NSString *)reuseIdentifier
{
    return [self className];
}

#pragma mark - public method
- (BOOL)isDatePickerHidden
{
    return self.datePicker.isHidden;
}

- (void)setIsDatePickerHidden:(BOOL)isDatePickerHidden
{
    [self.datePicker setHidden:isDatePickerHidden];
}

@end