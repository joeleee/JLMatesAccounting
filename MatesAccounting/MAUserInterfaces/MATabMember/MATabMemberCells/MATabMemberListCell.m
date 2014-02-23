//
//  MATabMemberListCell.m
//  MatesAccounting
//
//  Created by Lee on 13-12-12.
//  Copyright (c) 2013年 Lee. All rights reserved.
//

#import "MATabMemberListCell.h"

#import "MFriend.h"

@interface MATabMemberListCell ()

@property (weak, nonatomic) IBOutlet UILabel *memberNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *memberTelphoneLabel;
@property (weak, nonatomic) IBOutlet UILabel *memberFeeTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *memberFeeLabel;

@end

@implementation MATabMemberListCell

- (id)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super initWithCoder:aDecoder]) {
    }

    return self;
}

- (void)reuseCellWithData:(MFriend *)data
{
    [self.memberNameLabel setText:data.name];
    if (0 != [data.telephoneNumber integerValue]) {
        [self.memberTelphoneLabel setText:[data.telephoneNumber stringValue]];
    } else {
        [self.memberTelphoneLabel setText:@"暂无号码"];
    }
}

+ (CGFloat)cellHeight:(id)data
{
    return 80.0f;
}

+ (NSString *)reuseIdentifier
{
    return [self className];
}

@end