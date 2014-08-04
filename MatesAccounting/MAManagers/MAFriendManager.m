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
#import "MAFriendPersistent.h"
#import "MFriend.h"
#import "RMemberToGroup.h"

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
    NSArray *relationshipToMember = [[MASelectedGroup.relationshipToMember allObjects] sortedArrayUsingComparator:^NSComparisonResult(RMemberToGroup *obj1, RMemberToGroup *obj2) {
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
    NSArray *friends = [[MAFriendPersistent instance] fetchFriends:nil];

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
    if (0 >= [name stringByReplacingOccurrencesOfString:@" " withString:@""].length) {
        return nil;
    }

    MFriend *mFriend = [[MAFriendPersistent instance] createFriendWithName:name];
    MA_QUICK_ASSERT(mFriend, @"Create friend failed~ createFriendWithName");

    mFriend.sex = @(gender);
    mFriend.telephoneNumber = phoneNumber;
    mFriend.eMail = eMail;
    mFriend.birthday = birthday;
    BOOL isSucceed = [[MAFriendPersistent instance] updateFriend:mFriend];
    MA_QUICK_ASSERT(isSucceed, @"Update friend failed~ createFriendWithName");

    [self listenersForKey:kMAFMFriendHasCreated withBlock:^(id<MAFriendManagerListenerProtocol> listener) {
        [listener friendHasModified:mFriend];
    }];
    return mFriend;
}

- (BOOL)editAndSaveFriend:(MFriend *)mFriend
                     name:(NSString *)name
                   gender:(MAGenderEnum)gender
              phoneNumber:(NSNumber *)phoneNumber
                    eMail:(NSString *)eMail
                 birthday:(NSDate *)birthday
{
    if (0 >= [name stringByReplacingOccurrencesOfString:@" " withString:@""].length) {
        return NO;
    }

    mFriend.name = name;
    mFriend.sex = @(gender);
    mFriend.telephoneNumber = phoneNumber;
    mFriend.eMail = eMail;
    mFriend.birthday = birthday;
    BOOL isSucceed = [[MAFriendPersistent instance] updateFriend:mFriend];
    MA_QUICK_ASSERT(isSucceed, @"Update friend failed~ createFriendWithName");

    [self listenersForKey:kMAFMFriendHasModified withBlock:^(id<MAFriendManagerListenerProtocol> listener) {
        [listener friendHasModified:mFriend];
    }];
    return isSucceed;
}

- (BOOL)deleteFriend:(MFriend *)mFriend
{
    return [[MAFriendPersistent instance] deleteFriend:mFriend];
}

@end