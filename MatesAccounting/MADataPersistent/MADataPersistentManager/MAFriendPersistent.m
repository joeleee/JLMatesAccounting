//
//  MAFriendPersistent.m
//  MatesAccounting
//
//  Created by Lee on 13-11-15.
//  Copyright (c) 2013年 Lee. All rights reserved.
//

#import "MAFriendPersistent.h"

#import "MACommonPersistent.h"
#import "MFriend.h"
#import "MAContextAPI.h"

@implementation MAFriendPersistent

+ (MAFriendPersistent *)instance
{
    static MAFriendPersistent     *sharedInstance;
    static dispatch_once_t        onceToken;

    dispatch_once(&onceToken, ^{
        sharedInstance = [[self alloc] init];
    });
    return sharedInstance;
}

- (MFriend *)createFriendWithName:(NSString *)name
{
    MFriend *member = [MACommonPersistent createObject:NSStringFromClass([MFriend class])];
    NSAssert(member, @"Assert member == nil");

    if (member) {
        NSDate *currentData = [NSDate date];
        member.name = name;
        member.createDate = currentData;
        member.updateDate = currentData;
        member.friendID = @([currentData timeIntervalSince1970]);
        [[MAContextAPI sharedAPI] saveContextData];
    }

    return member;
}

- (BOOL)updateFriend:(MFriend *)friend
{
    BOOL isSucceed = NO;

    if (friend) {
        NSDate *currentData = [NSDate date];
        friend.updateDate = currentData;
        isSucceed = [[MAContextAPI sharedAPI] saveContextData];
    }

    return isSucceed;
}

- (BOOL)deleteFriend:(MFriend *)friend
{
    BOOL isSucceed = [MACommonPersistent deleteObject:friend];

    return isSucceed;
}

- (NSArray *)fetchFriends:(NSFetchRequest *)request
{
    NSArray *result = [MACommonPersistent fetchObjects:request entityName:NSStringFromClass([MFriend class])];

    return result;
}

@end