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

- (NSArray *)generateGroups:(NSUInteger)totalCount
{
    MALogTestInfo(@"\n\n==============================\n");
    NSMutableArray *groups = [NSMutableArray array];
    for (; totalCount > 0; --totalCount) {
        MALogTestInfo(@"Generating groups %lu", (unsigned long)totalCount);
        unsigned int randomValue = arc4random() % 10000;
        MGroup *group = [GroupManager createGroup:[NSString stringWithFormat:@"Group_%u", randomValue]];
        MA_QUICK_ASSERT(group, @"Create group failed!");
        [groups addObject:group];
    }

    return groups;
}

- (NSArray *)generateFriends:(NSUInteger)totalCount
{
    MALogTestInfo(@"\n\n==============================\n");
    NSMutableArray *friends = [NSMutableArray array];
    for (; totalCount > 0; --totalCount) {
        MALogTestInfo(@"Generating friend %lu", (unsigned long)totalCount);
        unsigned int randomValue = arc4random();
        MFriend *friend = [FriendManager createFriendWithName:[NSString stringWithFormat:@"Friend_%u", randomValue % 1000]
                                     gender:(randomValue % 2) ? MAGenderFemale : MAGenderMale
                                phoneNumber:@(randomValue)
                                      eMail:[NSString stringWithFormat:@"Friend_%u@gmail.boss", randomValue % 1000]
                                   birthday:[[NSDate date] dateByAddingTimeInterval:-randomValue]];
        MA_QUICK_ASSERT(friend, @"Create friend failed!");
        [friends addObject:friend];
    }

    return friends;
}

- (NSArray *)addFriendToGroup:(MGroup *)group totalCount:(NSUInteger)totalCount
{
    MALogTestInfo(@"\n\n==============================\n");
    NSMutableArray *memberToGroups = [NSMutableArray array];
    NSMutableArray *friends = [NSMutableArray arrayWithArray:[FriendManager allFriendsFilteByGroup:group]];
    for (; totalCount > 0; --totalCount) {
        if (0 >= friends.count) {
            return memberToGroups;
        }
        NSUInteger index = arc4random() % friends.count;
        MFriend *friend = friends[index];
        [friends removeObjectAtIndex:index];
        MALogTestInfo(@"Adding friend to group %lu", (unsigned long)totalCount);
        RMemberToGroup *memberToGroup = [GroupManager addFriend:friend toGroup:group];
        [memberToGroups addObject:memberToGroup];
    }

    return memberToGroups;
}

- (void)generateAccountInGroup:(MGroup *)group totalCount:(NSUInteger)totalCount
{
    MALogTestInfo(@"\n\n==============================\n");
    if (0 == group.relationshipToMember.count) {
        return;
    }

    for (; totalCount > 0; --totalCount) {
        MALogTestInfo(@"Generating account %lu", (unsigned long)totalCount);

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
        CLLocation *location = [[CLLocation alloc] initWithLatitude:(randomValue % 10000) longitude:(randomValue % 10000)];
        [AccountManager createAccountWithGroup:group
                                          date:[[NSDate date] dateByAddingTimeInterval:(randomValue % 1000000)]
                                     placeName:[NSString stringWithFormat:@"place_%u", randomValue % 1000]
                                      location:location
                                        detail:[NSString stringWithFormat:@"detail_%u", randomValue % 1000]
                                  feeOfMembers:feeOfMembers];
    }
}

- (void)onePackageService
{
    [[MATestDataGenerater instance] generateGroups:10];
    [[MATestDataGenerater instance] generateFriends:80];
    for (MGroup *group in [GroupManager myGroups]) {
        [[MATestDataGenerater instance] addFriendToGroup:group totalCount:10];
        [[MATestDataGenerater instance] generateAccountInGroup:group totalCount:10];
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
        MALogTestInfo(@"!!! Save failed !!!");
    }
}

@end