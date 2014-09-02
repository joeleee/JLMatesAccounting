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
    MA_QUICK_ASSERT(member, @"Assert member == nil");

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

- (BOOL)updateFriend:(MFriend *)mFriend
{
    BOOL isSucceed = NO;

    if (mFriend) {
        NSDate *currentData = [NSDate date];
        mFriend.updateDate = currentData;
        isSucceed = [[MAContextAPI sharedAPI] saveContextData];
    }

    return isSucceed;
}

- (BOOL)deleteFriend:(MFriend *)mFriend
{
    BOOL isSucceed = [MACommonPersistent deleteObject:mFriend];

    return isSucceed;
}

- (NSArray *)fetchFriends:(NSFetchRequest *)request
{
    NSArray *result;
    if (request) {
        result = [MACommonPersistent fetchObjectsWithRequest:request];
    } else {
        result = [MACommonPersistent fetchObjectsWithEntityName:[MFriend className]];
    }

    return result;
}

@end