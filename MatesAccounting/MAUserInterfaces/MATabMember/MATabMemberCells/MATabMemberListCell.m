//
//  MATabMemberListCell.m
//  MatesAccounting
//
//  Created by Lee on 13-12-12.
//  Copyright (c) 2013年 Lee. All rights reserved.
//

#import "MATabMemberListCell.h"

@interface MATabMemberListCell ()

@property (weak, nonatomic) IBOutlet UILabel *memberNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *memberFeeTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *memberFeeLabel;
@property (weak, nonatomic) IBOutlet UILabel *memberTelphoneLabel;

@end

@implementation MATabMemberListCell

- (id)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super initWithCoder:aDecoder]) {
    }

    return self;
}

- (void)reuseCellWithData:(id)data
{
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