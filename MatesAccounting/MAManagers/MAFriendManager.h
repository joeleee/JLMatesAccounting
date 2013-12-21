//
//  MAFriendManager.h
//  MatesAccounting
//
//  Created by Lee on 13-12-12.
//  Copyright (c) 2013年 Lee. All rights reserved.
//

#import <Foundation/Foundation.h>

#define FriendManager [MAFriendManager sharedManager]

typedef enum {
    Unknow = 0,
    Male = 1,
    Female = 2
} MAFriendGender;

@interface MAFriendManager : NSObject

+ (MAFriendManager *)sharedManager;

- (NSArray *)currentGroupMembers;

@end