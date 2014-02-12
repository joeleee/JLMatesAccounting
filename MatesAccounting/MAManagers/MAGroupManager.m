//
//  MAGroupManager.m
//  MatesAccounting
//
//  Created by Lee on 13-11-27.
//  Copyright (c) 2013年 Lee. All rights reserved.
//

#import "MAGroupManager.h"

#import "MGroup.h"
#import "MAGroupPersistent.h"

NSString * const MAGroupManagerSelectedGroupChanged = @"MAGroupManagerSelectedGroupChanged";

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
    NSArray *groups = [[MAGroupPersistent instance] fetchGroups:nil];

    return groups;
}

- (BOOL)changeGroup:(MGroup *)group
{
    NSAssert(group, @"change new group should not be nil! - changeGroup");
    self.selectedGroup = group;

    [[NSNotificationCenter defaultCenter] postNotificationName:MAGroupManagerSelectedGroupChanged object:self];

    return YES;
}

- (MGroup *)createGroup:(NSString *)name
{
    MGroup *group = [[MAGroupPersistent instance] createGroupWithGroupName:name];
    NSAssert(group, @"createGroup result is nil! - createGroup");

    return group;
}

- (MGroup *)editAndSaveGroup:(MGroup *)group
                        name:(NSString *)name
{
    group.groupName = name;
    BOOL isSucceed = [[MAGroupPersistent instance] updateGroup:group];
    NSAssert(isSucceed, @"editAndSaveGroup result is nil! - editAndSaveGroup");

    return group;
}

@end