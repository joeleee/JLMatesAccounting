//
//  MFriend.h
//  MatesAccounting
//
//  Created by Joe Lee on 2014-8-11.
//  Copyright (c) 2014年 Lee. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class RMemberToAccount, RMemberToGroup;

@interface MFriend : NSManagedObject

@property (nonatomic, retain) NSDate * birthday;
@property (nonatomic, retain) NSDate * createDate;
@property (nonatomic, retain) NSString * eMail;
@property (nonatomic, retain) NSNumber * friendID;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSNumber * sex;
@property (nonatomic, retain) NSNumber * telephoneNumber;
@property (nonatomic, retain) NSDate * updateDate;
@property (nonatomic, retain) NSSet *relationshipToAccount;
@property (nonatomic, retain) NSSet *relationshipToGroup;
@end

@interface MFriend (CoreDataGeneratedAccessors)

- (void)addRelationshipToAccountObject:(RMemberToAccount *)value;
- (void)removeRelationshipToAccountObject:(RMemberToAccount *)value;
- (void)addRelationshipToAccount:(NSSet *)values;
- (void)removeRelationshipToAccount:(NSSet *)values;

- (void)addRelationshipToGroupObject:(RMemberToGroup *)value;
- (void)removeRelationshipToGroupObject:(RMemberToGroup *)value;
- (void)addRelationshipToGroup:(NSSet *)values;
- (void)removeRelationshipToGroup:(NSSet *)values;

@end
