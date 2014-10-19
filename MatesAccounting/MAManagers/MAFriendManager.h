//
//  MAFriendManager.h
//  MatesAccounting
//
//  Created by Lee on 13-12-12.
//  Copyright (c) 2013年 Lee. All rights reserved.
//

#import <Foundation/Foundation.h>

#define FriendManager [MAFriendManager sharedManager]

@class MFriend, MGroup;

@protocol MAFriendManagerObserverProtocol <NSObject>

@optional
- (void)friendDidCreated:(MFriend *)mFriend;
- (void)friendDidDeleted;
- (void)friendDidChanged:(MFriend *)mFriend;

@end


@interface MAFriendManager : NSObject

+ (MAFriendManager *)sharedManager;

- (void)registerFriendObserver:(id<MAFriendManagerObserverProtocol>)observer;

- (void)unregisterFriendObserver:(id<MAFriendManagerObserverProtocol>)observer;

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

- (void)deleteFriend:(MFriend *)mFriend onComplete:(MACommonCallBackBlock)onComplete onFailed:(MACommonCallBackBlock)onFailed;

- (NSArray *)unpaidGroupsForFriend:(MFriend *)mFriend;

@end