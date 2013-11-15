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

- (MMember *)createMember;

- (BOOL)deleteMember:(MMember *)member;

- (NSArray *)fetchAccount:(NSFetchRequest *)request;

@end