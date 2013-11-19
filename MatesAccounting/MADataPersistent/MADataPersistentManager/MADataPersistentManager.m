//
//  MADataPersistentManager.m
//  MatesAccounting
//
//  Created by Lee on 13-11-15.
//  Copyright (c) 2013年 Lee. All rights reserved.
//

#import "MADataPersistentManager.h"

#import "MMember.h"
#import "MGroup.h"
#import "MAccount.h"
#import "MAAccountPersistent.h"
#import "MAMemberPersistent.h"
#import "MAGroupPersistent.h"
#import "MAContextAPI.h"

@interface MADataPersistentManager ()

@property (nonatomic, strong) MAAccountPersistent *accountPersistent;
@property (nonatomic, strong) MAMemberPersistent *memberPersistent;
@property (nonatomic, strong) MAGroupPersistent *groupPersistent;

@end

@implementation MADataPersistentManager

+ (MADataPersistentManager *)sharedManager
{
    static MADataPersistentManager *sharedInstance;
    static dispatch_once_t         onceToken;

    dispatch_once(&onceToken, ^{
        sharedInstance = [[self alloc] init];
    });
    return sharedInstance;
}

- (MMember *)createMemberWithName:(NSString *)name
                    setValueBlock:(PersistentBlock)setValueBlock
{
    MMember *member = [self.memberPersistent createMemberWithName:name];
    EXECUTE_BLOCK_SAFELY(setValueBlock, member ? YES : NO, member, nil, nil);
    [[MAContextAPI sharedAPI] saveContextData];

    return member;
}

- (BOOL)addMember:(MMember *)member toGroup:(MGroup *)group
{
    BOOL isSucceed = NO;
    if (!group || !member) {
        return isSucceed;
    }

    isSucceed = [self.groupPersistent addMember:member toGroup:group];

    return isSucceed;
}

- (BOOL)removeMember:(MMember *)member fromGroup:(MGroup *)group
{
    BOOL isSucceed = NO;
    if (!group || !member) {
        return isSucceed;
    }

    isSucceed = [self.groupPersistent removeMember:member fromGroup:group];

    return isSucceed;
}

- (BOOL)addMember:(MMember *)member toAccount:(MAccount *)account fee:(NSNumber *)fee
{
    BOOL isSucceed = NO;
    if (!account || !member) {
        return isSucceed;
    }

    isSucceed = [self.accountPersistent addMember:member toAccount:account fee:fee];
    return isSucceed;
}

- (BOOL)removeMember:(MMember *)member fromAccount:(MAccount *)account
{
    BOOL isSucceed = NO;
    if (!account || !member) {
        return isSucceed;
    }

    isSucceed = [self.accountPersistent removeMember:member fromAccount:account];

    return isSucceed;
}

@end