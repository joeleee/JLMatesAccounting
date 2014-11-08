//
//  RMemberToGroup.h
//  MatesAccounting
//
//  Created by Joe Lee on 2014-11-8.
//  Copyright (c) 2014年 Lee. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class MFriend, MGroup;

@interface RMemberToGroup : NSManagedObject

@property (nonatomic, retain) NSDate * createDate;
@property (nonatomic, retain) NSDecimalNumber * fee;
@property (nonatomic, retain) MGroup *group;
@property (nonatomic, retain) MFriend *member;

@end
