//
//  MAAccountDetailDescriptionCell.m
//  MatesAccounting
//
//  Created by Lee on 13-12-1.
//  Copyright (c) 2013年 Lee. All rights reserved.
//

#import "MAAccountDetailDescriptionCell.h"

@implementation MAAccountDetailDescriptionCell

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
    return 110.0f;
}

@end