//
//  MAAccountPersistent.m
//  MatesAccounting
//
//  Created by Lee on 13-11-15.
//  Copyright (c) 2013年 Lee. All rights reserved.
//

#import "MAAccountPersistent.h"

#import "MAccount.h"
#import "MACommonPersistent.h"
#import "RMemberToAccount.h"
#import "MAContextAPI.h"

@implementation MAAccountPersistent

- (BOOL)addMember:(MMember *)member toAccount:(MAccount *)account fee:(NSNumber *)fee
{
    RMemberToAccount *memberToAccount = [MACommonPersistent createObject:NSStringFromClass([RMemberToAccount class])];

    if (memberToAccount) {
        NSDate *currentData = [NSDate date];
        memberToAccount.createDate = currentData;
        memberToAccount.member = member;
        memberToAccount.fee = fee;
        memberToAccount.account = account;
        return [[MAContextAPI sharedAPI] saveContextData];
    }

    return NO;
}

- (BOOL)removeMember:(MMember *)member fromAccount:(MAccount *)account
{
    // TODO: 移除成员
    return NO;
}

- (MAccount *)createAccountInGroup:(MGroup *)group
                            detail:(NSString *)detail
                             place:(MPlace *)place
{
    MAccount *account = [MACommonPersistent createObject:NSStringFromClass([MAccount class])];

    if (account) {
        NSDate *currentData = [NSDate date];
        account.createDate = currentData;
        account.updateDate = currentData;
        account.accountID = @([currentData timeIntervalSince1970]);
        account.group = group;
        account.detail = detail;
        account.place = place;
        [[MAContextAPI sharedAPI] saveContextData];
    }

    return account;
}

- (BOOL)updateAccount:(MAccount *)account
{
    BOOL isSucceed = NO;
    if (account) {
        NSDate *currentData = [NSDate date];
        account.updateDate = currentData;
        isSucceed = [[MAContextAPI sharedAPI] saveContextData];
    }

    return isSucceed;
}

- (BOOL)deleteAccount:(MAccount *)account
{
    BOOL isSucceed = [MACommonPersistent deleteObject:account];

    return isSucceed;
}

- (NSArray *)fetchAccount:(NSFetchRequest *)request
{
    NSArray *result = [MACommonPersistent fetchObjects:request entityName:NSStringFromClass([MAccount class])];

    return result;
}

@end