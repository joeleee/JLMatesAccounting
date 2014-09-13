//
//  MAGroupManager.m
//  MatesAccounting
//
//  Created by Lee on 13-11-27.
//  Copyright (c) 2013年 Lee. All rights reserved.
//

#import "MAGroupManager.h"

#import "MGroup+expand.h"
#import "MFriend.h"
#import "MACommonPersistent.h"
#import "RMemberToGroup+expand.h"
#import "MAContextAPI.h"

NSString * const kCurrentGroupID = @"kCurrentGroupID";

NSString * const kMAGMGroupHasCreated = @"kMAGMGroupHasCreated";
NSString * const kMAGMGroupHasModified = @"kMAGMGroupHasModified";
NSString * const kMAGMGroupMemberHasChanged = @"kMAGMGroupMemberHasChanged";
NSString * const kMAGMCurrentGroupHasChanged = @"kMAGMCurrentGroupHasChanged";

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

- (id)init
{
    if (self = [super init]) {

        [self setListenerKeyToSelecterDict:@{kMAGMGroupHasCreated:NSStringFromSelector(@selector(groupHasCreated:)),
                                            kMAGMGroupHasModified:NSStringFromSelector(@selector(groupHasModified:)),
                                            kMAGMGroupMemberHasChanged:NSStringFromSelector(@selector(groupMemberHasChanged:member:isAdd:)),
                                             kMAGMCurrentGroupHasChanged:NSStringFromSelector(@selector(currentGroupHasChanged:))}];

    }

    return self;
}

- (MGroup *)selectedGroup
{
    if (!_selectedGroup) {
        NSNumber *groupID = [[NSUserDefaults standardUserDefaults] objectForKey:kCurrentGroupID];
        NSFetchRequest *fetchRequest = [NSFetchRequest fetchRequestWithEntityName:[MGroup className]];
        fetchRequest.predicate = [NSPredicate predicateWithFormat:@"groupID == %@", groupID];
        NSArray *groupList = [MACommonPersistent fetchObjectsWithRequest:fetchRequest];
        _selectedGroup = groupList.firstObject;
    }

    return _selectedGroup;
}

- (NSArray *)myGroups
{
    NSArray *groups = [MACommonPersistent fetchObjectsWithEntityName:[MGroup className]];

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
    [self listenersForKey:kMAGMCurrentGroupHasChanged withBlock:^(id<MAGroupManagerListenerProtocol> listener) {
        [listener currentGroupHasChanged:group];
    }];

    return YES;
}

- (MGroup *)createGroup:(NSString *)name
{
    name = [name stringByReplacingOccurrencesOfString:@" " withString:@""];
    if ((0 >= name.length)) {
        return nil;
    }

    MGroup *group = [MACommonPersistent createObject:NSStringFromClass([MGroup class])];
    MA_QUICK_ASSERT(group, @"Assert group == nil");
    NSDate *currentData = [NSDate date];
    group.createDate = currentData;
    group.updateDate = currentData;
    group.groupName = name;
    group.groupID = @([currentData timeIntervalSince1970]);
    [[MAContextAPI sharedAPI] saveContextData];

    [self listenersForKey:kMAGMGroupHasCreated withBlock:^(id<MAGroupManagerListenerProtocol> listener) {
        [listener groupHasCreated:group];
    }];

    return group;
}

- (MGroup *)editAndSaveGroup:(MGroup *)group name:(NSString *)name
{
    name = [name stringByReplacingOccurrencesOfString:@" " withString:@""];
    if ((0 >= name.length)) {
        return nil;
    }

    group.groupName = name;
    group.updateDate = [NSDate date];
    BOOL isSucceed = [[MAContextAPI sharedAPI] saveContextData];
    MA_QUICK_ASSERT(isSucceed, @"editAndSaveGroup result is nil! - editAndSaveGroup");

    [self listenersForKey:kMAGMGroupHasModified withBlock:^(id<MAGroupManagerListenerProtocol> listener) {
        [listener groupHasModified:group];
    }];

    return group;
}

- (RMemberToGroup *)addFriend:(MFriend *)mFriend toGroup:(MGroup *)group
{
    if (!mFriend || !group || 0 < [group relationshipToMembersByFriend:mFriend].count) {
        return nil;
    }
    for (RMemberToGroup *memberToGroup in mFriend.relationshipToGroup) {
        if (memberToGroup.group == group) {
            return nil;
        }
    }

    RMemberToGroup *memberToGroup = [MACommonPersistent createObject:NSStringFromClass([RMemberToGroup class])];
    MA_QUICK_ASSERT(memberToGroup, @"Assert memberToGroup == nil");

    memberToGroup.createDate = [NSDate date];
    memberToGroup.member = mFriend;
    memberToGroup.group = group;
    if (![[MAContextAPI sharedAPI] saveContextData]) {
        MA_QUICK_ASSERT(NO, @"Update failed.");
        [MACommonPersistent deleteObject:memberToGroup];
        [[MAContextAPI sharedAPI] saveContextData];
        return nil;
    }

    [self listenersForKey:kMAGMGroupMemberHasChanged withBlock:^(id<MAGroupManagerListenerProtocol> listener) {
        [listener groupMemberHasChanged:memberToGroup.group member:memberToGroup.member isAdd:YES];
    }];

    return memberToGroup;
}

- (void)removeFriend:(MFriend *)mFriend fromGroup:(MGroup *)group onComplete:(MACommonCallBackBlock)onComplete onFailed:(MACommonCallBackBlock)onFailed;
{
    NSSet *relationships = [group.relationshipToMember filteredSetUsingPredicate:[NSPredicate predicateWithFormat:@"%K = %@", @"member", mFriend]];
    MA_QUICK_ASSERT(relationships.count > 0, @"Assert memberToGroup == nil");

    RMemberToGroup *memberToGroup = relationships.allObjects.firstObject;
    [memberToGroup refreshMemberTotalFee];
    if (NSOrderedSame != [memberToGroup.fee compare:DecimalZero]) {
        NSError *error = [NSError errorWithDomain:@"Please be sure this member's balance is zero first." code:-1 userInfo:nil];
        MA_INVOKE_BLOCK_SAFELY(onFailed, nil, error);
        return;
    }

    if ([MACommonPersistent deleteObject:memberToGroup]) {
        [self listenersForKey:kMAGMGroupMemberHasChanged withBlock:^(id<MAGroupManagerListenerProtocol> listener) {
            [listener groupMemberHasChanged:group member:mFriend isAdd:NO];
        }];
        MA_INVOKE_BLOCK_SAFELY(onComplete, nil, nil);
        return;
    } else {
        NSError *error = [NSError errorWithDomain:@"Remove member failed!" code:-1 userInfo:nil];
        MA_INVOKE_BLOCK_SAFELY(onFailed, nil, error);
        return;
    }
}

- (BOOL)isMember:(MFriend *)member belongsToGroup:(MGroup *)group
{
    BOOL isBelong = [member.relationshipToGroup intersectsSet:group.relationshipToMember];
    return isBelong;
}

@end