//
//  MABaseCell.m
//  MatesAccounting
//
//  Created by Lee on 13-12-15.
//  Copyright (c) 2013年 Lee. All rights reserved.
//

#import "MABaseCell.h"

@implementation MABaseCell

- (id)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super initWithCoder:aDecoder]) {
        self.status = 0;
    }

    return self;
}

- (void)reuseCellWithData:(id)data
{
    MA_ASSERT(NO, @"If you want call this method, you must overwrite it. - reuseCellWithData");
}

+ (CGFloat)cellHeight:(id)data
{
    MA_ASSERT(NO, @"If you want call this method, you must overwrite it. - cellHeight");
    return 0.0f;
}

@end