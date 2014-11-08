//
//  MAFriendManager.m
//  MatesAccounting
//
//  Created by Lee on 13-12-12.
//  Copyright (c) 2013年 Lee. All rights reserved.
//

#import "MAFriendManager.h"

#import "MAObserverObject.h"
#import "MGroup.h"
#import "MAGroupManager.h"
#import "MFriend.h"
#import "RMemberToGroup.h"
#import "MACommonPersistent.h"
#import "MAContextAPI.h"
#import "RMemberToAccount.h"
#import "MAccount+expand.h"

@interface MAFriendManager () <MAFriendManagerObserverProtocol>

@property (nonatomic, strong) NSMutableArray *friendObservers;

@end

@implementation MAFriendManager

+ (MAFriendManager *)sharedManager
{
    static MAFriendManager *sharedInstance = nil;
    static dispatch_once_t onceToken;

    dispatch_once(&onceToken, ^{
        sharedInstance = [[MAFriendManager alloc] init];
    });

    return sharedInstance;
}

- (id)init
{
    if (self = [super init]) {
        self.friendObservers = [NSMutableArray array];
    }

    return self;
}


#pragma mark - public methods

- (void)registerFriendObserver:(id<MAFriendManagerObserverProtocol>)observer
{
    MAObserverObject *observerObject = [MAObserverObject observerObjectWith:observer];
    [self.friendObservers addObject:observerObject];
}

- (void)unregisterFriendObserver:(id<MAFriendManagerObserverProtocol>)observer
{
    [[NSOperationQueue mainQueue] addOperationWithBlock:^{
        NSMutableArray *invalidObservers = [NSMutableArray array];
        for (MAObserverObject *observerObject in self.friendObservers) {
            if (!observerObject.observer) {
                [invalidObservers addObject:observerObject];
            }
        }
        [self.friendObservers removeObjectsInArray:invalidObservers];
    }];
}

- (NSArray *)currentGroupToMemberRelationships
{
    NSArray *relationshipToMember = [[MACurrentGroup.relationshipToMember allObjects] sortedArrayUsingComparator:^NSComparisonResult(RMemberToGroup *obj1, RMemberToGroup *obj2) {
        return [obj1.createDate compare:obj2.createDate];
    }];

    return relationshipToMember;
}

- (NSArray *)allFriendsByGroup:(MGroup *)group
{
    NSArray *relationshipToMember = [group.relationshipToMember allObjects];
    NSMutableArray *friends = [NSMutableArray array];
    for (RMemberToGroup *memberToGroup in relationshipToMember) {
        [friends addObject:memberToGroup.member];
    }
    return friends;
}

- (NSArray *)allFriendsFilteByGroup:(MGroup *)group
{
    NSArray *friends = [MACommonPersistent fetchObjectsWithEntityName:[MFriend className]];;

    if (group) {
        NSPredicate *predicate = [NSPredicate predicateWithBlock:^BOOL(id evaluatedObject, NSDictionary *bindings) {
            MFriend *friend = evaluatedObject;
            return ![friend.relationshipToGroup intersectsSet:group.relationshipToMember];
        }];
        friends = [friends filteredArrayUsingPredicate:predicate];
    }

    return friends;
}

- (MFriend *)createFriendWithName:(NSString *)name
                           gender:(MAGenderEnum)gender
                      phoneNumber:(NSString *)phoneNumber
                            eMail:(NSString *)eMail
                         birthday:(NSDate *)birthday
{
    name = [name stringByReplacingOccurrencesOfString:@" " withString:@""];
    if (0 >= name.length) {
        return nil;
    }

    MFriend *member = [MACommonPersistent createObject:NSStringFromClass([MFriend class])];
    MA_ASSERT(member, @"Assert member == nil");

    NSDate *currentData = [NSDate date];
    member.name = name;
    member.createDate = currentData;
    member.friendID = @([currentData timeIntervalSince1970]);
    member.sex = @(gender);
    member.telephoneNumber = phoneNumber;
    member.eMail = eMail;
    member.birthday = birthday;
    member.updateDate = currentData;

    BOOL isSucceed = [[MAContextAPI sharedAPI] saveContextData];
    MA_ASSERT(isSucceed, @"Update friend failed");

    [self friendDidCreated:member];

    return member;
}

- (BOOL)editAndSaveFriend:(MFriend *)mFriend
                     name:(NSString *)name
                   gender:(MAGenderEnum)gender
              phoneNumber:(NSString *)phoneNumber
                    eMail:(NSString *)eMail
                 birthday:(NSDate *)birthday
{
    name = [name stringByReplacingOccurrencesOfString:@" " withString:@""];
    if (0 >= name.length) {
        return NO;
    }

    mFriend.name = name;
    mFriend.sex = @(gender);
    mFriend.telephoneNumber = phoneNumber;
    mFriend.eMail = eMail;
    mFriend.birthday = birthday;
    mFriend.updateDate = [NSDate date];
    BOOL isSucceed = [[MAContextAPI sharedAPI] saveContextData];
    MA_ASSERT(isSucceed, @"Update friend failed");

    [self friendDidChanged:mFriend];
    return isSucceed;
}

- (void)deleteFriend:(MFriend *)mFriend onComplete:(MACommonCallBackBlock)onComplete onFailed:(MACommonCallBackBlock)onFailed
{
    if (0 != mFriend.relationshipToGroup.count) {
        NSMutableArray *groupNames = [NSMutableArray array];
        NSMutableSet *groupSet = [NSMutableSet set];
        for (RMemberToGroup *memberToGroup in mFriend.relationshipToGroup.allObjects) {
            if (![groupSet containsObject:memberToGroup.group]) {
                [groupSet addObject:memberToGroup.group];
                [groupNames addObject:memberToGroup.group.groupName];
            }
        }
        NSString *errorDomain = [NSString stringWithFormat:@"%@ still belongs to %lu groups: %@", mFriend.name, (unsigned long)groupSet.count, [groupNames componentsJoinedByString:@", "]];
        NSError *error = [NSError errorWithDomain:errorDomain code:-1 userInfo:nil];
        MA_INVOKE_BLOCK_SAFELY(onFailed, nil, error);
        return;
    }

    if (0 != mFriend.relationshipToAccount.count) {
        NSMutableArray *groupNames = [NSMutableArray array];
        NSMutableSet *groupSet = [NSMutableSet set];
        for (RMemberToAccount *memberToAccount in mFriend.relationshipToAccount.allObjects) {
            if (![groupSet containsObject:memberToAccount.account.group]) {
                [groupSet addObject:memberToAccount.account.group];
                [groupNames addObject:memberToAccount.account.group.groupName];
            }
        }
        NSString *errorDomain = [NSString stringWithFormat:@"%@ still has accounts in %lu groups: %@", mFriend.name, (unsigned long)groupSet.count, [groupNames componentsJoinedByString:@", "]];
        NSError *error = [NSError errorWithDomain:errorDomain code:-1 userInfo:nil];
        MA_INVOKE_BLOCK_SAFELY(onFailed, nil, error);
        return;
    }

    BOOL isSucceed = [MACommonPersistent deleteObject:mFriend];
    MA_ASSERT(isSucceed, @"Delete friend failed");
    [self friendDidDeleted];
    MA_INVOKE_BLOCK_SAFELY(onComplete, nil, nil);
}

- (NSArray *)unpaidGroupsForFriend:(MFriend *)mFriend
{
    NSMutableArray *unpaidMemberToGroups = [NSMutableArray array];
    for (RMemberToGroup *memberToGroup in mFriend.relationshipToGroup) {
        if (NSOrderedSame != [memberToGroup.fee compare:DecimalZero]) {
            [unpaidMemberToGroups addObject:memberToGroup.group];
        }
    }

    return unpaidMemberToGroups;
}


#pragma mark - MAFriendManagerObserverProtocol

- (void)friendDidCreated:(MFriend *)mFriend
{
    MAObserverObject *observerObject;
    MA_START_ENUMERATION_OBSERVERS(self.friendObservers, observerObject, @selector(friendDidCreated:)) {
        [observerObject.observer friendDidCreated:mFriend];
    }
    MA_END_ENUMERATION_OBSERVERS;
}

- (void)friendDidDeleted
{
    MAObserverObject *observerObject;
    MA_START_ENUMERATION_OBSERVERS(self.friendObservers, observerObject, @selector(friendDidDeleted)) {
        [observerObject.observer friendDidDeleted];
    }
    MA_END_ENUMERATION_OBSERVERS;
}

- (void)friendDidChanged:(MFriend *)mFriend
{
    MAObserverObject *observerObject;
    MA_START_ENUMERATION_OBSERVERS(self.friendObservers, observerObject, @selector(friendDidChanged:)) {
        [observerObject.observer friendDidChanged:mFriend];
    }
    MA_END_ENUMERATION_OBSERVERS;
}


@end