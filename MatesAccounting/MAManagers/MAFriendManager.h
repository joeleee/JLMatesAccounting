//
//  MAFriendManager.h
//  MatesAccounting
//
//  Created by Lee on 13-12-12.
//  Copyright (c) 2013年 Lee. All rights reserved.
//

#import <Foundation/Foundation.h>

#define FriendManager [MAFriendManager sharedManager]

@class MFriend;

typedef enum {
    Unknow = 0,
    Male = 1,
    Female = 2
} MAFriendGender;

@interface MAFriendManager : NSObject

+ (MAFriendManager *)sharedManager;

- (NSArray *)currentGroupMembers;

- (NSArray *)allFriends;

- (MFriend *)createFriendWithName:(NSString *)name
                           gender:(MAFriendGender)gender
                      phoneNumber:(NSNumber *)phoneNumber
                            eMail:(NSString *)eMail
                         birthday:(NSDate *)birthday;

- (MFriend *)editAndSaveFriend:(MFriend *)friend
                          name:(NSString *)name
                        gender:(MAFriendGender)gender
                   phoneNumber:(NSNumber *)phoneNumber
                         eMail:(NSString *)eMail
                      birthday:(NSDate *)birthday;

@end