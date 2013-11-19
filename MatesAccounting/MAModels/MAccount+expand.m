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
    double totalFee = 0.0f;
    for (RMemberToAccount *relationship in self.relationshipToMember) {
        totalFee += [relationship.fee doubleValue];
    }
    self.totalFee = @(totalFee);
}

@end