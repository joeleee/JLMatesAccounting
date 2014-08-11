//
//  MAccount+expand.m
//  MatesAccounting
//
//  Created by Lee on 13-11-19.
//  Copyright (c) 2013年 Lee. All rights reserved.
//

#import "MAccount+expand.h"

#import "RMemberToAccount.h"

@implementation MAccount (expand)

- (void)refreshAccountTotalFee
{
    NSDecimalNumber *totalFee = DecimalZero;
    for (RMemberToAccount *relationship in self.relationshipToMember) {
        if (NSOrderedDescending == [relationship.fee compare:DecimalZero]) {
            totalFee = [totalFee decimalNumberByAdding:relationship.fee];
        }
    }
    self.totalFee = totalFee;
}

@end