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

- (void)reuseCellWithData:(NSNumber *)gender
{
    if (MAGenderFemale == [gender integerValue]) {
        [self.genderSwitch setOn:YES animated:YES];
    } else {
        [self.genderSwitch setOn:NO animated:YES];
    }

    if (self.status) {
        [self.genderSwitch setHidden:NO];
    } else {
        [self.genderSwitch setHidden:YES];
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

- (IBAction)didGenderSwitchValueChanged:(UISwitch *)sender
{
    MAGenderEnum gender = MAGenderUnknow;
    if (sender.isOn) {
        gender = MAGenderFemale;
        [self.genderLabel setText:@"女"];
    } else {
        gender = MAGenderMale;
        [self.genderLabel setText:@"男"];
    }
    [self.actionDelegate actionWithData:@(gender) cell:self type:self.tag];
}

@end