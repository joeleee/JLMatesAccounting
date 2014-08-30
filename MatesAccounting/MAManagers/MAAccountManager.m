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
#import "MGroup+expand.h"
#import "RMemberToGroup+expand.h"


#pragma mark - @implementation MAFeeOfMember
@implementation MAFeeOfMember

+ (MAFeeOfMember *)feeOfMember:(MFriend *)member fee:(NSDecimalNumber *)fee
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
    feeOfMember.fee = memberToAccount.fee;
    feeOfMember.createDate = memberToAccount.createDate;
    return feeOfMember;
}

@end


#pragma mark - @implementation MAAccountSettlement
@implementation MAAccountSettlement

+ (MAAccountSettlement *)accountSettlement:(MFriend *)fromMember toMember:(MFriend *)toMember fee:(NSDecimalNumber *)fee
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
                            location:(CLLocation *)location
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
                                        location:location
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
             location:(CLLocation *)location
               detail:(NSString *)detail
         feeOfMembers:(NSSet *)feeOfMembers
{
    if (![self verifyFeeOfMambers:feeOfMembers]) {
        return NO;
    }

    // update members
    NSArray *updateMembers = [feeOfMembers allObjects];
    NSArray *originMembers = [account.relationshipToMember allObjects];
    NSMutableSet *membersNeedUpdate = [NSMutableSet set];
    NSMutableSet *updatedMembers = [NSMutableSet set];
    [updateMembers enumerateObjectsUsingBlock:^(MAFeeOfMember *obj, NSUInteger idx, BOOL *stop) {
        [membersNeedUpdate addObject:obj.member];
        RMemberToAccount *memberToAccount = nil;
        if (idx < originMembers.count) {
            memberToAccount = originMembers[idx];
            [membersNeedUpdate addObject:memberToAccount.member];
            memberToAccount.member = obj.member;
            memberToAccount.fee = obj.fee;
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
        [membersNeedUpdate addObject:memberToAccount.member];
        [[MAAccountPersistent instance] deleteMemberToAccount:memberToAccount];
    }
    account.relationshipToMember = updatedMembers;
    // update place
    MPlace *place = account.place;
    if (place) {
        place.location = location;
        place.placeName = placeName;
    } else {
        place = [[MAPlacePersistent instance] createPlaceWithLocation:location name:placeName];
    }
    account.place = place;
    // update detail
    account.detail = detail;
    // update date
    account.accountDate = date;

    BOOL updated = [[MAAccountPersistent instance] updateAccount:account];
    for (MFriend *member in membersNeedUpdate) {
        NSArray *relationshipToMember = [account.group relationshipToMembersByFriend:member];
        [(RMemberToGroup *)[relationshipToMember firstObject] refreshMemberTotalFee];
    }
    return updated;
}

- (BOOL)verifyFeeOfMambers:(NSSet *)feeOfMambers
{
    NSDecimalNumber *sumFee = DecimalZero;
    for (MAFeeOfMember *feeOfMember in feeOfMambers) {
        sumFee = [sumFee decimalNumberByAdding:feeOfMember.fee];
    }
    return NSOrderedSame == [sumFee compare:DecimalZero];
}

- (NSArray *)feeOfMembersForAccount:(MAccount *)account isPayers:(BOOL)isPayers
{
    NSMutableArray *memberToAccounts = [NSMutableArray array];
    NSMutableArray *zeroCoastMembers = [NSMutableArray array];

    for (RMemberToAccount *memberToAccount in account.relationshipToMember) {
        MAFeeOfMember *feeOfMember = [MAFeeOfMember feeOfMember:memberToAccount];
        if (isPayers && NSOrderedDescending == [memberToAccount.fee compare:DecimalZero]) {
            [memberToAccounts addObject:feeOfMember];
        } else if (!isPayers && NSOrderedAscending == [memberToAccount.fee compare:DecimalZero]) {
            [memberToAccounts addObject:feeOfMember];
        } else if (!isPayers && NSOrderedSame == [memberToAccount.fee compare:DecimalZero]) {
            [zeroCoastMembers addObject:feeOfMember];
        }
    }

    memberToAccounts = [NSMutableArray arrayWithArray:[memberToAccounts sortedArrayUsingComparator:^NSComparisonResult(MAFeeOfMember *obj1, MAFeeOfMember *obj2) {
        return [obj1.createDate compare:obj2.createDate];
    }]];
    [memberToAccounts addObjectsFromArray:zeroCoastMembers];
    return memberToAccounts;
}

- (NSArray *)feeOfMembersForNewMembers:(NSArray *)members originFeeOfMembers:(NSArray *)originFeeOfMembers totalFee:(NSDecimalNumber *)totalFee isPayer:(BOOL)isPayer
{
    totalFee = isPayer ? totalFee : [totalFee inverseNumber];
    NSDecimalNumber *averageFee = DecimalZero;
    NSDecimalNumber *oddFee = DecimalZero;
    if (members.count > 0) {
        averageFee = [totalFee decimalNumberByDividingBy:MAULongDecimal((unsigned long)members.count)];
        averageFee = MATwoPreciseDecimal([averageFee doubleValue]);
        oddFee = [totalFee decimalNumberByAdding:[[averageFee decimalNumberByMultiplyingBy:MAULongDecimal((unsigned long)members.count)] inverseNumber]];
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

    MAFeeOfMember *lastObject = feeOfMembers.lastObject;
    lastObject.fee = [lastObject.fee decimalNumberByAdding:oddFee];

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
        if (NSOrderedDescending == [memberToGroup.fee compare:DecimalZero]) {
            MAAccountSettlement *accountSettlement = [MAAccountSettlement accountSettlement:nil toMember:memberToGroup.member fee:memberToGroup.fee];
            [receiverSettlementList addObject:accountSettlement];
        } else if (NSOrderedAscending == [memberToGroup.fee compare:DecimalZero]) {
            MAAccountSettlement *accountSettlement = [MAAccountSettlement accountSettlement:memberToGroup.member toMember:nil fee:memberToGroup.fee];
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

            if (NSOrderedDescending == [receiverSettlement.fee compare:[payerSettlement.fee inverseNumber]]) {
                receiverSettlement.fee = [receiverSettlement.fee decimalNumberByAdding:payerSettlement.fee];
                payerSettlement.fee = [payerSettlement.fee inverseNumber];
                payerSettlement.toMember = receiverSettlement.toMember;
                [accountSettlementList addObject:payerSettlement];
                [payerSettlementList removeObject:payerSettlement];
            }
            else if (NSOrderedAscending == [receiverSettlement.fee compare:[payerSettlement.fee inverseNumber]]) {
                payerSettlement.fee = [payerSettlement.fee decimalNumberByAdding:receiverSettlement.fee];
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