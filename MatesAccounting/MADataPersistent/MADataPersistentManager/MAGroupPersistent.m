//
//  MAGroupPersistent.m
//  MatesAccounting
//
//  Created by Lee on 13-11-15.
//  Copyright (c) 2013年 Lee. All rights reserved.
//

#import "MAGroupPersistent.h"

#import "MACommonPersistent.h"
#import "MGroup.h"
#import "MAContextAPI.h"
#import "RMemberToGroup.h"
#import "MFriend.h"

@implementation MAGroupPersistent

+ (MAGroupPersistent *)instance
{
    static MAGroupPersistent     *sharedInstance;
    static dispatch_once_t       onceToken;

    dispatch_once(&onceToken, ^{
        sharedInstance = [[self alloc] init];
    });
    return sharedInstance;
}

- (BOOL)addFriend:(MFriend *)friend toGroup:(MGroup *)group
{
    MA_QUICK_ASSERT(friend && group, @"friend or group should not be nil");

    for (RMemberToGroup *memberToGroup in friend.relationshipToGroup) {
        if (memberToGroup.group == group) {
            return NO;
        }
    }

    RMemberToGroup *memberToGroup = [MACommonPersistent createObject:NSStringFromClass([RMemberToGroup class])];
    MA_QUICK_ASSERT(memberToGroup, @"Assert memberToGroup == nil");

    if (memberToGroup) {
        memberToGroup.createDate = [NSDate date];
        memberToGroup.member = friend;
        memberToGroup.group = group;
        return [[MAContextAPI sharedAPI] saveContextData];
    }

    return NO;
}

- (BOOL)removeFriend:(MFriend *)friend fromGroup:(MGroup *)group
{
    BOOL isSucceed = NO;

    RMemberToGroup *memberToGroup = nil;
    for (RMemberToGroup *relationship in group.relationshipToMember) {
        if (memberToGroup.member == friend) {
            memberToGroup = relationship;
            break;
        }
    }
    MA_QUICK_ASSERT(memberToGroup, @"Assert memberToGroup == nil");

    isSucceed = [MACommonPersistent deleteObject:memberToGroup];

    return isSucceed;
}

- (MGroup *)createGroupWithGroupName:(NSString *)groupName
{
    MGroup *group = [MACommonPersistent createObject:NSStringFromClass([MGroup class])];
    MA_QUICK_ASSERT(group, @"Assert group == nil");

    if (group) {
        NSDate *currentData = [NSDate date];
        group.createDate = currentData;
        group.updateDate = currentData;
        group.groupName = groupName;
        group.groupID = @([currentData timeIntervalSince1970]);
        [[MAContextAPI sharedAPI] saveContextData];
    }

    return group;
}

- (BOOL)updateGroup:(MGroup *)group
{
    BOOL isSucceed = NO;
    if (group) {
        NSDate *currentData = [NSDate date];
        group.updateDate = currentData;
        isSucceed = [[MAContextAPI sharedAPI] saveContextData];
    }

    return isSucceed;
}

- (BOOL)deleteGroup:(MGroup *)group
{
    BOOL isSucceed = [MACommonPersistent deleteObject:group];

    return isSucceed;
}

- (NSArray *)fetchGroups:(NSFetchRequest *)request
{
    if (!request) {
        request = [[NSFetchRequest alloc] init];
    }
    NSArray *result = [MACommonPersistent fetchObjects:request entityName:[MGroup className]];

    return result;
}

- (MGroup *)groupByGroupID:(NSNumber *)groupID
{
    NSFetchRequest *fetchRequest = [NSFetchRequest fetchRequestWithEntityName:[MGroup className]];
    fetchRequest.predicate = [NSPredicate predicateWithFormat:@"groupID == %@", groupID];
    NSArray *groupList = [self fetchGroups:fetchRequest];

    MGroup *group = nil;
    if (0 < groupList.count) {
        group = groupList[0];
    }
    return group;
}

@end