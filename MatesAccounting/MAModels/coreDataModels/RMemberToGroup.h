//
//  RMemberToGroup.h
//  MatesAccounting
//
//  Created by Lee on 13-12-21.
//  Copyright (c) 2013年 Lee. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class MFriend, MGroup;

@interface RMemberToGroup : NSManagedObject

@property (nonatomic, retain) NSDate * createDate;
@property (nonatomic, retain) MGroup *group;
@property (nonatomic, retain) MFriend *member;

@end
