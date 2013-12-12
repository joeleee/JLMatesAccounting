//
//  MAMemberManager.m
//  MatesAccounting
//
//  Created by Lee on 13-12-12.
//  Copyright (c) 2013年 Lee. All rights reserved.
//

#import "MAMemberManager.h"

@implementation MAMemberManager

+ (MAMemberManager *)sharedManager
{
    static MAMemberManager *sharedInstance = nil;
    static dispatch_once_t onceToken;

    dispatch_once(&onceToken, ^{
        sharedInstance = [[MAMemberManager alloc] init];
    });

    return sharedInstance;
}

- (NSArray *)currentGroupMembers
{
    return nil;
}

@end