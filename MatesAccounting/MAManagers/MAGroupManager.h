//
//  MAGroupManager.h
//  MatesAccounting
//
//  Created by Lee on 13-11-27.
//  Copyright (c) 2013年 Lee. All rights reserved.
//

#import <Foundation/Foundation.h>

#define GroupManager [MAGroupManager sharedManager]
#define MACurrentGroup [GroupManager selectedGroup]

@class MGroup, MFriend, RMemberToGroup;

@protocol MAGroupManagerObserverProtocol <NSObject>

@optional
- (void)groupDidCreated:(MGroup *)group;
- (void)groupInfoDidChanged:(MGroup *)group;
- (void)groupMemberDidChanged:(MGroup *)group member:(MFriend *)mFriend isAdd:(BOOL)isAdd;
- (void)currentGroupDidSwitched:(MGroup *)group;

@end


@interface MAGroupManager : NSObject

+ (MAGroupManager *)sharedManager;

- (void)registerGroupObserver:(id<MAGroupManagerObserverProtocol>)observer;

- (void)unregisterGroupObserver:(id<MAGroupManagerObserverProtocol>)observer;

- (MGroup *)selectedGroup;

- (NSArray *)myGroups;

- (BOOL)changeGroup:(MGroup *)group;

- (MGroup *)createGroup:(NSString *)name;

- (MGroup *)editAndSaveGroup:(MGroup *)group name:(NSString *)name;

- (RMemberToGroup *)addFriend:(MFriend *)mFriend toGroup:(MGroup *)group;

- (void)removeFriend:(MFriend *)mFriend fromGroup:(MGroup *)group onComplete:(MACommonCallBackBlock)onComplete onFailed:(MACommonCallBackBlock)onFailed;

- (BOOL)isMember:(MFriend *)member belongsToGroup:(MGroup *)group;

@end