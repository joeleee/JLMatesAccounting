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

NSString * const kCurrentGroupID = @"kCurrentGroupID";

NSString * const MAGroupManagerSelectedGroupChanged = @"MAGroupManagerSelectedGroupChanged";
NSString * const MAGroupManagerGroupHasCreated = @"MAGroupManagerGroupHasCreated";
NSString * const MAGroupManagerGroupHasModified = @"MAGroupManagerGroupHasModified";

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
    if (!self.selectedGroup) {
        NSNumber *groupID = [[NSUserDefaults standardUserDefaults] objectForKey:kCurrentGroupID];
        self.selectedGroup = [[MAGroupPersistent instance] groupByGroupID:groupID];
    }

    return self.selectedGroup;
}

- (NSArray *)myGroups
{
    NSArray *groups = [[MAGroupPersistent instance] fetchGroups:nil];

    return groups;
}

- (BOOL)changeGroup:(MGroup *)group
{
    MA_QUICK_ASSERT(group, @"change new group should not be nil! - changeGroup");
    if (!group) {
        return NO;
    }

    self.selectedGroup = group;

    [[NSUserDefaults standardUserDefaults] setObject:self.selectedGroup.groupID forKey:kCurrentGroupID];
    [[NSUserDefaults standardUserDefaults] synchronize];
    [[NSNotificationCenter defaultCenter] postNotificationName:MAGroupManagerSelectedGroupChanged object:self.selectedGroup];

    return YES;
}

- (MGroup *)createGroup:(NSString *)name
{
    MGroup *group = [[MAGroupPersistent instance] createGroupWithGroupName:name];
    MA_QUICK_ASSERT(group, @"createGroup result is nil! - createGroup");

    if (group) {
        [[NSNotificationCenter defaultCenter] postNotificationName:MAGroupManagerGroupHasCreated object:group];
    }
    return group;
}

- (MGroup *)editAndSaveGroup:(MGroup *)group
                        name:(NSString *)name
{
    group.groupName = name;
    BOOL isSucceed = [[MAGroupPersistent instance] updateGroup:group];
    MA_QUICK_ASSERT(isSucceed, @"editAndSaveGroup result is nil! - editAndSaveGroup");

    if (isSucceed) {
        [[NSNotificationCenter defaultCenter] postNotificationName:MAGroupManagerGroupHasModified object:group];
    }
    return group;
}

@end