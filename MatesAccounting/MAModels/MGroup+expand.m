//
//  MGroup+expand.m
//  MatesAccounting
//
//  Created by Joe Lee on 2014-8-20.
//  Copyright (c) 2014年 Lee. All rights reserved.
//

#import "MGroup+expand.h"

#import "MFriend.h"

@implementation MGroup (expand)

- (NSArray *)relationshipToMembersByFriend:(MFriend *)friend
{
    NSArray *relationshipToMembers = [[self.relationshipToMember filteredSetUsingPredicate:[NSPredicate predicateWithFormat:@"member = %@", friend]] allObjects];
    return relationshipToMembers;
}

@end