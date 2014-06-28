//
//  MGroup.h
//  MatesAccounting
//
//  Created by Lee on 13-12-21.
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
@property (nonatomic, retain) NSSet *accounts;
@property (nonatomic, retain) NSSet *relationshipToMember;
@end

@interface MGroup (CoreDataGeneratedAccessors)

- (void)addAccountsObject:(MAccount *)value;
- (void)removeAccountsObject:(MAccount *)value;
- (void)addAccounts:(NSSet *)values;
- (void)removeAccounts:(NSSet *)values;

- (void)addRelationshipToMemberObject:(RMemberToGroup *)value;
- (void)removeRelationshipToMemberObject:(RMemberToGroup *)value;
- (void)addRelationshipToMember:(NSSet *)values;
- (void)removeRelationshipToMember:(NSSet *)values;

@end
