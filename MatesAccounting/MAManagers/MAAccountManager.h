//
//  MAAccountManager.h
//  MatesAccounting
//
//  Created by Lee on 13-11-29.
//  Copyright (c) 2013年 Lee. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CLLocation.h>

#define AccountManager [MAAccountManager sharedManager]

@class MFriend, MAccount, MGroup, RMemberToAccount;

@interface MAFeeOfMember : NSObject

@property (nonatomic, strong) NSDate *createDate;
@property (nonatomic, strong) MFriend *member;
@property (nonatomic, strong) NSDecimalNumber *fee;

+ (MAFeeOfMember *)feeOfMember:(MFriend *)member fee:(NSDecimalNumber *)fee;
+ (MAFeeOfMember *)feeOfMember:(RMemberToAccount *)memberToAccount;

@end

@interface MAAccountSettlement : NSObject

@property (nonatomic, strong) MFriend *fromMember;
@property (nonatomic, strong) MFriend *toMember;
@property (nonatomic, strong) NSDecimalNumber *fee;

+ (MAAccountSettlement *)accountSettlement:(MFriend *)fromMember toMember:(MFriend *)toMember fee:(NSDecimalNumber *)fee;

@end


@interface MAAccountManager : NSObject

+ (MAAccountManager *)sharedManager;

- (NSArray *)sectionedAccountListForGroup:(MGroup *)group;

- (MAccount *)createAccountWithGroup:(MGroup *)group
                                date:(NSDate *)date
                           placeName:(NSString *)placeName
                            location:(CLLocation *)location
                              detail:(NSString *)detail
                        feeOfMembers:(NSSet *)feeOfMembers;

- (BOOL)updateAccount:(MAccount *)account
                 date:(NSDate *)date
            placeName:(NSString *)placeName
             location:(CLLocation *)location
               detail:(NSString *)detail
         feeOfMembers:(NSSet *)feeOfMembers;

- (BOOL)verifyFeeOfMambers:(NSSet *)feeOfMambers;

- (NSArray *)feeOfMembersForAccount:(MAccount *)account isPayers:(BOOL)isPayers;

- (NSArray *)feeOfMembersForNewMembers:(NSArray *)members originFeeOfMembers:(NSArray *)originFeeOfMembers totalFee:(NSDecimalNumber *)totalFee isPayer:(BOOL)isPayer inGroup:(MGroup *)group;

- (NSArray *)memberForAccount:(MAccount *)account isSelected:(BOOL)isSelected isPayers:(BOOL)isPayers;

- (NSArray *)accountSettlementListForGroup:(MGroup *)group;

- (void)deleteAccount:(MAccount *)account onComplete:(MACommonCallBackBlock)onComplete onFailed:(MACommonCallBackBlock)onFailed;

@end