//
//  UIView+MALayout.m
//  MatesAccounting
//
//  Created by Joe Lee on 2014-8-27.
//  Copyright (c) 2014年 Lee. All rights reserved.
//

#import "UIView+MALayout.h"

#import <objc/runtime.h>

static char kNeedManualLayout;

@implementation UIView (MALayout)

+ (void)load
{
    [NSObject swizzlingClass:self.class originMethodSEL:@selector(layoutSubviews) newMethodSEL:@selector(layoutSubviews_MALayout) isInstanceMethod:YES];
}

- (void)layoutSubviews_MALayout
{
    [self layoutSubviews_MALayout];

    NSNumber *layoutFlag = objc_getAssociatedObject(self, &kNeedManualLayout);
    if ([layoutFlag boolValue] && [self conformsToProtocol:@protocol(MAManualLayoutAfterLayoutSubviewsProtocol)]) {
        objc_setAssociatedObject(self, &kNeedManualLayout, nil, OBJC_ASSOCIATION_COPY);
        id <MAManualLayoutAfterLayoutSubviewsProtocol> _self = (id <MAManualLayoutAfterLayoutSubviewsProtocol>)self;
        [_self manualLayoutAfterLayoutSubviews];
    }
}

- (void)needManualLayoutAfterLayoutSubviews
{
    MA_QUICK_ASSERT([self conformsToProtocol:@protocol(MAManualLayoutAfterLayoutSubviewsProtocol)], @"Be sure your view is conformed to protocol 'MAManualLayoutAfterLayoutSubviewsProtocol' before call this method!");
    objc_setAssociatedObject(self, &kNeedManualLayout, @(YES), OBJC_ASSOCIATION_COPY);
}

@end