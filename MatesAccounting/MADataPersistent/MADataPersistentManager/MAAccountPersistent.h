//
//  MAAccountPersistent.h
//  MatesAccounting
//
//  Created by Lee on 13-11-15.
//  Copyright (c) 2013年 Lee. All rights reserved.
//

#import <Foundation/Foundation.h>

@class MAccount, MMember, MPlace, MGroup;

@interface MAAccountPersistent : NSObject

- (BOOL)addMember:(MMember *)member toAccount:(MAccount *)account fee:(NSNumber *)fee;

- (BOOL)removeMember:(MMember *)member fromAccount:(MAccount *)account;

- (MAccount *)createAccountInGroup:(MGroup *)group
                            detail:(NSString *)detail
                             place:(MPlace *)place;

- (BOOL)updateAccount:(MAccount *)account;

- (BOOL)deleteAccount:(MAccount *)account;

- (NSArray *)fetchAccount:(NSFetchRequest *)request;

@end