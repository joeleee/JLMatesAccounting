//
//  MACommonManagerBase.m
//  MatesAccounting
//
//  Created by Lee on 14-2-25.
//  Copyright (c) 2014年 Lee. All rights reserved.
//

// TODO: 暂时废用

#import "MACommonManagerBase.h"

@implementation MACommonManagerBase

+ (instancetype)sharedManager
{
    MA_QUICK_ASSERT(NO, @"You must overrite this method, also you cannot call super.");
    return nil;
}

- (id)init
{
    if (self = [super init]) {
        _listeners = nil;
        _listenerKeyToSelector = nil;
    }

    return self;
}

@end