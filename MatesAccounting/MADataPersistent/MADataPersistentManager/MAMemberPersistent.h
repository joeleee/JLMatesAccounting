//
//  MAMemberPersistent.h
//  MatesAccounting
//
//  Created by Lee on 13-11-15.
//  Copyright (c) 2013年 Lee. All rights reserved.
//

#import <Foundation/Foundation.h>

@class MFriend;

@interface MAMemberPersistent : NSObject

+ (MAMemberPersistent *)instance;

- (MFriend *)createMemberWithName:(NSString *)name;

- (BOOL)updateMember:(MFriend *)member;

- (BOOL)deleteMember:(MFriend *)member;

- (NSArray *)fetchAccount:(NSFetchRequest *)request;

@end