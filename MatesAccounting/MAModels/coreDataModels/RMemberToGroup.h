//
//  RMemberToGroup.h
//  MatesAccounting
//
//  Created by Joe Lee on 2014-8-9.
//  Copyright (c) 2014年 Lee. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class MFriend, MGroup;

@interface RMemberToGroup : NSManagedObject

@property (nonatomic, retain) NSDate * createDate;
@property (nonatomic, retain) NSNumber * fee;
@property (nonatomic, retain) MGroup *group;
@property (nonatomic, retain) MFriend *member;

@end
