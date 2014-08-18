//
//  MATestDataGenerater.h
//  MatesAccounting
//
//  Created by Joe Lee on 2014-8-18.
//  Copyright (c) 2014年 Lee. All rights reserved.
//

#import <Foundation/Foundation.h>

@class MGroup;

@interface MATestDataGenerater : NSObject

+ (MATestDataGenerater *)instance;

- (void)generateGroups:(NSUInteger)totalCount;

- (void)generateFriends:(NSUInteger)totalCount;

- (void)addFriendToGroup:(MGroup *)group totalCount:(NSUInteger)totalCount;

- (void)generateAccountInGroup:(MGroup *)group totalCount:(NSUInteger)totalCount;

- (void)onePackageService;

- (void)clearAllData;

@end