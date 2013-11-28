//
//  MAAccountManager.h
//  MatesAccounting
//
//  Created by Lee on 13-11-29.
//  Copyright (c) 2013年 Lee. All rights reserved.
//

#define AccountManager [MAAccountManager sharedManager]

#import <Foundation/Foundation.h>

@interface MAAccountManager : NSObject

+ (MAAccountManager *)sharedManager;

- (NSArray *)sectionedAccountListForCurrentGroup;

@end