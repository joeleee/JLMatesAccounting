//
//  MAGroupManager.m
//  MatesAccounting
//
//  Created by Lee on 13-11-27.
//  Copyright (c) 2013年 Lee. All rights reserved.
//

#import "MAGroupManager.h"

@interface MAGroupManager ()

@property (nonatomic, strong) MGroup *selectedGroup;

@end

@implementation MAGroupManager

+ (MAGroupManager *)sharedManager
{
    static MAGroupManager  *sharedInstance;
    static dispatch_once_t onceToken;

    dispatch_once(&onceToken, ^{
            sharedInstance = [[self alloc] init];
        });
    return sharedInstance;
}

- (MGroup *)currentGroup
{
    return self.selectedGroup;
}

- (NSArray *)myGroups
{
    return nil;
}

@end