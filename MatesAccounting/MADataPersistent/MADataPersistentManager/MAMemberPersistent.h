//
//  MAMemberPersistent.h
//  MatesAccounting
//
//  Created by Lee on 13-11-15.
//  Copyright (c) 2013年 Lee. All rights reserved.
//

#import <Foundation/Foundation.h>

@class MMember;

@interface MAMemberPersistent : NSObject

+ (MAMemberPersistent *)instance;

- (MMember *)createMemberWithName:(NSString *)name;

- (BOOL)updateMember:(MMember *)member;

- (BOOL)deleteMember:(MMember *)member;

- (NSArray *)fetchAccount:(NSFetchRequest *)request;

@end