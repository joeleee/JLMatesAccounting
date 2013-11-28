//
//  MAAccountManager.m
//  MatesAccounting
//
//  Created by Lee on 13-11-29.
//  Copyright (c) 2013年 Lee. All rights reserved.
//

#import "MAAccountManager.h"

@implementation MAAccountManager

+ (MAAccountManager *)sharedManager
{
    static MAAccountManager  *sharedInstance;
    static dispatch_once_t   onceToken;

    dispatch_once(&onceToken, ^{
        sharedInstance = [[self alloc] init];
    });
    return sharedInstance;
}

- (NSArray *)sectionedAccountListForCurrentGroup
{
    return nil;
}

@end