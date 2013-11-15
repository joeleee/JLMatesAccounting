//
//  MGroup.h
//  MatesAccounting
//
//  Created by Lee on 13-11-16.
//  Copyright (c) 2013年 Lee. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class MAccount, RMemberToGroup;

@interface MGroup : NSManagedObject

@property (nonatomic, retain) NSDate * createDate;
@property (nonatomic, retain) NSNumber * groupID;
@property (nonatomic, retain) NSString * groupName;
@property (nonatomic, retain) NSDate * updateDate;
@property (nonatomic, retain) NSOrderedSet *accounts;
@property (nonatomic, retain) NSOrderedSet *relationshipToMember;
@end

@interface MGroup (CoreDataGeneratedAccessors)

- (void)insertObject:(MAccount *)value inAccountsAtIndex:(NSUInteger)idx;
- (void)removeObjectFromAccountsAtIndex:(NSUInteger)idx;
- (void)insertAccounts:(NSArray *)value atIndexes:(NSIndexSet *)indexes;
- (void)removeAccountsAtIndexes:(NSIndexSet *)indexes;
- (void)replaceObjectInAccountsAtIndex:(NSUInteger)idx withObject:(MAccount *)value;
- (void)replaceAccountsAtIndexes:(NSIndexSet *)indexes withAccounts:(NSArray *)values;
- (void)addAccountsObject:(MAccount *)value;
- (void)removeAccountsObject:(MAccount *)value;
- (void)addAccounts:(NSOrderedSet *)values;
- (void)removeAccounts:(NSOrderedSet *)values;
- (void)insertObject:(RMemberToGroup *)value inRelationshipToMemberAtIndex:(NSUInteger)idx;
- (void)removeObjectFromRelationshipToMemberAtIndex:(NSUInteger)idx;
- (void)insertRelationshipToMember:(NSArray *)value atIndexes:(NSIndexSet *)indexes;
- (void)removeRelationshipToMemberAtIndexes:(NSIndexSet *)indexes;
- (void)replaceObjectInRelationshipToMemberAtIndex:(NSUInteger)idx withObject:(RMemberToGroup *)value;
- (void)replaceRelationshipToMemberAtIndexes:(NSIndexSet *)indexes withRelationshipToMember:(NSArray *)values;
- (void)addRelationshipToMemberObject:(RMemberToGroup *)value;
- (void)removeRelationshipToMemberObject:(RMemberToGroup *)value;
- (void)addRelationshipToMember:(NSOrderedSet *)values;
- (void)removeRelationshipToMember:(NSOrderedSet *)values;
@end
