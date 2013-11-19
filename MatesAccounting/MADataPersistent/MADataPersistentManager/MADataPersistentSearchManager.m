//
//  MADataPersistentSearchManager.m
//  MatesAccounting
//
//  Created by Lee on 13-11-19.
//  Copyright (c) 2013年 Lee. All rights reserved.
//

#import "MADataPersistentSearchManager.h"

#import "MAccount.h"
#import "MMember.h"
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

- (NSSet *)accountsByMember:(MMember *)member sortDescriptor:(NSSortDescriptor *)sortDescriptor
{
    NSMutableSet *accounts = [NSMutableSet setWithSet:[member.payAccounts set]];

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

@end