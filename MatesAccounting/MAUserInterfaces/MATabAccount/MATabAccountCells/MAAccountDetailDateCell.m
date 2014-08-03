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

- (void)reuseCellWithData:(NSDate *)date
{
    if (!date) {
        date = [NSDate dateWithTimeIntervalSince1970:0.0f];
    }

    [self.datePicker setDate:date animated:YES];
    [self.dateDescriptionLabel setText:[date dateToString:@"yyyy年MM月dd日 HH:mm"]];

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

- (IBAction)didDatePickerValueChanged:(id)sender
{
    [self.dateDescriptionLabel setText:[[sender date] dateToString:@"yyyy年MM月dd日 HH:mm"]];
    [self.actionDelegate actionWithData:sender cell:self type:0];
}

#pragma mark - public method

- (void)setDatePickerHidden:(BOOL)isHidden
{
    [self.datePicker setHidden:isHidden];
}

@end