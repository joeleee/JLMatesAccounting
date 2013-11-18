//
//  MMember.h
//  MatesAccounting
//
//  Created by Lee on 13-11-18.
//  Copyright (c) 2013年 Lee. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class RMemberToAccount, RMemberToGroup;

@interface MMember : NSManagedObject

@property (nonatomic, retain) NSNumber * age;
@property (nonatomic, retain) NSDate * createDate;
@property (nonatomic, retain) NSString * eMail;
@property (nonatomic, retain) NSNumber * memberID;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSNumber * sex;
@property (nonatomic, retain) NSNumber * telephoneNumber;
@property (nonatomic, retain) NSDate * updateDate;
@property (nonatomic, retain) NSOrderedSet *relationshipToAccount;
@property (nonatomic, retain) NSOrderedSet *relationshipToGroup;
@end

@interface MMember (CoreDataGeneratedAccessors)

- (void)insertObject:(RMemberToAccount *)value inRelationshipToAccountAtIndex:(NSUInteger)idx;
- (void)removeObjectFromRelationshipToAccountAtIndex:(NSUInteger)idx;
- (void)insertRelationshipToAccount:(NSArray *)value atIndexes:(NSIndexSet *)indexes;
- (void)removeRelationshipToAccountAtIndexes:(NSIndexSet *)indexes;
- (void)replaceObjectInRelationshipToAccountAtIndex:(NSUInteger)idx withObject:(RMemberToAccount *)value;
- (void)replaceRelationshipToAccountAtIndexes:(NSIndexSet *)indexes withRelationshipToAccount:(NSArray *)values;
- (void)addRelationshipToAccountObject:(RMemberToAccount *)value;
- (void)removeRelationshipToAccountObject:(RMemberToAccount *)value;
- (void)addRelationshipToAccount:(NSOrderedSet *)values;
- (void)removeRelationshipToAccount:(NSOrderedSet *)values;
- (void)insertObject:(RMemberToGroup *)value inRelationshipToGroupAtIndex:(NSUInteger)idx;
- (void)removeObjectFromRelationshipToGroupAtIndex:(NSUInteger)idx;
- (void)insertRelationshipToGroup:(NSArray *)value atIndexes:(NSIndexSet *)indexes;
- (void)removeRelationshipToGroupAtIndexes:(NSIndexSet *)indexes;
- (void)replaceObjectInRelationshipToGroupAtIndex:(NSUInteger)idx withObject:(RMemberToGroup *)value;
- (void)replaceRelationshipToGroupAtIndexes:(NSIndexSet *)indexes withRelationshipToGroup:(NSArray *)values;
- (void)addRelationshipToGroupObject:(RMemberToGroup *)value;
- (void)removeRelationshipToGroupObject:(RMemberToGroup *)value;
- (void)addRelationshipToGroup:(NSOrderedSet *)values;
- (void)removeRelationshipToGroup:(NSOrderedSet *)values;
@end
