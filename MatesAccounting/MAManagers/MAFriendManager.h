//
//  MAFriendManager.h
//  MatesAccounting
//
//  Created by Lee on 13-12-12.
//  Copyright (c) 2013年 Lee. All rights reserved.
//

#define FriendManager [MAFriendManager sharedManager]

#import "ZLMulticastAgent.h"

@class MFriend, MGroup;

@protocol MAFriendManagerListenerProtocol <NSObject>

@optional
- (void)friendHasCreated:(MFriend *)mFriend;
- (void)friendHasModified:(MFriend *)mFriend;

@end


@interface MAFriendManager : ZLMulticastAgent

+ (MAFriendManager *)sharedManager;

- (BOOL)addListener:(id<MAFriendManagerListenerProtocol>)listener;

- (BOOL)removeListener:(id<MAFriendManagerListenerProtocol>)listener;

- (NSArray *)currentGroupToMemberRelationships;

- (NSArray *)allFriendsByGroup:(MGroup *)group;

- (NSArray *)allFriendsFilteByGroup:(MGroup *)group;

- (MFriend *)createFriendWithName:(NSString *)name
                           gender:(MAGenderEnum)gender
                      phoneNumber:(NSNumber *)phoneNumber
                            eMail:(NSString *)eMail
                         birthday:(NSDate *)birthday;

- (BOOL)editAndSaveFriend:(MFriend *)mFriend
                     name:(NSString *)name
                   gender:(MAGenderEnum)gender
              phoneNumber:(NSNumber *)phoneNumber
                    eMail:(NSString *)eMail
                 birthday:(NSDate *)birthday;

- (BOOL)deleteFriend:(MFriend *)mFriend;

- (NSArray *)unpaidGroupsForFriend:(MFriend *)mFriend;

@end