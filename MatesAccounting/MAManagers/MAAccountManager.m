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

- (NSArray *)sectionedAccountListForCurrentGroup
{
    return nil;
}

- (MAccount *)createAccountWithGroup:(MGroup *)group
                                date:(NSDate *)date
                           placeName:(NSString *)placeName
                            latitude:(CLLocationDegrees)latitude
                           longitude:(CLLocationDegrees)longitude
                              detail:(NSString *)detail
                        feeOfMembers:(NSSet *)feeOfMembers
{
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
    if (0.0f != [self totalFeeOfMambers:feeOfMembers memberToAccounts:account.relationshipToMember]) {
        return NO;
    }

    // 更新成员条目
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
    // 删除多余的成员条目
    NSUInteger index = updateMembers.count;
    while (originMembers.count > index) {
        RMemberToAccount *memberToAccount = originMembers[index++];
        [[MAAccountPersistent instance] deleteMemberToAccount:memberToAccount];
    }
    account.relationshipToMember = updatedMembers;
    // 更新地理位置
    CLLocationCoordinate2D location;
    location.latitude = latitude;
    location.longitude = longitude;
    MPlace *place = [[MAPlacePersistent instance] createPlaceWithCoordinate:location name:placeName];
    account.place = place;
    // 更新账目详情
    account.detail = detail;

    BOOL updated = [[MAAccountPersistent instance] updateAccount:account];
    return updated;
}

- (CGFloat)totalFeeOfMambers:(NSSet *)feeOfMambers memberToAccounts:(NSSet *)memberToAccounts
{
    CGFloat totalFee = 0.0f;
    for (RMemberToAccount *memberToAccount in memberToAccounts) {
        totalFee += [memberToAccount.fee doubleValue];
    }
    for (MAFeeOfMember *feeOfMember in feeOfMambers) {
        totalFee += feeOfMember.fee;
    }
    return totalFee;
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
    CGFloat restTotalFee = 0.0f;
    NSMutableArray *originPayers = [NSMutableArray array];
    NSMutableArray *newMembers = [NSMutableArray arrayWithArray:members];
    for (MAFeeOfMember *feeOfMember in originFeeOfMembers) {
        if ([members containsObject:feeOfMember.member]) {
            totalFee += feeOfMember.fee;
            [originPayers addObject:feeOfMember];
            [newMembers removeObject:feeOfMember.member];
        }
    }

    CGFloat restFee = isPayer ? totalFee - restTotalFee : totalFee + restTotalFee;
    CGFloat averageFee = 0;
    if (newMembers.count > 0 && ((isPayer && restFee > 0) || (!isPayer && restFee < 0))) {
        averageFee = restFee / newMembers.count;
    }
    for (MFriend *member in newMembers) {
        MAFeeOfMember *feeOfMember = [MAFeeOfMember feeOfMember:member fee:averageFee];
        [originPayers addObject:feeOfMember];
    }

    return originPayers;
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

#pragma mark - private method

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