//
//  MAFriendManager.h
//  MatesAccounting
//
//  Created by Lee on 13-12-12.
//  Copyright (c) 2013年 Lee. All rights reserved.
//

#import <Foundation/Foundation.h>

@class MFriend, MGroup;

#define FriendManager [MAFriendManager sharedManager]

@interface MAFriendManager : NSObject

+ (MAFriendManager *)sharedManager;

- (NSArray *)currentGroupToMembers;

- (NSArray *)allFriendsFilteByGroup:(MGroup *)group;

- (MFriend *)createFriendWithName:(NSString *)name
                           gender:(MAGenderEnum)gender
                      phoneNumber:(NSNumber *)phoneNumber
                            eMail:(NSString *)eMail
                         birthday:(NSDate *)birthday;

- (BOOL)editAndSaveFriend:(MFriend *)friend
                     name:(NSString *)name
                   gender:(MAGenderEnum)gender
              phoneNumber:(NSNumber *)phoneNumber
                    eMail:(NSString *)eMail
                 birthday:(NSDate *)birthday;

@end