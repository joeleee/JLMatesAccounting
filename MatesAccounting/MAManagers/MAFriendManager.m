//
//  MAFriendManager.m
//  MatesAccounting
//
//  Created by Lee on 13-12-12.
//  Copyright (c) 2013年 Lee. All rights reserved.
//

#import "MAFriendManager.h"

#import "MFriend.h"
#import "MGroup.h"
#import "MAGroupManager.h"
#import "MAFriendPersistent.h"

@implementation MAFriendManager

+ (MAFriendManager *)sharedManager
{
    static MAFriendManager *sharedInstance = nil;
    static dispatch_once_t onceToken;

    dispatch_once(&onceToken, ^{
        sharedInstance = [[MAFriendManager alloc] init];
    });

    return sharedInstance;
}

- (NSArray *)currentGroupMembers
{
    NSArray *members = [[GroupManager currentGroup].relationshipToMember allObjects];

    return members;
}

- (NSArray *)allFriends
{
    NSArray *friends = [[MAFriendPersistent instance] fetchFriends:nil];

    return friends;
}

- (MFriend *)createFriendWithName:(NSString *)name
                           gender:(MAFriendGender)gender
                      phoneNumber:(NSNumber *)phoneNumber
                            eMail:(NSString *)eMail
                         birthday:(NSDate *)birthday
{
    MFriend *friend = [[MAFriendPersistent instance] createFriendWithName:name];
    NSAssert(friend, @"Create friend failed~ createFriendWithName");

    friend.sex = @(gender);
    friend.telephoneNumber = phoneNumber;
    friend.eMail = eMail;
    friend.birthday = birthday;
    BOOL isSucceed = [[MAFriendPersistent instance] updateFriend:friend];
    NSAssert(isSucceed, @"Update friend failed~ createFriendWithName");

    return friend;
}

- (MFriend *)editAndSaveFriend:(MFriend *)friend
                          name:(NSString *)name
                        gender:(MAFriendGender)gender
                   phoneNumber:(NSNumber *)phoneNumber
                         eMail:(NSString *)eMail
                      birthday:(NSDate *)birthday
{
    friend.sex = @(gender);
    friend.telephoneNumber = phoneNumber;
    friend.eMail = eMail;
    friend.birthday = birthday;
    BOOL isSucceed = [[MAFriendPersistent instance] updateFriend:friend];
    NSAssert(isSucceed, @"Update friend failed~ createFriendWithName");

    return friend;
}

- (BOOL)addFriend:(MFriend *)friend toGroup:(MGroup *)group
{
    NSSet *members = group.relationshipToMember;
    if ([members containsObject:friend]) {
        return NO;
    }

    return YES;
}

@end