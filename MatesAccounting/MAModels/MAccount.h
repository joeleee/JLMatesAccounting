//
//  MAccount.h
//  MatesAccounting
//
//  Created by Lee on 13-11-19.
//  Copyright (c) 2013年 Lee. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class MGroup, MMember, MPlace, RMemberToAccount;

@interface MAccount : NSManagedObject

@property (nonatomic, retain) NSNumber * accountID;
@property (nonatomic, retain) NSDate * createDate;
@property (nonatomic, retain) NSString * detail;
@property (nonatomic, retain) NSDate * updateDate;
@property (nonatomic, retain) NSDate * accountDate;
@property (nonatomic, retain) MGroup *group;
@property (nonatomic, retain) NSOrderedSet *relationshipToMember;
@property (nonatomic, retain) MPlace *place;
@property (nonatomic, retain) MMember *payer;
@end

@interface MAccount (CoreDataGeneratedAccessors)

- (void)insertObject:(RMemberToAccount *)value inRelationshipToMemberAtIndex:(NSUInteger)idx;
- (void)removeObjectFromRelationshipToMemberAtIndex:(NSUInteger)idx;
- (void)insertRelationshipToMember:(NSArray *)value atIndexes:(NSIndexSet *)indexes;
- (void)removeRelationshipToMemberAtIndexes:(NSIndexSet *)indexes;
- (void)replaceObjectInRelationshipToMemberAtIndex:(NSUInteger)idx withObject:(RMemberToAccount *)value;
- (void)replaceRelationshipToMemberAtIndexes:(NSIndexSet *)indexes withRelationshipToMember:(NSArray *)values;
- (void)addRelationshipToMemberObject:(RMemberToAccount *)value;
- (void)removeRelationshipToMemberObject:(RMemberToAccount *)value;
- (void)addRelationshipToMember:(NSOrderedSet *)values;
- (void)removeRelationshipToMember:(NSOrderedSet *)values;
@end
