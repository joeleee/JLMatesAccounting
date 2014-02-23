//
//  MAFriendManager.m
//  MatesAccounting
//
//  Created by Lee on 13-12-12.
//  Copyright (c) 2013年 Lee. All rights reserved.
//

#import "MAFriendManager.h"

#import "MGroup.h"
#import "MAGroupManager.h"
#import "MAFriendPersistent.h"
#import "MFriend.h"

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

- (NSArray *)currentGroupToMembers
{
    NSArray *relationshipToMember = [[GroupManager currentGroup].relationshipToMember allObjects];

    return relationshipToMember;
}

- (NSArray *)allFriendsFilteByGroup:(MGroup *)group
{
    NSArray *friends = [[MAFriendPersistent instance] fetchFriends:nil];

    if (group) {
        NSPredicate *predicate = [NSPredicate predicateWithBlock:^BOOL(id evaluatedObject, NSDictionary *bindings) {
            MFriend *friend = evaluatedObject;
            return ![friend.relationshipToGroup intersectsSet:group.relationshipToMember];
        }];
        friends = [friends filteredArrayUsingPredicate:predicate];
    }

    return friends;
}

- (MFriend *)createFriendWithName:(NSString *)name
                           gender:(MAGenderEnum)gender
                      phoneNumber:(NSNumber *)phoneNumber
                            eMail:(NSString *)eMail
                         birthday:(NSDate *)birthday
{
    if (0 >= [name stringByReplacingOccurrencesOfString:@" " withString:@""].length) {
        return nil;
    }

    MFriend *friend = [[MAFriendPersistent instance] createFriendWithName:name];
    MA_QUICK_ASSERT(friend, @"Create friend failed~ createFriendWithName");

    friend.sex = @(gender);
    friend.telephoneNumber = phoneNumber;
    friend.eMail = eMail;
    friend.birthday = birthday;
    BOOL isSucceed = [[MAFriendPersistent instance] updateFriend:friend];
    MA_QUICK_ASSERT(isSucceed, @"Update friend failed~ createFriendWithName");

    return friend;
}

- (BOOL)editAndSaveFriend:(MFriend *)friend
                     name:(NSString *)name
                   gender:(MAGenderEnum)gender
              phoneNumber:(NSNumber *)phoneNumber
                    eMail:(NSString *)eMail
                 birthday:(NSDate *)birthday
{
    if (0 >= [name stringByReplacingOccurrencesOfString:@" " withString:@""].length) {
        return NO;
    }

    friend.name = name;
    friend.sex = @(gender);
    friend.telephoneNumber = phoneNumber;
    friend.eMail = eMail;
    friend.birthday = birthday;
    BOOL isSucceed = [[MAFriendPersistent instance] updateFriend:friend];
    MA_QUICK_ASSERT(isSucceed, @"Update friend failed~ createFriendWithName");

    return isSucceed;
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