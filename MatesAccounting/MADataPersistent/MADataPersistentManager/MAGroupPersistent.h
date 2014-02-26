//
//  MAGroupPersistent.h
//  MatesAccounting
//
//  Created by Lee on 13-11-15.
//  Copyright (c) 2013年 Lee. All rights reserved.
//

#import <Foundation/Foundation.h>

@class MGroup, MFriend, RMemberToGroup;

@interface MAGroupPersistent : NSObject

+ (MAGroupPersistent *)instance;

- (RMemberToGroup *)addFriend:(MFriend *)member toGroup:(MGroup *)group;

- (BOOL)removeFriend:(MFriend *)member fromGroup:(MGroup *)group;

- (MGroup *)createGroupWithGroupName:(NSString *)groupName;

- (BOOL)updateGroup:(MGroup *)group;

- (BOOL)deleteGroup:(MGroup *)group;

- (NSArray *)fetchGroups:(NSFetchRequest *)request;

- (MGroup *)groupByGroupID:(NSNumber *)groupID;

@end