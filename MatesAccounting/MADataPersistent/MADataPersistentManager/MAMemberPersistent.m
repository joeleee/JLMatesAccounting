//
//  MAMemberPersistent.m
//  MatesAccounting
//
//  Created by Lee on 13-11-15.
//  Copyright (c) 2013年 Lee. All rights reserved.
//

#import "MAMemberPersistent.h"

#import "MACommonPersistent.h"
#import "MMember.h"
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

- (MMember *)createMemberWithName:(NSString *)name
{
    MMember *member = [MACommonPersistent createObject:NSStringFromClass([MMember class])];
    NSAssert(member, @"Assert member == nil");

    if (member) {
        NSDate *currentData = [NSDate date];
        member.name = name;
        member.createDate = currentData;
        member.updateDate = currentData;
        member.memberID = @([currentData timeIntervalSince1970]);
        [[MAContextAPI sharedAPI] saveContextData];
    }

    return member;
}

- (BOOL)updateMember:(MMember *)member
{
    BOOL isSucceed = NO;

    if (member) {
        NSDate *currentData = [NSDate date];
        member.updateDate = currentData;
        isSucceed = [[MAContextAPI sharedAPI] saveContextData];
    }

    return isSucceed;
}

- (BOOL)deleteMember:(MMember *)member
{
    BOOL isSucceed = [MACommonPersistent deleteObject:member];

    return isSucceed;
}

- (NSArray *)fetchAccount:(NSFetchRequest *)request
{
    NSArray *result = [MACommonPersistent fetchObjects:request entityName:NSStringFromClass([MMember class])];

    return result;
}

@end