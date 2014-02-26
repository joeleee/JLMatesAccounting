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
#import "MACommonManagerBase+private.h"
#import "RMemberToGroup.h"

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

        _listeners = @{kMAGMGroupHasCreated:[NSMutableSet set],
                       kMAGMGroupHasModified:[NSMutableSet set],
                       kMAGMGroupMemberHasChanged:[NSMutableSet set],
                       kMAGMCurrentGroupHasChanged:[NSMutableSet set]};

        _listenerKeyToSelector = @{kMAGMGroupHasCreated:NSStringFromSelector(@selector(groupHasCreated:)),
                                   kMAGMGroupHasModified:NSStringFromSelector(@selector(groupHasModified:)),
                                   kMAGMGroupMemberHasChanged:NSStringFromSelector(@selector(groupMemberHasChanged:member:isAdd:)),
                                   kMAGMCurrentGroupHasChanged:NSStringFromSelector(@selector(currentGroupHasChanged:))};
    }

    return self;
}

- (BOOL)addListener:(id<MAGroupManagerListenerProtocol>)listener
{
    return [self listener:listener isAdd:YES];
}

- (BOOL)removeListener:(id<MAGroupManagerListenerProtocol>)listener
{
    return [self listener:listener isAdd:NO];
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
    [self listenersForKey:kMAGMCurrentGroupHasChanged withBlock:^(id<MAGroupManagerListenerProtocol> listener) {
        [listener currentGroupHasChanged:group];
    }];

    return YES;
}

- (MGroup *)createGroup:(NSString *)name
{
    if ((0 >= [name stringByReplacingOccurrencesOfString:@" " withString:@""].length)) {
        return nil;
    }

    MGroup *group = [[MAGroupPersistent instance] createGroupWithGroupName:name];
    MA_QUICK_ASSERT(group, @"createGroup result is nil! - createGroup");

    if (group) {
        [self listenersForKey:kMAGMGroupHasCreated withBlock:^(id<MAGroupManagerListenerProtocol> listener) {
            [listener groupHasCreated:group];
        }];
    }
    return group;
}

- (MGroup *)editAndSaveGroup:(MGroup *)group
                        name:(NSString *)name
{
    if ((0 >= [name stringByReplacingOccurrencesOfString:@" " withString:@""].length)) {
        return nil;
    }

    group.groupName = name;
    BOOL isSucceed = [[MAGroupPersistent instance] updateGroup:group];
    MA_QUICK_ASSERT(isSucceed, @"editAndSaveGroup result is nil! - editAndSaveGroup");

    if (isSucceed) {
        [self listenersForKey:kMAGMGroupHasModified withBlock:^(id<MAGroupManagerListenerProtocol> listener) {
            [listener groupHasModified:group];
        }];
    }
    return group;
}

- (RMemberToGroup *)addFriend:(MFriend *)mFriend toGroup:(MGroup *)group
{
    RMemberToGroup *relationship = [[MAGroupPersistent instance] addFriend:mFriend toGroup:group];
    if (relationship) {
        [self listenersForKey:kMAGMGroupMemberHasChanged withBlock:^(id<MAGroupManagerListenerProtocol> listener) {
            [listener groupMemberHasChanged:relationship.group member:relationship.member isAdd:YES];
        }];
    }
    return relationship;
}

- (BOOL)removeFriend:(MFriend *)mFriend fromGroup:(MGroup *)group
{
    BOOL succeed = [[MAGroupPersistent instance] removeFriend:mFriend fromGroup:group];
    if (succeed) {
        [self listenersForKey:kMAGMGroupMemberHasChanged withBlock:^(id<MAGroupManagerListenerProtocol> listener) {
            [listener groupMemberHasChanged:group member:mFriend isAdd:NO];
        }];
    }
    return succeed;
}

@end