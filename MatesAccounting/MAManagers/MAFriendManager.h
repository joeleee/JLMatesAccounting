//
//  MAFriendManager.h
//  MatesAccounting
//
//  Created by Lee on 13-12-12.
//  Copyright (c) 2013年 Lee. All rights reserved.
//

#define FriendManager [MAFriendManager sharedManager]

#import "MACommonManagerBase.h"

@class MFriend, MGroup;

@protocol MAFriendManagerListenerProtocol <NSObject>

@optional
- (void)friendHasCreated:(MFriend *)mFriend;
- (void)friendHasModified:(MFriend *)mFriend;

@end


@interface MAFriendManager : MACommonManagerBase

- (BOOL)addListener:(id<MAFriendManagerListenerProtocol>)listener;

- (BOOL)removeListener:(id<MAFriendManagerListenerProtocol>)listener;

- (NSArray *)currentGroupToMemberRelationships;

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

@end