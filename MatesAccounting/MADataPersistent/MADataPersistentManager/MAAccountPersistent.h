//
//  MAAccountPersistent.h
//  MatesAccounting
//
//  Created by Lee on 13-11-15.
//  Copyright (c) 2013年 Lee. All rights reserved.
//

#import <Foundation/Foundation.h>

@class MAccount, MFriend, MPlace, MGroup;

@interface MAAccountPersistent : NSObject

+ (MAAccountPersistent *)instance;

- (BOOL)addFriend:(MFriend *)member toAccount:(MAccount *)account fee:(double)fee;

- (BOOL)removeFriend:(MFriend *)member fromAccount:(MAccount *)account;

- (MAccount *)createAccountInGroup:(MGroup *)group
                              date:(NSDate *)date;

- (BOOL)updateAccount:(MAccount *)account;

- (BOOL)deleteAccount:(MAccount *)account;

- (NSArray *)fetchAccounts:(NSFetchRequest *)request;

@end