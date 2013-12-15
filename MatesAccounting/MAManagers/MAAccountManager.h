//
//  MAAccountManager.h
//  MatesAccounting
//
//  Created by Lee on 13-11-29.
//  Copyright (c) 2013年 Lee. All rights reserved.
//

#import <Foundation/Foundation.h>

#define AccountManager [MAAccountManager sharedManager]

@class MMember, MAccount, MGroup;

@interface MAFeeOfMember : NSObject

@property (nonatomic, strong) MMember *member;
@property (nonatomic, assign) CGFloat fee;

+ (MAFeeOfMember *)feeOfMember:(MMember *)member fee:(CGFloat)fee;

@end


@interface MAAccountManager : NSObject

+ (MAAccountManager *)sharedManager;

- (NSArray *)sectionedAccountListForCurrentGroup;

- (MAccount *)createAccountWithFee:(CGFloat)totalFee
                              date:(NSDate *)date
                          latitude:(CGFloat *)latitude
                         longitude:(CGFloat *)longitude
                            detail:(NSString *)detail
                             group:(MGroup *)group
                 payerFeeOfMembers:(NSArray *)payersOfMembers
              consumerFeeOfMembers:(NSArray *)consumersOfMembers;

@end