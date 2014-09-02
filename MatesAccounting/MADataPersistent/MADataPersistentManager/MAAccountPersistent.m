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

- (MAccount *)createAccountInGroup:(MGroup *)group
                              date:(NSDate *)date
{
    MAccount *account = [MACommonPersistent createObject:NSStringFromClass([MAccount class])];
    MA_QUICK_ASSERT(account, @"Assert account == nil");

    if (account) {
        NSDate *currentData = [NSDate date];
        account.createDate = currentData;
        account.updateDate = currentData;
        account.accountID = @([currentData timeIntervalSince1970]);
        account.group = group;
        account.accountDate = date;
        account.totalFee = DecimalZero;
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
        [account refreshAccountTotalFee];
        isSucceed = [[MAContextAPI sharedAPI] saveContextData];
    }

    return isSucceed;
}

- (BOOL)deleteAccount:(MAccount *)account
{
    BOOL isSucceed = [MACommonPersistent deleteObject:account];

    return isSucceed;
}

- (NSArray *)fetchAccounts:(NSFetchRequest *)request
{
    NSArray *result;
    if (request) {
        result = [MACommonPersistent fetchObjectsWithRequest:request];
    } else {
        result = [MACommonPersistent fetchObjectsWithEntityName:[MAccount className]];
    }

    return result;
}

- (RMemberToAccount *)createMemberToAccount:(MAccount *)account member:(MFriend *)member fee:(NSDecimalNumber *)fee
{
    MA_QUICK_ASSERT(account && member, @"account && member cannot be nil.");
    RMemberToAccount *memberToAccount = [MACommonPersistent createObject:NSStringFromClass([RMemberToAccount class])];
    MA_QUICK_ASSERT(memberToAccount, @"Assert create memberToAccount failed.");

    if (memberToAccount) {
        memberToAccount.createDate = [NSDate date];
        memberToAccount.member = member;
        memberToAccount.fee = fee;
        memberToAccount.account = account;
        if (![[MAContextAPI sharedAPI] saveContextData]) {
            [MACommonPersistent deleteObject:memberToAccount];
            memberToAccount = nil;
        }
    }

    return memberToAccount;
}

- (BOOL)deleteMemberToAccount:(RMemberToAccount *)memberToAccount
{
    BOOL isSucceed = [MACommonPersistent deleteObject:memberToAccount];

    return isSucceed;
}

- (BOOL)addFriend:(MFriend *)member toAccount:(MAccount *)account fee:(NSDecimalNumber *)fee
{
    for (RMemberToAccount *memberToAccount in account.relationshipToMember) {
        if (memberToAccount.member == member) {
            return NO;
        }
    }

    RMemberToAccount *memberToAccount = [self createMemberToAccount:account member:member fee:fee];
    MA_QUICK_ASSERT(memberToAccount, @"Assert memberToAccount == nil");

    if (memberToAccount) {
        [account refreshAccountTotalFee];
        return [[MAContextAPI sharedAPI] saveContextData];
    }

    return NO;
}

- (BOOL)removeFriend:(MFriend *)mFriend fromAccount:(MAccount *)account
{
    BOOL isSucceed = NO;

    RMemberToAccount *memberToAccount = nil;
    for (RMemberToAccount *relationship in account.relationshipToMember) {
        if (relationship.member == mFriend) {
            memberToAccount = relationship;
            break;
        }
    }

    MA_QUICK_ASSERT(memberToAccount, @"Assert memberToAccount == nil");
    isSucceed = [MACommonPersistent deleteObject:memberToAccount];
    [account refreshAccountTotalFee];

    return isSucceed;
}

@end