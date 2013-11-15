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

@implementation MAAccountPersistent

- (MAccount *)createAccount
{
    MAccount *account = [MACommonPersistent createObject:NSStringFromClass([MAccount class])];

    if (account) {
        NSDate *currentData = [NSDate date];
        account.createDate = currentData;
        account.updateDate = currentData;
        account.accountID = @([currentData timeIntervalSince1970]);
    }

    return account;
}

- (BOOL)deleteAccount:(MAccount *)account
{
    BOOL isSucceed = [MACommonPersistent deleteAccount:account];

    return isSucceed;
}

- (NSArray *)fetchAccount:(NSFetchRequest *)request
{
    NSArray *result = [MACommonPersistent fetchObjects:request entityName:NSStringFromClass([MAccount class])];

    return result;
}

@end