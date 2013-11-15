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

@implementation MAMemberPersistent

- (MMember *)createMember
{
    MMember *member = [MACommonPersistent createObject:NSStringFromClass([MMember class])];

    if (member) {
        NSDate *currentData = [NSDate date];
        member.createDate = currentData;
        member.updateDate = currentData;
        member.memberID = @([currentData timeIntervalSince1970]);
    }

    return member;
}

- (BOOL)deleteMember:(MMember *)member
{
    BOOL isSucceed = [MACommonPersistent deleteAccount:member];

    return isSucceed;
}

- (NSArray *)fetchAccount:(NSFetchRequest *)request
{
    NSArray *result = [MACommonPersistent fetchObjects:request entityName:NSStringFromClass([MMember class])];

    return result;
}

@end