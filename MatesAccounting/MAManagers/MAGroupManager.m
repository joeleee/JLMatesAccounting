//
//  MAGroupManager.m
//  MatesAccounting
//
//  Created by Lee on 13-11-27.
//  Copyright (c) 2013年 Lee. All rights reserved.
//

#import "MAGroupManager.h"

@interface MAGroupManager ()

@property (nonatomic, strong) MGroup *currentGroup;
@property (nonatomic, strong) NSArray *myGroups;

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
    if (_currentGroup) {
        return _currentGroup;
    }

    return _currentGroup;
}

- (NSArray *)myGroups
{
    if (_myGroups) {
        return _myGroups;
    }

    return _myGroups;
}

@end