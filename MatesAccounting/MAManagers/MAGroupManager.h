//
//  MAGroupManager.h
//  MatesAccounting
//
//  Created by Lee on 13-11-27.
//  Copyright (c) 2013年 Lee. All rights reserved.
//

#define GroupManager [MAGroupManager sharedManager]
#define MASelectedGroup [GroupManager selectedGroup]

#import "ZLMulticastAgent.h"

@class MGroup, MFriend, RMemberToGroup;

@protocol MAGroupManagerListenerProtocol <NSObject>

@optional
- (void)groupHasCreated:(MGroup *)group;
- (void)groupHasModified:(MGroup *)group;
- (void)groupMemberHasChanged:(MGroup *)group member:(MFriend *)mFriend isAdd:(BOOL)isAdd;
- (void)currentGroupHasChanged:(MGroup *)group;

@end


@interface MAGroupManager : ZLMulticastAgent

+ (MAGroupManager *)sharedManager;

- (MGroup *)selectedGroup;

- (NSArray *)myGroups;

- (BOOL)changeGroup:(MGroup *)group;

- (MGroup *)createGroup:(NSString *)name;

- (MGroup *)editAndSaveGroup:(MGroup *)group name:(NSString *)name;

- (RMemberToGroup *)addFriend:(MFriend *)mFriend toGroup:(MGroup *)group;

- (BOOL)removeFriend:(MFriend *)mFriend fromGroup:(MGroup *)group;

@end