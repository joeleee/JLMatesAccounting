//
//  MAAccountManager.m
//  MatesAccounting
//
//  Created by Lee on 13-11-29.
//  Copyright (c) 2013年 Lee. All rights reserved.
//

#import "MAAccountManager.h"

#import "MAccount+expand.h"
#import "MPlace.h"
#import "MFriend.h"
#import "RMemberToAccount.h"
#import "MAAccountPersistent.h"
#import "MAPlacePersistent.h"
#import "MAFriendManager.h"
#import "MGroup.h"
#import "RMemberToGroup.h"


#pragma mark - @implementation MAFeeOfMember
@implementation MAFeeOfMember

+ (MAFeeOfMember *)feeOfMember:(MFriend *)member fee:(CGFloat)fee
{
    MA_QUICK_ASSERT(member, @"member should not be nil! - MAFeeOfMember");

    MAFeeOfMember *feeOfMember = [[MAFeeOfMember alloc] init];
    feeOfMember.member = member;
    feeOfMember.fee = fee;
    feeOfMember.createDate = [NSDate date];
    return feeOfMember;
}

+ (MAFeeOfMember *)feeOfMember:(RMemberToAccount *)memberToAccount
{
    MA_QUICK_ASSERT(memberToAccount, @"member should not be nil! - MAFeeOfMember");

    MAFeeOfMember *feeOfMember = [[MAFeeOfMember alloc] init];
    feeOfMember.member = memberToAccount.member;
    feeOfMember.fee = [memberToAccount.fee doubleValue];
    feeOfMember.createDate = memberToAccount.createDate;
    return feeOfMember;
}

@end


#pragma mark - @implementation MAAccountSettlement
@implementation MAAccountSettlement

+ (MAAccountSettlement *)accountSettlement:(MFriend *)fromMember toMember:(MFriend *)toMember fee:(CGFloat)fee
{
    MAAccountSettlement *accountSettlement = [[MAAccountSettlement alloc] init];
    accountSettlement.fromMember = fromMember;
    accountSettlement.toMember = toMember;
    accountSettlement.fee = fee;
    return accountSettlement;
}

@end


#pragma mark - @implementation MAAccountManager
@implementation MAAccountManager

+ (MAAccountManager *)sharedManager
{
    static MAAccountManager  *sharedInstance;
    static dispatch_once_t   onceToken;

    dispatch_once(&onceToken, ^{
        sharedInstance = [[self alloc] init];
    });
    return sharedInstance;
}

- (NSArray *)sectionedAccountListForGroup:(MGroup *)group
{
    NSArray *accounts = [group.accounts.allObjects sortedArrayUsingDescriptors:@[[NSSortDescriptor sortDescriptorWithKey:@"accountDate" ascending:NO]]];

    NSMutableArray *result = [NSMutableArray array];
    NSMutableArray *accountList = [NSMutableArray array];
    for (MAccount *account in accounts) {
        long long currentTime = [[account.accountDate dateToString:@"yyyyMMdd"] longLongValue];
        long long lastTime = [[[accountList.lastObject accountDate] dateToString:@"yyyyMMdd"] longLongValue];
        if (0 >= accountList.count || currentTime == lastTime) {
            [accountList addObject:account];
        } else {
            [result addObject:accountList];
            accountList = [NSMutableArray array];
            [accountList addObject:account];
        }
    }
    if (0 < accountList.count) {
        [result addObject:accountList];
    }

    return result;
}

- (MAccount *)createAccountWithGroup:(MGroup *)group
                                date:(NSDate *)date
                           placeName:(NSString *)placeName
                            latitude:(CLLocationDegrees)latitude
                           longitude:(CLLocationDegrees)longitude
                              detail:(NSString *)detail
                        feeOfMembers:(NSSet *)feeOfMembers
{
    if (![self verifyFeeOfMambers:feeOfMembers]) {
        return nil;
    }

    MAccount *account = [[MAAccountPersistent instance] createAccountInGroup:group date:date];

    if (account) {
        BOOL updateSucceed = [self updateAccount:account
                                            date:date
                                       placeName:placeName
                                        latitude:latitude
                                       longitude:longitude
                                          detail:detail
                                    feeOfMembers:feeOfMembers];
        if (!updateSucceed) {
            [[MAAccountPersistent instance] deleteAccount:account];
            account = nil;
        }
    }

    return account;
}

- (BOOL)updateAccount:(MAccount *)account
                 date:(NSDate *)date
            placeName:(NSString *)placeName
             latitude:(CLLocationDegrees)latitude
            longitude:(CLLocationDegrees)longitude
               detail:(NSString *)detail
         feeOfMembers:(NSSet *)feeOfMembers
{
    if (![self verifyFeeOfMambers:feeOfMembers]) {
        return NO;
    }

    // update members
    NSArray *updateMembers = [feeOfMembers allObjects];
    NSArray *originMembers = [account.relationshipToMember allObjects];
    NSMutableSet *updatedMembers = [NSMutableSet set];
    [updateMembers enumerateObjectsUsingBlock:^(MAFeeOfMember *obj, NSUInteger idx, BOOL *stop) {
        RMemberToAccount *memberToAccount = nil;
        if (idx < originMembers.count) {
            memberToAccount = originMembers[idx];
            memberToAccount.member = obj.member;
            memberToAccount.fee = @(obj.fee);
        } else {
            memberToAccount = [[MAAccountPersistent instance] createMemberToAccount:account member:obj.member fee:obj.fee];
        }

        if (memberToAccount) {
            [updatedMembers addObject:memberToAccount];
        }
    }];
    // delete the remaining members
    NSUInteger index = updateMembers.count;
    while (originMembers.count > index) {
        RMemberToAccount *memberToAccount = originMembers[index++];
        [[MAAccountPersistent instance] deleteMemberToAccount:memberToAccount];
    }
    account.relationshipToMember = updatedMembers;
    // update place
    CLLocationCoordinate2D location;
    location.latitude = latitude;
    location.longitude = longitude;
    MPlace *place = [[MAPlacePersistent instance] createPlaceWithCoordinate:location name:placeName];
    account.place = place;
    // update detail
    account.detail = detail;
    // update date
    account.accountDate = date;

    BOOL updated = [[MAAccountPersistent instance] updateAccount:account];
    return updated;
}

- (BOOL)verifyFeeOfMambers:(NSSet *)feeOfMambers
{
    CGFloat sumFee = 0.0f;
    for (MAFeeOfMember *feeOfMember in feeOfMambers) {
        sumFee += feeOfMember.fee;
    }
    return sumFee == 0.0f;
}

- (NSArray *)feeOfMembersForAccount:(MAccount *)account isPayers:(BOOL)isPayers
{
    NSMutableArray *memberToAccounts = [NSMutableArray array];

    for (RMemberToAccount *memberToAccount in account.relationshipToMember) {
        if (isPayers && 0 > [memberToAccount.fee doubleValue]) {
            MAFeeOfMember *feeOfMember = [MAFeeOfMember feeOfMember:memberToAccount];
            [memberToAccounts addObject:feeOfMember];
        } else if (!isPayers && 0 <= [memberToAccount.fee doubleValue]) {
            MAFeeOfMember *feeOfMember = [MAFeeOfMember feeOfMember:memberToAccount];
            [memberToAccounts addObject:feeOfMember];
        }
    }

    return [memberToAccounts sortedArrayUsingComparator:^NSComparisonResult(MAFeeOfMember *obj1, MAFeeOfMember *obj2) {
        return [obj1.createDate compare:obj2.createDate];
    }];
}

- (NSArray *)feeOfMembersForNewMembers:(NSArray *)members originFeeOfMembers:(NSArray *)originFeeOfMembers totalFee:(CGFloat)totalFee isPayer:(BOOL)isPayer
{
    CGFloat averageFee = 0;
    if (members.count > 0) {
        averageFee = isPayer ? totalFee / members.count : 0 - totalFee / members.count;
    } else {
        return nil;
    }

    NSMutableArray *feeOfMembers = [NSMutableArray array];
    NSMutableArray *newMembers = [NSMutableArray arrayWithArray:members];

    for (MAFeeOfMember *feeOfMember in originFeeOfMembers) {
        if ([members containsObject:feeOfMember.member]) {
            [newMembers removeObject:feeOfMember.member];
            feeOfMember.fee = averageFee;
            [feeOfMembers addObject:feeOfMember];
        }
    }

    for (MFriend *member in newMembers) {
        MAFeeOfMember *feeOfMember = [MAFeeOfMember feeOfMember:member fee:averageFee];
        [feeOfMembers addObject:feeOfMember];
    }

    return feeOfMembers;
}

- (NSArray *)memberForAccount:(MAccount *)account isSelected:(BOOL)isSelected isPayers:(BOOL)isPayers
{
    NSMutableArray *selectedMembers = [NSMutableArray array];
    for (RMemberToAccount *memberToAccount in account.relationshipToMember) {
        if ((isPayers ? memberToAccount.fee.floatValue > 0.0f : memberToAccount.fee.floatValue < 0.0f)) {
            [selectedMembers addObject:memberToAccount.member];
        }
    }

    if (isSelected) {
        return selectedMembers;
    } else {
        NSMutableArray *unSelectedMembers = [NSMutableArray arrayWithArray:[FriendManager allFriendsFilteByGroup:account.group]];
        [unSelectedMembers removeObjectsInArray:selectedMembers];
        return unSelectedMembers;
    }
}

- (NSArray *)accountSettlementListForGroup:(MGroup *)group
{
    NSMutableArray *receiverSettlementList = [NSMutableArray array];
    NSMutableArray *payerSettlementList = [NSMutableArray array];
    for (RMemberToGroup *memberToGroup in group.relationshipToMember) {
        CGFloat finalFee = 0.0f;
        for (RMemberToAccount *memberToAccount in memberToGroup.member.relationshipToAccount) {
            finalFee += memberToAccount.fee.floatValue;
        }
        if (finalFee > 0.0f) {
            MAAccountSettlement *accountSettlement = [MAAccountSettlement accountSettlement:nil toMember:memberToGroup.member fee:finalFee];
            [receiverSettlementList addObject:accountSettlement];
        } else if (finalFee < 0.0f) {
            MAAccountSettlement *accountSettlement = [MAAccountSettlement accountSettlement:memberToGroup.member toMember:nil fee:finalFee];
            [payerSettlementList addObject:accountSettlement];
        }
    }

    [receiverSettlementList sortUsingDescriptors:@[[NSSortDescriptor sortDescriptorWithKey:@"fee" ascending:NO]]];
    [payerSettlementList sortUsingDescriptors:@[[NSSortDescriptor sortDescriptorWithKey:@"fee" ascending:NO]]];
    NSMutableArray *accountSettlementList = [NSMutableArray array];

    NSArray *seekReceiverArray = [NSArray arrayWithArray:receiverSettlementList];
    for (MAAccountSettlement *receiverSettlement in seekReceiverArray) {

        NSArray *seekPayerArray = [NSArray arrayWithArray:payerSettlementList];
        for (MAAccountSettlement *payerSettlement in seekPayerArray) {

            if (receiverSettlement.fee > -payerSettlement.fee) {
                receiverSettlement.fee += payerSettlement.fee;
                payerSettlement.fee = -payerSettlement.fee;
                payerSettlement.toMember = receiverSettlement.toMember;
                [accountSettlementList addObject:payerSettlement];
                [payerSettlementList removeObject:payerSettlement];
            }
            else if (receiverSettlement.fee < -payerSettlement.fee) {
                payerSettlement.fee += receiverSettlement.fee;
                receiverSettlement.fromMember = payerSettlement.fromMember;
                [accountSettlementList addObject:receiverSettlement];
                [receiverSettlementList removeObject:receiverSettlement];
                break;
            }
            else {
                receiverSettlement.fromMember = payerSettlement.fromMember;
                [accountSettlementList addObject:receiverSettlement];
                [payerSettlementList removeObject:payerSettlement];
                [receiverSettlementList removeObject:receiverSettlement];
                break;
            }

        }
    }

    MA_QUICK_ASSERT(0 == receiverSettlementList.count && 0 == payerSettlementList.count, @"Bad debt!");

    return accountSettlementList;
}

#pragma mark private method
- (NSUInteger)insertIndexOfRMemberToAccount:(RMemberToAccount *)memberToAccount
                                     inList:(NSArray *)list
{
    MA_QUICK_ASSERT([list containsObject:memberToAccount], @"list already contained memberToAccount - indexOfRMemberToAccount");

    if (0 == list.count) {
        return 0;
    }

    RMemberToAccount *firstObject = [list firstObject];
    if (memberToAccount.createDate >= firstObject.createDate) {
        return 0;
    }

    RMemberToAccount *lastObject = [list lastObject];
    if (memberToAccount.createDate <= lastObject.createDate) {
        return list.count;
    }

    NSUInteger index = 0;
    NSUInteger middleIndex = list.count / 2;
    RMemberToAccount *middleObject = list[middleIndex];
    NSRange range;
    if (memberToAccount.createDate >= middleObject.createDate) {
        range.location = 0;
        range.length = middleIndex;
        index = [self insertIndexOfRMemberToAccount:memberToAccount
                                             inList:[list subarrayWithRange:range]];
    } else {
        range.location = middleIndex;
        range.length = list.count - middleIndex;
        index = middleIndex + [self insertIndexOfRMemberToAccount:memberToAccount
                                                           inList:[list subarrayWithRange:range]];
    }
    
    return index;
}

@end