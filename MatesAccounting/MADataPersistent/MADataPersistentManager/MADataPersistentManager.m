//
//  MADataPersistentManager.m
//  MatesAccounting
//
//  Created by Lee on 13-11-15.
//  Copyright (c) 2013年 Lee. All rights reserved.
//

#import "MADataPersistentManager.h"

#import "MAAccountPersistent.h"
#import "MAFriendPersistent.h"
#import "MAGroupPersistent.h"
#import "MAPlacePersistent.h"
#import "MAContextAPI.h"

@interface MADataPersistentManager ()

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

#pragma mark - 持久化操作

#pragma mark member相关

- (MFriend *)createMemberWithName:(NSString *)name
                    setValueBlock:(PersistentBlock)setValueBlock
{
    MFriend *member = [[MAFriendPersistent instance] createFriendWithName:name];
    EXECUTE_BLOCK_SAFELY(setValueBlock, member ? YES : NO, member, nil, nil);
    [[MAContextAPI sharedAPI] saveContextData];

    return member;
}

- (BOOL)deleteMember:(MFriend *)member
{
    BOOL isSucceed = NO;
    if (!member) {
        return isSucceed;
    }

    isSucceed = [[MAFriendPersistent instance] deleteFriend:member];

    return isSucceed;
}

- (BOOL)addMember:(MFriend *)member toGroup:(MGroup *)group
{
    if (!group || !member) {
        return NO;
    }

    if ([[MAGroupPersistent instance] addFriend:member toGroup:group]) {
        return YES;
    } else {
        return NO;
    }
}

- (BOOL)removeMember:(MFriend *)member fromGroup:(MGroup *)group
{
    if (!group || !member) {
        return NO;
    }

    if ([[MAGroupPersistent instance] removeFriend:member fromGroup:group]) {
        return YES;
    } else {
        return NO;
    }
}

- (BOOL)addMember:(MFriend *)member toAccount:(MAccount *)account fee:(double)fee
{
    BOOL isSucceed = NO;
    if (!account || !member) {
        return isSucceed;
    }

    isSucceed = [[MAAccountPersistent instance] addFriend:member toAccount:account fee:fee];
    return isSucceed;
}

- (BOOL)removeMember:(MFriend *)member fromAccount:(MAccount *)account
{
    BOOL isSucceed = NO;
    if (!account || !member) {
        return isSucceed;
    }

    isSucceed = [[MAAccountPersistent instance] removeFriend:member fromAccount:account];

    return isSucceed;
}

#pragma mark group相关

- (MGroup *)createGroupWithName:(NSString *)name
                  setValueBlock:(PersistentBlock)setValueBlock
{
    MGroup *group = [[MAGroupPersistent instance] createGroupWithGroupName:name];
    EXECUTE_BLOCK_SAFELY(setValueBlock, group ? YES : NO, group, nil, nil);
    [[MAContextAPI sharedAPI] saveContextData];

    return group;
}

- (BOOL)deleteGroup:(MGroup *)group
{
    BOOL isSucceed = NO;
    if (!group) {
        return isSucceed;
    }

    isSucceed = [[MAGroupPersistent instance] deleteGroup:group];

    return isSucceed;
}

#pragma mark account相关

- (MAccount *)createAccountToGroup:(MGroup *)group
                              date:(NSDate *)date
                     setValueBlock:(PersistentBlock)setValueBlock
{
    MAccount *account = [[MAAccountPersistent instance] createAccountInGroup:group date:date];
    EXECUTE_BLOCK_SAFELY(setValueBlock, account ? YES : NO, account, nil, nil);
    [[MAContextAPI sharedAPI] saveContextData];

    return account;
}

- (BOOL)deleteAccount:(MAccount *)account
{
    BOOL isSucceed = NO;
    if (!account) {
        return isSucceed;
    }

    isSucceed = [[MAAccountPersistent instance] deleteAccount:account];

    return isSucceed;
}

#pragma mark place相关

- (MPlace *)createPlaceCoordinate:(CLLocationCoordinate2D)coordinate
                             name:(NSString *)name
                    setValueBlock:(PersistentBlock)setValueBlock
{
    MPlace *place = [[MAPlacePersistent instance] createPlaceWithCoordinate:coordinate name:name];
    EXECUTE_BLOCK_SAFELY(setValueBlock, place ? YES : NO, place, nil, nil);
    [[MAContextAPI sharedAPI] saveContextData];

    return place;
}

- (BOOL)deletePlace:(MPlace *)place
{
    BOOL isSucceed = NO;
    if (!place) {
        return isSucceed;
    }

    isSucceed = [[MAPlacePersistent instance] deletePlace:place];

    return isSucceed;
}

@end