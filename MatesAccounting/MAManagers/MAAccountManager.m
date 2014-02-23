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

@implementation MAFeeOfMember

+ (MAFeeOfMember *)feeOfMember:(MFriend *)member fee:(CGFloat)fee
{
    MA_QUICK_ASSERT(member, @"member should not be nil! - MAFeeOfMember");

    MAFeeOfMember *feeOfMember = [[MAFeeOfMember alloc] init];
    feeOfMember.member = member;
    feeOfMember.fee = fee;
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

- (MAccount *)createAccountWithFee:(CGFloat)totalFee
                              date:(NSDate *)date
                          latitude:(CGFloat *)latitude
                         longitude:(CGFloat *)longitude
                            detail:(NSString *)detail
                             group:(MGroup *)group
                 payerFeeOfMembers:(NSArray *)payersOfMembers
              consumerFeeOfMembers:(NSArray *)consumersOfMembers
{
    return nil;
}

- (NSArray *)payersDetailForAccount:(MAccount *)account
{
    NSMutableArray *payerDetailList = [NSMutableArray array];

    for (RMemberToAccount *memberToAccount in account.relationshipToMember) {
        if (0 < [memberToAccount.fee doubleValue]) {
        }
    }

    return payerDetailList;
}

- (NSArray *)consumersDetailForAccount:(MAccount *)account
{
    NSMutableArray *consumerDetailList = [NSMutableArray array];

    for (RMemberToAccount *memberToAccount in account.relationshipToMember) {
        if (0 >= [memberToAccount.fee doubleValue]) {
        }
    }

    return consumerDetailList;
}

#pragma mark - private method

- (MAccount *)createAccountWithFee:(CGFloat)totalFee
                              date:(NSDate *)date
                             place:(MPlace *)place
                            detail:(NSString *)detail
                             group:(MGroup *)group
{
    return nil;
}

- (BOOL)addFeeOfMembers:(NSArray *)feeOfMembers
              toAccount:(MAccount *)account
{
    for (MAFeeOfMember *feeOfMember in feeOfMembers) {
        MA_QUICK_ASSERT(feeOfMember.member, @"member should not be nil! - MAAccountManager");
    }
    return NO;
}

- (BOOL)addMember:(MFriend *)member
        toAccount:(MAccount *)account
          withFee:(CGFloat)fee
{
    return NO;
}

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