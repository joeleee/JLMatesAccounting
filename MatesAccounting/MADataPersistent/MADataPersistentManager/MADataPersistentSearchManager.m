//
//  MADataPersistentSearchManager.m
//  MatesAccounting
//
//  Created by Lee on 13-11-19.
//  Copyright (c) 2013年 Lee. All rights reserved.
//

#import "MADataPersistentSearchManager.h"

#import "MAccount.h"
#import "MFriend.h"
#import "RMemberToAccount.h"
#import "MAAccountPersistent.h"
#import "MAMemberPersistent.h"
#import "MAGroupPersistent.h"
#import "MAPlacePersistent.h"
#import "MACommonPersistent.h"

@implementation MADataPersistentSearchManager

+ (MADataPersistentSearchManager *)sharedManager
{
    static MADataPersistentSearchManager *sharedInstance;
    static dispatch_once_t               onceToken;

    dispatch_once(&onceToken, ^{
        sharedInstance = [[self alloc] init];
    });
    return sharedInstance;
}

#pragma mark - 持久化查询

#pragma mark member相关

- (NSSet *)accountsForMember:(MFriend *)member sortDescriptor:(NSSortDescriptor *)sortDescriptor
{
    NSMutableSet *accounts = [NSMutableSet set];

    for (RMemberToAccount *relationship in member.relationshipToAccount) {
        [accounts addObject:relationship.account];
    }

    if (sortDescriptor) {
        [accounts sortedArrayUsingDescriptors:@[sortDescriptor]];
    } else {
        NSSortDescriptor *defaultSort = [NSSortDescriptor sortDescriptorWithKey:@"createDate" ascending:NO];
        [accounts sortedArrayUsingDescriptors:@[defaultSort]];
    }

    return accounts;
}

- (NSSet *)spendingDetailsForMember:(MFriend *)member sortDescriptor:(NSSortDescriptor *)sortDescriptor
{
    NSMutableSet *spendingDetails = [NSMutableSet setWithSet:member.relationshipToAccount];

    if (sortDescriptor) {
        [spendingDetails sortedArrayUsingDescriptors:@[sortDescriptor]];
    } else {
        NSSortDescriptor *defaultSort = [NSSortDescriptor sortDescriptorWithKey:@"account" ascending:NO comparator:^NSComparisonResult(id obj1, id obj2) {
            MAccount *account1 = obj1;
            MAccount *account2 = obj2;
            return [account1.createDate compare:account2.createDate];
        }];
        [spendingDetails sortedArrayUsingDescriptors:@[defaultSort]];
    }

    return spendingDetails;
}

- (NSSet *)payAccountsForMember:(MFriend *)member sortDescriptor:(NSSortDescriptor *)sortDescriptor
{
    NSMutableSet *accounts = [NSMutableSet set];
    for (RMemberToAccount *relationship in member.relationshipToAccount) {
        if (0 < [relationship.fee doubleValue]) {
            [accounts addObject:relationship.account];
        }
    }

    if (sortDescriptor) {
        [accounts sortedArrayUsingDescriptors:@[sortDescriptor]];
    } else {
        NSSortDescriptor *defaultSort = [NSSortDescriptor sortDescriptorWithKey:@"createDate" ascending:NO];
        [accounts sortedArrayUsingDescriptors:@[defaultSort]];
    }

    return accounts;
}

#pragma mark account相关

- (NSSet *)membersForAccount:(MAccount *)account sortDescriptor:(NSSortDescriptor *)sortDescriptor
{
    NSMutableSet *members = [NSMutableSet set];

    for (RMemberToAccount *relationship in account.relationshipToMember) {
        [members addObject:relationship.member];
    }

    if (sortDescriptor) {
        [members sortedArrayUsingDescriptors:@[sortDescriptor]];
    } else {
        NSSortDescriptor *defaultSort = [NSSortDescriptor sortDescriptorWithKey:@"createDate" ascending:YES];
        [members sortedArrayUsingDescriptors:@[defaultSort]];
    }

    return members;
}

@end