//
//  MGroup.h
//  MatesAccounting
//
//  Created by Lee on 13-11-14.
//  Copyright (c) 2013年 Lee. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface MGroup : NSManagedObject

@property (nonatomic, retain) NSNumber * groupID;
@property (nonatomic, retain) NSDate * createDate;
@property (nonatomic, retain) NSDate * updateTime;
@property (nonatomic, retain) NSString * groupName;
@property (nonatomic, retain) NSOrderedSet *accounts;
@property (nonatomic, retain) NSOrderedSet *relationshipToMember;
@end

@interface MGroup (CoreDataGeneratedAccessors)

- (void)insertObject:(NSManagedObject *)value inAccountsAtIndex:(NSUInteger)idx;
- (void)removeObjectFromAccountsAtIndex:(NSUInteger)idx;
- (void)insertAccounts:(NSArray *)value atIndexes:(NSIndexSet *)indexes;
- (void)removeAccountsAtIndexes:(NSIndexSet *)indexes;
- (void)replaceObjectInAccountsAtIndex:(NSUInteger)idx withObject:(NSManagedObject *)value;
- (void)replaceAccountsAtIndexes:(NSIndexSet *)indexes withAccounts:(NSArray *)values;
- (void)addAccountsObject:(NSManagedObject *)value;
- (void)removeAccountsObject:(NSManagedObject *)value;
- (void)addAccounts:(NSOrderedSet *)values;
- (void)removeAccounts:(NSOrderedSet *)values;
- (void)insertObject:(NSManagedObject *)value inRelationshipToMemberAtIndex:(NSUInteger)idx;
- (void)removeObjectFromRelationshipToMemberAtIndex:(NSUInteger)idx;
- (void)insertRelationshipToMember:(NSArray *)value atIndexes:(NSIndexSet *)indexes;
- (void)removeRelationshipToMemberAtIndexes:(NSIndexSet *)indexes;
- (void)replaceObjectInRelationshipToMemberAtIndex:(NSUInteger)idx withObject:(NSManagedObject *)value;
- (void)replaceRelationshipToMemberAtIndexes:(NSIndexSet *)indexes withRelationshipToMember:(NSArray *)values;
- (void)addRelationshipToMemberObject:(NSManagedObject *)value;
- (void)removeRelationshipToMemberObject:(NSManagedObject *)value;
- (void)addRelationshipToMember:(NSOrderedSet *)values;
- (void)removeRelationshipToMember:(NSOrderedSet *)values;
@end
