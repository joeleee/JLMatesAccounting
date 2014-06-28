//
//  MAFriendPersistent.h
//  MatesAccounting
//
//  Created by Lee on 13-11-15.
//  Copyright (c) 2013年 Lee. All rights reserved.
//

#import <Foundation/Foundation.h>

@class MFriend;

@interface MAFriendPersistent : NSObject

+ (MAFriendPersistent *)instance;

- (MFriend *)createFriendWithName:(NSString *)name;

- (BOOL)updateFriend:(MFriend *)mFriend;

- (BOOL)deleteFriend:(MFriend *)mFriend;

- (NSArray *)fetchFriends:(NSFetchRequest *)request;

@end