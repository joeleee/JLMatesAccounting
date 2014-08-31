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

- (NSArray *)generateGroups:(NSUInteger)totalCount;

- (NSArray *)generateFriends:(NSUInteger)totalCount;

- (NSArray *)addFriendToGroup:(MGroup *)group totalCount:(NSUInteger)totalCount;

- (void)generateAccountInGroup:(MGroup *)group totalCount:(NSUInteger)totalCount;

- (void)onePackageService;

- (void)clearAllData;

@end