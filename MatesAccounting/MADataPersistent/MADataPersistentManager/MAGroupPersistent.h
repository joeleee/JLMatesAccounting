//
//  MAGroupPersistent.h
//  MatesAccounting
//
//  Created by Lee on 13-11-15.
//  Copyright (c) 2013年 Lee. All rights reserved.
//

#import <Foundation/Foundation.h>

@class MGroup, MMember;

@interface MAGroupPersistent : NSObject

+ (MAGroupPersistent *)instance;

- (BOOL)addMember:(MMember *)member toGroup:(MGroup *)group;

- (BOOL)removeMember:(MMember *)member fromGroup:(MGroup *)group;

- (MGroup *)createGroupWithGroupName:(NSString *)groupName;

- (BOOL)updateGroup:(MGroup *)group;

- (BOOL)deleteGroup:(MGroup *)group;

- (NSArray *)fetchAccount:(NSFetchRequest *)request;

@end