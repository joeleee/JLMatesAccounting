//
//  MAMemberDetailGenderCell.m
//  MatesAccounting
//
//  Created by Lee on 13-12-8.
//  Copyright (c) 2013年 Lee. All rights reserved.
//

#import "MAMemberDetailGenderCell.h"

@interface MAMemberDetailGenderCell ()

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UISwitch *genderSwitch;
@property (weak, nonatomic) IBOutlet UILabel *genderLabel;

@end

@implementation MAMemberDetailGenderCell

- (id)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super initWithCoder:aDecoder]) {
    }

    return self;
}

- (void)awakeFromNib
{
    self.titleLabel.textColor = MA_COLOR_TABMEMBER_DETAIL_TITLE;
    self.genderLabel.textColor = MA_COLOR_TABMEMBER_DETAIL_LABEL;
}

- (void)reuseCellWithData:(NSNumber *)gender
{
    [self.genderSwitch setOn:(MAGenderFemale == [gender integerValue]) animated:YES];
    [self.genderSwitch setHidden:!self.status];
    [self.genderLabel setText:(MAGenderFemale == [gender integerValue]) ? @"F" : @"M"];
}

+ (CGFloat)cellHeight:(id)data
{
    return 50.0f;
}

- (IBAction)didGenderSwitchValueChanged:(UISwitch *)sender
{
    MAGenderEnum gender = MAGenderUnknow;
    if (sender.isOn) {
        gender = MAGenderFemale;
        [self.genderLabel setText:@"F"];
    } else {
        gender = MAGenderMale;
        [self.genderLabel setText:@"M"];
    }
    [self.actionDelegate actionWithData:@(gender) cell:self type:self.tag];
}

@end