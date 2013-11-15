//
//  MAGroupPersistent.m
//  MatesAccounting
//
//  Created by Lee on 13-11-15.
//  Copyright (c) 2013年 Lee. All rights reserved.
//

#import "MAGroupPersistent.h"

#import "MACommonPersistent.h"
#import "MGroup.h"

@implementation MAGroupPersistent

- (MGroup *)createGroup
{
    MGroup *group = [MACommonPersistent createObject:NSStringFromClass([MGroup class])];

    if (group) {
        NSDate *currentData = [NSDate date];
        group.createDate = currentData;
        group.updateDate = currentData;
        group.groupID = @([currentData timeIntervalSince1970]);
    }

    return group;
}

- (BOOL)deleteGroup:(MGroup *)group
{
    BOOL isSucceed = [MACommonPersistent deleteAccount:group];

    return isSucceed;
}

- (NSArray *)fetchAccount:(NSFetchRequest *)request
{
    NSArray *result = [MACommonPersistent fetchObjects:request entityName:NSStringFromClass([MGroup class])];

    return result;
}

@end