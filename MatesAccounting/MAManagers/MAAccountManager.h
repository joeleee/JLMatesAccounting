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
@property (nonatomic, assign) CGFloat fee;

+ (MAFeeOfMember *)feeOfMember:(MFriend *)member fee:(CGFloat)fee;
+ (MAFeeOfMember *)feeOfMember:(RMemberToAccount *)memberToAccount;

@end


@interface MAAccountManager : NSObject

+ (MAAccountManager *)sharedManager;

- (NSArray *)sectionedAccountListForCurrentGroup;

- (MAccount *)createAccountWithGroup:(MGroup *)group
                                date:(NSDate *)date
                           placeName:(NSString *)placeName
                            latitude:(CLLocationDegrees)latitude
                           longitude:(CLLocationDegrees)longitude
                              detail:(NSString *)detail
                        feeOfMembers:(NSSet *)feeOfMembers;

- (BOOL)updateAccount:(MAccount *)account
                 date:(NSDate *)date
            placeName:(NSString *)placeName
             latitude:(CLLocationDegrees)latitude
            longitude:(CLLocationDegrees)longitude
               detail:(NSString *)detail
         feeOfMembers:(NSSet *)feeOfMembers;

- (CGFloat)totalFeeOfMambers:(NSSet *)feeOfMambers memberToAccounts:(NSSet *)memberToAccounts;

- (NSArray *)feeOfMembersForAccount:(MAccount *)account isPayers:(BOOL)isPayers;

- (NSArray *)feeOfMembersForNewMembers:(NSArray *)members originFeeOfMembers:(NSArray *)originFeeOfMembers totalFee:(CGFloat)totalFee isPayer:(BOOL)isPayer;

- (NSArray *)memberForAccount:(MAccount *)account isSelected:(BOOL)isSelected isPayers:(BOOL)isPayers;

@end