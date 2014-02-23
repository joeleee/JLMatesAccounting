//
//  MAGroupManager.h
//  MatesAccounting
//
//  Created by Lee on 13-11-27.
//  Copyright (c) 2013年 Lee. All rights reserved.
//

#define GroupManager [MAGroupManager sharedManager]

#import <Foundation/Foundation.h>

extern NSString * const MAGroupManagerSelectedGroupChanged;
extern NSString * const MAGroupManagerGroupHasCreated;
extern NSString * const MAGroupManagerGroupHasModified;

@class MGroup, MFriend;

@interface MAGroupManager : NSObject

+ (MAGroupManager *)sharedManager;

- (MGroup *)currentGroup;

- (NSArray *)myGroups;

- (BOOL)changeGroup:(MGroup *)group;

- (MGroup *)createGroup:(NSString *)name;

- (MGroup *)editAndSaveGroup:(MGroup *)group
                        name:(NSString *)name;

- (BOOL)addFriend:(MFriend *)friend toGroup:(MGroup *)group;

@end