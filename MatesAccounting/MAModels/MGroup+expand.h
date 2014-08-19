//
//  MGroup+expand.h
//  MatesAccounting
//
//  Created by Joe Lee on 2014-8-20.
//  Copyright (c) 2014年 Lee. All rights reserved.
//

#import "MGroup.h"

@class MFriend;

@interface MGroup (expand)

- (NSArray *)relationshipToMembersByFriend:(MFriend *)friend;

@end