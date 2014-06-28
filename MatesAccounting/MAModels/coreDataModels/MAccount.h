//
//  MAccount.h
//  MatesAccounting
//
//  Created by Lee on 13-12-21.
//  Copyright (c) 2013年 Lee. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class MGroup, MPlace, RMemberToAccount;

@interface MAccount : NSManagedObject

@property (nonatomic, retain) NSDate * accountDate;
@property (nonatomic, retain) NSNumber * accountID;
@property (nonatomic, retain) NSDate * createDate;
@property (nonatomic, retain) NSString * detail;
@property (nonatomic, retain) NSNumber * totalFee;
@property (nonatomic, retain) NSDate * updateDate;
@property (nonatomic, retain) MGroup *group;
@property (nonatomic, retain) MPlace *place;
@property (nonatomic, retain) NSSet *relationshipToMember;
@end

@interface MAccount (CoreDataGeneratedAccessors)

- (void)addRelationshipToMemberObject:(RMemberToAccount *)value;
- (void)removeRelationshipToMemberObject:(RMemberToAccount *)value;
- (void)addRelationshipToMember:(NSSet *)values;
- (void)removeRelationshipToMember:(NSSet *)values;

@end
