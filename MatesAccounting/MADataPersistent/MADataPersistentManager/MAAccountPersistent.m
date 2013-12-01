//
//  MAAccountPersistent.m
//  MatesAccounting
//
//  Created by Lee on 13-11-15.
//  Copyright (c) 2013年 Lee. All rights reserved.
//

#import "MAAccountPersistent.h"

#import "MAccount+expand.h"
#import "MACommonPersistent.h"
#import "RMemberToAccount.h"
#import "MAContextAPI.h"

@implementation MAAccountPersistent

+ (MAAccountPersistent *)instance
{
    static MAAccountPersistent     *sharedInstance;
    static dispatch_once_t         onceToken;

    dispatch_once(&onceToken, ^{
        sharedInstance = [[self alloc] init];
    });
    return sharedInstance;
}

- (BOOL)addMember:(MMember *)member toAccount:(MAccount *)account fee:(double)fee
{
    for (RMemberToAccount *memberToAccount in account.relationshipToMember) {
        if (memberToAccount.member == member) {
            return NO;
        }
    }

    RMemberToAccount *memberToAccount = [MACommonPersistent createObject:NSStringFromClass([RMemberToAccount class])];
    NSAssert(memberToAccount, @"Assert memberToAccount == nil");

    if (memberToAccount) {
        NSDate *currentData = [NSDate date];
        memberToAccount.createDate = currentData;
        memberToAccount.member = member;
        memberToAccount.fee = @(fee);
        memberToAccount.account = account;
        [account refreshAccountTotalFee];
        return [[MAContextAPI sharedAPI] saveContextData];
    }

    return NO;
}

- (BOOL)removeMember:(MMember *)member fromAccount:(MAccount *)account
{
    BOOL isSucceed = NO;

    RMemberToAccount *memberToAccount = nil;
    for (RMemberToAccount *relationship in account.relationshipToMember) {
        if (relationship.member == member) {
            memberToAccount = relationship;
            break;
        }
    }

    NSAssert(memberToAccount, @"Assert memberToAccount == nil");
    isSucceed = [MACommonPersistent deleteObject:memberToAccount];
    [account refreshAccountTotalFee];

    return isSucceed;
}

- (MAccount *)createAccountInGroup:(MGroup *)group
                              date:(NSDate *)date
{
    MAccount *account = [MACommonPersistent createObject:NSStringFromClass([MAccount class])];
    NSAssert(account, @"Assert account == nil");

    if (account) {
        NSDate *currentData = [NSDate date];
        account.createDate = currentData;
        account.updateDate = currentData;
        account.accountID = @([currentData timeIntervalSince1970]);
        account.group = group;
        account.accountDate = date;
        account.totalFee = @(0);
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