//
//  MAAccountPersistent.h
//  MatesAccounting
//
//  Created by Lee on 13-11-15.
//  Copyright (c) 2013年 Lee. All rights reserved.
//

#import <Foundation/Foundation.h>

@class MAccount;

@interface MAAccountPersistent : NSObject

- (MAccount *)createAccount;

- (BOOL)deleteAccount:(MAccount *)account;

- (NSArray *)fetchAccount:(NSFetchRequest *)request;

@end