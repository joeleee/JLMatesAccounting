//
//  MAFriendManager.m
//  MatesAccounting
//
//  Created by Lee on 13-12-12.
//  Copyright (c) 2013年 Lee. All rights reserved.
//

#import "MAFriendManager.h"

#import "MFriend.h"
#import "MGroup.h"
#import "MAGroupManager.h"

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

- (NSArray *)currentGroupMembers
{
    NSArray *members = [[GroupManager currentGroup].relationshipToMember allObjects];

    return members;
}

- (NSArray *)allFriends
{
    return nil;
}

- (MFriend *)createFriendWithName:(NSString *)name
                           gender:(MAFriendGender)gender
                      phoneNumber:(NSNumber *)phoneNumber
                            eMail:(NSString *)eMail
                         birthday:(NSDate *)birthday
{
    MFriend *member = nil;

    return member;
}

- (MFriend *)editAndSaveFriend:(MFriend *)member
                          name:(NSString *)name
                        gender:(MAFriendGender)gender
                   phoneNumber:(NSNumber *)phoneNumber
                         eMail:(NSString *)eMail
                      birthday:(NSDate *)birthday
{
    return member;
}

@end