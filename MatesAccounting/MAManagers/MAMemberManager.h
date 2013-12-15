//
//  MAMemberManager.h
//  MatesAccounting
//
//  Created by Lee on 13-12-12.
//  Copyright (c) 2013年 Lee. All rights reserved.
//

#import <Foundation/Foundation.h>

#define MemberManager [MAMemberManager sharedManager]

@interface MAMemberManager : NSObject

+ (MAMemberManager *)sharedManager;

- (NSArray *)currentGroupMembers;

@end