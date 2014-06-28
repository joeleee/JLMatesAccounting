//
//  MAMemberListSectionEmptyCell.m
//  MatesAccounting
//
//  Created by Lee on 13-12-7.
//  Copyright (c) 2013年 Lee. All rights reserved.
//

#import "MAMemberListSectionEmptyCell.h"

@implementation MAMemberListSectionEmptyCell

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
    return 65.0f;
}

+ (NSString *)reuseIdentifier
{
    return [self className];
}

@end