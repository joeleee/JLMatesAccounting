//
//  MAFriendManager.m
//  MatesAccounting
//
//  Created by Lee on 13-12-12.
//  Copyright (c) 2013年 Lee. All rights reserved.
//

#import "MAFriendManager.h"

#import "MGroup.h"
#import "MAGroupManager.h"
#import "MFriend.h"
#import "RMemberToGroup.h"
#import "MACommonPersistent.h"
#import "MAContextAPI.h"

NSString * const kMAFMFriendHasCreated = @"kMAFMFriendHasCreated";
NSString * const kMAFMFriendHasModified = @"kMAFMFriendHasModified";

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

        [self setListenerKeyToSelecterDict:@{kMAFMFriendHasCreated:NSStringFromSelector(@selector(friendHasCreated:)),
                                             kMAFMFriendHasModified:NSStringFromSelector(@selector(friendHasModified:))}];

    }

    return self;
}

#pragma mark - public methods

- (BOOL)addListener:(id<MAFriendManagerListenerProtocol>)listener
{
    return [self addListener:listener];
}

- (BOOL)removeListener:(id<MAFriendManagerListenerProtocol>)listener
{
    return [self removeListener:listener];
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
                      phoneNumber:(NSNumber *)phoneNumber
                            eMail:(NSString *)eMail
                         birthday:(NSDate *)birthday
{
    name = [name stringByReplacingOccurrencesOfString:@" " withString:@""];
    if (0 >= name.length) {
        return nil;
    }

    MFriend *member = [MACommonPersistent createObject:NSStringFromClass([MFriend class])];
    MA_QUICK_ASSERT(member, @"Assert member == nil");

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
    MA_QUICK_ASSERT(isSucceed, @"Update friend failed");

    [self listenersForKey:kMAFMFriendHasCreated withBlock:^(id<MAFriendManagerListenerProtocol> listener) {
        [listener friendHasModified:member];
    }];

    return member;
}

- (BOOL)editAndSaveFriend:(MFriend *)mFriend
                     name:(NSString *)name
                   gender:(MAGenderEnum)gender
              phoneNumber:(NSNumber *)phoneNumber
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
    MA_QUICK_ASSERT(isSucceed, @"Update friend failed");

    [self listenersForKey:kMAFMFriendHasModified withBlock:^(id<MAFriendManagerListenerProtocol> listener) {
        [listener friendHasModified:mFriend];
    }];
    return isSucceed;
}

- (BOOL)deleteFriend:(MFriend *)mFriend
{
    if (0 != mFriend.relationshipToGroup.count) {
        return NO;
    }

    BOOL isSucceed = [MACommonPersistent deleteObject:mFriend];
    MA_QUICK_ASSERT(isSucceed, @"Delete friend failed");
    return isSucceed;
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

@end