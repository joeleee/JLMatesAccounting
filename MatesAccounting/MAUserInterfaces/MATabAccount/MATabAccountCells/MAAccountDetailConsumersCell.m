//
//  MAAccountDetailConsumersCell.m
//  MatesAccounting
//
//  Created by Lee on 13-12-1.
//  Copyright (c) 2013年 Lee. All rights reserved.
//

#import "MAAccountDetailConsumersCell.h"

@implementation MAAccountDetailConsumersCell

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
    return 40.0f;
}

+ (NSString *)reuseIdentifier
{
    return [self className];
}

@end