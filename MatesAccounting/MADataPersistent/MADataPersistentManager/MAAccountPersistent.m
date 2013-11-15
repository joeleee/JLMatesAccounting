//
//  MAAccountPersistent.m
//  MatesAccounting
//
//  Created by Lee on 13-11-15.
//  Copyright (c) 2013年 Lee. All rights reserved.
//

#import "MAAccountPersistent.h"

#import "MAccount.h"
#import "MGroup.h"
#import "MACommonPersistent.h"
#import "MAContextAPI.h"

@implementation MAAccountPersistent

- (MAccount *)createAccount
{
    NSManagedObjectContext *moContext = [[MAContextAPI sharedAPI] managedObjectContext];
    NSManagedObjectModel   *moModel = [[MAContextAPI sharedAPI] managedObjectModel];
    NSEntityDescription    *entity = [[moModel entitiesByName] objectForKey:NSStringFromClass([MAccount class])];

    MAccount *account = [NSEntityDescription insertNewObjectForEntityForName:[entity name] inManagedObjectContext:moContext];

    [[MAContextAPI sharedAPI] saveContextData];

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
    BOOL isSucceed = NO;

    if (!account) {
        return isSucceed;
    }

    NSManagedObjectContext *moContext = [[MAContextAPI sharedAPI] managedObjectContext];
    [moContext deleteObject:account];
    isSucceed = [[MAContextAPI sharedAPI] saveContextData];

    return isSucceed;
}

- (NSArray *)fetchAccount:(NSFetchRequest *)request
{
    NSManagedObjectContext *moContext = [[MAContextAPI sharedAPI] managedObjectContext];
    NSEntityDescription    *entityDescription = [NSEntityDescription entityForName:NSStringFromClass([MAccount class]) inManagedObjectContext:moContext];

    [request setEntity:entityDescription];

    NSError *error = nil;
    NSArray *result = [moContext executeFetchRequest:request error:&error];

    return result;
}

@end