//
//  MAMemberDetailGenderCell.m
//  MatesAccounting
//
//  Created by Lee on 13-12-8.
//  Copyright (c) 2013年 Lee. All rights reserved.
//

#import "MAMemberDetailGenderCell.h"

#import "MFriend.h"

@interface MAMemberDetailGenderCell ()

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UISwitch *genderSwitch;
@property (weak, nonatomic) IBOutlet UILabel *genderLabel;

@property (nonatomic, strong) MFriend *member;

@end

@implementation MAMemberDetailGenderCell

- (id)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super initWithCoder:aDecoder]) {
    }

    return self;
}

- (void)reuseCellWithData:(MFriend *)member
{
    self.member = member;
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
    if (sender.isOn) {
        [self.genderLabel setText:@"男"];
    } else {
        [self.genderLabel setText:@"女"];
    }
}

@end