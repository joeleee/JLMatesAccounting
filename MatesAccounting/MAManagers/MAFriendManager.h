//
//  MAFriendManager.h
//  MatesAccounting
//
//  Created by Lee on 13-12-12.
//  Copyright (c) 2013年 Lee. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "MFriend+expand.h"

#define FriendManager [MAFriendManager sharedManager]

@interface MAFriendManager : NSObject

+ (MAFriendManager *)sharedManager;

- (NSArray *)currentGroupMembers;

- (NSArray *)allFriends;

- (MFriend *)createFriendWithName:(NSString *)name
                           gender:(MAFriendGender)gender
                      phoneNumber:(NSNumber *)phoneNumber
                            eMail:(NSString *)eMail
                         birthday:(NSDate *)birthday;

- (BOOL)editAndSaveFriend:(MFriend *)friend
                     name:(NSString *)name
                   gender:(MAFriendGender)gender
              phoneNumber:(NSNumber *)phoneNumber
                    eMail:(NSString *)eMail
                 birthday:(NSDate *)birthday;

@end