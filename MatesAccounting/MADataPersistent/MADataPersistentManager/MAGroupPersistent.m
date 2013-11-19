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

- (BOOL)addMember:(MMember *)member toGroup:(MGroup *)group
{
    RMemberToGroup *memberToGroup = [MACommonPersistent createObject:NSStringFromClass([RMemberToGroup class])];

    if (memberToGroup) {
        NSDate *currentData = [NSDate date];
        memberToGroup.createDate = currentData;
        memberToGroup.member = member;
        memberToGroup.group = group;
        return [[MAContextAPI sharedAPI] saveContextData];
    }

    return NO;
}

- (BOOL)removeMember:(MMember *)member fromGroup:(MGroup *)group
{
    BOOL isSucceed = NO;

    NSString *memberToGroupClass = NSStringFromClass([RMemberToGroup class]);
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] initWithEntityName:memberToGroupClass];
    NSPredicate *predicate = [NSPredicate predicateWithBlock:^BOOL(id evaluatedObject, NSDictionary *bindings) {
        RMemberToGroup *relationship = evaluatedObject;
        return (relationship.member == member && relationship.group == group);
    }];
    [fetchRequest setPredicate:predicate];

    NSArray *relationships = [MACommonPersistent fetchObjects:fetchRequest entityName:memberToGroupClass];
    if (0 >= relationships.count) {
        return isSucceed;
    }

    RMemberToGroup *relationship = relationships[0];
    isSucceed = [MACommonPersistent deleteObject:relationship];
    return isSucceed;
}

- (MGroup *)createGroupWithGroupName:(NSString *)groupName
{
    MGroup *group = [MACommonPersistent createObject:NSStringFromClass([MGroup class])];

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

- (NSArray *)fetchAccount:(NSFetchRequest *)request
{
    NSArray *result = [MACommonPersistent fetchObjects:request entityName:NSStringFromClass([MGroup class])];

    return result;
}

@end