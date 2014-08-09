//
//  RMemberToGroup+expand.m
//  MatesAccounting
//
//  Created by Joe Lee on 2014-8-9.
//  Copyright (c) 2014年 Lee. All rights reserved.
//

#import "RMemberToGroup+expand.h"

#import "MFriend.h"
#import "MAccount+expand.h"
#import "RMemberToAccount.h"

@implementation RMemberToGroup (expand)

- (void)refreshMemberTotalFee
{
    CGFloat totalFee = 0.0f;
    for (RMemberToAccount *memberToAccount in self.member.relationshipToAccount) {
        if (memberToAccount.account.group == self.group) {
            totalFee += [memberToAccount.fee doubleValue];
        }
    }
    self.fee = @(totalFee);
}

@end