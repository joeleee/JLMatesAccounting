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

+ (MAAccountPersistent *)instance
{
    static MAAccountPersistent     *sharedInstance;
    static dispatch_once_t         onceToken;

    dispatch_once(&onceToken, ^{
        sharedInstance = [[self alloc] init];
    });
    return sharedInstance;
}

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
    BOOL isSucceed = NO;

    NSString *memberToAccountClass = NSStringFromClass([RMemberToAccount class]);
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] initWithEntityName:memberToAccountClass];
    NSPredicate *predicate = [NSPredicate predicateWithBlock:^BOOL(id evaluatedObject, NSDictionary *bindings) {
        RMemberToAccount *relationship = evaluatedObject;
        return (relationship.member == member && relationship.account == account);
    }];
    [fetchRequest setPredicate:predicate];

    NSArray *relationships = [MACommonPersistent fetchObjects:fetchRequest entityName:memberToAccountClass];
    if (0 >= relationships.count) {
        return isSucceed;
    }

    RMemberToAccount *relationship = relationships[0];
    isSucceed = [MACommonPersistent deleteObject:relationship];
    return isSucceed;
}

- (MAccount *)createAccountInGroup:(MGroup *)group
                              date:(NSDate *)date
                             payer:(MMember *)payer
{
    MAccount *account = [MACommonPersistent createObject:NSStringFromClass([MAccount class])];

    if (account) {
        NSDate *currentData = [NSDate date];
        account.createDate = currentData;
        account.updateDate = currentData;
        account.accountID = @([currentData timeIntervalSince1970]);
        account.group = group;
        account.accountDate = date;
        account.payer = payer;
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