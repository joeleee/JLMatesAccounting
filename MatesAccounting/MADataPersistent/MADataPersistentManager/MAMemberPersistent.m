//
//  MAMemberPersistent.m
//  MatesAccounting
//
//  Created by Lee on 13-11-15.
//  Copyright (c) 2013年 Lee. All rights reserved.
//

#import "MAMemberPersistent.h"

#import "MACommonPersistent.h"
#import "MFriend.h"
#import "MAContextAPI.h"

@implementation MAMemberPersistent

+ (MAMemberPersistent *)instance
{
    static MAMemberPersistent     *sharedInstance;
    static dispatch_once_t        onceToken;

    dispatch_once(&onceToken, ^{
        sharedInstance = [[self alloc] init];
    });
    return sharedInstance;
}

- (MFriend *)createMemberWithName:(NSString *)name
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

- (BOOL)updateMember:(MFriend *)member
{
    BOOL isSucceed = NO;

    if (member) {
        NSDate *currentData = [NSDate date];
        member.updateDate = currentData;
        isSucceed = [[MAContextAPI sharedAPI] saveContextData];
    }

    return isSucceed;
}

- (BOOL)deleteMember:(MFriend *)member
{
    BOOL isSucceed = [MACommonPersistent deleteObject:member];

    return isSucceed;
}

- (NSArray *)fetchAccount:(NSFetchRequest *)request
{
    NSArray *result = [MACommonPersistent fetchObjects:request entityName:NSStringFromClass([MFriend class])];

    return result;
}

@end