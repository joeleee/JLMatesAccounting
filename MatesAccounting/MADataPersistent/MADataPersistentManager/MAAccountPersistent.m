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
#import "RMemberToAccount.h"
#import "MAContextAPI.h"

@implementation MAAccountPersistent

- (MAccount *)createAccount
{
    NSManagedObjectModel   *moModel = [[MAContextAPI sharedAPI] managedObjectModel];
    NSManagedObjectContext *moContext = [[MAContextAPI sharedAPI] managedObjectContext];
    NSEntityDescription    *entity = [[moModel entitiesByName] objectForKey:NSStringFromClass([MAccount class])];

    MAccount *account = [NSEntityDescription insertNewObjectForEntityForName:[entity name] inManagedObjectContext:moContext];

    if (account) {
        account.createDate = [NSDate date];

        // TODO: 存储处理
        if ([[MAContextAPI sharedAPI] saveContextData]) {
        } else {
        }
    }

    return account;
}

@end