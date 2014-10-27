//
//  MAGroupManager.m
//  MatesAccounting
//
//  Created by Lee on 13-11-27.
//  Copyright (c) 2013年 Lee. All rights reserved.
//

#import "MAGroupManager.h"


#import "MAObserverObject.h"
#import "MGroup+expand.h"
#import "MFriend.h"
#import "MACommonPersistent.h"
#import "RMemberToGroup+expand.h"
#import "MAContextAPI.h"

NSString * const kCurrentGroupID = @"kCurrentGroupID";

@interface MAGroupManager () <MAGroupManagerObserverProtocol>

@property (nonatomic, strong) NSMutableArray *groupObservers;
@property (nonatomic, strong) MGroup *selectedGroup;

@end

@implementation MAGroupManager

+ (MAGroupManager *)sharedManager
{
    static MAGroupManager  *sharedInstance;
    static dispatch_once_t onceToken;

    dispatch_once(&onceToken, ^{
        sharedInstance = [[self alloc] init];
    });
    return sharedInstance;
}

- (id)init
{
    if (self = [super init]) {
        self.groupObservers = [NSMutableArray array];
    }

    return self;
}


#pragma mark - public methods

- (void)registerGroupObserver:(id<MAGroupManagerObserverProtocol>)observer
{
    MAObserverObject *observerObject = [MAObserverObject observerObjectWith:observer];
    [self.groupObservers addObject:observerObject];
}

- (void)unregisterGroupObserver:(id<MAGroupManagerObserverProtocol>)observer
{
    [[NSOperationQueue mainQueue] addOperationWithBlock:^{
        NSMutableArray *invalidObservers = [NSMutableArray array];
        for (MAObserverObject *observerObject in self.groupObservers) {
            if (!observerObject.observer) {
                [invalidObservers addObject:observerObject];
            }
        }
        [self.groupObservers removeObjectsInArray:invalidObservers];
    }];
}

- (MGroup *)selectedGroup
{
    if (!_selectedGroup) {
        NSNumber *groupID = [[NSUserDefaults standardUserDefaults] objectForKey:kCurrentGroupID];
        NSFetchRequest *fetchRequest = [NSFetchRequest fetchRequestWithEntityName:[MGroup className]];
        fetchRequest.predicate = [NSPredicate predicateWithFormat:@"groupID == %@", groupID];
        NSArray *groupList = [MACommonPersistent fetchObjectsWithRequest:fetchRequest];
        _selectedGroup = groupList.firstObject;
    }

    return _selectedGroup;
}

- (NSArray *)myGroups
{
    NSArray *groups = [MACommonPersistent fetchObjectsWithEntityName:[MGroup className]];

    return groups;
}

- (BOOL)changeGroup:(MGroup *)group
{
    MA_QUICK_ASSERT(group, @"change new group should not be nil! - changeGroup");
    if (!group) {
        return NO;
    }

    self.selectedGroup = group;

    [[NSUserDefaults standardUserDefaults] setObject:self.selectedGroup.groupID forKey:kCurrentGroupID];
    [[NSUserDefaults standardUserDefaults] synchronize];
    [self currentGroupDidSwitched:group];

    return YES;
}

- (MGroup *)createGroup:(NSString *)name
{
    name = [name stringByReplacingOccurrencesOfString:@" " withString:@""];
    if ((0 >= name.length)) {
        return nil;
    }

    MGroup *group = [MACommonPersistent createObject:NSStringFromClass([MGroup class])];
    MA_QUICK_ASSERT(group, @"Assert group == nil");
    NSDate *currentData = [NSDate date];
    group.createDate = currentData;
    group.updateDate = currentData;
    group.groupName = name;
    group.groupID = @([currentData timeIntervalSince1970]);
    [[MAContextAPI sharedAPI] saveContextData];
    [self groupDidCreated:group];

    return group;
}

- (MGroup *)editAndSaveGroup:(MGroup *)group name:(NSString *)name
{
    name = [name stringByReplacingOccurrencesOfString:@" " withString:@""];
    if ((0 >= name.length)) {
        return nil;
    }

    group.groupName = name;
    group.updateDate = [NSDate date];
    BOOL isSucceed = [[MAContextAPI sharedAPI] saveContextData];
    MA_QUICK_ASSERT(isSucceed, @"editAndSaveGroup result is nil! - editAndSaveGroup");
    [self groupInfoDidChanged:group];

    return group;
}

- (RMemberToGroup *)addFriend:(MFriend *)mFriend toGroup:(MGroup *)group
{
    if (!mFriend || !group || 0 < [group relationshipToMembersByFriend:mFriend].count) {
        return nil;
    }
    for (RMemberToGroup *memberToGroup in mFriend.relationshipToGroup) {
        if (memberToGroup.group == group) {
            return nil;
        }
    }

    RMemberToGroup *memberToGroup = [MACommonPersistent createObject:NSStringFromClass([RMemberToGroup class])];
    MA_QUICK_ASSERT(memberToGroup, @"Assert memberToGroup == nil");

    memberToGroup.createDate = [NSDate date];
    memberToGroup.member = mFriend;
    memberToGroup.group = group;
    if (![[MAContextAPI sharedAPI] saveContextData]) {
        MA_QUICK_ASSERT(NO, @"Update failed.");
        [MACommonPersistent deleteObject:memberToGroup];
        [[MAContextAPI sharedAPI] saveContextData];
        return nil;
    }
    [self groupMemberDidChanged:memberToGroup.group member:memberToGroup.member isAdd:YES];

    return memberToGroup;
}

- (void)removeFriend:(MFriend *)mFriend fromGroup:(MGroup *)group onComplete:(MACommonCallBackBlock)onComplete onFailed:(MACommonCallBackBlock)onFailed;
{
    NSSet *relationships = [group.relationshipToMember filteredSetUsingPredicate:[NSPredicate predicateWithFormat:@"%K = %@", @"member", mFriend]];
    MA_QUICK_ASSERT(relationships.count > 0, @"Assert memberToGroup == nil");

    RMemberToGroup *memberToGroup = relationships.allObjects.firstObject;
    [memberToGroup refreshMemberTotalFee];
    if (NSOrderedSame != [memberToGroup.fee compare:DecimalZero]) {
        NSError *error = [NSError errorWithDomain:@"Please be sure this member's balance is zero first." code:-1 userInfo:nil];
        MA_INVOKE_BLOCK_SAFELY(onFailed, nil, error);
        return;
    }

    if ([MACommonPersistent deleteObject:memberToGroup]) {
        [self groupMemberDidChanged:group member:mFriend isAdd:NO];
        MA_INVOKE_BLOCK_SAFELY(onComplete, nil, nil);
    } else {
        NSError *error = [NSError errorWithDomain:@"Remove member failed!" code:-1 userInfo:nil];
        MA_INVOKE_BLOCK_SAFELY(onFailed, nil, error);
    }
}

- (BOOL)isMember:(MFriend *)member belongsToGroup:(MGroup *)group
{
    BOOL isBelong = [member.relationshipToGroup intersectsSet:group.relationshipToMember];
    return isBelong;
}


#pragma mark - MAGroupManagerObserverProtocol

- (void)groupDidCreated:(MGroup *)group
{
    MAObserverObject *observerObject;
    MA_START_ENUMERATION_OBSERVERS(self.groupObservers, observerObject, @selector(groupDidCreated:)) {
        [observerObject.observer groupDidCreated:group];
    }
    MA_END_ENUMERATION_OBSERVERS;
}

- (void)groupInfoDidChanged:(MGroup *)group
{
    MAObserverObject *observerObject;
    MA_START_ENUMERATION_OBSERVERS(self.groupObservers, observerObject, @selector(groupInfoDidChanged:)) {
        [observerObject.observer groupInfoDidChanged:group];
    }
    MA_END_ENUMERATION_OBSERVERS;
}

- (void)groupMemberDidChanged:(MGroup *)group member:(MFriend *)mFriend isAdd:(BOOL)isAdd
{
    MAObserverObject *observerObject;
    MA_START_ENUMERATION_OBSERVERS(self.groupObservers, observerObject, @selector(groupMemberDidChanged:member:isAdd:)) {
        [observerObject.observer groupMemberDidChanged:group member:mFriend isAdd:isAdd];
    }
    MA_END_ENUMERATION_OBSERVERS;
}

- (void)currentGroupDidSwitched:(MGroup *)group
{
    MAObserverObject *observerObject;
    MA_START_ENUMERATION_OBSERVERS(self.groupObservers, observerObject, @selector(currentGroupDidSwitched:)) {
        [observerObject.observer currentGroupDidSwitched:group];
    }
    MA_END_ENUMERATION_OBSERVERS;
}

@end