//
//  MATestDataGenerater.m
//  MatesAccounting
//
//  Created by Joe Lee on 2014-8-18.
//  Copyright (c) 2014年 Lee. All rights reserved.
//

#import "MATestDataGenerater.h"

#import "MGroup.h"
#import "RMemberToGroup+expand.h"
#import "MAGroupManager.h"
#import "MAAccountManager.h"
#import "MAFriendManager.h"
#import "MAContextAPI.h"

@implementation MATestDataGenerater

+ (MATestDataGenerater *)instance
{
    static MATestDataGenerater *sharedInstance;
    static dispatch_once_t onceToken;

    dispatch_once(&onceToken, ^{
        sharedInstance = [[self alloc] init];
    });
    return sharedInstance;
}

- (void)generateGroups:(NSUInteger)totalCount
{
    MALogInfo(@"\n\n==============================\n");
    for (; totalCount > 0; --totalCount) {
        MALogInfo(@"Generating groups %lu", (unsigned long)totalCount);
        unsigned int randomValue = arc4random() % 10000;
        [GroupManager createGroup:[NSString stringWithFormat:@"Group_%u", randomValue]];
    }
}

- (void)generateFriends:(NSUInteger)totalCount
{
    MALogInfo(@"\n\n==============================\n");
    for (; totalCount > 0; --totalCount) {
        MALogInfo(@"Generating friend %lu", (unsigned long)totalCount);
        unsigned int randomValue = arc4random();
        [FriendManager createFriendWithName:[NSString stringWithFormat:@"Friend_%u", randomValue % 1000]
                                     gender:(randomValue % 2) ? MAGenderFemale : MAGenderMale
                                phoneNumber:@(randomValue)
                                      eMail:[NSString stringWithFormat:@"Friend_%u@gmail.boss", randomValue % 1000]
                                   birthday:[[NSDate date] dateByAddingTimeInterval:-randomValue]];
    }
}

- (void)addFriendToGroup:(MGroup *)group totalCount:(NSUInteger)totalCount
{
    MALogInfo(@"\n\n==============================\n");
    for (MFriend *friend in [FriendManager allFriendsFilteByGroup:group]) {
        if (totalCount-- == 0) {
            return;
        }
        MALogInfo(@"Adding friend to group %lu", (unsigned long)totalCount);
        [GroupManager addFriend:friend toGroup:group];
    }
}

- (void)generateAccountInGroup:(MGroup *)group totalCount:(NSUInteger)totalCount
{
    MALogInfo(@"\n\n==============================\n");
    if (0 == group.relationshipToMember.count) {
        return;
    }

    for (; totalCount > 0; --totalCount) {
        MALogInfo(@"Generating account %lu", (unsigned long)totalCount);

        unsigned int randomValue = arc4random();
        NSMutableSet *feeOfMembers = [NSMutableSet set];

        // generating payers
        NSMutableArray *members = [NSMutableArray arrayWithArray:[group.relationshipToMember allObjects]];
        NSUInteger totalFee = randomValue % 10000000;
        NSUInteger payersCount = (randomValue % group.relationshipToMember.count) + 1;
        for (; payersCount > 0; --payersCount) {
            unsigned int tempRandomValue = arc4random();
            unsigned long fee = (payersCount == 1) ? totalFee : (tempRandomValue % totalFee);
            NSUInteger index = tempRandomValue % members.count;
            MAFeeOfMember *feeOfMember = [MAFeeOfMember feeOfMember:((RMemberToGroup *)members[index]).member fee:MATwoPreciseDecimal((double)fee/100.0f)];
            totalFee -= fee;
            [members removeObjectAtIndex:index];
            [feeOfMembers addObject:feeOfMember];
        }

        // generating consumers
        members = [NSMutableArray arrayWithArray:[group.relationshipToMember allObjects]];
        totalFee = randomValue % 10000000;
        NSUInteger consumersCount = (arc4random() % group.relationshipToMember.count) + 1;
        for (; consumersCount > 0; --consumersCount) {
            unsigned int tempRandomValue = arc4random();
            unsigned long fee = (consumersCount == 1) ? totalFee : (tempRandomValue % totalFee);
            NSUInteger index = tempRandomValue % members.count;
            MAFeeOfMember *feeOfMember = [MAFeeOfMember feeOfMember:((RMemberToGroup *)members[index]).member fee:MATwoPreciseDecimal(-(double)fee/100.0f)];
            totalFee -= fee;
            [members removeObjectAtIndex:index];
            [feeOfMembers addObject:feeOfMember];
        }

        // generating account
        [AccountManager createAccountWithGroup:group
                                          date:[[NSDate date] dateByAddingTimeInterval:(randomValue % 1000000)]
                                     placeName:[NSString stringWithFormat:@"place_%u", randomValue % 1000]
                                      latitude:(randomValue % 10000)
                                     longitude:(randomValue % 10000)
                                        detail:[NSString stringWithFormat:@"detail_%u", randomValue % 1000]
                                  feeOfMembers:feeOfMembers];
    }
}

- (void)onePackageService
{
    [[MATestDataGenerater instance] generateGroups:10];
    [[MATestDataGenerater instance] generateFriends:100];
    for (MGroup *group in [GroupManager myGroups]) {
        [[MATestDataGenerater instance] addFriendToGroup:group totalCount:24];
        [[MATestDataGenerater instance] generateAccountInGroup:group totalCount:23];
    }
}

- (void)clearAllData
{
    [self clearAllDataByEntityName:@"MPlace"];
    [self clearAllDataByEntityName:@"RMemberToAccount"];
    [self clearAllDataByEntityName:@"MAccount"];
    [self clearAllDataByEntityName:@"RMemberToGroup"];
    [self clearAllDataByEntityName:@"MFriend"];
    [self clearAllDataByEntityName:@"MGroup"];
}

- (void)clearAllDataByEntityName:(NSString *)entityName
{
    NSManagedObjectContext *context = [[MAContextAPI sharedAPI] managedObjectContext];
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    [request setIncludesPropertyValues:NO];
    [request setEntity:[NSEntityDescription entityForName:entityName inManagedObjectContext:context]];
    NSError *error = nil;
    NSArray *datas = [context executeFetchRequest:request error:&error];
    if (!error && [datas count] > 0) {
        for (NSManagedObject *obj in datas) {
            [context deleteObject:obj];
        }
    }
    if (![context save:&error]) {
        MALogInfo(@"!!! Save failed !!!");
    }
}

@end