//
//  MARootNavigationControllerDelegate.m
//  MatesAccounting
//
//  Created by Joe Lee on 2014-8-8.
//  Copyright (c) 2014年 Lee. All rights reserved.
//

#import "MARootNavigationControllerDelegate.h"

@interface MARootNavigationControllerDelegate ()

@end


@implementation MARootNavigationControllerDelegate

+ (instancetype)sharedDelegate
{
    static MARootNavigationControllerDelegate *shareDelegate;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        shareDelegate = [[MARootNavigationControllerDelegate alloc] init];
    });

    return shareDelegate;
}

@end